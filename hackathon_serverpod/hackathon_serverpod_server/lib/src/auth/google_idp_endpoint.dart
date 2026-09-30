import 'package:serverpod_auth_idp_server/providers/google.dart';

/// By extending [GoogleIdpBaseEndpoint], signing in with Google is made
/// available on the server. Its credentials are `googleClientSecret` in
/// `config/passwords.yaml`: the "Web application" OAuth client's JSON.
class GoogleIdpEndpoint extends GoogleIdpBaseEndpoint {}
