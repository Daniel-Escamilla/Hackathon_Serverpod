/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:hackathon_serverpod_client/src/protocol/events/group_event.dart'
    as _ixxl2uus;
import 'package:hackathon_serverpod_client/src/protocol/greetings/greeting.dart'
    as _icy68nvy;
import 'package:hackathon_serverpod_client/src/protocol/groups/group.dart'
    as _iubjh9pq;
import 'package:hackathon_serverpod_client/src/protocol/groups/group_member.dart'
    as _ir4oz66a;
import 'package:hackathon_serverpod_client/src/protocol/groups/group_type.dart'
    as _i0727frs;
import 'package:hackathon_serverpod_client/src/protocol/shop/purchase.dart'
    as _idofij3t;
import 'package:hackathon_serverpod_client/src/protocol/shop/reward_item.dart'
    as _ibcsn808;
import 'package:hackathon_serverpod_client/src/protocol/tasks/task.dart'
    as _i7vt05yn;
import 'package:hackathon_serverpod_client/src/protocol/wallet/coin_movement.dart'
    as _ibr29qpn;
import 'package:hackathon_serverpod_client/src/protocol/wallet/ranking_entry.dart'
    as _ixil0pu8;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Live updates for the signed-in member's group (PRODUCT.md §10.4, issue #65).
/// {@category Endpoint}
class EndpointEvent extends _isc.EndpointRef {
  EndpointEvent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'event';

