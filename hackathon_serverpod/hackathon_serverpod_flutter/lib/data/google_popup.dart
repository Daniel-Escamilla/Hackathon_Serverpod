import 'google_popup_stub.dart'
    if (dart.library.js_interop) 'google_popup_web.dart'
    as impl;

/// What the server needs to finish a Google sign-in started on the web.
typedef GooglePopupResult = ({
  String code,
  String codeVerifier,
  String redirectUri,
});

/// The browser refused to open the Google window.
class GooglePopupBlockedException implements Exception {
  const GooglePopupBlockedException();
}

/// Google answered, but not with a code the server can use.
class GooglePopupException implements Exception {
  const GooglePopupException(this.reason);

  final String reason;

  @override
  String toString() => 'GooglePopupException($reason)';
}

/// Web only: asks Google for an authorization code in a small window, and
/// resolves to null when the person closes it or cancels on Google's side.
///
/// Serverpod's own web flow (`GoogleWebSignInService`) opens a full tab and
/// never notices it closing, so the button stayed busy for five minutes. This
/// is the same OAuth2 PKCE request, answered by the same `/auth/callback`
/// page, in a window we own and can watch.
///
/// Call it straight from a tap, before any `await`: browsers only let a user
/// gesture open a window.
Future<GooglePopupResult?> signInWithGooglePopup({
  required String clientId,
  required String redirectUri,
  required List<String> scopes,
}) => impl.signInWithGooglePopup(
  clientId: clientId,
  redirectUri: redirectUri,
  scopes: scopes,
);
