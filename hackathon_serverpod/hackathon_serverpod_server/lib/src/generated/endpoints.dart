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
import 'package:hackathon_serverpod_server/src/generated/future_calls.dart'
    as _isvvvywu;
import 'package:hackathon_serverpod_server/src/generated/groups/group_type.dart'
    as _ik8b7v56;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../events/event_endpoint.dart' as _i7r7roa3;
import '../greetings/greeting_endpoint.dart' as _il624ik7;
import '../groups/group_endpoint.dart' as _irt1w8ui;
import '../shop/shop_endpoint.dart' as _ig43k7x5;
import '../tasks/task_endpoint.dart' as _i3nmwja6;
import '../wallet/wallet_endpoint.dart' as _il5vx24y;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'event': _i7r7roa3.EventEndpoint()
        ..initialize(
          server,
          'event',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'group': _irt1w8ui.GroupEndpoint()
        ..initialize(
          server,
          'group',
          null,
        ),
      'shop': _ig43k7x5.ShopEndpoint()
        ..initialize(
          server,
          'shop',
          null,
        ),
      'task': _i3nmwja6.TaskEndpoint()
        ..initialize(
          server,
          'task',
          null,
        ),
      'wallet': _il5vx24y.WalletEndpoint()
        ..initialize(
          server,
          'wallet',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['event'] = _is.EndpointConnector(
      name: 'event',
      endpoint: endpoints['event']!,
      methodConnectors: {
        'watchGroup': _is.MethodStreamConnector(
          name: 'watchGroup',
          params: {},
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['event'] as _i7r7roa3.EventEndpoint).watchGroup(
                session,
              ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
    connectors['group'] = _is.EndpointConnector(
      name: 'group',
      endpoint: endpoints['group']!,
      methodConnectors: {
        'createGroup': _is.MethodConnector(
          name: 'createGroup',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<_ik8b7v56.GroupType>(),
              nullable: false,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['group'] as _irt1w8ui.GroupEndpoint).createGroup(
                    session,
                    params['name'],
                    params['type'],
                    displayName: params['displayName'],
                  ),
        ),
        'joinGroup': _is.MethodConnector(
          name: 'joinGroup',
          params: {
            'inviteCode': _is.ParameterDescription(
              name: 'inviteCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['group'] as _irt1w8ui.GroupEndpoint).joinGroup(
                    session,
                    params['inviteCode'],
                    displayName: params['displayName'],
                  ),
        ),
        'myGroup': _is.MethodConnector(
          name: 'myGroup',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['group'] as _irt1w8ui.GroupEndpoint)
                  .myGroup(session),
        ),
        'listMembers': _is.MethodConnector(
          name: 'listMembers',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['group'] as _irt1w8ui.GroupEndpoint)
                  .listMembers(session),
        ),
        'expelMember': _is.MethodConnector(
          name: 'expelMember',
          params: {
            'memberId': _is.ParameterDescription(
              name: 'memberId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['group'] as _irt1w8ui.GroupEndpoint).expelMember(
                    session,
                    params['memberId'],
                  ),
        ),
        'regenerateInviteCode': _is.MethodConnector(
          name: 'regenerateInviteCode',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['group'] as _irt1w8ui.GroupEndpoint)
                  .regenerateInviteCode(session),
        ),
      },
    );
    connectors['shop'] = _is.EndpointConnector(
      name: 'shop',
      endpoint: endpoints['shop']!,
      methodConnectors: {
        'listRewards': _is.MethodConnector(
          name: 'listRewards',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shop'] as _ig43k7x5.ShopEndpoint)
                  .listRewards(session),
        ),
        'proposeReward': _is.MethodConnector(
          name: 'proposeReward',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'price': _is.ParameterDescription(
              name: 'price',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'stock': _is.ParameterDescription(
              name: 'stock',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shop'] as _ig43k7x5.ShopEndpoint).proposeReward(
                    session,
                    params['title'],
                    params['description'],
                    params['price'],
                    stock: params['stock'],
                  ),
        ),
        'voteReward': _is.MethodConnector(
          name: 'voteReward',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'approve': _is.ParameterDescription(
              name: 'approve',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shop'] as _ig43k7x5.ShopEndpoint).voteReward(
                    session,
                    params['itemId'],
                    params['approve'],
                  ),
        ),
        'requestWish': _is.MethodConnector(
          name: 'requestWish',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shop'] as _ig43k7x5.ShopEndpoint).requestWish(
                    session,
                    params['title'],
                    params['description'],
                  ),
        ),
        'purchaseReward': _is.MethodConnector(
          name: 'purchaseReward',
          params: {
            'itemId': _is.ParameterDescription(
              name: 'itemId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'providerId': _is.ParameterDescription(
              name: 'providerId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shop'] as _ig43k7x5.ShopEndpoint).purchaseReward(
                    session,
                    params['itemId'],
                    params['providerId'],
                  ),
        ),
        'approveChildPurchase': _is.MethodConnector(
          name: 'approveChildPurchase',
          params: {
            'purchaseId': _is.ParameterDescription(
              name: 'purchaseId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'approve': _is.ParameterDescription(
              name: 'approve',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shop'] as _ig43k7x5.ShopEndpoint)
                  .approveChildPurchase(
                    session,
                    params['purchaseId'],
                    params['approve'],
                  ),
        ),
        'respondToPurchase': _is.MethodConnector(
          name: 'respondToPurchase',
          params: {
            'purchaseId': _is.ParameterDescription(
              name: 'purchaseId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'accept': _is.ParameterDescription(
              name: 'accept',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shop'] as _ig43k7x5.ShopEndpoint)
                  .respondToPurchase(
                    session,
                    params['purchaseId'],
                    params['accept'],
                  ),
        ),
        'markDelivered': _is.MethodConnector(
          name: 'markDelivered',
          params: {
            'purchaseId': _is.ParameterDescription(
              name: 'purchaseId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shop'] as _ig43k7x5.ShopEndpoint).markDelivered(
                    session,
                    params['purchaseId'],
                  ),
        ),
      },
    );
    connectors['task'] = _is.EndpointConnector(
      name: 'task',
      endpoint: endpoints['task']!,
      methodConnectors: {
        'listTasks': _is.MethodConnector(
          name: 'listTasks',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _i3nmwja6.TaskEndpoint)
                  .listTasks(session),
        ),
        'proposeTask': _is.MethodConnector(
          name: 'proposeTask',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'reward': _is.ParameterDescription(
              name: 'reward',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['task'] as _i3nmwja6.TaskEndpoint).proposeTask(
                    session,
                    params['title'],
                    params['description'],
                    params['reward'],
                  ),
        ),
        'voteTaskProposal': _is.MethodConnector(
          name: 'voteTaskProposal',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'approve': _is.ParameterDescription(
              name: 'approve',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _i3nmwja6.TaskEndpoint)
                  .voteTaskProposal(
                    session,
                    params['taskId'],
                    params['approve'],
                  ),
        ),
        'counterOfferTask': _is.MethodConnector(
          name: 'counterOfferTask',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'counterReward': _is.ParameterDescription(
              name: 'counterReward',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _i3nmwja6.TaskEndpoint)
                  .counterOfferTask(
                    session,
                    params['taskId'],
                    params['counterReward'],
                  ),
        ),
        'respondToCounterOffer': _is.MethodConnector(
          name: 'respondToCounterOffer',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'accept': _is.ParameterDescription(
              name: 'accept',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _i3nmwja6.TaskEndpoint)
                  .respondToCounterOffer(
                    session,
                    params['taskId'],
                    params['accept'],
                  ),
        ),
        'markTaskDone': _is.MethodConnector(
          name: 'markTaskDone',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['task'] as _i3nmwja6.TaskEndpoint).markTaskDone(
                    session,
                    params['taskId'],
                  ),
        ),
        'voteTaskCompletion': _is.MethodConnector(
          name: 'voteTaskCompletion',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'approve': _is.ParameterDescription(
              name: 'approve',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['task'] as _i3nmwja6.TaskEndpoint)
                  .voteTaskCompletion(
                    session,
                    params['taskId'],
                    params['approve'],
                  ),
        ),
      },
    );
    connectors['wallet'] = _is.EndpointConnector(
      name: 'wallet',
      endpoint: endpoints['wallet']!,
      methodConnectors: {
        'getBalance': _is.MethodConnector(
          name: 'getBalance',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wallet'] as _il5vx24y.WalletEndpoint)
                  .getBalance(session),
        ),
        'getHistory': _is.MethodConnector(
          name: 'getHistory',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wallet'] as _il5vx24y.WalletEndpoint).getHistory(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'getWeeklyRanking': _is.MethodConnector(
          name: 'getWeeklyRanking',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wallet'] as _il5vx24y.WalletEndpoint)
                  .getWeeklyRanking(session),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _isvvvywu.FutureCalls();
  }
}
