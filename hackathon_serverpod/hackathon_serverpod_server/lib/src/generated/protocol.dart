/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:hackathon_serverpod_server/src/generated/groups/group_member.dart'
    as _is20wtgg;
import 'package:hackathon_serverpod_server/src/generated/shop/purchase.dart'
    as _il4ufzf6;
import 'package:hackathon_serverpod_server/src/generated/shop/reward_item.dart'
    as _iub5jn2z;
import 'package:hackathon_serverpod_server/src/generated/tasks/task.dart'
    as _i0sdpywk;
import 'package:hackathon_serverpod_server/src/generated/tasks/task_vote.dart'
    as _ini4h15w;
import 'package:hackathon_serverpod_server/src/generated/wallet/coin_movement.dart'
    as _ijihwky5;
import 'package:hackathon_serverpod_server/src/generated/wallet/ranking_entry.dart'
    as _ie8onyv8;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'events/group_event.dart' as _iecilz9e;
import 'events/group_event_kind.dart' as _il82a0w2;
import 'future_calls_generated_models/task_vote_future_call_expire_vote_model.dart'
    as _if11z8io;
import 'groups/child_login_code.dart' as _ivjbsthj;
import 'groups/group.dart' as _i9ztykbt;
import 'groups/group_error_reason.dart' as _i7quka6t;
import 'groups/group_exception.dart' as _i3la3wci;
import 'groups/group_member.dart' as _iio6btzp;
import 'groups/group_member_role.dart' as _ixnaxhon;
import 'groups/group_member_status.dart' as _ivrm4l0w;
import 'groups/group_type.dart' as _iskz3t6h;
import 'shop/purchase.dart' as _iw24ridd;
import 'shop/purchase_status.dart' as _ifglcefk;
import 'shop/reward_item.dart' as _ikfprkod;
import 'shop/reward_item_status.dart' as _i2lcnj26;
import 'shop/reward_vote.dart' as _iod77io3;
import 'tasks/task.dart' as _i253is06;
import 'tasks/task_kind.dart' as _i4hckegz;
import 'tasks/task_recurrence.dart' as _ieirl7mq;
import 'tasks/task_status.dart' as _i65tv1la;
import 'tasks/task_vote.dart' as _ikgry9hi;
import 'tasks/task_vote_phase.dart' as _i40o7ktz;
import 'wallet/coin_movement.dart' as _ii2179p0;
import 'wallet/coin_transaction.dart' as _iyltnat0;
import 'wallet/coin_transaction_reason.dart' as _inbrsz7i;
import 'wallet/ranking_entry.dart' as _izo0hjq0;
export 'events/group_event.dart';
export 'events/group_event_kind.dart';
export 'groups/child_login_code.dart';
export 'groups/group.dart';
export 'groups/group_error_reason.dart';
export 'groups/group_exception.dart';
export 'groups/group_member.dart';
export 'groups/group_member_role.dart';
export 'groups/group_member_status.dart';
export 'groups/group_type.dart';
export 'shop/purchase.dart';
export 'shop/purchase_status.dart';
export 'shop/reward_item.dart';
export 'shop/reward_item_status.dart';
export 'shop/reward_vote.dart';
export 'tasks/task.dart';
export 'tasks/task_kind.dart';
export 'tasks/task_recurrence.dart';
export 'tasks/task_status.dart';
export 'tasks/task_vote.dart';
export 'tasks/task_vote_phase.dart';
export 'wallet/coin_movement.dart';
export 'wallet/coin_transaction.dart';
export 'wallet/coin_transaction_reason.dart';
export 'wallet/ranking_entry.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'child_login_code',
      dartName: 'ChildLoginCode',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'memberId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'codeHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'usedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'child_login_code_fk_0',
          columns: ['memberId'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'child_login_code_member_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'memberId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'child_login_code_code_hash_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'codeHash',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'coin_transaction',
      dartName: 'CoinTransaction',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'memberId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'amount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'reason',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CoinTransactionReason',
        ),
        _isp.ColumnDefinition(
          name: 'taskId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'purchaseId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'coin_transaction_fk_0',
          columns: ['groupId'],
          referenceTable: 'group',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'coin_transaction_fk_1',
          columns: ['memberId'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'coin_transaction_group_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'coin_transaction_member_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'memberId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'group',
      dartName: 'Group',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:GroupType',
        ),
        _isp.ColumnDefinition(
          name: 'inviteCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'finePercent',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '20',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'group__inviteCode__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'inviteCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'group_member',
      dartName: 'GroupMember',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:GroupMemberRole',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:GroupMemberStatus',
          columnDefault: '\'active\'',
        ),
        _isp.ColumnDefinition(
          name: 'balance',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'joinedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'leftAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'group_member_fk_0',
          columns: ['groupId'],
          referenceTable: 'group',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'group_member_group_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'purchase',
      dartName: 'Purchase',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'buyerId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'providerId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PurchaseStatus',
          columnDefault: '\'pending\'',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'purchase_fk_0',
          columns: ['groupId'],
          referenceTable: 'group',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'purchase_fk_1',
          columns: ['itemId'],
          referenceTable: 'reward_item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'purchase_fk_2',
          columns: ['buyerId'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'purchase_fk_3',
          columns: ['providerId'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'purchase_group_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'purchase_item_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'purchase_buyer_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'buyerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'purchase_provider_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'providerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'reward_item',
      dartName: 'RewardItem',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'price',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RewardItemStatus',
          columnDefault: '\'proposed\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdById',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'stock',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'reward_item_fk_0',
          columns: ['groupId'],
          referenceTable: 'group',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'reward_item_fk_1',
          columns: ['createdById'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'reward_item_group_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'reward_item_created_by_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdById',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'reward_vote',
      dartName: 'RewardVote',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'itemId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'memberId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'approve',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'reward_vote_fk_0',
          columns: ['itemId'],
          referenceTable: 'reward_item',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'reward_vote_fk_1',
          columns: ['memberId'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'reward_vote__itemId__memberId__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'itemId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'memberId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'task',
      dartName: 'Task',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'groupId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'reward',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TaskKind',
          columnDefault: '\'oneOff\'',
        ),
        _isp.ColumnDefinition(
          name: 'recurrence',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TaskRecurrence?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TaskStatus',
          columnDefault: '\'proposed\'',
        ),
        _isp.ColumnDefinition(
          name: 'proposedById',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'doneById',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'voteClosesAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'task_fk_0',
          columns: ['groupId'],
          referenceTable: 'group',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'task_fk_1',
          columns: ['proposedById'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'task_fk_2',
          columns: ['doneById'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'task_group_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'groupId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'task_proposed_by_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'proposedById',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'task_done_by_id_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'doneById',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'task_vote',
      dartName: 'TaskVote',
      schema: 'public',
      module: 'hackathon_serverpod',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'taskId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'memberId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'phase',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TaskVotePhase',
        ),
        _isp.ColumnDefinition(
          name: 'approve',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'counterReward',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'task_vote_fk_0',
          columns: ['taskId'],
          referenceTable: 'task',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'task_vote_fk_1',
          columns: ['memberId'],
          referenceTable: 'group_member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'task_vote__taskId__phase__memberId__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'taskId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'phase',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'memberId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iecilz9e.GroupEvent) {
      return _iecilz9e.GroupEvent.fromJson(data) as T;
    }
    if (t == _il82a0w2.GroupEventKind) {
      return _il82a0w2.GroupEventKind.fromJson(data) as T;
    }
    if (t == _if11z8io.TaskVoteFutureCallExpireVoteModel) {
      return _if11z8io.TaskVoteFutureCallExpireVoteModel.fromJson(data) as T;
    }
    if (t == _ivjbsthj.ChildLoginCode) {
      return _ivjbsthj.ChildLoginCode.fromJson(data) as T;
    }
    if (t == _i9ztykbt.Group) {
      return _i9ztykbt.Group.fromJson(data) as T;
    }
    if (t == _i7quka6t.GroupErrorReason) {
      return _i7quka6t.GroupErrorReason.fromJson(data) as T;
    }
    if (t == _i3la3wci.GroupException) {
      return _i3la3wci.GroupException.fromJson(data) as T;
    }
    if (t == _iio6btzp.GroupMember) {
      return _iio6btzp.GroupMember.fromJson(data) as T;
    }
    if (t == _ixnaxhon.GroupMemberRole) {
      return _ixnaxhon.GroupMemberRole.fromJson(data) as T;
    }
    if (t == _ivrm4l0w.GroupMemberStatus) {
      return _ivrm4l0w.GroupMemberStatus.fromJson(data) as T;
    }
    if (t == _iskz3t6h.GroupType) {
      return _iskz3t6h.GroupType.fromJson(data) as T;
    }
    if (t == _iw24ridd.Purchase) {
      return _iw24ridd.Purchase.fromJson(data) as T;
    }
    if (t == _ifglcefk.PurchaseStatus) {
      return _ifglcefk.PurchaseStatus.fromJson(data) as T;
    }
    if (t == _ikfprkod.RewardItem) {
      return _ikfprkod.RewardItem.fromJson(data) as T;
    }
    if (t == _i2lcnj26.RewardItemStatus) {
      return _i2lcnj26.RewardItemStatus.fromJson(data) as T;
    }
    if (t == _iod77io3.RewardVote) {
      return _iod77io3.RewardVote.fromJson(data) as T;
    }
    if (t == _i253is06.Task) {
      return _i253is06.Task.fromJson(data) as T;
    }
    if (t == _i4hckegz.TaskKind) {
      return _i4hckegz.TaskKind.fromJson(data) as T;
    }
    if (t == _ieirl7mq.TaskRecurrence) {
      return _ieirl7mq.TaskRecurrence.fromJson(data) as T;
    }
    if (t == _i65tv1la.TaskStatus) {
      return _i65tv1la.TaskStatus.fromJson(data) as T;
    }
    if (t == _ikgry9hi.TaskVote) {
      return _ikgry9hi.TaskVote.fromJson(data) as T;
    }
    if (t == _i40o7ktz.TaskVotePhase) {
      return _i40o7ktz.TaskVotePhase.fromJson(data) as T;
    }
    if (t == _ii2179p0.CoinMovement) {
      return _ii2179p0.CoinMovement.fromJson(data) as T;
    }
    if (t == _iyltnat0.CoinTransaction) {
      return _iyltnat0.CoinTransaction.fromJson(data) as T;
    }
    if (t == _inbrsz7i.CoinTransactionReason) {
      return _inbrsz7i.CoinTransactionReason.fromJson(data) as T;
    }
    if (t == _izo0hjq0.RankingEntry) {
      return _izo0hjq0.RankingEntry.fromJson(data) as T;
    }
    if (t == _is.getType<_iecilz9e.GroupEvent?>()) {
      return (data != null ? _iecilz9e.GroupEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_il82a0w2.GroupEventKind?>()) {
      return (data != null ? _il82a0w2.GroupEventKind.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_if11z8io.TaskVoteFutureCallExpireVoteModel?>()) {
      return (data != null
              ? _if11z8io.TaskVoteFutureCallExpireVoteModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ivjbsthj.ChildLoginCode?>()) {
      return (data != null ? _ivjbsthj.ChildLoginCode.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9ztykbt.Group?>()) {
      return (data != null ? _i9ztykbt.Group.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7quka6t.GroupErrorReason?>()) {
      return (data != null ? _i7quka6t.GroupErrorReason.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i3la3wci.GroupException?>()) {
      return (data != null ? _i3la3wci.GroupException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iio6btzp.GroupMember?>()) {
      return (data != null ? _iio6btzp.GroupMember.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixnaxhon.GroupMemberRole?>()) {
      return (data != null ? _ixnaxhon.GroupMemberRole.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivrm4l0w.GroupMemberStatus?>()) {
      return (data != null ? _ivrm4l0w.GroupMemberStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iskz3t6h.GroupType?>()) {
      return (data != null ? _iskz3t6h.GroupType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iw24ridd.Purchase?>()) {
      return (data != null ? _iw24ridd.Purchase.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifglcefk.PurchaseStatus?>()) {
      return (data != null ? _ifglcefk.PurchaseStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikfprkod.RewardItem?>()) {
      return (data != null ? _ikfprkod.RewardItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2lcnj26.RewardItemStatus?>()) {
      return (data != null ? _i2lcnj26.RewardItemStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iod77io3.RewardVote?>()) {
      return (data != null ? _iod77io3.RewardVote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i253is06.Task?>()) {
      return (data != null ? _i253is06.Task.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4hckegz.TaskKind?>()) {
      return (data != null ? _i4hckegz.TaskKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ieirl7mq.TaskRecurrence?>()) {
      return (data != null ? _ieirl7mq.TaskRecurrence.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i65tv1la.TaskStatus?>()) {
      return (data != null ? _i65tv1la.TaskStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikgry9hi.TaskVote?>()) {
      return (data != null ? _ikgry9hi.TaskVote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i40o7ktz.TaskVotePhase?>()) {
      return (data != null ? _i40o7ktz.TaskVotePhase.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ii2179p0.CoinMovement?>()) {
      return (data != null ? _ii2179p0.CoinMovement.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyltnat0.CoinTransaction?>()) {
      return (data != null ? _iyltnat0.CoinTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_inbrsz7i.CoinTransactionReason?>()) {
      return (data != null
              ? _inbrsz7i.CoinTransactionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izo0hjq0.RankingEntry?>()) {
      return (data != null ? _izo0hjq0.RankingEntry.fromJson(data) : null) as T;
    }
    if (t == List<_is20wtgg.GroupMember>) {
      return (data as List)
              .map((e) => deserialize<_is20wtgg.GroupMember>(e))
              .toList()
          as T;
    }
    if (t == List<_iub5jn2z.RewardItem>) {
      return (data as List)
              .map((e) => deserialize<_iub5jn2z.RewardItem>(e))
              .toList()
          as T;
    }
    if (t == List<_il4ufzf6.Purchase>) {
      return (data as List)
              .map((e) => deserialize<_il4ufzf6.Purchase>(e))
              .toList()
          as T;
    }
    if (t == List<_i0sdpywk.Task>) {
      return (data as List).map((e) => deserialize<_i0sdpywk.Task>(e)).toList()
          as T;
    }
    if (t == List<_ini4h15w.TaskVote>) {
      return (data as List)
              .map((e) => deserialize<_ini4h15w.TaskVote>(e))
              .toList()
          as T;
    }
    if (t == List<_ijihwky5.CoinMovement>) {
      return (data as List)
              .map((e) => deserialize<_ijihwky5.CoinMovement>(e))
              .toList()
          as T;
    }
    if (t == List<_ie8onyv8.RankingEntry>) {
      return (data as List)
              .map((e) => deserialize<_ie8onyv8.RankingEntry>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iecilz9e.GroupEvent => 'GroupEvent',
      _il82a0w2.GroupEventKind => 'GroupEventKind',
      _if11z8io.TaskVoteFutureCallExpireVoteModel =>
        'TaskVoteFutureCallExpireVoteModel',
      _ivjbsthj.ChildLoginCode => 'ChildLoginCode',
      _i9ztykbt.Group => 'Group',
      _i7quka6t.GroupErrorReason => 'GroupErrorReason',
      _i3la3wci.GroupException => 'GroupException',
      _iio6btzp.GroupMember => 'GroupMember',
      _ixnaxhon.GroupMemberRole => 'GroupMemberRole',
      _ivrm4l0w.GroupMemberStatus => 'GroupMemberStatus',
      _iskz3t6h.GroupType => 'GroupType',
      _iw24ridd.Purchase => 'Purchase',
      _ifglcefk.PurchaseStatus => 'PurchaseStatus',
      _ikfprkod.RewardItem => 'RewardItem',
      _i2lcnj26.RewardItemStatus => 'RewardItemStatus',
      _iod77io3.RewardVote => 'RewardVote',
      _i253is06.Task => 'Task',
      _i4hckegz.TaskKind => 'TaskKind',
      _ieirl7mq.TaskRecurrence => 'TaskRecurrence',
      _i65tv1la.TaskStatus => 'TaskStatus',
      _ikgry9hi.TaskVote => 'TaskVote',
      _i40o7ktz.TaskVotePhase => 'TaskVotePhase',
      _ii2179p0.CoinMovement => 'CoinMovement',
      _iyltnat0.CoinTransaction => 'CoinTransaction',
      _inbrsz7i.CoinTransactionReason => 'CoinTransactionReason',
      _izo0hjq0.RankingEntry => 'RankingEntry',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'hackathon_serverpod.',
        '',
      );
    }

    switch (data) {
      case _iecilz9e.GroupEvent():
        return 'GroupEvent';
      case _il82a0w2.GroupEventKind():
        return 'GroupEventKind';
      case _if11z8io.TaskVoteFutureCallExpireVoteModel():
        return 'TaskVoteFutureCallExpireVoteModel';
      case _ivjbsthj.ChildLoginCode():
        return 'ChildLoginCode';
      case _i9ztykbt.Group():
        return 'Group';
      case _i7quka6t.GroupErrorReason():
        return 'GroupErrorReason';
      case _i3la3wci.GroupException():
        return 'GroupException';
      case _iio6btzp.GroupMember():
        return 'GroupMember';
      case _ixnaxhon.GroupMemberRole():
        return 'GroupMemberRole';
      case _ivrm4l0w.GroupMemberStatus():
        return 'GroupMemberStatus';
      case _iskz3t6h.GroupType():
        return 'GroupType';
      case _iw24ridd.Purchase():
        return 'Purchase';
      case _ifglcefk.PurchaseStatus():
        return 'PurchaseStatus';
      case _ikfprkod.RewardItem():
        return 'RewardItem';
      case _i2lcnj26.RewardItemStatus():
        return 'RewardItemStatus';
      case _iod77io3.RewardVote():
        return 'RewardVote';
      case _i253is06.Task():
        return 'Task';
      case _i4hckegz.TaskKind():
        return 'TaskKind';
      case _ieirl7mq.TaskRecurrence():
        return 'TaskRecurrence';
      case _i65tv1la.TaskStatus():
        return 'TaskStatus';
      case _ikgry9hi.TaskVote():
        return 'TaskVote';
      case _i40o7ktz.TaskVotePhase():
        return 'TaskVotePhase';
      case _ii2179p0.CoinMovement():
        return 'CoinMovement';
      case _iyltnat0.CoinTransaction():
        return 'CoinTransaction';
      case _inbrsz7i.CoinTransactionReason():
        return 'CoinTransactionReason';
      case _izo0hjq0.RankingEntry():
        return 'RankingEntry';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'GroupEvent') {
      return deserialize<_iecilz9e.GroupEvent>(data['data']);
    }
    if (dataClassName == 'GroupEventKind') {
      return deserialize<_il82a0w2.GroupEventKind>(data['data']);
    }
    if (dataClassName == 'TaskVoteFutureCallExpireVoteModel') {
      return deserialize<_if11z8io.TaskVoteFutureCallExpireVoteModel>(
        data['data'],
      );
    }
    if (dataClassName == 'ChildLoginCode') {
      return deserialize<_ivjbsthj.ChildLoginCode>(data['data']);
    }
    if (dataClassName == 'Group') {
      return deserialize<_i9ztykbt.Group>(data['data']);
    }
    if (dataClassName == 'GroupErrorReason') {
      return deserialize<_i7quka6t.GroupErrorReason>(data['data']);
    }
    if (dataClassName == 'GroupException') {
      return deserialize<_i3la3wci.GroupException>(data['data']);
    }
    if (dataClassName == 'GroupMember') {
      return deserialize<_iio6btzp.GroupMember>(data['data']);
    }
    if (dataClassName == 'GroupMemberRole') {
      return deserialize<_ixnaxhon.GroupMemberRole>(data['data']);
    }
    if (dataClassName == 'GroupMemberStatus') {
      return deserialize<_ivrm4l0w.GroupMemberStatus>(data['data']);
    }
    if (dataClassName == 'GroupType') {
      return deserialize<_iskz3t6h.GroupType>(data['data']);
    }
    if (dataClassName == 'Purchase') {
      return deserialize<_iw24ridd.Purchase>(data['data']);
    }
    if (dataClassName == 'PurchaseStatus') {
      return deserialize<_ifglcefk.PurchaseStatus>(data['data']);
    }
    if (dataClassName == 'RewardItem') {
      return deserialize<_ikfprkod.RewardItem>(data['data']);
    }
    if (dataClassName == 'RewardItemStatus') {
      return deserialize<_i2lcnj26.RewardItemStatus>(data['data']);
    }
    if (dataClassName == 'RewardVote') {
      return deserialize<_iod77io3.RewardVote>(data['data']);
    }
    if (dataClassName == 'Task') {
      return deserialize<_i253is06.Task>(data['data']);
    }
    if (dataClassName == 'TaskKind') {
      return deserialize<_i4hckegz.TaskKind>(data['data']);
    }
    if (dataClassName == 'TaskRecurrence') {
      return deserialize<_ieirl7mq.TaskRecurrence>(data['data']);
    }
    if (dataClassName == 'TaskStatus') {
      return deserialize<_i65tv1la.TaskStatus>(data['data']);
    }
    if (dataClassName == 'TaskVote') {
      return deserialize<_ikgry9hi.TaskVote>(data['data']);
    }
    if (dataClassName == 'TaskVotePhase') {
      return deserialize<_i40o7ktz.TaskVotePhase>(data['data']);
    }
    if (dataClassName == 'CoinMovement') {
      return deserialize<_ii2179p0.CoinMovement>(data['data']);
    }
    if (dataClassName == 'CoinTransaction') {
      return deserialize<_iyltnat0.CoinTransaction>(data['data']);
    }
    if (dataClassName == 'CoinTransactionReason') {
      return deserialize<_inbrsz7i.CoinTransactionReason>(data['data']);
    }
    if (dataClassName == 'RankingEntry') {
      return deserialize<_izo0hjq0.RankingEntry>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('hackathon_serverpod', this);
    _iacs.Protocol().registerHostProtocol('hackathon_serverpod', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ivjbsthj.ChildLoginCode:
        return _ivjbsthj.ChildLoginCode.t;
      case _i9ztykbt.Group:
        return _i9ztykbt.Group.t;
      case _iio6btzp.GroupMember:
        return _iio6btzp.GroupMember.t;
      case _iw24ridd.Purchase:
        return _iw24ridd.Purchase.t;
      case _ikfprkod.RewardItem:
        return _ikfprkod.RewardItem.t;
      case _iod77io3.RewardVote:
        return _iod77io3.RewardVote.t;
      case _i253is06.Task:
        return _i253is06.Task.t;
      case _ikgry9hi.TaskVote:
        return _ikgry9hi.TaskVote.t;
      case _iyltnat0.CoinTransaction:
        return _iyltnat0.CoinTransaction.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'hackathon_serverpod';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
