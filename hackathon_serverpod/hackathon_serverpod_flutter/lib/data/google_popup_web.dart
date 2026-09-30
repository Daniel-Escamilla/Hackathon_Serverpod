import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:web/web.dart' as web;

import 'google_popup.dart';

/// The key Serverpod's `/auth/callback` page answers under, by `postMessage`
/// to the opener or, when the opener is gone, in localStorage.
const _callbackKey = 'flutter-web-auth-2';

Future<GooglePopupResult?> signInWithGooglePopup({
  required String clientId,
  required String redirectUri,
  required List<String> scopes,
}) async {
  final codeVerifier = _randomString(32);
  final state = _randomString(16);
  final codeChallenge = base64UrlEncode(
    sha256.convert(utf8.encode(codeVerifier)).bytes,
  ).replaceAll('=', '');

  // The same request Serverpod's GoogleWebSignInService builds.
  final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'code',
    'scope': scopes.join(' '),
    'code_challenge': codeChallenge,
    'code_challenge_method': 'S256',
    'state': state,
    'prompt': 'select_account',
    'access_type': 'online',
  });

  const width = 480;
  const height = 640;
  final window = web.window;
  final left = window.screenX + (window.outerWidth - width) ~/ 2;
  final top = window.screenY + (window.outerHeight - height) ~/ 2;

  window.localStorage.removeItem(_callbackKey);
  final popup = window.open(
    url.toString(),
    'google-sign-in',
    'popup,width=$width,height=$height,left=$left,top=$top',
  );
  if (popup == null) throw const GooglePopupBlockedException();

  final answer = Completer<String?>();
  void finish(String? callbackUrl) {
    if (!answer.isCompleted) answer.complete(callbackUrl);
  }

  final messages = window.onMessage.listen((event) {
    if (event.origin != Uri.base.origin) return;
    final data = event.data.dartify();
    if (data is Map && data[_callbackKey] is String) {
      finish(data[_callbackKey] as String);
    }
  });

  Timer? closedGrace;
  final watcher = Timer.periodic(const Duration(milliseconds: 300), (_) {
    final stored = window.localStorage.getItem(_callbackKey);
    if (stored != null) {
      window.localStorage.removeItem(_callbackKey);
      finish(stored);
      return;
    }
    // Closed, and this window has the focus back: the person gave up. The
    // focus check matters if Google ever enforces its opener policy: the
    // handle then reads as closed while the window is still open on top.
    // The grace lets an answer that raced the close arrive first.
    if (popup.closed && web.document.hasFocus()) {
      closedGrace ??= Timer(const Duration(milliseconds: 800), () {
        finish(null);
      });
    }
  });
  final giveUp = Timer(const Duration(minutes: 5), () => finish(null));

  try {
    final callbackUrl = await answer.future;
    if (callbackUrl == null) return null;

    final params = Uri.parse(callbackUrl).queryParameters;
    if (params['state'] != state) {
      throw const GooglePopupException('state mismatch');
    }
    final code = params['code'];
    if (code == null || code.isEmpty) {
      // "Cancel" on Google's consent screen reads the same as closing.
      if (params['error'] == 'access_denied') return null;
      throw GooglePopupException(params['error'] ?? 'no code');
    }
    return (code: code, codeVerifier: codeVerifier, redirectUri: redirectUri);
  } finally {
    await messages.cancel();
    watcher.cancel();
    closedGrace?.cancel();
    giveUp.cancel();
    if (!popup.closed) popup.close();
  }
}

String _randomString(int byteLength) {
  final random = Random.secure();
  final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
  return base64UrlEncode(bytes).replaceAll('=', '');
}
