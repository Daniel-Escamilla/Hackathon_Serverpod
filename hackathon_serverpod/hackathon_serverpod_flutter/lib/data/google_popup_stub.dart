import 'google_popup.dart';

/// Phones sign in through the Google SDK instead; there is no window here.
Future<GooglePopupResult?> signInWithGooglePopup({
  required String clientId,
  required String redirectUri,
  required List<String> scopes,
}) => throw UnsupportedError('The Google window only exists on the web.');