  /// Subscribes to the group's Stream: every `GroupEvent` published for it
  /// from this point on, until the client stops listening.
  _ida.Stream<_ixxl2uus.GroupEvent> watchGroup() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_ixxl2uus.GroupEvent>,
        _ixxl2uus.GroupEvent
      >(
        'event',
        'watchGroup',
        {},
        {},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_icy68nvy.Greeting> hello(String name) =>
      caller.callServerEndpoint<_icy68nvy.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Create a group and join one by invite code (PRODUCT.md §7, §10.3).
/// {@category Endpoint}
class EndpointGroup extends _isc.EndpointRef {
  EndpointGroup(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'group';

  /// Creates a group with [name] and [type], making the signed-in user its admin,
  /// and seeds the profile's reward templates. A person can belong to only one
  /// group at a time (PRODUCT.md §7).
  _ida.Future<_iubjh9pq.Group> createGroup(
    String name,
    _i0727frs.GroupType type, {
    String? displayName,
  }) => caller.callServerEndpoint<_iubjh9pq.Group>(
    'group',
    'createGroup',
    {
      'name': name,
      'type': type,
      'displayName': displayName,
    },
  );

  /// Joins the group identified by [inviteCode]. Enters directly, no approval
  /// needed (PRODUCT.md §7). A person can belong to only one group at a time.
  _ida.Future<_ir4oz66a.GroupMember> joinGroup(
    String inviteCode, {
    String? displayName,
  }) => caller.callServerEndpoint<_ir4oz66a.GroupMember>(
    'group',
    'joinGroup',
    {
      'inviteCode': inviteCode,
      'displayName': displayName,
    },
  );

  /// The signed-in member's group: its name, profile and invite code.
  ///
  /// `joinGroup` returns the membership, not the group, so without this a
  /// member who joined could never read the code to pass on to anyone else.
  _ida.Future<_iubjh9pq.Group> myGroup() =>
      caller.callServerEndpoint<_iubjh9pq.Group>(
        'group',
        'myGroup',
        {},
      );

  /// Everyone currently in the caller's group, oldest first — the order the
  /// admin role passes down in when an admin leaves (PRODUCT.md §7).
  _ida.Future<List<_ir4oz66a.GroupMember>> listMembers() =>
      caller.callServerEndpoint<List<_ir4oz66a.GroupMember>>(
        'group',
        'listMembers',
        {},
      );

  /// The admin removes [memberId] from the group (PRODUCT.md §7).
  ///
  /// Entry is direct with the code, so this is what protects a group whose
  /// code has leaked: whoever got in without being wanted can be put out.
  ///
  /// The row is kept with `leftAt` set, so the tasks they did and the coins
  /// they moved stay in everyone's history. Their balance is lost, as §4.6
  /// says, without touching the ledger: no call ever reaches a membership that
  /// has left, and joining again later starts a new one at zero.
  _ida.Future<void> expelMember(int memberId) =>
      caller.callServerEndpoint<void>(
        'group',
        'expelMember',
        {'memberId': memberId},
      );

  /// The admin replaces the invite code. The old one stops working at once;
  /// nobody already in the group is affected.
  ///
  /// The other half of what expelling covers: this stops a leaked code from
  /// letting anyone else in, expelling removes whoever already used it.
  _ida.Future<_iubjh9pq.Group> regenerateInviteCode() =>
      caller.callServerEndpoint<_iubjh9pq.Group>(
        'group',
        'regenerateInviteCode',
        {},
      );
}

/// List, propose, vote, buy and fulfil rewards (PRODUCT.md §6, §10.3).
/// {@category Endpoint}
class EndpointShop extends _isc.EndpointRef {
  EndpointShop(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'shop';

  /// All rewards visible in the signed-in member's group shop.
  _ida.Future<List<_ibcsn808.RewardItem>> listRewards() =>
      caller.callServerEndpoint<List<_ibcsn808.RewardItem>>(
        'shop',
        'listRewards',
        {},
      );

  /// Propose a new reward. Starts `proposed` and goes to a vote in piso/pareja.
  _ida.Future<_ibcsn808.RewardItem> proposeReward(
    String title,
    String description,
    int price, {
    int? stock,
  }) => caller.callServerEndpoint<_ibcsn808.RewardItem>(
    'shop',
    'proposeReward',
    {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
    },
  );

  /// Vote on a proposed reward.
  _ida.Future<void> voteReward(
    int itemId,
    bool approve,
  ) => caller.callServerEndpoint<void>(
    'shop',
    'voteReward',
    {
      'itemId': itemId,
      'approve': approve,
    },
  );

  /// A child asks for a reward with no price yet; a guardian sets it and publishes
  /// (PRODUCT.md §8). Family mode is out of MVP scope (PLAN.md §1).
  _ida.Future<_ibcsn808.RewardItem> requestWish(
    String title,
    String description,
  ) => caller.callServerEndpoint<_ibcsn808.RewardItem>(
    'shop',
    'requestWish',
    {
      'title': title,
      'description': description,
    },
  );

  /// Buy a reward, choosing who among the other members fulfils it.
  _ida.Future<_idofij3t.Purchase> purchaseReward(
    int itemId,
    int providerId,
  ) => caller.callServerEndpoint<_idofij3t.Purchase>(
    'shop',
    'purchaseReward',
    {
      'itemId': itemId,
      'providerId': providerId,
    },
  );

  /// A guardian approves or denies a child's pending purchase. Family mode is out
  /// of MVP scope (PLAN.md §1).
  _ida.Future<void> approveChildPurchase(
    int purchaseId,
    bool approve,
  ) => caller.callServerEndpoint<void>(
    'shop',
    'approveChildPurchase',
    {
      'purchaseId': purchaseId,
      'approve': approve,
    },
  );

  /// The chosen provider accepts or refuses a purchase. Refusing pays the fine and
  /// refunds the buyer.
  _ida.Future<void> respondToPurchase(
    int purchaseId,
    bool accept,
  ) => caller.callServerEndpoint<void>(
    'shop',
    'respondToPurchase',
    {
      'purchaseId': purchaseId,
      'accept': accept,
    },
  );

  /// The provider marks an accepted purchase as fulfilled.
  _ida.Future<void> markDelivered(int purchaseId) =>
      caller.callServerEndpoint<void>(
        'shop',
        'markDelivered',
        {'purchaseId': purchaseId},
      );
}

/// Propose and vote on tasks (PRODUCT.md §3, §10.3).
/// {@category Endpoint}
class EndpointTask extends _isc.EndpointRef {
  EndpointTask(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'task';

  /// All tasks in the signed-in member's group.
  _ida.Future<List<_i7vt05yn.Task>> listTasks() =>
      caller.callServerEndpoint<List<_i7vt05yn.Task>>(
        'task',
        'listTasks',
        {},
      );

  /// Propose a new task. Starts `proposed` and opens a proposal vote.
  _ida.Future<_i7vt05yn.Task> proposeTask(
    String title,
    String description,
    int reward,
  ) => caller.callServerEndpoint<_i7vt05yn.Task>(
    'task',
    'proposeTask',
    {
      'title': title,
      'description': description,
      'reward': reward,
    },
  );

  /// Vote on a proposed task's price and description.
  _ida.Future<_i7vt05yn.Task> voteTaskProposal(
    int taskId,
    bool approve,
  ) => caller.callServerEndpoint<_i7vt05yn.Task>(
    'task',
    'voteTaskProposal',
    {
      'taskId': taskId,
      'approve': approve,
    },
  );

  /// Counter-offer a different price instead of a plain reject. Freezes the
  /// vote until the proposer responds.
  _ida.Future<_i7vt05yn.Task> counterOfferTask(
    int taskId,
    int counterReward,
  ) => caller.callServerEndpoint<_i7vt05yn.Task>(
    'task',
    'counterOfferTask',
    {
      'taskId': taskId,
      'counterReward': counterReward,
    },
  );

  /// The proposer accepts or withdraws the pending counter-offer.
  _ida.Future<_i7vt05yn.Task> respondToCounterOffer(
    int taskId,
    bool accept,
  ) => caller.callServerEndpoint<_i7vt05yn.Task>(
    'task',
    'respondToCounterOffer',
    {
      'taskId': taskId,
      'accept': accept,
    },
  );

  /// Claim an open task as done. Whoever's request commits first wins; the
  /// other gets rejected (PRODUCT.md §3, §10.2).
  _ida.Future<_i7vt05yn.Task> markTaskDone(int taskId) =>
      caller.callServerEndpoint<_i7vt05yn.Task>(
        'task',
        'markTaskDone',
        {'taskId': taskId},
      );

  /// Vote on whether a claimed task was actually done. Approval pays the
  /// claimant; denial fines them and reopens the task for someone else
  /// (PRODUCT.md §3).
  _ida.Future<_i7vt05yn.Task> voteTaskCompletion(
    int taskId,
    bool approve,
  ) => caller.callServerEndpoint<_i7vt05yn.Task>(
    'task',
    'voteTaskCompletion',
    {
      'taskId': taskId,
      'approve': approve,
    },
  );
}

/// Balance, history and ranking (PRODUCT.md §10.3, §4.6).
/// {@category Endpoint}
class EndpointWallet extends _isc.EndpointRef {
  EndpointWallet(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'wallet';

  /// Current balance of the signed-in member, in their group. Can be negative.
  _ida.Future<int> getBalance() => caller.callServerEndpoint<int>(
    'wallet',
    'getBalance',
    {},
  );

  /// Movement history (earned/fined/spent/refunded), most recent first, each
  /// with the title of the task or reward behind it.
  ///
  /// Three queries whatever the page size — the transactions, then every task
  /// and every reward they point at in one go each — rather than one per row.
  _ida.Future<List<_ibr29qpn.CoinMovement>> getHistory({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_ibr29qpn.CoinMovement>>(
    'wallet',
    'getHistory',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// This week's ranking: coins earned minus fines, spending excluded. Resets every
  /// Monday (PRODUCT.md §4.6).
  _ida.Future<List<_ixil0pu8.RankingEntry>> getWeeklyRanking() =>
      caller.callServerEndpoint<List<_ixil0pu8.RankingEntry>>(
        'wallet',
        'getWeeklyRanking',
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    event = EndpointEvent(this);
    greeting = EndpointGreeting(this);
    group = EndpointGroup(this);
    shop = EndpointShop(this);
    task = EndpointTask(this);
    wallet = EndpointWallet(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointEvent event;

  late final EndpointGreeting greeting;

  late final EndpointGroup group;

  late final EndpointShop shop;

  late final EndpointTask task;

  late final EndpointWallet wallet;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'event': event,
    'greeting': greeting,
    'group': group,
    'shop': shop,
    'task': task,
    'wallet': wallet,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
