// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identityKindMeta = const VerificationMeta(
    'identityKind',
  );
  @override
  late final GeneratedColumn<String> identityKind = GeneratedColumn<String>(
    'identity_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local_dev'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    identityKind,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('identity_kind')) {
      context.handle(
        _identityKindMeta,
        identityKind.isAcceptableOrUnknown(
          data['identity_kind']!,
          _identityKindMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      identityKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_kind'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final String displayName;
  final String identityKind;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.displayName,
    required this.identityKind,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['identity_kind'] = Variable<String>(identityKind);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      identityKind: Value(identityKind),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      identityKind: serializer.fromJson<String>(json['identityKind']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'identityKind': serializer.toJson<String>(identityKind),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    String? id,
    String? displayName,
    String? identityKind,
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    identityKind: identityKind ?? this.identityKind,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      identityKind: data.identityKind.present
          ? data.identityKind.value
          : this.identityKind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('identityKind: $identityKind, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, identityKind, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.identityKind == this.identityKind &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> identityKind;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.identityKind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String displayName,
    this.identityKind = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       createdAt = Value(createdAt);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? identityKind,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (identityKind != null) 'identity_kind': identityKind,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? identityKind,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      identityKind: identityKind ?? this.identityKind,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (identityKind.present) {
      map['identity_kind'] = Variable<String>(identityKind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('identityKind: $identityKind, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkspacesTable extends Workspaces
    with TableInfo<$WorkspacesTable, Workspace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkspacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    createdBy,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workspaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workspace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workspace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workspace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $WorkspacesTable createAlias(String alias) {
    return $WorkspacesTable(attachedDatabase, alias);
  }
}

class Workspace extends DataClass implements Insertable<Workspace> {
  final String id;
  final String name;
  final DateTime createdAt;
  final String createdBy;
  final DateTime? archivedAt;
  const Workspace({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.createdBy,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  WorkspacesCompanion toCompanion(bool nullToAbsent) {
    return WorkspacesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Workspace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workspace(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Workspace copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? createdBy,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Workspace(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Workspace copyWithCompanion(WorkspacesCompanion data) {
    return Workspace(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workspace(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, createdBy, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workspace &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.archivedAt == this.archivedAt);
}

class WorkspacesCompanion extends UpdateCompanion<Workspace> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const WorkspacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkspacesCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required String createdBy,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy);
  static Insertable<Workspace> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkspacesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return WorkspacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkspacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MembershipsTable extends Memberships
    with TableInfo<$MembershipsTable, Membership> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembershipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [workspaceId, userId, role, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memberships';
  @override
  VerificationContext validateIntegrity(
    Insertable<Membership> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workspaceId, userId};
  @override
  Membership map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Membership(
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MembershipsTable createAlias(String alias) {
    return $MembershipsTable(attachedDatabase, alias);
  }
}

class Membership extends DataClass implements Insertable<Membership> {
  final String workspaceId;
  final String userId;
  final String role;
  final String status;
  const Membership({
    required this.workspaceId,
    required this.userId,
    required this.role,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workspace_id'] = Variable<String>(workspaceId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['status'] = Variable<String>(status);
    return map;
  }

  MembershipsCompanion toCompanion(bool nullToAbsent) {
    return MembershipsCompanion(
      workspaceId: Value(workspaceId),
      userId: Value(userId),
      role: Value(role),
      status: Value(status),
    );
  }

  factory Membership.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Membership(
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workspaceId': serializer.toJson<String>(workspaceId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'status': serializer.toJson<String>(status),
    };
  }

  Membership copyWith({
    String? workspaceId,
    String? userId,
    String? role,
    String? status,
  }) => Membership(
    workspaceId: workspaceId ?? this.workspaceId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    status: status ?? this.status,
  );
  Membership copyWithCompanion(MembershipsCompanion data) {
    return Membership(
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Membership(')
          ..write('workspaceId: $workspaceId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workspaceId, userId, role, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Membership &&
          other.workspaceId == this.workspaceId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.status == this.status);
}

class MembershipsCompanion extends UpdateCompanion<Membership> {
  final Value<String> workspaceId;
  final Value<String> userId;
  final Value<String> role;
  final Value<String> status;
  final Value<int> rowid;
  const MembershipsCompanion({
    this.workspaceId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembershipsCompanion.insert({
    required String workspaceId,
    required String userId,
    required String role,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workspaceId = Value(workspaceId),
       userId = Value(userId),
       role = Value(role);
  static Insertable<Membership> custom({
    Expression<String>? workspaceId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembershipsCompanion copyWith({
    Value<String>? workspaceId,
    Value<String>? userId,
    Value<String>? role,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return MembershipsCompanion(
      workspaceId: workspaceId ?? this.workspaceId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembershipsCompanion(')
          ..write('workspaceId: $workspaceId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FieldsTable extends Fields with TableInfo<$FieldsTable, Field> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasesMeta = const VerificationMeta(
    'aliases',
  );
  @override
  late final GeneratedColumn<String> aliases = GeneratedColumn<String>(
    'aliases',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
    'area_m2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaMethodMeta = const VerificationMeta(
    'areaMethod',
  );
  @override
  late final GeneratedColumn<String> areaMethod = GeneratedColumn<String>(
    'area_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    name,
    aliases,
    areaM2,
    areaMethod,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<Field> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('aliases')) {
      context.handle(
        _aliasesMeta,
        aliases.isAcceptableOrUnknown(data['aliases']!, _aliasesMeta),
      );
    }
    if (data.containsKey('area_m2')) {
      context.handle(
        _areaM2Meta,
        areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta),
      );
    }
    if (data.containsKey('area_method')) {
      context.handle(
        _areaMethodMeta,
        areaMethod.isAcceptableOrUnknown(data['area_method']!, _areaMethodMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Field map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Field(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      aliases: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aliases'],
      )!,
      areaM2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_m2'],
      ),
      areaMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area_method'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $FieldsTable createAlias(String alias) {
    return $FieldsTable(attachedDatabase, alias);
  }
}

class Field extends DataClass implements Insertable<Field> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String name;
  final String aliases;
  final double? areaM2;
  final String? areaMethod;
  final String notes;
  const Field({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.name,
    required this.aliases,
    this.areaM2,
    this.areaMethod,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['name'] = Variable<String>(name);
    map['aliases'] = Variable<String>(aliases);
    if (!nullToAbsent || areaM2 != null) {
      map['area_m2'] = Variable<double>(areaM2);
    }
    if (!nullToAbsent || areaMethod != null) {
      map['area_method'] = Variable<String>(areaMethod);
    }
    map['notes'] = Variable<String>(notes);
    return map;
  }

  FieldsCompanion toCompanion(bool nullToAbsent) {
    return FieldsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      name: Value(name),
      aliases: Value(aliases),
      areaM2: areaM2 == null && nullToAbsent
          ? const Value.absent()
          : Value(areaM2),
      areaMethod: areaMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(areaMethod),
      notes: Value(notes),
    );
  }

  factory Field.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Field(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      name: serializer.fromJson<String>(json['name']),
      aliases: serializer.fromJson<String>(json['aliases']),
      areaM2: serializer.fromJson<double?>(json['areaM2']),
      areaMethod: serializer.fromJson<String?>(json['areaMethod']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'name': serializer.toJson<String>(name),
      'aliases': serializer.toJson<String>(aliases),
      'areaM2': serializer.toJson<double?>(areaM2),
      'areaMethod': serializer.toJson<String?>(areaMethod),
      'notes': serializer.toJson<String>(notes),
    };
  }

  Field copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? name,
    String? aliases,
    Value<double?> areaM2 = const Value.absent(),
    Value<String?> areaMethod = const Value.absent(),
    String? notes,
  }) => Field(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    name: name ?? this.name,
    aliases: aliases ?? this.aliases,
    areaM2: areaM2.present ? areaM2.value : this.areaM2,
    areaMethod: areaMethod.present ? areaMethod.value : this.areaMethod,
    notes: notes ?? this.notes,
  );
  Field copyWithCompanion(FieldsCompanion data) {
    return Field(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      name: data.name.present ? data.name.value : this.name,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      areaMethod: data.areaMethod.present
          ? data.areaMethod.value
          : this.areaMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Field(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('aliases: $aliases, ')
          ..write('areaM2: $areaM2, ')
          ..write('areaMethod: $areaMethod, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    name,
    aliases,
    areaM2,
    areaMethod,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Field &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.name == this.name &&
          other.aliases == this.aliases &&
          other.areaM2 == this.areaM2 &&
          other.areaMethod == this.areaMethod &&
          other.notes == this.notes);
}

class FieldsCompanion extends UpdateCompanion<Field> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> name;
  final Value<String> aliases;
  final Value<double?> areaM2;
  final Value<String?> areaMethod;
  final Value<String> notes;
  final Value<int> rowid;
  const FieldsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.aliases = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.areaMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FieldsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String name,
    this.aliases = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.areaMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       name = Value(name);
  static Insertable<Field> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? name,
    Expression<String>? aliases,
    Expression<double>? areaM2,
    Expression<String>? areaMethod,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (name != null) 'name': name,
      if (aliases != null) 'aliases': aliases,
      if (areaM2 != null) 'area_m2': areaM2,
      if (areaMethod != null) 'area_method': areaMethod,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FieldsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? name,
    Value<String>? aliases,
    Value<double?>? areaM2,
    Value<String?>? areaMethod,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return FieldsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      name: name ?? this.name,
      aliases: aliases ?? this.aliases,
      areaM2: areaM2 ?? this.areaM2,
      areaMethod: areaMethod ?? this.areaMethod,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (aliases.present) {
      map['aliases'] = Variable<String>(aliases.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (areaMethod.present) {
      map['area_method'] = Variable<String>(areaMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('aliases: $aliases, ')
          ..write('areaM2: $areaM2, ')
          ..write('areaMethod: $areaMethod, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FieldBoundaryVersionsTable extends FieldBoundaryVersions
    with TableInfo<$FieldBoundaryVersionsTable, FieldBoundaryVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldBoundaryVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsJsonMeta = const VerificationMeta(
    'pointsJson',
  );
  @override
  late final GeneratedColumn<String> pointsJson = GeneratedColumn<String>(
    'points_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medianAccuracyMMeta = const VerificationMeta(
    'medianAccuracyM',
  );
  @override
  late final GeneratedColumn<double> medianAccuracyM = GeneratedColumn<double>(
    'median_accuracy_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaM2Meta = const VerificationMeta('areaM2');
  @override
  late final GeneratedColumn<double> areaM2 = GeneratedColumn<double>(
    'area_m2',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    pointsJson,
    source,
    medianAccuracyM,
    areaM2,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'field_boundary_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FieldBoundaryVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('points_json')) {
      context.handle(
        _pointsJsonMeta,
        pointsJson.isAcceptableOrUnknown(data['points_json']!, _pointsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsJsonMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('median_accuracy_m')) {
      context.handle(
        _medianAccuracyMMeta,
        medianAccuracyM.isAcceptableOrUnknown(
          data['median_accuracy_m']!,
          _medianAccuracyMMeta,
        ),
      );
    }
    if (data.containsKey('area_m2')) {
      context.handle(
        _areaM2Meta,
        areaM2.isAcceptableOrUnknown(data['area_m2']!, _areaM2Meta),
      );
    } else if (isInserting) {
      context.missing(_areaM2Meta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FieldBoundaryVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FieldBoundaryVersion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      pointsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}points_json'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      medianAccuracyM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}median_accuracy_m'],
      ),
      areaM2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}area_m2'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $FieldBoundaryVersionsTable createAlias(String alias) {
    return $FieldBoundaryVersionsTable(attachedDatabase, alias);
  }
}

class FieldBoundaryVersion extends DataClass
    implements Insertable<FieldBoundaryVersion> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String fieldId;
  final String pointsJson;
  final String source;
  final double? medianAccuracyM;
  final double areaM2;
  final String status;
  const FieldBoundaryVersion({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.fieldId,
    required this.pointsJson,
    required this.source,
    this.medianAccuracyM,
    required this.areaM2,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['field_id'] = Variable<String>(fieldId);
    map['points_json'] = Variable<String>(pointsJson);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || medianAccuracyM != null) {
      map['median_accuracy_m'] = Variable<double>(medianAccuracyM);
    }
    map['area_m2'] = Variable<double>(areaM2);
    map['status'] = Variable<String>(status);
    return map;
  }

  FieldBoundaryVersionsCompanion toCompanion(bool nullToAbsent) {
    return FieldBoundaryVersionsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      fieldId: Value(fieldId),
      pointsJson: Value(pointsJson),
      source: Value(source),
      medianAccuracyM: medianAccuracyM == null && nullToAbsent
          ? const Value.absent()
          : Value(medianAccuracyM),
      areaM2: Value(areaM2),
      status: Value(status),
    );
  }

  factory FieldBoundaryVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FieldBoundaryVersion(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      pointsJson: serializer.fromJson<String>(json['pointsJson']),
      source: serializer.fromJson<String>(json['source']),
      medianAccuracyM: serializer.fromJson<double?>(json['medianAccuracyM']),
      areaM2: serializer.fromJson<double>(json['areaM2']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'fieldId': serializer.toJson<String>(fieldId),
      'pointsJson': serializer.toJson<String>(pointsJson),
      'source': serializer.toJson<String>(source),
      'medianAccuracyM': serializer.toJson<double?>(medianAccuracyM),
      'areaM2': serializer.toJson<double>(areaM2),
      'status': serializer.toJson<String>(status),
    };
  }

  FieldBoundaryVersion copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? fieldId,
    String? pointsJson,
    String? source,
    Value<double?> medianAccuracyM = const Value.absent(),
    double? areaM2,
    String? status,
  }) => FieldBoundaryVersion(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    fieldId: fieldId ?? this.fieldId,
    pointsJson: pointsJson ?? this.pointsJson,
    source: source ?? this.source,
    medianAccuracyM: medianAccuracyM.present
        ? medianAccuracyM.value
        : this.medianAccuracyM,
    areaM2: areaM2 ?? this.areaM2,
    status: status ?? this.status,
  );
  FieldBoundaryVersion copyWithCompanion(FieldBoundaryVersionsCompanion data) {
    return FieldBoundaryVersion(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      pointsJson: data.pointsJson.present
          ? data.pointsJson.value
          : this.pointsJson,
      source: data.source.present ? data.source.value : this.source,
      medianAccuracyM: data.medianAccuracyM.present
          ? data.medianAccuracyM.value
          : this.medianAccuracyM,
      areaM2: data.areaM2.present ? data.areaM2.value : this.areaM2,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FieldBoundaryVersion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('source: $source, ')
          ..write('medianAccuracyM: $medianAccuracyM, ')
          ..write('areaM2: $areaM2, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    pointsJson,
    source,
    medianAccuracyM,
    areaM2,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldBoundaryVersion &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.fieldId == this.fieldId &&
          other.pointsJson == this.pointsJson &&
          other.source == this.source &&
          other.medianAccuracyM == this.medianAccuracyM &&
          other.areaM2 == this.areaM2 &&
          other.status == this.status);
}

class FieldBoundaryVersionsCompanion
    extends UpdateCompanion<FieldBoundaryVersion> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> fieldId;
  final Value<String> pointsJson;
  final Value<String> source;
  final Value<double?> medianAccuracyM;
  final Value<double> areaM2;
  final Value<String> status;
  final Value<int> rowid;
  const FieldBoundaryVersionsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.pointsJson = const Value.absent(),
    this.source = const Value.absent(),
    this.medianAccuracyM = const Value.absent(),
    this.areaM2 = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FieldBoundaryVersionsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String fieldId,
    required String pointsJson,
    required String source,
    this.medianAccuracyM = const Value.absent(),
    required double areaM2,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       fieldId = Value(fieldId),
       pointsJson = Value(pointsJson),
       source = Value(source),
       areaM2 = Value(areaM2),
       status = Value(status);
  static Insertable<FieldBoundaryVersion> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? fieldId,
    Expression<String>? pointsJson,
    Expression<String>? source,
    Expression<double>? medianAccuracyM,
    Expression<double>? areaM2,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (fieldId != null) 'field_id': fieldId,
      if (pointsJson != null) 'points_json': pointsJson,
      if (source != null) 'source': source,
      if (medianAccuracyM != null) 'median_accuracy_m': medianAccuracyM,
      if (areaM2 != null) 'area_m2': areaM2,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FieldBoundaryVersionsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? fieldId,
    Value<String>? pointsJson,
    Value<String>? source,
    Value<double?>? medianAccuracyM,
    Value<double>? areaM2,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return FieldBoundaryVersionsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      fieldId: fieldId ?? this.fieldId,
      pointsJson: pointsJson ?? this.pointsJson,
      source: source ?? this.source,
      medianAccuracyM: medianAccuracyM ?? this.medianAccuracyM,
      areaM2: areaM2 ?? this.areaM2,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (pointsJson.present) {
      map['points_json'] = Variable<String>(pointsJson.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (medianAccuracyM.present) {
      map['median_accuracy_m'] = Variable<double>(medianAccuracyM.value);
    }
    if (areaM2.present) {
      map['area_m2'] = Variable<double>(areaM2.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldBoundaryVersionsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('pointsJson: $pointsJson, ')
          ..write('source: $source, ')
          ..write('medianAccuracyM: $medianAccuracyM, ')
          ..write('areaM2: $areaM2, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LandParcelsTable extends LandParcels
    with TableInfo<$LandParcelsTable, LandParcel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LandParcelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parcelCodeMeta = const VerificationMeta(
    'parcelCode',
  );
  @override
  late final GeneratedColumn<String> parcelCode = GeneratedColumn<String>(
    'parcel_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    parcelCode,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'land_parcels';
  @override
  VerificationContext validateIntegrity(
    Insertable<LandParcel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('parcel_code')) {
      context.handle(
        _parcelCodeMeta,
        parcelCode.isAcceptableOrUnknown(data['parcel_code']!, _parcelCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelCodeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LandParcel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LandParcel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      parcelCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parcel_code'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $LandParcelsTable createAlias(String alias) {
    return $LandParcelsTable(attachedDatabase, alias);
  }
}

class LandParcel extends DataClass implements Insertable<LandParcel> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String parcelCode;
  final String notes;
  const LandParcel({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.parcelCode,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['parcel_code'] = Variable<String>(parcelCode);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  LandParcelsCompanion toCompanion(bool nullToAbsent) {
    return LandParcelsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      parcelCode: Value(parcelCode),
      notes: Value(notes),
    );
  }

  factory LandParcel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LandParcel(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      parcelCode: serializer.fromJson<String>(json['parcelCode']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'parcelCode': serializer.toJson<String>(parcelCode),
      'notes': serializer.toJson<String>(notes),
    };
  }

  LandParcel copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? parcelCode,
    String? notes,
  }) => LandParcel(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    parcelCode: parcelCode ?? this.parcelCode,
    notes: notes ?? this.notes,
  );
  LandParcel copyWithCompanion(LandParcelsCompanion data) {
    return LandParcel(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      parcelCode: data.parcelCode.present
          ? data.parcelCode.value
          : this.parcelCode,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LandParcel(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('parcelCode: $parcelCode, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    parcelCode,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LandParcel &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.parcelCode == this.parcelCode &&
          other.notes == this.notes);
}

class LandParcelsCompanion extends UpdateCompanion<LandParcel> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> parcelCode;
  final Value<String> notes;
  final Value<int> rowid;
  const LandParcelsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.parcelCode = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LandParcelsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String parcelCode,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       parcelCode = Value(parcelCode);
  static Insertable<LandParcel> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? parcelCode,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (parcelCode != null) 'parcel_code': parcelCode,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LandParcelsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? parcelCode,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return LandParcelsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      parcelCode: parcelCode ?? this.parcelCode,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (parcelCode.present) {
      map['parcel_code'] = Variable<String>(parcelCode.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LandParcelsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('parcelCode: $parcelCode, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FieldParcelsTable extends FieldParcels
    with TableInfo<$FieldParcelsTable, FieldParcel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldParcelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parcelIdMeta = const VerificationMeta(
    'parcelId',
  );
  @override
  late final GeneratedColumn<String> parcelId = GeneratedColumn<String>(
    'parcel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [workspaceId, fieldId, parcelId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'field_parcels';
  @override
  VerificationContext validateIntegrity(
    Insertable<FieldParcel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('parcel_id')) {
      context.handle(
        _parcelIdMeta,
        parcelId.isAcceptableOrUnknown(data['parcel_id']!, _parcelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fieldId, parcelId};
  @override
  FieldParcel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FieldParcel(
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      parcelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parcel_id'],
      )!,
    );
  }

  @override
  $FieldParcelsTable createAlias(String alias) {
    return $FieldParcelsTable(attachedDatabase, alias);
  }
}

class FieldParcel extends DataClass implements Insertable<FieldParcel> {
  final String workspaceId;
  final String fieldId;
  final String parcelId;
  const FieldParcel({
    required this.workspaceId,
    required this.fieldId,
    required this.parcelId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workspace_id'] = Variable<String>(workspaceId);
    map['field_id'] = Variable<String>(fieldId);
    map['parcel_id'] = Variable<String>(parcelId);
    return map;
  }

  FieldParcelsCompanion toCompanion(bool nullToAbsent) {
    return FieldParcelsCompanion(
      workspaceId: Value(workspaceId),
      fieldId: Value(fieldId),
      parcelId: Value(parcelId),
    );
  }

  factory FieldParcel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FieldParcel(
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      parcelId: serializer.fromJson<String>(json['parcelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workspaceId': serializer.toJson<String>(workspaceId),
      'fieldId': serializer.toJson<String>(fieldId),
      'parcelId': serializer.toJson<String>(parcelId),
    };
  }

  FieldParcel copyWith({
    String? workspaceId,
    String? fieldId,
    String? parcelId,
  }) => FieldParcel(
    workspaceId: workspaceId ?? this.workspaceId,
    fieldId: fieldId ?? this.fieldId,
    parcelId: parcelId ?? this.parcelId,
  );
  FieldParcel copyWithCompanion(FieldParcelsCompanion data) {
    return FieldParcel(
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      parcelId: data.parcelId.present ? data.parcelId.value : this.parcelId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FieldParcel(')
          ..write('workspaceId: $workspaceId, ')
          ..write('fieldId: $fieldId, ')
          ..write('parcelId: $parcelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workspaceId, fieldId, parcelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldParcel &&
          other.workspaceId == this.workspaceId &&
          other.fieldId == this.fieldId &&
          other.parcelId == this.parcelId);
}

class FieldParcelsCompanion extends UpdateCompanion<FieldParcel> {
  final Value<String> workspaceId;
  final Value<String> fieldId;
  final Value<String> parcelId;
  final Value<int> rowid;
  const FieldParcelsCompanion({
    this.workspaceId = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.parcelId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FieldParcelsCompanion.insert({
    required String workspaceId,
    required String fieldId,
    required String parcelId,
    this.rowid = const Value.absent(),
  }) : workspaceId = Value(workspaceId),
       fieldId = Value(fieldId),
       parcelId = Value(parcelId);
  static Insertable<FieldParcel> custom({
    Expression<String>? workspaceId,
    Expression<String>? fieldId,
    Expression<String>? parcelId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (fieldId != null) 'field_id': fieldId,
      if (parcelId != null) 'parcel_id': parcelId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FieldParcelsCompanion copyWith({
    Value<String>? workspaceId,
    Value<String>? fieldId,
    Value<String>? parcelId,
    Value<int>? rowid,
  }) {
    return FieldParcelsCompanion(
      workspaceId: workspaceId ?? this.workspaceId,
      fieldId: fieldId ?? this.fieldId,
      parcelId: parcelId ?? this.parcelId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (parcelId.present) {
      map['parcel_id'] = Variable<String>(parcelId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldParcelsCompanion(')
          ..write('workspaceId: $workspaceId, ')
          ..write('fieldId: $fieldId, ')
          ..write('parcelId: $parcelId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LandRelationsTable extends LandRelations
    with TableInfo<$LandRelationsTable, LandRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LandRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parcelIdMeta = const VerificationMeta(
    'parcelId',
  );
  @override
  late final GeneratedColumn<String> parcelId = GeneratedColumn<String>(
    'parcel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partyNameMeta = const VerificationMeta(
    'partyName',
  );
  @override
  late final GeneratedColumn<String> partyName = GeneratedColumn<String>(
    'party_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shareMeta = const VerificationMeta('share');
  @override
  late final GeneratedColumn<String> share = GeneratedColumn<String>(
    'share',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _periodStartMeta = const VerificationMeta(
    'periodStart',
  );
  @override
  late final GeneratedColumn<DateTime> periodStart = GeneratedColumn<DateTime>(
    'period_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _periodEndMeta = const VerificationMeta(
    'periodEnd',
  );
  @override
  late final GeneratedColumn<DateTime> periodEnd = GeneratedColumn<DateTime>(
    'period_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rentAmountMeta = const VerificationMeta(
    'rentAmount',
  );
  @override
  late final GeneratedColumn<String> rentAmount = GeneratedColumn<String>(
    'rent_amount',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verificationMeta = const VerificationMeta(
    'verification',
  );
  @override
  late final GeneratedColumn<String> verification = GeneratedColumn<String>(
    'verification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('self_reported'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    parcelId,
    partyName,
    kind,
    share,
    periodStart,
    periodEnd,
    rentAmount,
    verification,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'land_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LandRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('parcel_id')) {
      context.handle(
        _parcelIdMeta,
        parcelId.isAcceptableOrUnknown(data['parcel_id']!, _parcelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parcelIdMeta);
    }
    if (data.containsKey('party_name')) {
      context.handle(
        _partyNameMeta,
        partyName.isAcceptableOrUnknown(data['party_name']!, _partyNameMeta),
      );
    } else if (isInserting) {
      context.missing(_partyNameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('share')) {
      context.handle(
        _shareMeta,
        share.isAcceptableOrUnknown(data['share']!, _shareMeta),
      );
    }
    if (data.containsKey('period_start')) {
      context.handle(
        _periodStartMeta,
        periodStart.isAcceptableOrUnknown(
          data['period_start']!,
          _periodStartMeta,
        ),
      );
    }
    if (data.containsKey('period_end')) {
      context.handle(
        _periodEndMeta,
        periodEnd.isAcceptableOrUnknown(data['period_end']!, _periodEndMeta),
      );
    }
    if (data.containsKey('rent_amount')) {
      context.handle(
        _rentAmountMeta,
        rentAmount.isAcceptableOrUnknown(data['rent_amount']!, _rentAmountMeta),
      );
    }
    if (data.containsKey('verification')) {
      context.handle(
        _verificationMeta,
        verification.isAcceptableOrUnknown(
          data['verification']!,
          _verificationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LandRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LandRelation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      parcelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parcel_id'],
      )!,
      partyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party_name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      share: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share'],
      )!,
      periodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start'],
      ),
      periodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_end'],
      ),
      rentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rent_amount'],
      ),
      verification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification'],
      )!,
    );
  }

  @override
  $LandRelationsTable createAlias(String alias) {
    return $LandRelationsTable(attachedDatabase, alias);
  }
}

class LandRelation extends DataClass implements Insertable<LandRelation> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String parcelId;
  final String partyName;
  final String kind;
  final String share;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String? rentAmount;
  final String verification;
  const LandRelation({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.parcelId,
    required this.partyName,
    required this.kind,
    required this.share,
    this.periodStart,
    this.periodEnd,
    this.rentAmount,
    required this.verification,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['parcel_id'] = Variable<String>(parcelId);
    map['party_name'] = Variable<String>(partyName);
    map['kind'] = Variable<String>(kind);
    map['share'] = Variable<String>(share);
    if (!nullToAbsent || periodStart != null) {
      map['period_start'] = Variable<DateTime>(periodStart);
    }
    if (!nullToAbsent || periodEnd != null) {
      map['period_end'] = Variable<DateTime>(periodEnd);
    }
    if (!nullToAbsent || rentAmount != null) {
      map['rent_amount'] = Variable<String>(rentAmount);
    }
    map['verification'] = Variable<String>(verification);
    return map;
  }

  LandRelationsCompanion toCompanion(bool nullToAbsent) {
    return LandRelationsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      parcelId: Value(parcelId),
      partyName: Value(partyName),
      kind: Value(kind),
      share: Value(share),
      periodStart: periodStart == null && nullToAbsent
          ? const Value.absent()
          : Value(periodStart),
      periodEnd: periodEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(periodEnd),
      rentAmount: rentAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(rentAmount),
      verification: Value(verification),
    );
  }

  factory LandRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LandRelation(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      parcelId: serializer.fromJson<String>(json['parcelId']),
      partyName: serializer.fromJson<String>(json['partyName']),
      kind: serializer.fromJson<String>(json['kind']),
      share: serializer.fromJson<String>(json['share']),
      periodStart: serializer.fromJson<DateTime?>(json['periodStart']),
      periodEnd: serializer.fromJson<DateTime?>(json['periodEnd']),
      rentAmount: serializer.fromJson<String?>(json['rentAmount']),
      verification: serializer.fromJson<String>(json['verification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'parcelId': serializer.toJson<String>(parcelId),
      'partyName': serializer.toJson<String>(partyName),
      'kind': serializer.toJson<String>(kind),
      'share': serializer.toJson<String>(share),
      'periodStart': serializer.toJson<DateTime?>(periodStart),
      'periodEnd': serializer.toJson<DateTime?>(periodEnd),
      'rentAmount': serializer.toJson<String?>(rentAmount),
      'verification': serializer.toJson<String>(verification),
    };
  }

  LandRelation copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? parcelId,
    String? partyName,
    String? kind,
    String? share,
    Value<DateTime?> periodStart = const Value.absent(),
    Value<DateTime?> periodEnd = const Value.absent(),
    Value<String?> rentAmount = const Value.absent(),
    String? verification,
  }) => LandRelation(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    parcelId: parcelId ?? this.parcelId,
    partyName: partyName ?? this.partyName,
    kind: kind ?? this.kind,
    share: share ?? this.share,
    periodStart: periodStart.present ? periodStart.value : this.periodStart,
    periodEnd: periodEnd.present ? periodEnd.value : this.periodEnd,
    rentAmount: rentAmount.present ? rentAmount.value : this.rentAmount,
    verification: verification ?? this.verification,
  );
  LandRelation copyWithCompanion(LandRelationsCompanion data) {
    return LandRelation(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      parcelId: data.parcelId.present ? data.parcelId.value : this.parcelId,
      partyName: data.partyName.present ? data.partyName.value : this.partyName,
      kind: data.kind.present ? data.kind.value : this.kind,
      share: data.share.present ? data.share.value : this.share,
      periodStart: data.periodStart.present
          ? data.periodStart.value
          : this.periodStart,
      periodEnd: data.periodEnd.present ? data.periodEnd.value : this.periodEnd,
      rentAmount: data.rentAmount.present
          ? data.rentAmount.value
          : this.rentAmount,
      verification: data.verification.present
          ? data.verification.value
          : this.verification,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LandRelation(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('parcelId: $parcelId, ')
          ..write('partyName: $partyName, ')
          ..write('kind: $kind, ')
          ..write('share: $share, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('rentAmount: $rentAmount, ')
          ..write('verification: $verification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    parcelId,
    partyName,
    kind,
    share,
    periodStart,
    periodEnd,
    rentAmount,
    verification,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LandRelation &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.parcelId == this.parcelId &&
          other.partyName == this.partyName &&
          other.kind == this.kind &&
          other.share == this.share &&
          other.periodStart == this.periodStart &&
          other.periodEnd == this.periodEnd &&
          other.rentAmount == this.rentAmount &&
          other.verification == this.verification);
}

class LandRelationsCompanion extends UpdateCompanion<LandRelation> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> parcelId;
  final Value<String> partyName;
  final Value<String> kind;
  final Value<String> share;
  final Value<DateTime?> periodStart;
  final Value<DateTime?> periodEnd;
  final Value<String?> rentAmount;
  final Value<String> verification;
  final Value<int> rowid;
  const LandRelationsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.parcelId = const Value.absent(),
    this.partyName = const Value.absent(),
    this.kind = const Value.absent(),
    this.share = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.rentAmount = const Value.absent(),
    this.verification = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LandRelationsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String parcelId,
    required String partyName,
    required String kind,
    this.share = const Value.absent(),
    this.periodStart = const Value.absent(),
    this.periodEnd = const Value.absent(),
    this.rentAmount = const Value.absent(),
    this.verification = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       parcelId = Value(parcelId),
       partyName = Value(partyName),
       kind = Value(kind);
  static Insertable<LandRelation> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? parcelId,
    Expression<String>? partyName,
    Expression<String>? kind,
    Expression<String>? share,
    Expression<DateTime>? periodStart,
    Expression<DateTime>? periodEnd,
    Expression<String>? rentAmount,
    Expression<String>? verification,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (parcelId != null) 'parcel_id': parcelId,
      if (partyName != null) 'party_name': partyName,
      if (kind != null) 'kind': kind,
      if (share != null) 'share': share,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (rentAmount != null) 'rent_amount': rentAmount,
      if (verification != null) 'verification': verification,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LandRelationsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? parcelId,
    Value<String>? partyName,
    Value<String>? kind,
    Value<String>? share,
    Value<DateTime?>? periodStart,
    Value<DateTime?>? periodEnd,
    Value<String?>? rentAmount,
    Value<String>? verification,
    Value<int>? rowid,
  }) {
    return LandRelationsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      parcelId: parcelId ?? this.parcelId,
      partyName: partyName ?? this.partyName,
      kind: kind ?? this.kind,
      share: share ?? this.share,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      rentAmount: rentAmount ?? this.rentAmount,
      verification: verification ?? this.verification,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (parcelId.present) {
      map['parcel_id'] = Variable<String>(parcelId.value);
    }
    if (partyName.present) {
      map['party_name'] = Variable<String>(partyName.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (share.present) {
      map['share'] = Variable<String>(share.value);
    }
    if (periodStart.present) {
      map['period_start'] = Variable<DateTime>(periodStart.value);
    }
    if (periodEnd.present) {
      map['period_end'] = Variable<DateTime>(periodEnd.value);
    }
    if (rentAmount.present) {
      map['rent_amount'] = Variable<String>(rentAmount.value);
    }
    if (verification.present) {
      map['verification'] = Variable<String>(verification.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LandRelationsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('parcelId: $parcelId, ')
          ..write('partyName: $partyName, ')
          ..write('kind: $kind, ')
          ..write('share: $share, ')
          ..write('periodStart: $periodStart, ')
          ..write('periodEnd: $periodEnd, ')
          ..write('rentAmount: $rentAmount, ')
          ..write('verification: $verification, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CropSeasonsTable extends CropSeasons
    with TableInfo<$CropSeasonsTable, CropSeason> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CropSeasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropNameMeta = const VerificationMeta(
    'cropName',
  );
  @override
  late final GeneratedColumn<String> cropName = GeneratedColumn<String>(
    'crop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _varietyMeta = const VerificationMeta(
    'variety',
  );
  @override
  late final GeneratedColumn<String> variety = GeneratedColumn<String>(
    'variety',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedStartMeta = const VerificationMeta(
    'plannedStart',
  );
  @override
  late final GeneratedColumn<DateTime> plannedStart = GeneratedColumn<DateTime>(
    'planned_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualStartMeta = const VerificationMeta(
    'actualStart',
  );
  @override
  late final GeneratedColumn<DateTime> actualStart = GeneratedColumn<DateTime>(
    'actual_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedEndMeta = const VerificationMeta(
    'plannedEnd',
  );
  @override
  late final GeneratedColumn<DateTime> plannedEnd = GeneratedColumn<DateTime>(
    'planned_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualEndMeta = const VerificationMeta(
    'actualEnd',
  );
  @override
  late final GeneratedColumn<DateTime> actualEnd = GeneratedColumn<DateTime>(
    'actual_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    name,
    cropName,
    variety,
    status,
    plannedStart,
    actualStart,
    plannedEnd,
    actualEnd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crop_seasons';
  @override
  VerificationContext validateIntegrity(
    Insertable<CropSeason> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('crop_name')) {
      context.handle(
        _cropNameMeta,
        cropName.isAcceptableOrUnknown(data['crop_name']!, _cropNameMeta),
      );
    } else if (isInserting) {
      context.missing(_cropNameMeta);
    }
    if (data.containsKey('variety')) {
      context.handle(
        _varietyMeta,
        variety.isAcceptableOrUnknown(data['variety']!, _varietyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('planned_start')) {
      context.handle(
        _plannedStartMeta,
        plannedStart.isAcceptableOrUnknown(
          data['planned_start']!,
          _plannedStartMeta,
        ),
      );
    }
    if (data.containsKey('actual_start')) {
      context.handle(
        _actualStartMeta,
        actualStart.isAcceptableOrUnknown(
          data['actual_start']!,
          _actualStartMeta,
        ),
      );
    }
    if (data.containsKey('planned_end')) {
      context.handle(
        _plannedEndMeta,
        plannedEnd.isAcceptableOrUnknown(data['planned_end']!, _plannedEndMeta),
      );
    }
    if (data.containsKey('actual_end')) {
      context.handle(
        _actualEndMeta,
        actualEnd.isAcceptableOrUnknown(data['actual_end']!, _actualEndMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CropSeason map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CropSeason(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      cropName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop_name'],
      )!,
      variety: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variety'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      plannedStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_start'],
      ),
      actualStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_start'],
      ),
      plannedEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_end'],
      ),
      actualEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_end'],
      ),
    );
  }

  @override
  $CropSeasonsTable createAlias(String alias) {
    return $CropSeasonsTable(attachedDatabase, alias);
  }
}

class CropSeason extends DataClass implements Insertable<CropSeason> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String fieldId;
  final String name;
  final String cropName;
  final String variety;
  final String status;
  final DateTime? plannedStart;
  final DateTime? actualStart;
  final DateTime? plannedEnd;
  final DateTime? actualEnd;
  const CropSeason({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.fieldId,
    required this.name,
    required this.cropName,
    required this.variety,
    required this.status,
    this.plannedStart,
    this.actualStart,
    this.plannedEnd,
    this.actualEnd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['field_id'] = Variable<String>(fieldId);
    map['name'] = Variable<String>(name);
    map['crop_name'] = Variable<String>(cropName);
    map['variety'] = Variable<String>(variety);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || plannedStart != null) {
      map['planned_start'] = Variable<DateTime>(plannedStart);
    }
    if (!nullToAbsent || actualStart != null) {
      map['actual_start'] = Variable<DateTime>(actualStart);
    }
    if (!nullToAbsent || plannedEnd != null) {
      map['planned_end'] = Variable<DateTime>(plannedEnd);
    }
    if (!nullToAbsent || actualEnd != null) {
      map['actual_end'] = Variable<DateTime>(actualEnd);
    }
    return map;
  }

  CropSeasonsCompanion toCompanion(bool nullToAbsent) {
    return CropSeasonsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      fieldId: Value(fieldId),
      name: Value(name),
      cropName: Value(cropName),
      variety: Value(variety),
      status: Value(status),
      plannedStart: plannedStart == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedStart),
      actualStart: actualStart == null && nullToAbsent
          ? const Value.absent()
          : Value(actualStart),
      plannedEnd: plannedEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedEnd),
      actualEnd: actualEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(actualEnd),
    );
  }

  factory CropSeason.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CropSeason(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      name: serializer.fromJson<String>(json['name']),
      cropName: serializer.fromJson<String>(json['cropName']),
      variety: serializer.fromJson<String>(json['variety']),
      status: serializer.fromJson<String>(json['status']),
      plannedStart: serializer.fromJson<DateTime?>(json['plannedStart']),
      actualStart: serializer.fromJson<DateTime?>(json['actualStart']),
      plannedEnd: serializer.fromJson<DateTime?>(json['plannedEnd']),
      actualEnd: serializer.fromJson<DateTime?>(json['actualEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'fieldId': serializer.toJson<String>(fieldId),
      'name': serializer.toJson<String>(name),
      'cropName': serializer.toJson<String>(cropName),
      'variety': serializer.toJson<String>(variety),
      'status': serializer.toJson<String>(status),
      'plannedStart': serializer.toJson<DateTime?>(plannedStart),
      'actualStart': serializer.toJson<DateTime?>(actualStart),
      'plannedEnd': serializer.toJson<DateTime?>(plannedEnd),
      'actualEnd': serializer.toJson<DateTime?>(actualEnd),
    };
  }

  CropSeason copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? fieldId,
    String? name,
    String? cropName,
    String? variety,
    String? status,
    Value<DateTime?> plannedStart = const Value.absent(),
    Value<DateTime?> actualStart = const Value.absent(),
    Value<DateTime?> plannedEnd = const Value.absent(),
    Value<DateTime?> actualEnd = const Value.absent(),
  }) => CropSeason(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    fieldId: fieldId ?? this.fieldId,
    name: name ?? this.name,
    cropName: cropName ?? this.cropName,
    variety: variety ?? this.variety,
    status: status ?? this.status,
    plannedStart: plannedStart.present ? plannedStart.value : this.plannedStart,
    actualStart: actualStart.present ? actualStart.value : this.actualStart,
    plannedEnd: plannedEnd.present ? plannedEnd.value : this.plannedEnd,
    actualEnd: actualEnd.present ? actualEnd.value : this.actualEnd,
  );
  CropSeason copyWithCompanion(CropSeasonsCompanion data) {
    return CropSeason(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      name: data.name.present ? data.name.value : this.name,
      cropName: data.cropName.present ? data.cropName.value : this.cropName,
      variety: data.variety.present ? data.variety.value : this.variety,
      status: data.status.present ? data.status.value : this.status,
      plannedStart: data.plannedStart.present
          ? data.plannedStart.value
          : this.plannedStart,
      actualStart: data.actualStart.present
          ? data.actualStart.value
          : this.actualStart,
      plannedEnd: data.plannedEnd.present
          ? data.plannedEnd.value
          : this.plannedEnd,
      actualEnd: data.actualEnd.present ? data.actualEnd.value : this.actualEnd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CropSeason(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('name: $name, ')
          ..write('cropName: $cropName, ')
          ..write('variety: $variety, ')
          ..write('status: $status, ')
          ..write('plannedStart: $plannedStart, ')
          ..write('actualStart: $actualStart, ')
          ..write('plannedEnd: $plannedEnd, ')
          ..write('actualEnd: $actualEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    name,
    cropName,
    variety,
    status,
    plannedStart,
    actualStart,
    plannedEnd,
    actualEnd,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CropSeason &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.fieldId == this.fieldId &&
          other.name == this.name &&
          other.cropName == this.cropName &&
          other.variety == this.variety &&
          other.status == this.status &&
          other.plannedStart == this.plannedStart &&
          other.actualStart == this.actualStart &&
          other.plannedEnd == this.plannedEnd &&
          other.actualEnd == this.actualEnd);
}

class CropSeasonsCompanion extends UpdateCompanion<CropSeason> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> fieldId;
  final Value<String> name;
  final Value<String> cropName;
  final Value<String> variety;
  final Value<String> status;
  final Value<DateTime?> plannedStart;
  final Value<DateTime?> actualStart;
  final Value<DateTime?> plannedEnd;
  final Value<DateTime?> actualEnd;
  final Value<int> rowid;
  const CropSeasonsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.name = const Value.absent(),
    this.cropName = const Value.absent(),
    this.variety = const Value.absent(),
    this.status = const Value.absent(),
    this.plannedStart = const Value.absent(),
    this.actualStart = const Value.absent(),
    this.plannedEnd = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CropSeasonsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String fieldId,
    required String name,
    required String cropName,
    this.variety = const Value.absent(),
    required String status,
    this.plannedStart = const Value.absent(),
    this.actualStart = const Value.absent(),
    this.plannedEnd = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       fieldId = Value(fieldId),
       name = Value(name),
       cropName = Value(cropName),
       status = Value(status);
  static Insertable<CropSeason> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? fieldId,
    Expression<String>? name,
    Expression<String>? cropName,
    Expression<String>? variety,
    Expression<String>? status,
    Expression<DateTime>? plannedStart,
    Expression<DateTime>? actualStart,
    Expression<DateTime>? plannedEnd,
    Expression<DateTime>? actualEnd,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (fieldId != null) 'field_id': fieldId,
      if (name != null) 'name': name,
      if (cropName != null) 'crop_name': cropName,
      if (variety != null) 'variety': variety,
      if (status != null) 'status': status,
      if (plannedStart != null) 'planned_start': plannedStart,
      if (actualStart != null) 'actual_start': actualStart,
      if (plannedEnd != null) 'planned_end': plannedEnd,
      if (actualEnd != null) 'actual_end': actualEnd,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CropSeasonsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? fieldId,
    Value<String>? name,
    Value<String>? cropName,
    Value<String>? variety,
    Value<String>? status,
    Value<DateTime?>? plannedStart,
    Value<DateTime?>? actualStart,
    Value<DateTime?>? plannedEnd,
    Value<DateTime?>? actualEnd,
    Value<int>? rowid,
  }) {
    return CropSeasonsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      fieldId: fieldId ?? this.fieldId,
      name: name ?? this.name,
      cropName: cropName ?? this.cropName,
      variety: variety ?? this.variety,
      status: status ?? this.status,
      plannedStart: plannedStart ?? this.plannedStart,
      actualStart: actualStart ?? this.actualStart,
      plannedEnd: plannedEnd ?? this.plannedEnd,
      actualEnd: actualEnd ?? this.actualEnd,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cropName.present) {
      map['crop_name'] = Variable<String>(cropName.value);
    }
    if (variety.present) {
      map['variety'] = Variable<String>(variety.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (plannedStart.present) {
      map['planned_start'] = Variable<DateTime>(plannedStart.value);
    }
    if (actualStart.present) {
      map['actual_start'] = Variable<DateTime>(actualStart.value);
    }
    if (plannedEnd.present) {
      map['planned_end'] = Variable<DateTime>(plannedEnd.value);
    }
    if (actualEnd.present) {
      map['actual_end'] = Variable<DateTime>(actualEnd.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CropSeasonsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('name: $name, ')
          ..write('cropName: $cropName, ')
          ..write('variety: $variety, ')
          ..write('status: $status, ')
          ..write('plannedStart: $plannedStart, ')
          ..write('actualStart: $actualStart, ')
          ..write('plannedEnd: $plannedEnd, ')
          ..write('actualEnd: $actualEnd, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _preferredChannelMeta = const VerificationMeta(
    'preferredChannel',
  );
  @override
  late final GeneratedColumn<String> preferredChannel = GeneratedColumn<String>(
    'preferred_channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('phone'),
  );
  static const VerificationMeta _workConstraintsMeta = const VerificationMeta(
    'workConstraints',
  );
  @override
  late final GeneratedColumn<String> workConstraints = GeneratedColumn<String>(
    'work_constraints',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _linkedUserIdMeta = const VerificationMeta(
    'linkedUserId',
  );
  @override
  late final GeneratedColumn<String> linkedUserId = GeneratedColumn<String>(
    'linked_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    name,
    nickname,
    phone,
    preferredChannel,
    workConstraints,
    notes,
    linkedUserId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Contact> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('preferred_channel')) {
      context.handle(
        _preferredChannelMeta,
        preferredChannel.isAcceptableOrUnknown(
          data['preferred_channel']!,
          _preferredChannelMeta,
        ),
      );
    }
    if (data.containsKey('work_constraints')) {
      context.handle(
        _workConstraintsMeta,
        workConstraints.isAcceptableOrUnknown(
          data['work_constraints']!,
          _workConstraintsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('linked_user_id')) {
      context.handle(
        _linkedUserIdMeta,
        linkedUserId.isAcceptableOrUnknown(
          data['linked_user_id']!,
          _linkedUserIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      preferredChannel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_channel'],
      )!,
      workConstraints: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_constraints'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      linkedUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_user_id'],
      ),
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String name;
  final String nickname;
  final String phone;
  final String preferredChannel;
  final String workConstraints;
  final String notes;
  final String? linkedUserId;
  const Contact({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.name,
    required this.nickname,
    required this.phone,
    required this.preferredChannel,
    required this.workConstraints,
    required this.notes,
    this.linkedUserId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['name'] = Variable<String>(name);
    map['nickname'] = Variable<String>(nickname);
    map['phone'] = Variable<String>(phone);
    map['preferred_channel'] = Variable<String>(preferredChannel);
    map['work_constraints'] = Variable<String>(workConstraints);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || linkedUserId != null) {
      map['linked_user_id'] = Variable<String>(linkedUserId);
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      name: Value(name),
      nickname: Value(nickname),
      phone: Value(phone),
      preferredChannel: Value(preferredChannel),
      workConstraints: Value(workConstraints),
      notes: Value(notes),
      linkedUserId: linkedUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedUserId),
    );
  }

  factory Contact.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      name: serializer.fromJson<String>(json['name']),
      nickname: serializer.fromJson<String>(json['nickname']),
      phone: serializer.fromJson<String>(json['phone']),
      preferredChannel: serializer.fromJson<String>(json['preferredChannel']),
      workConstraints: serializer.fromJson<String>(json['workConstraints']),
      notes: serializer.fromJson<String>(json['notes']),
      linkedUserId: serializer.fromJson<String?>(json['linkedUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'name': serializer.toJson<String>(name),
      'nickname': serializer.toJson<String>(nickname),
      'phone': serializer.toJson<String>(phone),
      'preferredChannel': serializer.toJson<String>(preferredChannel),
      'workConstraints': serializer.toJson<String>(workConstraints),
      'notes': serializer.toJson<String>(notes),
      'linkedUserId': serializer.toJson<String?>(linkedUserId),
    };
  }

  Contact copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? name,
    String? nickname,
    String? phone,
    String? preferredChannel,
    String? workConstraints,
    String? notes,
    Value<String?> linkedUserId = const Value.absent(),
  }) => Contact(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    name: name ?? this.name,
    nickname: nickname ?? this.nickname,
    phone: phone ?? this.phone,
    preferredChannel: preferredChannel ?? this.preferredChannel,
    workConstraints: workConstraints ?? this.workConstraints,
    notes: notes ?? this.notes,
    linkedUserId: linkedUserId.present ? linkedUserId.value : this.linkedUserId,
  );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      name: data.name.present ? data.name.value : this.name,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      phone: data.phone.present ? data.phone.value : this.phone,
      preferredChannel: data.preferredChannel.present
          ? data.preferredChannel.value
          : this.preferredChannel,
      workConstraints: data.workConstraints.present
          ? data.workConstraints.value
          : this.workConstraints,
      notes: data.notes.present ? data.notes.value : this.notes,
      linkedUserId: data.linkedUserId.present
          ? data.linkedUserId.value
          : this.linkedUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('nickname: $nickname, ')
          ..write('phone: $phone, ')
          ..write('preferredChannel: $preferredChannel, ')
          ..write('workConstraints: $workConstraints, ')
          ..write('notes: $notes, ')
          ..write('linkedUserId: $linkedUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    name,
    nickname,
    phone,
    preferredChannel,
    workConstraints,
    notes,
    linkedUserId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.name == this.name &&
          other.nickname == this.nickname &&
          other.phone == this.phone &&
          other.preferredChannel == this.preferredChannel &&
          other.workConstraints == this.workConstraints &&
          other.notes == this.notes &&
          other.linkedUserId == this.linkedUserId);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> name;
  final Value<String> nickname;
  final Value<String> phone;
  final Value<String> preferredChannel;
  final Value<String> workConstraints;
  final Value<String> notes;
  final Value<String?> linkedUserId;
  final Value<int> rowid;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.nickname = const Value.absent(),
    this.phone = const Value.absent(),
    this.preferredChannel = const Value.absent(),
    this.workConstraints = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String name,
    this.nickname = const Value.absent(),
    this.phone = const Value.absent(),
    this.preferredChannel = const Value.absent(),
    this.workConstraints = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       name = Value(name);
  static Insertable<Contact> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? name,
    Expression<String>? nickname,
    Expression<String>? phone,
    Expression<String>? preferredChannel,
    Expression<String>? workConstraints,
    Expression<String>? notes,
    Expression<String>? linkedUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (name != null) 'name': name,
      if (nickname != null) 'nickname': nickname,
      if (phone != null) 'phone': phone,
      if (preferredChannel != null) 'preferred_channel': preferredChannel,
      if (workConstraints != null) 'work_constraints': workConstraints,
      if (notes != null) 'notes': notes,
      if (linkedUserId != null) 'linked_user_id': linkedUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? name,
    Value<String>? nickname,
    Value<String>? phone,
    Value<String>? preferredChannel,
    Value<String>? workConstraints,
    Value<String>? notes,
    Value<String?>? linkedUserId,
    Value<int>? rowid,
  }) {
    return ContactsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      preferredChannel: preferredChannel ?? this.preferredChannel,
      workConstraints: workConstraints ?? this.workConstraints,
      notes: notes ?? this.notes,
      linkedUserId: linkedUserId ?? this.linkedUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (preferredChannel.present) {
      map['preferred_channel'] = Variable<String>(preferredChannel.value);
    }
    if (workConstraints.present) {
      map['work_constraints'] = Variable<String>(workConstraints.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (linkedUserId.present) {
      map['linked_user_id'] = Variable<String>(linkedUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('nickname: $nickname, ')
          ..write('phone: $phone, ')
          ..write('preferredChannel: $preferredChannel, ')
          ..write('workConstraints: $workConstraints, ')
          ..write('notes: $notes, ')
          ..write('linkedUserId: $linkedUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<String> seasonId = GeneratedColumn<String>(
    'season_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workTypeMeta = const VerificationMeta(
    'workType',
  );
  @override
  late final GeneratedColumn<String> workType = GeneratedColumn<String>(
    'work_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedStartMeta = const VerificationMeta(
    'plannedStart',
  );
  @override
  late final GeneratedColumn<DateTime> plannedStart = GeneratedColumn<DateTime>(
    'planned_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedEndMeta = const VerificationMeta(
    'plannedEnd',
  );
  @override
  late final GeneratedColumn<DateTime> plannedEnd = GeneratedColumn<DateTime>(
    'planned_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meetAtMeta = const VerificationMeta('meetAt');
  @override
  late final GeneratedColumn<DateTime> meetAt = GeneratedColumn<DateTime>(
    'meet_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meetPlaceMeta = const VerificationMeta(
    'meetPlace',
  );
  @override
  late final GeneratedColumn<String> meetPlace = GeneratedColumn<String>(
    'meet_place',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _headcountNeededMeta = const VerificationMeta(
    'headcountNeeded',
  );
  @override
  late final GeneratedColumn<int> headcountNeeded = GeneratedColumn<int>(
    'headcount_needed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    seasonId,
    title,
    workType,
    status,
    plannedStart,
    plannedEnd,
    meetAt,
    meetPlace,
    headcountNeeded,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('work_type')) {
      context.handle(
        _workTypeMeta,
        workType.isAcceptableOrUnknown(data['work_type']!, _workTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_workTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('planned_start')) {
      context.handle(
        _plannedStartMeta,
        plannedStart.isAcceptableOrUnknown(
          data['planned_start']!,
          _plannedStartMeta,
        ),
      );
    }
    if (data.containsKey('planned_end')) {
      context.handle(
        _plannedEndMeta,
        plannedEnd.isAcceptableOrUnknown(data['planned_end']!, _plannedEndMeta),
      );
    }
    if (data.containsKey('meet_at')) {
      context.handle(
        _meetAtMeta,
        meetAt.isAcceptableOrUnknown(data['meet_at']!, _meetAtMeta),
      );
    }
    if (data.containsKey('meet_place')) {
      context.handle(
        _meetPlaceMeta,
        meetPlace.isAcceptableOrUnknown(data['meet_place']!, _meetPlaceMeta),
      );
    }
    if (data.containsKey('headcount_needed')) {
      context.handle(
        _headcountNeededMeta,
        headcountNeeded.isAcceptableOrUnknown(
          data['headcount_needed']!,
          _headcountNeededMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}season_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      workType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      plannedStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_start'],
      ),
      plannedEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_end'],
      ),
      meetAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}meet_at'],
      ),
      meetPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meet_place'],
      )!,
      headcountNeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}headcount_needed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String fieldId;
  final String? seasonId;
  final String title;
  final String workType;
  final String status;
  final DateTime? plannedStart;
  final DateTime? plannedEnd;
  final DateTime? meetAt;
  final String meetPlace;
  final int headcountNeeded;
  final String notes;
  const Task({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.fieldId,
    this.seasonId,
    required this.title,
    required this.workType,
    required this.status,
    this.plannedStart,
    this.plannedEnd,
    this.meetAt,
    required this.meetPlace,
    required this.headcountNeeded,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['field_id'] = Variable<String>(fieldId);
    if (!nullToAbsent || seasonId != null) {
      map['season_id'] = Variable<String>(seasonId);
    }
    map['title'] = Variable<String>(title);
    map['work_type'] = Variable<String>(workType);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || plannedStart != null) {
      map['planned_start'] = Variable<DateTime>(plannedStart);
    }
    if (!nullToAbsent || plannedEnd != null) {
      map['planned_end'] = Variable<DateTime>(plannedEnd);
    }
    if (!nullToAbsent || meetAt != null) {
      map['meet_at'] = Variable<DateTime>(meetAt);
    }
    map['meet_place'] = Variable<String>(meetPlace);
    map['headcount_needed'] = Variable<int>(headcountNeeded);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      fieldId: Value(fieldId),
      seasonId: seasonId == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonId),
      title: Value(title),
      workType: Value(workType),
      status: Value(status),
      plannedStart: plannedStart == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedStart),
      plannedEnd: plannedEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedEnd),
      meetAt: meetAt == null && nullToAbsent
          ? const Value.absent()
          : Value(meetAt),
      meetPlace: Value(meetPlace),
      headcountNeeded: Value(headcountNeeded),
      notes: Value(notes),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      seasonId: serializer.fromJson<String?>(json['seasonId']),
      title: serializer.fromJson<String>(json['title']),
      workType: serializer.fromJson<String>(json['workType']),
      status: serializer.fromJson<String>(json['status']),
      plannedStart: serializer.fromJson<DateTime?>(json['plannedStart']),
      plannedEnd: serializer.fromJson<DateTime?>(json['plannedEnd']),
      meetAt: serializer.fromJson<DateTime?>(json['meetAt']),
      meetPlace: serializer.fromJson<String>(json['meetPlace']),
      headcountNeeded: serializer.fromJson<int>(json['headcountNeeded']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'fieldId': serializer.toJson<String>(fieldId),
      'seasonId': serializer.toJson<String?>(seasonId),
      'title': serializer.toJson<String>(title),
      'workType': serializer.toJson<String>(workType),
      'status': serializer.toJson<String>(status),
      'plannedStart': serializer.toJson<DateTime?>(plannedStart),
      'plannedEnd': serializer.toJson<DateTime?>(plannedEnd),
      'meetAt': serializer.toJson<DateTime?>(meetAt),
      'meetPlace': serializer.toJson<String>(meetPlace),
      'headcountNeeded': serializer.toJson<int>(headcountNeeded),
      'notes': serializer.toJson<String>(notes),
    };
  }

  Task copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? fieldId,
    Value<String?> seasonId = const Value.absent(),
    String? title,
    String? workType,
    String? status,
    Value<DateTime?> plannedStart = const Value.absent(),
    Value<DateTime?> plannedEnd = const Value.absent(),
    Value<DateTime?> meetAt = const Value.absent(),
    String? meetPlace,
    int? headcountNeeded,
    String? notes,
  }) => Task(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    fieldId: fieldId ?? this.fieldId,
    seasonId: seasonId.present ? seasonId.value : this.seasonId,
    title: title ?? this.title,
    workType: workType ?? this.workType,
    status: status ?? this.status,
    plannedStart: plannedStart.present ? plannedStart.value : this.plannedStart,
    plannedEnd: plannedEnd.present ? plannedEnd.value : this.plannedEnd,
    meetAt: meetAt.present ? meetAt.value : this.meetAt,
    meetPlace: meetPlace ?? this.meetPlace,
    headcountNeeded: headcountNeeded ?? this.headcountNeeded,
    notes: notes ?? this.notes,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      title: data.title.present ? data.title.value : this.title,
      workType: data.workType.present ? data.workType.value : this.workType,
      status: data.status.present ? data.status.value : this.status,
      plannedStart: data.plannedStart.present
          ? data.plannedStart.value
          : this.plannedStart,
      plannedEnd: data.plannedEnd.present
          ? data.plannedEnd.value
          : this.plannedEnd,
      meetAt: data.meetAt.present ? data.meetAt.value : this.meetAt,
      meetPlace: data.meetPlace.present ? data.meetPlace.value : this.meetPlace,
      headcountNeeded: data.headcountNeeded.present
          ? data.headcountNeeded.value
          : this.headcountNeeded,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('seasonId: $seasonId, ')
          ..write('title: $title, ')
          ..write('workType: $workType, ')
          ..write('status: $status, ')
          ..write('plannedStart: $plannedStart, ')
          ..write('plannedEnd: $plannedEnd, ')
          ..write('meetAt: $meetAt, ')
          ..write('meetPlace: $meetPlace, ')
          ..write('headcountNeeded: $headcountNeeded, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    seasonId,
    title,
    workType,
    status,
    plannedStart,
    plannedEnd,
    meetAt,
    meetPlace,
    headcountNeeded,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.fieldId == this.fieldId &&
          other.seasonId == this.seasonId &&
          other.title == this.title &&
          other.workType == this.workType &&
          other.status == this.status &&
          other.plannedStart == this.plannedStart &&
          other.plannedEnd == this.plannedEnd &&
          other.meetAt == this.meetAt &&
          other.meetPlace == this.meetPlace &&
          other.headcountNeeded == this.headcountNeeded &&
          other.notes == this.notes);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> fieldId;
  final Value<String?> seasonId;
  final Value<String> title;
  final Value<String> workType;
  final Value<String> status;
  final Value<DateTime?> plannedStart;
  final Value<DateTime?> plannedEnd;
  final Value<DateTime?> meetAt;
  final Value<String> meetPlace;
  final Value<int> headcountNeeded;
  final Value<String> notes;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.title = const Value.absent(),
    this.workType = const Value.absent(),
    this.status = const Value.absent(),
    this.plannedStart = const Value.absent(),
    this.plannedEnd = const Value.absent(),
    this.meetAt = const Value.absent(),
    this.meetPlace = const Value.absent(),
    this.headcountNeeded = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String fieldId,
    this.seasonId = const Value.absent(),
    required String title,
    required String workType,
    required String status,
    this.plannedStart = const Value.absent(),
    this.plannedEnd = const Value.absent(),
    this.meetAt = const Value.absent(),
    this.meetPlace = const Value.absent(),
    this.headcountNeeded = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       fieldId = Value(fieldId),
       title = Value(title),
       workType = Value(workType),
       status = Value(status);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? fieldId,
    Expression<String>? seasonId,
    Expression<String>? title,
    Expression<String>? workType,
    Expression<String>? status,
    Expression<DateTime>? plannedStart,
    Expression<DateTime>? plannedEnd,
    Expression<DateTime>? meetAt,
    Expression<String>? meetPlace,
    Expression<int>? headcountNeeded,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (fieldId != null) 'field_id': fieldId,
      if (seasonId != null) 'season_id': seasonId,
      if (title != null) 'title': title,
      if (workType != null) 'work_type': workType,
      if (status != null) 'status': status,
      if (plannedStart != null) 'planned_start': plannedStart,
      if (plannedEnd != null) 'planned_end': plannedEnd,
      if (meetAt != null) 'meet_at': meetAt,
      if (meetPlace != null) 'meet_place': meetPlace,
      if (headcountNeeded != null) 'headcount_needed': headcountNeeded,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? fieldId,
    Value<String?>? seasonId,
    Value<String>? title,
    Value<String>? workType,
    Value<String>? status,
    Value<DateTime?>? plannedStart,
    Value<DateTime?>? plannedEnd,
    Value<DateTime?>? meetAt,
    Value<String>? meetPlace,
    Value<int>? headcountNeeded,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      fieldId: fieldId ?? this.fieldId,
      seasonId: seasonId ?? this.seasonId,
      title: title ?? this.title,
      workType: workType ?? this.workType,
      status: status ?? this.status,
      plannedStart: plannedStart ?? this.plannedStart,
      plannedEnd: plannedEnd ?? this.plannedEnd,
      meetAt: meetAt ?? this.meetAt,
      meetPlace: meetPlace ?? this.meetPlace,
      headcountNeeded: headcountNeeded ?? this.headcountNeeded,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<String>(seasonId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (workType.present) {
      map['work_type'] = Variable<String>(workType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (plannedStart.present) {
      map['planned_start'] = Variable<DateTime>(plannedStart.value);
    }
    if (plannedEnd.present) {
      map['planned_end'] = Variable<DateTime>(plannedEnd.value);
    }
    if (meetAt.present) {
      map['meet_at'] = Variable<DateTime>(meetAt.value);
    }
    if (meetPlace.present) {
      map['meet_place'] = Variable<String>(meetPlace.value);
    }
    if (headcountNeeded.present) {
      map['headcount_needed'] = Variable<int>(headcountNeeded.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('seasonId: $seasonId, ')
          ..write('title: $title, ')
          ..write('workType: $workType, ')
          ..write('status: $status, ')
          ..write('plannedStart: $plannedStart, ')
          ..write('plannedEnd: $plannedEnd, ')
          ..write('meetAt: $meetAt, ')
          ..write('meetPlace: $meetPlace, ')
          ..write('headcountNeeded: $headcountNeeded, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssignmentsTable extends Assignments
    with TableInfo<$AssignmentsTable, Assignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactIdMeta = const VerificationMeta(
    'contactId',
  );
  @override
  late final GeneratedColumn<String> contactId = GeneratedColumn<String>(
    'contact_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('member'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wageRateSnapshotMeta = const VerificationMeta(
    'wageRateSnapshot',
  );
  @override
  late final GeneratedColumn<String> wageRateSnapshot = GeneratedColumn<String>(
    'wage_rate_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    taskId,
    contactId,
    role,
    status,
    wageRateSnapshot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Assignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('contact_id')) {
      context.handle(
        _contactIdMeta,
        contactId.isAcceptableOrUnknown(data['contact_id']!, _contactIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contactIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('wage_rate_snapshot')) {
      context.handle(
        _wageRateSnapshotMeta,
        wageRateSnapshot.isAcceptableOrUnknown(
          data['wage_rate_snapshot']!,
          _wageRateSnapshotMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Assignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Assignment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      contactId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      wageRateSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wage_rate_snapshot'],
      ),
    );
  }

  @override
  $AssignmentsTable createAlias(String alias) {
    return $AssignmentsTable(attachedDatabase, alias);
  }
}

class Assignment extends DataClass implements Insertable<Assignment> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String taskId;
  final String contactId;
  final String role;
  final String status;
  final String? wageRateSnapshot;
  const Assignment({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.taskId,
    required this.contactId,
    required this.role,
    required this.status,
    this.wageRateSnapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['task_id'] = Variable<String>(taskId);
    map['contact_id'] = Variable<String>(contactId);
    map['role'] = Variable<String>(role);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || wageRateSnapshot != null) {
      map['wage_rate_snapshot'] = Variable<String>(wageRateSnapshot);
    }
    return map;
  }

  AssignmentsCompanion toCompanion(bool nullToAbsent) {
    return AssignmentsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      taskId: Value(taskId),
      contactId: Value(contactId),
      role: Value(role),
      status: Value(status),
      wageRateSnapshot: wageRateSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(wageRateSnapshot),
    );
  }

  factory Assignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Assignment(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      taskId: serializer.fromJson<String>(json['taskId']),
      contactId: serializer.fromJson<String>(json['contactId']),
      role: serializer.fromJson<String>(json['role']),
      status: serializer.fromJson<String>(json['status']),
      wageRateSnapshot: serializer.fromJson<String?>(json['wageRateSnapshot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'taskId': serializer.toJson<String>(taskId),
      'contactId': serializer.toJson<String>(contactId),
      'role': serializer.toJson<String>(role),
      'status': serializer.toJson<String>(status),
      'wageRateSnapshot': serializer.toJson<String?>(wageRateSnapshot),
    };
  }

  Assignment copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? taskId,
    String? contactId,
    String? role,
    String? status,
    Value<String?> wageRateSnapshot = const Value.absent(),
  }) => Assignment(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    taskId: taskId ?? this.taskId,
    contactId: contactId ?? this.contactId,
    role: role ?? this.role,
    status: status ?? this.status,
    wageRateSnapshot: wageRateSnapshot.present
        ? wageRateSnapshot.value
        : this.wageRateSnapshot,
  );
  Assignment copyWithCompanion(AssignmentsCompanion data) {
    return Assignment(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      contactId: data.contactId.present ? data.contactId.value : this.contactId,
      role: data.role.present ? data.role.value : this.role,
      status: data.status.present ? data.status.value : this.status,
      wageRateSnapshot: data.wageRateSnapshot.present
          ? data.wageRateSnapshot.value
          : this.wageRateSnapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Assignment(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('taskId: $taskId, ')
          ..write('contactId: $contactId, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('wageRateSnapshot: $wageRateSnapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    taskId,
    contactId,
    role,
    status,
    wageRateSnapshot,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Assignment &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.taskId == this.taskId &&
          other.contactId == this.contactId &&
          other.role == this.role &&
          other.status == this.status &&
          other.wageRateSnapshot == this.wageRateSnapshot);
}

class AssignmentsCompanion extends UpdateCompanion<Assignment> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> taskId;
  final Value<String> contactId;
  final Value<String> role;
  final Value<String> status;
  final Value<String?> wageRateSnapshot;
  final Value<int> rowid;
  const AssignmentsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.taskId = const Value.absent(),
    this.contactId = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.wageRateSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssignmentsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String taskId,
    required String contactId,
    this.role = const Value.absent(),
    required String status,
    this.wageRateSnapshot = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       taskId = Value(taskId),
       contactId = Value(contactId),
       status = Value(status);
  static Insertable<Assignment> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? taskId,
    Expression<String>? contactId,
    Expression<String>? role,
    Expression<String>? status,
    Expression<String>? wageRateSnapshot,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (taskId != null) 'task_id': taskId,
      if (contactId != null) 'contact_id': contactId,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (wageRateSnapshot != null) 'wage_rate_snapshot': wageRateSnapshot,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssignmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? taskId,
    Value<String>? contactId,
    Value<String>? role,
    Value<String>? status,
    Value<String?>? wageRateSnapshot,
    Value<int>? rowid,
  }) {
    return AssignmentsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      taskId: taskId ?? this.taskId,
      contactId: contactId ?? this.contactId,
      role: role ?? this.role,
      status: status ?? this.status,
      wageRateSnapshot: wageRateSnapshot ?? this.wageRateSnapshot,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (contactId.present) {
      map['contact_id'] = Variable<String>(contactId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (wageRateSnapshot.present) {
      map['wage_rate_snapshot'] = Variable<String>(wageRateSnapshot.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssignmentsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('taskId: $taskId, ')
          ..write('contactId: $contactId, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('wageRateSnapshot: $wageRateSnapshot, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssignmentEventsTable extends AssignmentEvents
    with TableInfo<$AssignmentEventsTable, AssignmentEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssignmentEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assignmentIdMeta = const VerificationMeta(
    'assignmentId',
  );
  @override
  late final GeneratedColumn<String> assignmentId = GeneratedColumn<String>(
    'assignment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromStatusMeta = const VerificationMeta(
    'fromStatus',
  );
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
    'from_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toStatusMeta = const VerificationMeta(
    'toStatus',
  );
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
    'to_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelMeta = const VerificationMeta(
    'channel',
  );
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
    'channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byMeta = const VerificationMeta('by');
  @override
  late final GeneratedColumn<String> by = GeneratedColumn<String>(
    'by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    assignmentId,
    action,
    fromStatus,
    toStatus,
    channel,
    note,
    at,
    by,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assignment_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssignmentEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('assignment_id')) {
      context.handle(
        _assignmentIdMeta,
        assignmentId.isAcceptableOrUnknown(
          data['assignment_id']!,
          _assignmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignmentIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('from_status')) {
      context.handle(
        _fromStatusMeta,
        fromStatus.isAcceptableOrUnknown(data['from_status']!, _fromStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_fromStatusMeta);
    }
    if (data.containsKey('to_status')) {
      context.handle(
        _toStatusMeta,
        toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_toStatusMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(
        _channelMeta,
        channel.isAcceptableOrUnknown(data['channel']!, _channelMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('by')) {
      context.handle(_byMeta, by.isAcceptableOrUnknown(data['by']!, _byMeta));
    } else if (isInserting) {
      context.missing(_byMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssignmentEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssignmentEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      assignmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignment_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      fromStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_status'],
      )!,
      toStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_status'],
      )!,
      channel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      by: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}by'],
      )!,
    );
  }

  @override
  $AssignmentEventsTable createAlias(String alias) {
    return $AssignmentEventsTable(attachedDatabase, alias);
  }
}

class AssignmentEvent extends DataClass implements Insertable<AssignmentEvent> {
  final String id;
  final String workspaceId;
  final String assignmentId;
  final String action;
  final String fromStatus;
  final String toStatus;
  final String channel;
  final String note;
  final DateTime at;
  final String by;
  const AssignmentEvent({
    required this.id,
    required this.workspaceId,
    required this.assignmentId,
    required this.action,
    required this.fromStatus,
    required this.toStatus,
    required this.channel,
    required this.note,
    required this.at,
    required this.by,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['assignment_id'] = Variable<String>(assignmentId);
    map['action'] = Variable<String>(action);
    map['from_status'] = Variable<String>(fromStatus);
    map['to_status'] = Variable<String>(toStatus);
    map['channel'] = Variable<String>(channel);
    map['note'] = Variable<String>(note);
    map['at'] = Variable<DateTime>(at);
    map['by'] = Variable<String>(by);
    return map;
  }

  AssignmentEventsCompanion toCompanion(bool nullToAbsent) {
    return AssignmentEventsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      assignmentId: Value(assignmentId),
      action: Value(action),
      fromStatus: Value(fromStatus),
      toStatus: Value(toStatus),
      channel: Value(channel),
      note: Value(note),
      at: Value(at),
      by: Value(by),
    );
  }

  factory AssignmentEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssignmentEvent(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      assignmentId: serializer.fromJson<String>(json['assignmentId']),
      action: serializer.fromJson<String>(json['action']),
      fromStatus: serializer.fromJson<String>(json['fromStatus']),
      toStatus: serializer.fromJson<String>(json['toStatus']),
      channel: serializer.fromJson<String>(json['channel']),
      note: serializer.fromJson<String>(json['note']),
      at: serializer.fromJson<DateTime>(json['at']),
      by: serializer.fromJson<String>(json['by']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'assignmentId': serializer.toJson<String>(assignmentId),
      'action': serializer.toJson<String>(action),
      'fromStatus': serializer.toJson<String>(fromStatus),
      'toStatus': serializer.toJson<String>(toStatus),
      'channel': serializer.toJson<String>(channel),
      'note': serializer.toJson<String>(note),
      'at': serializer.toJson<DateTime>(at),
      'by': serializer.toJson<String>(by),
    };
  }

  AssignmentEvent copyWith({
    String? id,
    String? workspaceId,
    String? assignmentId,
    String? action,
    String? fromStatus,
    String? toStatus,
    String? channel,
    String? note,
    DateTime? at,
    String? by,
  }) => AssignmentEvent(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    assignmentId: assignmentId ?? this.assignmentId,
    action: action ?? this.action,
    fromStatus: fromStatus ?? this.fromStatus,
    toStatus: toStatus ?? this.toStatus,
    channel: channel ?? this.channel,
    note: note ?? this.note,
    at: at ?? this.at,
    by: by ?? this.by,
  );
  AssignmentEvent copyWithCompanion(AssignmentEventsCompanion data) {
    return AssignmentEvent(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      assignmentId: data.assignmentId.present
          ? data.assignmentId.value
          : this.assignmentId,
      action: data.action.present ? data.action.value : this.action,
      fromStatus: data.fromStatus.present
          ? data.fromStatus.value
          : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      channel: data.channel.present ? data.channel.value : this.channel,
      note: data.note.present ? data.note.value : this.note,
      at: data.at.present ? data.at.value : this.at,
      by: data.by.present ? data.by.value : this.by,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssignmentEvent(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('assignmentId: $assignmentId, ')
          ..write('action: $action, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('channel: $channel, ')
          ..write('note: $note, ')
          ..write('at: $at, ')
          ..write('by: $by')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    assignmentId,
    action,
    fromStatus,
    toStatus,
    channel,
    note,
    at,
    by,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssignmentEvent &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.assignmentId == this.assignmentId &&
          other.action == this.action &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.channel == this.channel &&
          other.note == this.note &&
          other.at == this.at &&
          other.by == this.by);
}

class AssignmentEventsCompanion extends UpdateCompanion<AssignmentEvent> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> assignmentId;
  final Value<String> action;
  final Value<String> fromStatus;
  final Value<String> toStatus;
  final Value<String> channel;
  final Value<String> note;
  final Value<DateTime> at;
  final Value<String> by;
  final Value<int> rowid;
  const AssignmentEventsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.assignmentId = const Value.absent(),
    this.action = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.channel = const Value.absent(),
    this.note = const Value.absent(),
    this.at = const Value.absent(),
    this.by = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssignmentEventsCompanion.insert({
    required String id,
    required String workspaceId,
    required String assignmentId,
    required String action,
    required String fromStatus,
    required String toStatus,
    this.channel = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime at,
    required String by,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       assignmentId = Value(assignmentId),
       action = Value(action),
       fromStatus = Value(fromStatus),
       toStatus = Value(toStatus),
       at = Value(at),
       by = Value(by);
  static Insertable<AssignmentEvent> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? assignmentId,
    Expression<String>? action,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<String>? channel,
    Expression<String>? note,
    Expression<DateTime>? at,
    Expression<String>? by,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (assignmentId != null) 'assignment_id': assignmentId,
      if (action != null) 'action': action,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (channel != null) 'channel': channel,
      if (note != null) 'note': note,
      if (at != null) 'at': at,
      if (by != null) 'by': by,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssignmentEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<String>? assignmentId,
    Value<String>? action,
    Value<String>? fromStatus,
    Value<String>? toStatus,
    Value<String>? channel,
    Value<String>? note,
    Value<DateTime>? at,
    Value<String>? by,
    Value<int>? rowid,
  }) {
    return AssignmentEventsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      assignmentId: assignmentId ?? this.assignmentId,
      action: action ?? this.action,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      channel: channel ?? this.channel,
      note: note ?? this.note,
      at: at ?? this.at,
      by: by ?? this.by,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (assignmentId.present) {
      map['assignment_id'] = Variable<String>(assignmentId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(fromStatus.value);
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(toStatus.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (by.present) {
      map['by'] = Variable<String>(by.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssignmentEventsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('assignmentId: $assignmentId, ')
          ..write('action: $action, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('channel: $channel, ')
          ..write('note: $note, ')
          ..write('at: $at, ')
          ..write('by: $by, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkReportsTable extends WorkReports
    with TableInfo<$WorkReportsTable, WorkReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportedByKindMeta = const VerificationMeta(
    'reportedByKind',
  );
  @override
  late final GeneratedColumn<String> reportedByKind = GeneratedColumn<String>(
    'reported_by_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _reporterNameMeta = const VerificationMeta(
    'reporterName',
  );
  @override
  late final GeneratedColumn<String> reporterName = GeneratedColumn<String>(
    'reporter_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualStartMeta = const VerificationMeta(
    'actualStart',
  );
  @override
  late final GeneratedColumn<DateTime> actualStart = GeneratedColumn<DateTime>(
    'actual_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualEndMeta = const VerificationMeta(
    'actualEnd',
  );
  @override
  late final GeneratedColumn<DateTime> actualEnd = GeneratedColumn<DateTime>(
    'actual_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rawQuantityTextMeta = const VerificationMeta(
    'rawQuantityText',
  );
  @override
  late final GeneratedColumn<String> rawQuantityText = GeneratedColumn<String>(
    'raw_quantity_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _pesticideClaimMeta = const VerificationMeta(
    'pesticideClaim',
  );
  @override
  late final GeneratedColumn<String> pesticideClaim = GeneratedColumn<String>(
    'pesticide_claim',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewNoteMeta = const VerificationMeta(
    'reviewNote',
  );
  @override
  late final GeneratedColumn<String> reviewNote = GeneratedColumn<String>(
    'review_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    taskId,
    fieldId,
    reportedByKind,
    reporterName,
    actualStart,
    actualEnd,
    rawText,
    rawQuantityText,
    pesticideClaim,
    status,
    reviewNote,
    submittedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('reported_by_kind')) {
      context.handle(
        _reportedByKindMeta,
        reportedByKind.isAcceptableOrUnknown(
          data['reported_by_kind']!,
          _reportedByKindMeta,
        ),
      );
    }
    if (data.containsKey('reporter_name')) {
      context.handle(
        _reporterNameMeta,
        reporterName.isAcceptableOrUnknown(
          data['reporter_name']!,
          _reporterNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reporterNameMeta);
    }
    if (data.containsKey('actual_start')) {
      context.handle(
        _actualStartMeta,
        actualStart.isAcceptableOrUnknown(
          data['actual_start']!,
          _actualStartMeta,
        ),
      );
    }
    if (data.containsKey('actual_end')) {
      context.handle(
        _actualEndMeta,
        actualEnd.isAcceptableOrUnknown(data['actual_end']!, _actualEndMeta),
      );
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    }
    if (data.containsKey('raw_quantity_text')) {
      context.handle(
        _rawQuantityTextMeta,
        rawQuantityText.isAcceptableOrUnknown(
          data['raw_quantity_text']!,
          _rawQuantityTextMeta,
        ),
      );
    }
    if (data.containsKey('pesticide_claim')) {
      context.handle(
        _pesticideClaimMeta,
        pesticideClaim.isAcceptableOrUnknown(
          data['pesticide_claim']!,
          _pesticideClaimMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('review_note')) {
      context.handle(
        _reviewNoteMeta,
        reviewNote.isAcceptableOrUnknown(data['review_note']!, _reviewNoteMeta),
      );
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkReport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      reportedByKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reported_by_kind'],
      )!,
      reporterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reporter_name'],
      )!,
      actualStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_start'],
      ),
      actualEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_end'],
      ),
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      )!,
      rawQuantityText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_quantity_text'],
      )!,
      pesticideClaim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pesticide_claim'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      reviewNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_note'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      ),
    );
  }

  @override
  $WorkReportsTable createAlias(String alias) {
    return $WorkReportsTable(attachedDatabase, alias);
  }
}

class WorkReport extends DataClass implements Insertable<WorkReport> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String? taskId;
  final String fieldId;
  final String reportedByKind;
  final String reporterName;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final String rawText;
  final String rawQuantityText;
  final String pesticideClaim;
  final String status;
  final String reviewNote;
  final DateTime? submittedAt;
  const WorkReport({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    this.taskId,
    required this.fieldId,
    required this.reportedByKind,
    required this.reporterName,
    this.actualStart,
    this.actualEnd,
    required this.rawText,
    required this.rawQuantityText,
    required this.pesticideClaim,
    required this.status,
    required this.reviewNote,
    this.submittedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['field_id'] = Variable<String>(fieldId);
    map['reported_by_kind'] = Variable<String>(reportedByKind);
    map['reporter_name'] = Variable<String>(reporterName);
    if (!nullToAbsent || actualStart != null) {
      map['actual_start'] = Variable<DateTime>(actualStart);
    }
    if (!nullToAbsent || actualEnd != null) {
      map['actual_end'] = Variable<DateTime>(actualEnd);
    }
    map['raw_text'] = Variable<String>(rawText);
    map['raw_quantity_text'] = Variable<String>(rawQuantityText);
    map['pesticide_claim'] = Variable<String>(pesticideClaim);
    map['status'] = Variable<String>(status);
    map['review_note'] = Variable<String>(reviewNote);
    if (!nullToAbsent || submittedAt != null) {
      map['submitted_at'] = Variable<DateTime>(submittedAt);
    }
    return map;
  }

  WorkReportsCompanion toCompanion(bool nullToAbsent) {
    return WorkReportsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      fieldId: Value(fieldId),
      reportedByKind: Value(reportedByKind),
      reporterName: Value(reporterName),
      actualStart: actualStart == null && nullToAbsent
          ? const Value.absent()
          : Value(actualStart),
      actualEnd: actualEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(actualEnd),
      rawText: Value(rawText),
      rawQuantityText: Value(rawQuantityText),
      pesticideClaim: Value(pesticideClaim),
      status: Value(status),
      reviewNote: Value(reviewNote),
      submittedAt: submittedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedAt),
    );
  }

  factory WorkReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkReport(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      reportedByKind: serializer.fromJson<String>(json['reportedByKind']),
      reporterName: serializer.fromJson<String>(json['reporterName']),
      actualStart: serializer.fromJson<DateTime?>(json['actualStart']),
      actualEnd: serializer.fromJson<DateTime?>(json['actualEnd']),
      rawText: serializer.fromJson<String>(json['rawText']),
      rawQuantityText: serializer.fromJson<String>(json['rawQuantityText']),
      pesticideClaim: serializer.fromJson<String>(json['pesticideClaim']),
      status: serializer.fromJson<String>(json['status']),
      reviewNote: serializer.fromJson<String>(json['reviewNote']),
      submittedAt: serializer.fromJson<DateTime?>(json['submittedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'taskId': serializer.toJson<String?>(taskId),
      'fieldId': serializer.toJson<String>(fieldId),
      'reportedByKind': serializer.toJson<String>(reportedByKind),
      'reporterName': serializer.toJson<String>(reporterName),
      'actualStart': serializer.toJson<DateTime?>(actualStart),
      'actualEnd': serializer.toJson<DateTime?>(actualEnd),
      'rawText': serializer.toJson<String>(rawText),
      'rawQuantityText': serializer.toJson<String>(rawQuantityText),
      'pesticideClaim': serializer.toJson<String>(pesticideClaim),
      'status': serializer.toJson<String>(status),
      'reviewNote': serializer.toJson<String>(reviewNote),
      'submittedAt': serializer.toJson<DateTime?>(submittedAt),
    };
  }

  WorkReport copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    Value<String?> taskId = const Value.absent(),
    String? fieldId,
    String? reportedByKind,
    String? reporterName,
    Value<DateTime?> actualStart = const Value.absent(),
    Value<DateTime?> actualEnd = const Value.absent(),
    String? rawText,
    String? rawQuantityText,
    String? pesticideClaim,
    String? status,
    String? reviewNote,
    Value<DateTime?> submittedAt = const Value.absent(),
  }) => WorkReport(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    taskId: taskId.present ? taskId.value : this.taskId,
    fieldId: fieldId ?? this.fieldId,
    reportedByKind: reportedByKind ?? this.reportedByKind,
    reporterName: reporterName ?? this.reporterName,
    actualStart: actualStart.present ? actualStart.value : this.actualStart,
    actualEnd: actualEnd.present ? actualEnd.value : this.actualEnd,
    rawText: rawText ?? this.rawText,
    rawQuantityText: rawQuantityText ?? this.rawQuantityText,
    pesticideClaim: pesticideClaim ?? this.pesticideClaim,
    status: status ?? this.status,
    reviewNote: reviewNote ?? this.reviewNote,
    submittedAt: submittedAt.present ? submittedAt.value : this.submittedAt,
  );
  WorkReport copyWithCompanion(WorkReportsCompanion data) {
    return WorkReport(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      reportedByKind: data.reportedByKind.present
          ? data.reportedByKind.value
          : this.reportedByKind,
      reporterName: data.reporterName.present
          ? data.reporterName.value
          : this.reporterName,
      actualStart: data.actualStart.present
          ? data.actualStart.value
          : this.actualStart,
      actualEnd: data.actualEnd.present ? data.actualEnd.value : this.actualEnd,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      rawQuantityText: data.rawQuantityText.present
          ? data.rawQuantityText.value
          : this.rawQuantityText,
      pesticideClaim: data.pesticideClaim.present
          ? data.pesticideClaim.value
          : this.pesticideClaim,
      status: data.status.present ? data.status.value : this.status,
      reviewNote: data.reviewNote.present
          ? data.reviewNote.value
          : this.reviewNote,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkReport(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('taskId: $taskId, ')
          ..write('fieldId: $fieldId, ')
          ..write('reportedByKind: $reportedByKind, ')
          ..write('reporterName: $reporterName, ')
          ..write('actualStart: $actualStart, ')
          ..write('actualEnd: $actualEnd, ')
          ..write('rawText: $rawText, ')
          ..write('rawQuantityText: $rawQuantityText, ')
          ..write('pesticideClaim: $pesticideClaim, ')
          ..write('status: $status, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('submittedAt: $submittedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    taskId,
    fieldId,
    reportedByKind,
    reporterName,
    actualStart,
    actualEnd,
    rawText,
    rawQuantityText,
    pesticideClaim,
    status,
    reviewNote,
    submittedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkReport &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.taskId == this.taskId &&
          other.fieldId == this.fieldId &&
          other.reportedByKind == this.reportedByKind &&
          other.reporterName == this.reporterName &&
          other.actualStart == this.actualStart &&
          other.actualEnd == this.actualEnd &&
          other.rawText == this.rawText &&
          other.rawQuantityText == this.rawQuantityText &&
          other.pesticideClaim == this.pesticideClaim &&
          other.status == this.status &&
          other.reviewNote == this.reviewNote &&
          other.submittedAt == this.submittedAt);
}

class WorkReportsCompanion extends UpdateCompanion<WorkReport> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String?> taskId;
  final Value<String> fieldId;
  final Value<String> reportedByKind;
  final Value<String> reporterName;
  final Value<DateTime?> actualStart;
  final Value<DateTime?> actualEnd;
  final Value<String> rawText;
  final Value<String> rawQuantityText;
  final Value<String> pesticideClaim;
  final Value<String> status;
  final Value<String> reviewNote;
  final Value<DateTime?> submittedAt;
  final Value<int> rowid;
  const WorkReportsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.taskId = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.reportedByKind = const Value.absent(),
    this.reporterName = const Value.absent(),
    this.actualStart = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.rawText = const Value.absent(),
    this.rawQuantityText = const Value.absent(),
    this.pesticideClaim = const Value.absent(),
    this.status = const Value.absent(),
    this.reviewNote = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkReportsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    this.taskId = const Value.absent(),
    required String fieldId,
    this.reportedByKind = const Value.absent(),
    required String reporterName,
    this.actualStart = const Value.absent(),
    this.actualEnd = const Value.absent(),
    this.rawText = const Value.absent(),
    this.rawQuantityText = const Value.absent(),
    this.pesticideClaim = const Value.absent(),
    required String status,
    this.reviewNote = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       fieldId = Value(fieldId),
       reporterName = Value(reporterName),
       status = Value(status);
  static Insertable<WorkReport> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? taskId,
    Expression<String>? fieldId,
    Expression<String>? reportedByKind,
    Expression<String>? reporterName,
    Expression<DateTime>? actualStart,
    Expression<DateTime>? actualEnd,
    Expression<String>? rawText,
    Expression<String>? rawQuantityText,
    Expression<String>? pesticideClaim,
    Expression<String>? status,
    Expression<String>? reviewNote,
    Expression<DateTime>? submittedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (taskId != null) 'task_id': taskId,
      if (fieldId != null) 'field_id': fieldId,
      if (reportedByKind != null) 'reported_by_kind': reportedByKind,
      if (reporterName != null) 'reporter_name': reporterName,
      if (actualStart != null) 'actual_start': actualStart,
      if (actualEnd != null) 'actual_end': actualEnd,
      if (rawText != null) 'raw_text': rawText,
      if (rawQuantityText != null) 'raw_quantity_text': rawQuantityText,
      if (pesticideClaim != null) 'pesticide_claim': pesticideClaim,
      if (status != null) 'status': status,
      if (reviewNote != null) 'review_note': reviewNote,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkReportsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String?>? taskId,
    Value<String>? fieldId,
    Value<String>? reportedByKind,
    Value<String>? reporterName,
    Value<DateTime?>? actualStart,
    Value<DateTime?>? actualEnd,
    Value<String>? rawText,
    Value<String>? rawQuantityText,
    Value<String>? pesticideClaim,
    Value<String>? status,
    Value<String>? reviewNote,
    Value<DateTime?>? submittedAt,
    Value<int>? rowid,
  }) {
    return WorkReportsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      taskId: taskId ?? this.taskId,
      fieldId: fieldId ?? this.fieldId,
      reportedByKind: reportedByKind ?? this.reportedByKind,
      reporterName: reporterName ?? this.reporterName,
      actualStart: actualStart ?? this.actualStart,
      actualEnd: actualEnd ?? this.actualEnd,
      rawText: rawText ?? this.rawText,
      rawQuantityText: rawQuantityText ?? this.rawQuantityText,
      pesticideClaim: pesticideClaim ?? this.pesticideClaim,
      status: status ?? this.status,
      reviewNote: reviewNote ?? this.reviewNote,
      submittedAt: submittedAt ?? this.submittedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (reportedByKind.present) {
      map['reported_by_kind'] = Variable<String>(reportedByKind.value);
    }
    if (reporterName.present) {
      map['reporter_name'] = Variable<String>(reporterName.value);
    }
    if (actualStart.present) {
      map['actual_start'] = Variable<DateTime>(actualStart.value);
    }
    if (actualEnd.present) {
      map['actual_end'] = Variable<DateTime>(actualEnd.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (rawQuantityText.present) {
      map['raw_quantity_text'] = Variable<String>(rawQuantityText.value);
    }
    if (pesticideClaim.present) {
      map['pesticide_claim'] = Variable<String>(pesticideClaim.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reviewNote.present) {
      map['review_note'] = Variable<String>(reviewNote.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkReportsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('taskId: $taskId, ')
          ..write('fieldId: $fieldId, ')
          ..write('reportedByKind: $reportedByKind, ')
          ..write('reporterName: $reporterName, ')
          ..write('actualStart: $actualStart, ')
          ..write('actualEnd: $actualEnd, ')
          ..write('rawText: $rawText, ')
          ..write('rawQuantityText: $rawQuantityText, ')
          ..write('pesticideClaim: $pesticideClaim, ')
          ..write('status: $status, ')
          ..write('reviewNote: $reviewNote, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkRecordsTable extends WorkRecords
    with TableInfo<$WorkRecordsTable, WorkRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seasonIdMeta = const VerificationMeta(
    'seasonId',
  );
  @override
  late final GeneratedColumn<String> seasonId = GeneratedColumn<String>(
    'season_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workTypeMeta = const VerificationMeta(
    'workType',
  );
  @override
  late final GeneratedColumn<String> workType = GeneratedColumn<String>(
    'work_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _performedOnMeta = const VerificationMeta(
    'performedOn',
  );
  @override
  late final GeneratedColumn<DateTime> performedOn = GeneratedColumn<DateTime>(
    'performed_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesticideStatusMeta = const VerificationMeta(
    'pesticideStatus',
  );
  @override
  late final GeneratedColumn<String> pesticideStatus = GeneratedColumn<String>(
    'pesticide_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedByMeta = const VerificationMeta(
    'confirmedBy',
  );
  @override
  late final GeneratedColumn<String> confirmedBy = GeneratedColumn<String>(
    'confirmed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
    'confirmed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    reportId,
    fieldId,
    seasonId,
    workType,
    performedOn,
    summary,
    pesticideStatus,
    status,
    confirmedBy,
    confirmedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('season_id')) {
      context.handle(
        _seasonIdMeta,
        seasonId.isAcceptableOrUnknown(data['season_id']!, _seasonIdMeta),
      );
    }
    if (data.containsKey('work_type')) {
      context.handle(
        _workTypeMeta,
        workType.isAcceptableOrUnknown(data['work_type']!, _workTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_workTypeMeta);
    }
    if (data.containsKey('performed_on')) {
      context.handle(
        _performedOnMeta,
        performedOn.isAcceptableOrUnknown(
          data['performed_on']!,
          _performedOnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedOnMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('pesticide_status')) {
      context.handle(
        _pesticideStatusMeta,
        pesticideStatus.isAcceptableOrUnknown(
          data['pesticide_status']!,
          _pesticideStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pesticideStatusMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('confirmed_by')) {
      context.handle(
        _confirmedByMeta,
        confirmedBy.isAcceptableOrUnknown(
          data['confirmed_by']!,
          _confirmedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmedByMeta);
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      seasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}season_id'],
      ),
      workType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_type'],
      )!,
      performedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_on'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      pesticideStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pesticide_status'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      confirmedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_by'],
      )!,
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmed_at'],
      )!,
    );
  }

  @override
  $WorkRecordsTable createAlias(String alias) {
    return $WorkRecordsTable(attachedDatabase, alias);
  }
}

class WorkRecord extends DataClass implements Insertable<WorkRecord> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String reportId;
  final String fieldId;
  final String? seasonId;
  final String workType;
  final DateTime performedOn;
  final String summary;
  final String pesticideStatus;
  final String status;
  final String confirmedBy;
  final DateTime confirmedAt;
  const WorkRecord({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.reportId,
    required this.fieldId,
    this.seasonId,
    required this.workType,
    required this.performedOn,
    required this.summary,
    required this.pesticideStatus,
    required this.status,
    required this.confirmedBy,
    required this.confirmedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['report_id'] = Variable<String>(reportId);
    map['field_id'] = Variable<String>(fieldId);
    if (!nullToAbsent || seasonId != null) {
      map['season_id'] = Variable<String>(seasonId);
    }
    map['work_type'] = Variable<String>(workType);
    map['performed_on'] = Variable<DateTime>(performedOn);
    map['summary'] = Variable<String>(summary);
    map['pesticide_status'] = Variable<String>(pesticideStatus);
    map['status'] = Variable<String>(status);
    map['confirmed_by'] = Variable<String>(confirmedBy);
    map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    return map;
  }

  WorkRecordsCompanion toCompanion(bool nullToAbsent) {
    return WorkRecordsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      reportId: Value(reportId),
      fieldId: Value(fieldId),
      seasonId: seasonId == null && nullToAbsent
          ? const Value.absent()
          : Value(seasonId),
      workType: Value(workType),
      performedOn: Value(performedOn),
      summary: Value(summary),
      pesticideStatus: Value(pesticideStatus),
      status: Value(status),
      confirmedBy: Value(confirmedBy),
      confirmedAt: Value(confirmedAt),
    );
  }

  factory WorkRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkRecord(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      reportId: serializer.fromJson<String>(json['reportId']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      seasonId: serializer.fromJson<String?>(json['seasonId']),
      workType: serializer.fromJson<String>(json['workType']),
      performedOn: serializer.fromJson<DateTime>(json['performedOn']),
      summary: serializer.fromJson<String>(json['summary']),
      pesticideStatus: serializer.fromJson<String>(json['pesticideStatus']),
      status: serializer.fromJson<String>(json['status']),
      confirmedBy: serializer.fromJson<String>(json['confirmedBy']),
      confirmedAt: serializer.fromJson<DateTime>(json['confirmedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'reportId': serializer.toJson<String>(reportId),
      'fieldId': serializer.toJson<String>(fieldId),
      'seasonId': serializer.toJson<String?>(seasonId),
      'workType': serializer.toJson<String>(workType),
      'performedOn': serializer.toJson<DateTime>(performedOn),
      'summary': serializer.toJson<String>(summary),
      'pesticideStatus': serializer.toJson<String>(pesticideStatus),
      'status': serializer.toJson<String>(status),
      'confirmedBy': serializer.toJson<String>(confirmedBy),
      'confirmedAt': serializer.toJson<DateTime>(confirmedAt),
    };
  }

  WorkRecord copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? reportId,
    String? fieldId,
    Value<String?> seasonId = const Value.absent(),
    String? workType,
    DateTime? performedOn,
    String? summary,
    String? pesticideStatus,
    String? status,
    String? confirmedBy,
    DateTime? confirmedAt,
  }) => WorkRecord(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    reportId: reportId ?? this.reportId,
    fieldId: fieldId ?? this.fieldId,
    seasonId: seasonId.present ? seasonId.value : this.seasonId,
    workType: workType ?? this.workType,
    performedOn: performedOn ?? this.performedOn,
    summary: summary ?? this.summary,
    pesticideStatus: pesticideStatus ?? this.pesticideStatus,
    status: status ?? this.status,
    confirmedBy: confirmedBy ?? this.confirmedBy,
    confirmedAt: confirmedAt ?? this.confirmedAt,
  );
  WorkRecord copyWithCompanion(WorkRecordsCompanion data) {
    return WorkRecord(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      seasonId: data.seasonId.present ? data.seasonId.value : this.seasonId,
      workType: data.workType.present ? data.workType.value : this.workType,
      performedOn: data.performedOn.present
          ? data.performedOn.value
          : this.performedOn,
      summary: data.summary.present ? data.summary.value : this.summary,
      pesticideStatus: data.pesticideStatus.present
          ? data.pesticideStatus.value
          : this.pesticideStatus,
      status: data.status.present ? data.status.value : this.status,
      confirmedBy: data.confirmedBy.present
          ? data.confirmedBy.value
          : this.confirmedBy,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecord(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('reportId: $reportId, ')
          ..write('fieldId: $fieldId, ')
          ..write('seasonId: $seasonId, ')
          ..write('workType: $workType, ')
          ..write('performedOn: $performedOn, ')
          ..write('summary: $summary, ')
          ..write('pesticideStatus: $pesticideStatus, ')
          ..write('status: $status, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('confirmedAt: $confirmedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    reportId,
    fieldId,
    seasonId,
    workType,
    performedOn,
    summary,
    pesticideStatus,
    status,
    confirmedBy,
    confirmedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkRecord &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.reportId == this.reportId &&
          other.fieldId == this.fieldId &&
          other.seasonId == this.seasonId &&
          other.workType == this.workType &&
          other.performedOn == this.performedOn &&
          other.summary == this.summary &&
          other.pesticideStatus == this.pesticideStatus &&
          other.status == this.status &&
          other.confirmedBy == this.confirmedBy &&
          other.confirmedAt == this.confirmedAt);
}

class WorkRecordsCompanion extends UpdateCompanion<WorkRecord> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> reportId;
  final Value<String> fieldId;
  final Value<String?> seasonId;
  final Value<String> workType;
  final Value<DateTime> performedOn;
  final Value<String> summary;
  final Value<String> pesticideStatus;
  final Value<String> status;
  final Value<String> confirmedBy;
  final Value<DateTime> confirmedAt;
  final Value<int> rowid;
  const WorkRecordsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.reportId = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.seasonId = const Value.absent(),
    this.workType = const Value.absent(),
    this.performedOn = const Value.absent(),
    this.summary = const Value.absent(),
    this.pesticideStatus = const Value.absent(),
    this.status = const Value.absent(),
    this.confirmedBy = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkRecordsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String reportId,
    required String fieldId,
    this.seasonId = const Value.absent(),
    required String workType,
    required DateTime performedOn,
    required String summary,
    required String pesticideStatus,
    required String status,
    required String confirmedBy,
    required DateTime confirmedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       reportId = Value(reportId),
       fieldId = Value(fieldId),
       workType = Value(workType),
       performedOn = Value(performedOn),
       summary = Value(summary),
       pesticideStatus = Value(pesticideStatus),
       status = Value(status),
       confirmedBy = Value(confirmedBy),
       confirmedAt = Value(confirmedAt);
  static Insertable<WorkRecord> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? reportId,
    Expression<String>? fieldId,
    Expression<String>? seasonId,
    Expression<String>? workType,
    Expression<DateTime>? performedOn,
    Expression<String>? summary,
    Expression<String>? pesticideStatus,
    Expression<String>? status,
    Expression<String>? confirmedBy,
    Expression<DateTime>? confirmedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (reportId != null) 'report_id': reportId,
      if (fieldId != null) 'field_id': fieldId,
      if (seasonId != null) 'season_id': seasonId,
      if (workType != null) 'work_type': workType,
      if (performedOn != null) 'performed_on': performedOn,
      if (summary != null) 'summary': summary,
      if (pesticideStatus != null) 'pesticide_status': pesticideStatus,
      if (status != null) 'status': status,
      if (confirmedBy != null) 'confirmed_by': confirmedBy,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? reportId,
    Value<String>? fieldId,
    Value<String?>? seasonId,
    Value<String>? workType,
    Value<DateTime>? performedOn,
    Value<String>? summary,
    Value<String>? pesticideStatus,
    Value<String>? status,
    Value<String>? confirmedBy,
    Value<DateTime>? confirmedAt,
    Value<int>? rowid,
  }) {
    return WorkRecordsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      reportId: reportId ?? this.reportId,
      fieldId: fieldId ?? this.fieldId,
      seasonId: seasonId ?? this.seasonId,
      workType: workType ?? this.workType,
      performedOn: performedOn ?? this.performedOn,
      summary: summary ?? this.summary,
      pesticideStatus: pesticideStatus ?? this.pesticideStatus,
      status: status ?? this.status,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (seasonId.present) {
      map['season_id'] = Variable<String>(seasonId.value);
    }
    if (workType.present) {
      map['work_type'] = Variable<String>(workType.value);
    }
    if (performedOn.present) {
      map['performed_on'] = Variable<DateTime>(performedOn.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (pesticideStatus.present) {
      map['pesticide_status'] = Variable<String>(pesticideStatus.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (confirmedBy.present) {
      map['confirmed_by'] = Variable<String>(confirmedBy.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecordsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('reportId: $reportId, ')
          ..write('fieldId: $fieldId, ')
          ..write('seasonId: $seasonId, ')
          ..write('workType: $workType, ')
          ..write('performedOn: $performedOn, ')
          ..write('summary: $summary, ')
          ..write('pesticideStatus: $pesticideStatus, ')
          ..write('status: $status, ')
          ..write('confirmedBy: $confirmedBy, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkRecordInputsTable extends WorkRecordInputs
    with TableInfo<$WorkRecordInputsTable, WorkRecordInput> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkRecordInputsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rawQuantityTextMeta = const VerificationMeta(
    'rawQuantityText',
  );
  @override
  late final GeneratedColumn<String> rawQuantityText = GeneratedColumn<String>(
    'raw_quantity_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitCodeMeta = const VerificationMeta(
    'unitCode',
  );
  @override
  late final GeneratedColumn<String> unitCode = GeneratedColumn<String>(
    'unit_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conversionBasisMeta = const VerificationMeta(
    'conversionBasis',
  );
  @override
  late final GeneratedColumn<String> conversionBasis = GeneratedColumn<String>(
    'conversion_basis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    recordId,
    productName,
    rawQuantityText,
    quantity,
    unitCode,
    conversionBasis,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_record_inputs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkRecordInput> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    }
    if (data.containsKey('raw_quantity_text')) {
      context.handle(
        _rawQuantityTextMeta,
        rawQuantityText.isAcceptableOrUnknown(
          data['raw_quantity_text']!,
          _rawQuantityTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawQuantityTextMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_code')) {
      context.handle(
        _unitCodeMeta,
        unitCode.isAcceptableOrUnknown(data['unit_code']!, _unitCodeMeta),
      );
    }
    if (data.containsKey('conversion_basis')) {
      context.handle(
        _conversionBasisMeta,
        conversionBasis.isAcceptableOrUnknown(
          data['conversion_basis']!,
          _conversionBasisMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkRecordInput map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkRecordInput(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      rawQuantityText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_quantity_text'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity'],
      ),
      unitCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_code'],
      ),
      conversionBasis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversion_basis'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $WorkRecordInputsTable createAlias(String alias) {
    return $WorkRecordInputsTable(attachedDatabase, alias);
  }
}

class WorkRecordInput extends DataClass implements Insertable<WorkRecordInput> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String recordId;
  final String productName;
  final String rawQuantityText;
  final String? quantity;
  final String? unitCode;
  final String conversionBasis;
  final String status;
  const WorkRecordInput({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.recordId,
    required this.productName,
    required this.rawQuantityText,
    this.quantity,
    this.unitCode,
    required this.conversionBasis,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['record_id'] = Variable<String>(recordId);
    map['product_name'] = Variable<String>(productName);
    map['raw_quantity_text'] = Variable<String>(rawQuantityText);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<String>(quantity);
    }
    if (!nullToAbsent || unitCode != null) {
      map['unit_code'] = Variable<String>(unitCode);
    }
    map['conversion_basis'] = Variable<String>(conversionBasis);
    map['status'] = Variable<String>(status);
    return map;
  }

  WorkRecordInputsCompanion toCompanion(bool nullToAbsent) {
    return WorkRecordInputsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      recordId: Value(recordId),
      productName: Value(productName),
      rawQuantityText: Value(rawQuantityText),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unitCode: unitCode == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCode),
      conversionBasis: Value(conversionBasis),
      status: Value(status),
    );
  }

  factory WorkRecordInput.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkRecordInput(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      recordId: serializer.fromJson<String>(json['recordId']),
      productName: serializer.fromJson<String>(json['productName']),
      rawQuantityText: serializer.fromJson<String>(json['rawQuantityText']),
      quantity: serializer.fromJson<String?>(json['quantity']),
      unitCode: serializer.fromJson<String?>(json['unitCode']),
      conversionBasis: serializer.fromJson<String>(json['conversionBasis']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'recordId': serializer.toJson<String>(recordId),
      'productName': serializer.toJson<String>(productName),
      'rawQuantityText': serializer.toJson<String>(rawQuantityText),
      'quantity': serializer.toJson<String?>(quantity),
      'unitCode': serializer.toJson<String?>(unitCode),
      'conversionBasis': serializer.toJson<String>(conversionBasis),
      'status': serializer.toJson<String>(status),
    };
  }

  WorkRecordInput copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? recordId,
    String? productName,
    String? rawQuantityText,
    Value<String?> quantity = const Value.absent(),
    Value<String?> unitCode = const Value.absent(),
    String? conversionBasis,
    String? status,
  }) => WorkRecordInput(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    recordId: recordId ?? this.recordId,
    productName: productName ?? this.productName,
    rawQuantityText: rawQuantityText ?? this.rawQuantityText,
    quantity: quantity.present ? quantity.value : this.quantity,
    unitCode: unitCode.present ? unitCode.value : this.unitCode,
    conversionBasis: conversionBasis ?? this.conversionBasis,
    status: status ?? this.status,
  );
  WorkRecordInput copyWithCompanion(WorkRecordInputsCompanion data) {
    return WorkRecordInput(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      rawQuantityText: data.rawQuantityText.present
          ? data.rawQuantityText.value
          : this.rawQuantityText,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCode: data.unitCode.present ? data.unitCode.value : this.unitCode,
      conversionBasis: data.conversionBasis.present
          ? data.conversionBasis.value
          : this.conversionBasis,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecordInput(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('recordId: $recordId, ')
          ..write('productName: $productName, ')
          ..write('rawQuantityText: $rawQuantityText, ')
          ..write('quantity: $quantity, ')
          ..write('unitCode: $unitCode, ')
          ..write('conversionBasis: $conversionBasis, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    recordId,
    productName,
    rawQuantityText,
    quantity,
    unitCode,
    conversionBasis,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkRecordInput &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.recordId == this.recordId &&
          other.productName == this.productName &&
          other.rawQuantityText == this.rawQuantityText &&
          other.quantity == this.quantity &&
          other.unitCode == this.unitCode &&
          other.conversionBasis == this.conversionBasis &&
          other.status == this.status);
}

class WorkRecordInputsCompanion extends UpdateCompanion<WorkRecordInput> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> recordId;
  final Value<String> productName;
  final Value<String> rawQuantityText;
  final Value<String?> quantity;
  final Value<String?> unitCode;
  final Value<String> conversionBasis;
  final Value<String> status;
  final Value<int> rowid;
  const WorkRecordInputsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.recordId = const Value.absent(),
    this.productName = const Value.absent(),
    this.rawQuantityText = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCode = const Value.absent(),
    this.conversionBasis = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkRecordInputsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String recordId,
    this.productName = const Value.absent(),
    required String rawQuantityText,
    this.quantity = const Value.absent(),
    this.unitCode = const Value.absent(),
    this.conversionBasis = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       recordId = Value(recordId),
       rawQuantityText = Value(rawQuantityText),
       status = Value(status);
  static Insertable<WorkRecordInput> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? recordId,
    Expression<String>? productName,
    Expression<String>? rawQuantityText,
    Expression<String>? quantity,
    Expression<String>? unitCode,
    Expression<String>? conversionBasis,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (recordId != null) 'record_id': recordId,
      if (productName != null) 'product_name': productName,
      if (rawQuantityText != null) 'raw_quantity_text': rawQuantityText,
      if (quantity != null) 'quantity': quantity,
      if (unitCode != null) 'unit_code': unitCode,
      if (conversionBasis != null) 'conversion_basis': conversionBasis,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkRecordInputsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? recordId,
    Value<String>? productName,
    Value<String>? rawQuantityText,
    Value<String?>? quantity,
    Value<String?>? unitCode,
    Value<String>? conversionBasis,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return WorkRecordInputsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      recordId: recordId ?? this.recordId,
      productName: productName ?? this.productName,
      rawQuantityText: rawQuantityText ?? this.rawQuantityText,
      quantity: quantity ?? this.quantity,
      unitCode: unitCode ?? this.unitCode,
      conversionBasis: conversionBasis ?? this.conversionBasis,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (rawQuantityText.present) {
      map['raw_quantity_text'] = Variable<String>(rawQuantityText.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (unitCode.present) {
      map['unit_code'] = Variable<String>(unitCode.value);
    }
    if (conversionBasis.present) {
      map['conversion_basis'] = Variable<String>(conversionBasis.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecordInputsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('recordId: $recordId, ')
          ..write('productName: $productName, ')
          ..write('rawQuantityText: $rawQuantityText, ')
          ..write('quantity: $quantity, ')
          ..write('unitCode: $unitCode, ')
          ..write('conversionBasis: $conversionBasis, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordRevisionsTable extends RecordRevisions
    with TableInfo<$RecordRevisionsTable, RecordRevision> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordRevisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beforeJsonMeta = const VerificationMeta(
    'beforeJson',
  );
  @override
  late final GeneratedColumn<String> beforeJson = GeneratedColumn<String>(
    'before_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _afterJsonMeta = const VerificationMeta(
    'afterJson',
  );
  @override
  late final GeneratedColumn<String> afterJson = GeneratedColumn<String>(
    'after_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byMeta = const VerificationMeta('by');
  @override
  late final GeneratedColumn<String> by = GeneratedColumn<String>(
    'by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    recordId,
    beforeJson,
    afterJson,
    reason,
    by,
    at,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_revisions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordRevision> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('before_json')) {
      context.handle(
        _beforeJsonMeta,
        beforeJson.isAcceptableOrUnknown(data['before_json']!, _beforeJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_beforeJsonMeta);
    }
    if (data.containsKey('after_json')) {
      context.handle(
        _afterJsonMeta,
        afterJson.isAcceptableOrUnknown(data['after_json']!, _afterJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_afterJsonMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('by')) {
      context.handle(_byMeta, by.isAcceptableOrUnknown(data['by']!, _byMeta));
    } else if (isInserting) {
      context.missing(_byMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordRevision map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordRevision(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      beforeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}before_json'],
      )!,
      afterJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}after_json'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      by: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}by'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $RecordRevisionsTable createAlias(String alias) {
    return $RecordRevisionsTable(attachedDatabase, alias);
  }
}

class RecordRevision extends DataClass implements Insertable<RecordRevision> {
  final String id;
  final String workspaceId;
  final String recordId;
  final String beforeJson;
  final String afterJson;
  final String reason;
  final String by;
  final DateTime at;
  const RecordRevision({
    required this.id,
    required this.workspaceId,
    required this.recordId,
    required this.beforeJson,
    required this.afterJson,
    required this.reason,
    required this.by,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['record_id'] = Variable<String>(recordId);
    map['before_json'] = Variable<String>(beforeJson);
    map['after_json'] = Variable<String>(afterJson);
    map['reason'] = Variable<String>(reason);
    map['by'] = Variable<String>(by);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  RecordRevisionsCompanion toCompanion(bool nullToAbsent) {
    return RecordRevisionsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      recordId: Value(recordId),
      beforeJson: Value(beforeJson),
      afterJson: Value(afterJson),
      reason: Value(reason),
      by: Value(by),
      at: Value(at),
    );
  }

  factory RecordRevision.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordRevision(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      recordId: serializer.fromJson<String>(json['recordId']),
      beforeJson: serializer.fromJson<String>(json['beforeJson']),
      afterJson: serializer.fromJson<String>(json['afterJson']),
      reason: serializer.fromJson<String>(json['reason']),
      by: serializer.fromJson<String>(json['by']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'recordId': serializer.toJson<String>(recordId),
      'beforeJson': serializer.toJson<String>(beforeJson),
      'afterJson': serializer.toJson<String>(afterJson),
      'reason': serializer.toJson<String>(reason),
      'by': serializer.toJson<String>(by),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  RecordRevision copyWith({
    String? id,
    String? workspaceId,
    String? recordId,
    String? beforeJson,
    String? afterJson,
    String? reason,
    String? by,
    DateTime? at,
  }) => RecordRevision(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    recordId: recordId ?? this.recordId,
    beforeJson: beforeJson ?? this.beforeJson,
    afterJson: afterJson ?? this.afterJson,
    reason: reason ?? this.reason,
    by: by ?? this.by,
    at: at ?? this.at,
  );
  RecordRevision copyWithCompanion(RecordRevisionsCompanion data) {
    return RecordRevision(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      beforeJson: data.beforeJson.present
          ? data.beforeJson.value
          : this.beforeJson,
      afterJson: data.afterJson.present ? data.afterJson.value : this.afterJson,
      reason: data.reason.present ? data.reason.value : this.reason,
      by: data.by.present ? data.by.value : this.by,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordRevision(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('recordId: $recordId, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('reason: $reason, ')
          ..write('by: $by, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    recordId,
    beforeJson,
    afterJson,
    reason,
    by,
    at,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordRevision &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.recordId == this.recordId &&
          other.beforeJson == this.beforeJson &&
          other.afterJson == this.afterJson &&
          other.reason == this.reason &&
          other.by == this.by &&
          other.at == this.at);
}

class RecordRevisionsCompanion extends UpdateCompanion<RecordRevision> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> recordId;
  final Value<String> beforeJson;
  final Value<String> afterJson;
  final Value<String> reason;
  final Value<String> by;
  final Value<DateTime> at;
  final Value<int> rowid;
  const RecordRevisionsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.recordId = const Value.absent(),
    this.beforeJson = const Value.absent(),
    this.afterJson = const Value.absent(),
    this.reason = const Value.absent(),
    this.by = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordRevisionsCompanion.insert({
    required String id,
    required String workspaceId,
    required String recordId,
    required String beforeJson,
    required String afterJson,
    required String reason,
    required String by,
    required DateTime at,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       recordId = Value(recordId),
       beforeJson = Value(beforeJson),
       afterJson = Value(afterJson),
       reason = Value(reason),
       by = Value(by),
       at = Value(at);
  static Insertable<RecordRevision> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? recordId,
    Expression<String>? beforeJson,
    Expression<String>? afterJson,
    Expression<String>? reason,
    Expression<String>? by,
    Expression<DateTime>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (recordId != null) 'record_id': recordId,
      if (beforeJson != null) 'before_json': beforeJson,
      if (afterJson != null) 'after_json': afterJson,
      if (reason != null) 'reason': reason,
      if (by != null) 'by': by,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordRevisionsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<String>? recordId,
    Value<String>? beforeJson,
    Value<String>? afterJson,
    Value<String>? reason,
    Value<String>? by,
    Value<DateTime>? at,
    Value<int>? rowid,
  }) {
    return RecordRevisionsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      recordId: recordId ?? this.recordId,
      beforeJson: beforeJson ?? this.beforeJson,
      afterJson: afterJson ?? this.afterJson,
      reason: reason ?? this.reason,
      by: by ?? this.by,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (beforeJson.present) {
      map['before_json'] = Variable<String>(beforeJson.value);
    }
    if (afterJson.present) {
      map['after_json'] = Variable<String>(afterJson.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (by.present) {
      map['by'] = Variable<String>(by.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordRevisionsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('recordId: $recordId, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('reason: $reason, ')
          ..write('by: $by, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaAssetsTable extends MediaAssets
    with TableInfo<$MediaAssetsTable, MediaAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerKindMeta = const VerificationMeta(
    'ownerKind',
  );
  @override
  late final GeneratedColumn<String> ownerKind = GeneratedColumn<String>(
    'owner_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('photo'),
  );
  static const VerificationMeta _mimeMeta = const VerificationMeta('mime');
  @override
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('image/jpeg'),
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMMeta = const VerificationMeta(
    'accuracyM',
  );
  @override
  late final GeneratedColumn<double> accuracyM = GeneratedColumn<double>(
    'accuracy_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headingDegMeta = const VerificationMeta(
    'headingDeg',
  );
  @override
  late final GeneratedColumn<double> headingDeg = GeneratedColumn<double>(
    'heading_deg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientUploadIdMeta = const VerificationMeta(
    'clientUploadId',
  );
  @override
  late final GeneratedColumn<String> clientUploadId = GeneratedColumn<String>(
    'client_upload_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadStatusMeta = const VerificationMeta(
    'uploadStatus',
  );
  @override
  late final GeneratedColumn<String> uploadStatus = GeneratedColumn<String>(
    'upload_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    ownerKind,
    ownerId,
    localPath,
    kind,
    mime,
    sizeBytes,
    sha256,
    capturedAt,
    lat,
    lng,
    accuracyM,
    headingDeg,
    clientUploadId,
    uploadStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('owner_kind')) {
      context.handle(
        _ownerKindMeta,
        ownerKind.isAcceptableOrUnknown(data['owner_kind']!, _ownerKindMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerKindMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('mime')) {
      context.handle(
        _mimeMeta,
        mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('accuracy_m')) {
      context.handle(
        _accuracyMMeta,
        accuracyM.isAcceptableOrUnknown(data['accuracy_m']!, _accuracyMMeta),
      );
    }
    if (data.containsKey('heading_deg')) {
      context.handle(
        _headingDegMeta,
        headingDeg.isAcceptableOrUnknown(data['heading_deg']!, _headingDegMeta),
      );
    }
    if (data.containsKey('client_upload_id')) {
      context.handle(
        _clientUploadIdMeta,
        clientUploadId.isAcceptableOrUnknown(
          data['client_upload_id']!,
          _clientUploadIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientUploadIdMeta);
    }
    if (data.containsKey('upload_status')) {
      context.handle(
        _uploadStatusMeta,
        uploadStatus.isAcceptableOrUnknown(
          data['upload_status']!,
          _uploadStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_uploadStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaAsset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      ownerKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_kind'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      accuracyM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_m'],
      ),
      headingDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading_deg'],
      ),
      clientUploadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_upload_id'],
      )!,
      uploadStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MediaAssetsTable createAlias(String alias) {
    return $MediaAssetsTable(attachedDatabase, alias);
  }
}

class MediaAsset extends DataClass implements Insertable<MediaAsset> {
  final String id;
  final String workspaceId;
  final String ownerKind;
  final String ownerId;
  final String localPath;
  final String kind;
  final String mime;
  final int sizeBytes;
  final String sha256;
  final DateTime capturedAt;
  final double? lat;
  final double? lng;
  final double? accuracyM;
  final double? headingDeg;
  final String clientUploadId;
  final String uploadStatus;
  final DateTime createdAt;
  const MediaAsset({
    required this.id,
    required this.workspaceId,
    required this.ownerKind,
    required this.ownerId,
    required this.localPath,
    required this.kind,
    required this.mime,
    required this.sizeBytes,
    required this.sha256,
    required this.capturedAt,
    this.lat,
    this.lng,
    this.accuracyM,
    this.headingDeg,
    required this.clientUploadId,
    required this.uploadStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['owner_kind'] = Variable<String>(ownerKind);
    map['owner_id'] = Variable<String>(ownerId);
    map['local_path'] = Variable<String>(localPath);
    map['kind'] = Variable<String>(kind);
    map['mime'] = Variable<String>(mime);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['sha256'] = Variable<String>(sha256);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || accuracyM != null) {
      map['accuracy_m'] = Variable<double>(accuracyM);
    }
    if (!nullToAbsent || headingDeg != null) {
      map['heading_deg'] = Variable<double>(headingDeg);
    }
    map['client_upload_id'] = Variable<String>(clientUploadId);
    map['upload_status'] = Variable<String>(uploadStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MediaAssetsCompanion toCompanion(bool nullToAbsent) {
    return MediaAssetsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      ownerKind: Value(ownerKind),
      ownerId: Value(ownerId),
      localPath: Value(localPath),
      kind: Value(kind),
      mime: Value(mime),
      sizeBytes: Value(sizeBytes),
      sha256: Value(sha256),
      capturedAt: Value(capturedAt),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      accuracyM: accuracyM == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyM),
      headingDeg: headingDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(headingDeg),
      clientUploadId: Value(clientUploadId),
      uploadStatus: Value(uploadStatus),
      createdAt: Value(createdAt),
    );
  }

  factory MediaAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaAsset(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      ownerKind: serializer.fromJson<String>(json['ownerKind']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      kind: serializer.fromJson<String>(json['kind']),
      mime: serializer.fromJson<String>(json['mime']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      sha256: serializer.fromJson<String>(json['sha256']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      accuracyM: serializer.fromJson<double?>(json['accuracyM']),
      headingDeg: serializer.fromJson<double?>(json['headingDeg']),
      clientUploadId: serializer.fromJson<String>(json['clientUploadId']),
      uploadStatus: serializer.fromJson<String>(json['uploadStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'ownerKind': serializer.toJson<String>(ownerKind),
      'ownerId': serializer.toJson<String>(ownerId),
      'localPath': serializer.toJson<String>(localPath),
      'kind': serializer.toJson<String>(kind),
      'mime': serializer.toJson<String>(mime),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'sha256': serializer.toJson<String>(sha256),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'accuracyM': serializer.toJson<double?>(accuracyM),
      'headingDeg': serializer.toJson<double?>(headingDeg),
      'clientUploadId': serializer.toJson<String>(clientUploadId),
      'uploadStatus': serializer.toJson<String>(uploadStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MediaAsset copyWith({
    String? id,
    String? workspaceId,
    String? ownerKind,
    String? ownerId,
    String? localPath,
    String? kind,
    String? mime,
    int? sizeBytes,
    String? sha256,
    DateTime? capturedAt,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<double?> accuracyM = const Value.absent(),
    Value<double?> headingDeg = const Value.absent(),
    String? clientUploadId,
    String? uploadStatus,
    DateTime? createdAt,
  }) => MediaAsset(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    ownerKind: ownerKind ?? this.ownerKind,
    ownerId: ownerId ?? this.ownerId,
    localPath: localPath ?? this.localPath,
    kind: kind ?? this.kind,
    mime: mime ?? this.mime,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    sha256: sha256 ?? this.sha256,
    capturedAt: capturedAt ?? this.capturedAt,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    accuracyM: accuracyM.present ? accuracyM.value : this.accuracyM,
    headingDeg: headingDeg.present ? headingDeg.value : this.headingDeg,
    clientUploadId: clientUploadId ?? this.clientUploadId,
    uploadStatus: uploadStatus ?? this.uploadStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  MediaAsset copyWithCompanion(MediaAssetsCompanion data) {
    return MediaAsset(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      ownerKind: data.ownerKind.present ? data.ownerKind.value : this.ownerKind,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      kind: data.kind.present ? data.kind.value : this.kind,
      mime: data.mime.present ? data.mime.value : this.mime,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      accuracyM: data.accuracyM.present ? data.accuracyM.value : this.accuracyM,
      headingDeg: data.headingDeg.present
          ? data.headingDeg.value
          : this.headingDeg,
      clientUploadId: data.clientUploadId.present
          ? data.clientUploadId.value
          : this.clientUploadId,
      uploadStatus: data.uploadStatus.present
          ? data.uploadStatus.value
          : this.uploadStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaAsset(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('ownerKind: $ownerKind, ')
          ..write('ownerId: $ownerId, ')
          ..write('localPath: $localPath, ')
          ..write('kind: $kind, ')
          ..write('mime: $mime, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('clientUploadId: $clientUploadId, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    ownerKind,
    ownerId,
    localPath,
    kind,
    mime,
    sizeBytes,
    sha256,
    capturedAt,
    lat,
    lng,
    accuracyM,
    headingDeg,
    clientUploadId,
    uploadStatus,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaAsset &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.ownerKind == this.ownerKind &&
          other.ownerId == this.ownerId &&
          other.localPath == this.localPath &&
          other.kind == this.kind &&
          other.mime == this.mime &&
          other.sizeBytes == this.sizeBytes &&
          other.sha256 == this.sha256 &&
          other.capturedAt == this.capturedAt &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.accuracyM == this.accuracyM &&
          other.headingDeg == this.headingDeg &&
          other.clientUploadId == this.clientUploadId &&
          other.uploadStatus == this.uploadStatus &&
          other.createdAt == this.createdAt);
}

class MediaAssetsCompanion extends UpdateCompanion<MediaAsset> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> ownerKind;
  final Value<String> ownerId;
  final Value<String> localPath;
  final Value<String> kind;
  final Value<String> mime;
  final Value<int> sizeBytes;
  final Value<String> sha256;
  final Value<DateTime> capturedAt;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<double?> accuracyM;
  final Value<double?> headingDeg;
  final Value<String> clientUploadId;
  final Value<String> uploadStatus;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MediaAssetsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.ownerKind = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.kind = const Value.absent(),
    this.mime = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.headingDeg = const Value.absent(),
    this.clientUploadId = const Value.absent(),
    this.uploadStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaAssetsCompanion.insert({
    required String id,
    required String workspaceId,
    required String ownerKind,
    required String ownerId,
    required String localPath,
    this.kind = const Value.absent(),
    this.mime = const Value.absent(),
    required int sizeBytes,
    required String sha256,
    required DateTime capturedAt,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.headingDeg = const Value.absent(),
    required String clientUploadId,
    required String uploadStatus,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       ownerKind = Value(ownerKind),
       ownerId = Value(ownerId),
       localPath = Value(localPath),
       sizeBytes = Value(sizeBytes),
       sha256 = Value(sha256),
       capturedAt = Value(capturedAt),
       clientUploadId = Value(clientUploadId),
       uploadStatus = Value(uploadStatus),
       createdAt = Value(createdAt);
  static Insertable<MediaAsset> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? ownerKind,
    Expression<String>? ownerId,
    Expression<String>? localPath,
    Expression<String>? kind,
    Expression<String>? mime,
    Expression<int>? sizeBytes,
    Expression<String>? sha256,
    Expression<DateTime>? capturedAt,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<double>? accuracyM,
    Expression<double>? headingDeg,
    Expression<String>? clientUploadId,
    Expression<String>? uploadStatus,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (ownerKind != null) 'owner_kind': ownerKind,
      if (ownerId != null) 'owner_id': ownerId,
      if (localPath != null) 'local_path': localPath,
      if (kind != null) 'kind': kind,
      if (mime != null) 'mime': mime,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (sha256 != null) 'sha256': sha256,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracy_m': accuracyM,
      if (headingDeg != null) 'heading_deg': headingDeg,
      if (clientUploadId != null) 'client_upload_id': clientUploadId,
      if (uploadStatus != null) 'upload_status': uploadStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaAssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<String>? ownerKind,
    Value<String>? ownerId,
    Value<String>? localPath,
    Value<String>? kind,
    Value<String>? mime,
    Value<int>? sizeBytes,
    Value<String>? sha256,
    Value<DateTime>? capturedAt,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<double?>? accuracyM,
    Value<double?>? headingDeg,
    Value<String>? clientUploadId,
    Value<String>? uploadStatus,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MediaAssetsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      ownerKind: ownerKind ?? this.ownerKind,
      ownerId: ownerId ?? this.ownerId,
      localPath: localPath ?? this.localPath,
      kind: kind ?? this.kind,
      mime: mime ?? this.mime,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256: sha256 ?? this.sha256,
      capturedAt: capturedAt ?? this.capturedAt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      accuracyM: accuracyM ?? this.accuracyM,
      headingDeg: headingDeg ?? this.headingDeg,
      clientUploadId: clientUploadId ?? this.clientUploadId,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (ownerKind.present) {
      map['owner_kind'] = Variable<String>(ownerKind.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (accuracyM.present) {
      map['accuracy_m'] = Variable<double>(accuracyM.value);
    }
    if (headingDeg.present) {
      map['heading_deg'] = Variable<double>(headingDeg.value);
    }
    if (clientUploadId.present) {
      map['client_upload_id'] = Variable<String>(clientUploadId.value);
    }
    if (uploadStatus.present) {
      map['upload_status'] = Variable<String>(uploadStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaAssetsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('ownerKind: $ownerKind, ')
          ..write('ownerId: $ownerId, ')
          ..write('localPath: $localPath, ')
          ..write('kind: $kind, ')
          ..write('mime: $mime, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('clientUploadId: $clientUploadId, ')
          ..write('uploadStatus: $uploadStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionSessionsTable extends InspectionSessions
    with TableInfo<$InspectionSessionsTable, InspectionSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<String> fieldId = GeneratedColumn<String>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keptFramesMeta = const VerificationMeta(
    'keptFrames',
  );
  @override
  late final GeneratedColumn<int> keptFrames = GeneratedColumn<int>(
    'kept_frames',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _skippedFramesMeta = const VerificationMeta(
    'skippedFrames',
  );
  @override
  late final GeneratedColumn<int> skippedFrames = GeneratedColumn<int>(
    'skipped_frames',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    startedAt,
    endedAt,
    status,
    keptFrames,
    skippedFrames,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('kept_frames')) {
      context.handle(
        _keptFramesMeta,
        keptFrames.isAcceptableOrUnknown(data['kept_frames']!, _keptFramesMeta),
      );
    }
    if (data.containsKey('skipped_frames')) {
      context.handle(
        _skippedFramesMeta,
        skippedFrames.isAcceptableOrUnknown(
          data['skipped_frames']!,
          _skippedFramesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      keptFrames: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kept_frames'],
      )!,
      skippedFrames: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skipped_frames'],
      )!,
    );
  }

  @override
  $InspectionSessionsTable createAlias(String alias) {
    return $InspectionSessionsTable(attachedDatabase, alias);
  }
}

class InspectionSession extends DataClass
    implements Insertable<InspectionSession> {
  final String id;
  final String workspaceId;
  final int version;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? archivedAt;
  final String fieldId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  final int keptFrames;
  final int skippedFrames;
  const InspectionSession({
    required this.id,
    required this.workspaceId,
    required this.version,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.archivedAt,
    required this.fieldId,
    required this.startedAt,
    this.endedAt,
    required this.status,
    required this.keptFrames,
    required this.skippedFrames,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['field_id'] = Variable<String>(fieldId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    map['kept_frames'] = Variable<int>(keptFrames);
    map['skipped_frames'] = Variable<int>(skippedFrames);
    return map;
  }

  InspectionSessionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionSessionsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      fieldId: Value(fieldId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      keptFrames: Value(keptFrames),
      skippedFrames: Value(skippedFrames),
    );
  }

  factory InspectionSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionSession(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      fieldId: serializer.fromJson<String>(json['fieldId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
      keptFrames: serializer.fromJson<int>(json['keptFrames']),
      skippedFrames: serializer.fromJson<int>(json['skippedFrames']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'fieldId': serializer.toJson<String>(fieldId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
      'keptFrames': serializer.toJson<int>(keptFrames),
      'skippedFrames': serializer.toJson<int>(skippedFrames),
    };
  }

  InspectionSession copyWith({
    String? id,
    String? workspaceId,
    int? version,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? fieldId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
    int? keptFrames,
    int? skippedFrames,
  }) => InspectionSession(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    fieldId: fieldId ?? this.fieldId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    keptFrames: keptFrames ?? this.keptFrames,
    skippedFrames: skippedFrames ?? this.skippedFrames,
  );
  InspectionSession copyWithCompanion(InspectionSessionsCompanion data) {
    return InspectionSession(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      keptFrames: data.keptFrames.present
          ? data.keptFrames.value
          : this.keptFrames,
      skippedFrames: data.skippedFrames.present
          ? data.skippedFrames.value
          : this.skippedFrames,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionSession(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('keptFrames: $keptFrames, ')
          ..write('skippedFrames: $skippedFrames')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    version,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    archivedAt,
    fieldId,
    startedAt,
    endedAt,
    status,
    keptFrames,
    skippedFrames,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionSession &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.archivedAt == this.archivedAt &&
          other.fieldId == this.fieldId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.keptFrames == this.keptFrames &&
          other.skippedFrames == this.skippedFrames);
}

class InspectionSessionsCompanion extends UpdateCompanion<InspectionSession> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> archivedAt;
  final Value<String> fieldId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<int> keptFrames;
  final Value<int> skippedFrames;
  final Value<int> rowid;
  const InspectionSessionsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.keptFrames = const Value.absent(),
    this.skippedFrames = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionSessionsCompanion.insert({
    required String id,
    required String workspaceId,
    this.version = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.archivedAt = const Value.absent(),
    required String fieldId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required String status,
    this.keptFrames = const Value.absent(),
    this.skippedFrames = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy),
       fieldId = Value(fieldId),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<InspectionSession> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? archivedAt,
    Expression<String>? fieldId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<int>? keptFrames,
    Expression<int>? skippedFrames,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (fieldId != null) 'field_id': fieldId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (keptFrames != null) 'kept_frames': keptFrames,
      if (skippedFrames != null) 'skipped_frames': skippedFrames,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<int>? version,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? archivedAt,
    Value<String>? fieldId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<int>? keptFrames,
    Value<int>? skippedFrames,
    Value<int>? rowid,
  }) {
    return InspectionSessionsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      archivedAt: archivedAt ?? this.archivedAt,
      fieldId: fieldId ?? this.fieldId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      keptFrames: keptFrames ?? this.keptFrames,
      skippedFrames: skippedFrames ?? this.skippedFrames,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<String>(fieldId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (keptFrames.present) {
      map['kept_frames'] = Variable<int>(keptFrames.value);
    }
    if (skippedFrames.present) {
      map['skipped_frames'] = Variable<int>(skippedFrames.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionSessionsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('fieldId: $fieldId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('keptFrames: $keptFrames, ')
          ..write('skippedFrames: $skippedFrames, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InspectionFramesTable extends InspectionFrames
    with TableInfo<$InspectionFramesTable, InspectionFrame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionFramesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accuracyMMeta = const VerificationMeta(
    'accuracyM',
  );
  @override
  late final GeneratedColumn<double> accuracyM = GeneratedColumn<double>(
    'accuracy_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headingDegMeta = const VerificationMeta(
    'headingDeg',
  );
  @override
  late final GeneratedColumn<double> headingDeg = GeneratedColumn<double>(
    'heading_deg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _blurScoreMeta = const VerificationMeta(
    'blurScore',
  );
  @override
  late final GeneratedColumn<double> blurScore = GeneratedColumn<double>(
    'blur_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<String> quality = GeneratedColumn<String>(
    'quality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reshootTaskIdMeta = const VerificationMeta(
    'reshootTaskId',
  );
  @override
  late final GeneratedColumn<String> reshootTaskId = GeneratedColumn<String>(
    'reshoot_task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    sessionId,
    mediaId,
    capturedAt,
    lat,
    lng,
    accuracyM,
    headingDeg,
    blurScore,
    quality,
    reshootTaskId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_frames';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionFrame> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('accuracy_m')) {
      context.handle(
        _accuracyMMeta,
        accuracyM.isAcceptableOrUnknown(data['accuracy_m']!, _accuracyMMeta),
      );
    }
    if (data.containsKey('heading_deg')) {
      context.handle(
        _headingDegMeta,
        headingDeg.isAcceptableOrUnknown(data['heading_deg']!, _headingDegMeta),
      );
    }
    if (data.containsKey('blur_score')) {
      context.handle(
        _blurScoreMeta,
        blurScore.isAcceptableOrUnknown(data['blur_score']!, _blurScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_blurScoreMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('reshoot_task_id')) {
      context.handle(
        _reshootTaskIdMeta,
        reshootTaskId.isAcceptableOrUnknown(
          data['reshoot_task_id']!,
          _reshootTaskIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionFrame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionFrame(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      ),
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      accuracyM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_m'],
      ),
      headingDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading_deg'],
      ),
      blurScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}blur_score'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality'],
      )!,
      reshootTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reshoot_task_id'],
      ),
    );
  }

  @override
  $InspectionFramesTable createAlias(String alias) {
    return $InspectionFramesTable(attachedDatabase, alias);
  }
}

class InspectionFrame extends DataClass implements Insertable<InspectionFrame> {
  final String id;
  final String workspaceId;
  final String sessionId;
  final String? mediaId;
  final DateTime capturedAt;
  final double? lat;
  final double? lng;
  final double? accuracyM;
  final double? headingDeg;
  final double blurScore;
  final String quality;
  final String? reshootTaskId;
  const InspectionFrame({
    required this.id,
    required this.workspaceId,
    required this.sessionId,
    this.mediaId,
    required this.capturedAt,
    this.lat,
    this.lng,
    this.accuracyM,
    this.headingDeg,
    required this.blurScore,
    required this.quality,
    this.reshootTaskId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || mediaId != null) {
      map['media_id'] = Variable<String>(mediaId);
    }
    map['captured_at'] = Variable<DateTime>(capturedAt);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || accuracyM != null) {
      map['accuracy_m'] = Variable<double>(accuracyM);
    }
    if (!nullToAbsent || headingDeg != null) {
      map['heading_deg'] = Variable<double>(headingDeg);
    }
    map['blur_score'] = Variable<double>(blurScore);
    map['quality'] = Variable<String>(quality);
    if (!nullToAbsent || reshootTaskId != null) {
      map['reshoot_task_id'] = Variable<String>(reshootTaskId);
    }
    return map;
  }

  InspectionFramesCompanion toCompanion(bool nullToAbsent) {
    return InspectionFramesCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      sessionId: Value(sessionId),
      mediaId: mediaId == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaId),
      capturedAt: Value(capturedAt),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      accuracyM: accuracyM == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyM),
      headingDeg: headingDeg == null && nullToAbsent
          ? const Value.absent()
          : Value(headingDeg),
      blurScore: Value(blurScore),
      quality: Value(quality),
      reshootTaskId: reshootTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(reshootTaskId),
    );
  }

  factory InspectionFrame.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionFrame(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      mediaId: serializer.fromJson<String?>(json['mediaId']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      accuracyM: serializer.fromJson<double?>(json['accuracyM']),
      headingDeg: serializer.fromJson<double?>(json['headingDeg']),
      blurScore: serializer.fromJson<double>(json['blurScore']),
      quality: serializer.fromJson<String>(json['quality']),
      reshootTaskId: serializer.fromJson<String?>(json['reshootTaskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'sessionId': serializer.toJson<String>(sessionId),
      'mediaId': serializer.toJson<String?>(mediaId),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'accuracyM': serializer.toJson<double?>(accuracyM),
      'headingDeg': serializer.toJson<double?>(headingDeg),
      'blurScore': serializer.toJson<double>(blurScore),
      'quality': serializer.toJson<String>(quality),
      'reshootTaskId': serializer.toJson<String?>(reshootTaskId),
    };
  }

  InspectionFrame copyWith({
    String? id,
    String? workspaceId,
    String? sessionId,
    Value<String?> mediaId = const Value.absent(),
    DateTime? capturedAt,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<double?> accuracyM = const Value.absent(),
    Value<double?> headingDeg = const Value.absent(),
    double? blurScore,
    String? quality,
    Value<String?> reshootTaskId = const Value.absent(),
  }) => InspectionFrame(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    sessionId: sessionId ?? this.sessionId,
    mediaId: mediaId.present ? mediaId.value : this.mediaId,
    capturedAt: capturedAt ?? this.capturedAt,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    accuracyM: accuracyM.present ? accuracyM.value : this.accuracyM,
    headingDeg: headingDeg.present ? headingDeg.value : this.headingDeg,
    blurScore: blurScore ?? this.blurScore,
    quality: quality ?? this.quality,
    reshootTaskId: reshootTaskId.present
        ? reshootTaskId.value
        : this.reshootTaskId,
  );
  InspectionFrame copyWithCompanion(InspectionFramesCompanion data) {
    return InspectionFrame(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      accuracyM: data.accuracyM.present ? data.accuracyM.value : this.accuracyM,
      headingDeg: data.headingDeg.present
          ? data.headingDeg.value
          : this.headingDeg,
      blurScore: data.blurScore.present ? data.blurScore.value : this.blurScore,
      quality: data.quality.present ? data.quality.value : this.quality,
      reshootTaskId: data.reshootTaskId.present
          ? data.reshootTaskId.value
          : this.reshootTaskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionFrame(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('sessionId: $sessionId, ')
          ..write('mediaId: $mediaId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('blurScore: $blurScore, ')
          ..write('quality: $quality, ')
          ..write('reshootTaskId: $reshootTaskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    sessionId,
    mediaId,
    capturedAt,
    lat,
    lng,
    accuracyM,
    headingDeg,
    blurScore,
    quality,
    reshootTaskId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionFrame &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.sessionId == this.sessionId &&
          other.mediaId == this.mediaId &&
          other.capturedAt == this.capturedAt &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.accuracyM == this.accuracyM &&
          other.headingDeg == this.headingDeg &&
          other.blurScore == this.blurScore &&
          other.quality == this.quality &&
          other.reshootTaskId == this.reshootTaskId);
}

class InspectionFramesCompanion extends UpdateCompanion<InspectionFrame> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> sessionId;
  final Value<String?> mediaId;
  final Value<DateTime> capturedAt;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<double?> accuracyM;
  final Value<double?> headingDeg;
  final Value<double> blurScore;
  final Value<String> quality;
  final Value<String?> reshootTaskId;
  final Value<int> rowid;
  const InspectionFramesCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.headingDeg = const Value.absent(),
    this.blurScore = const Value.absent(),
    this.quality = const Value.absent(),
    this.reshootTaskId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionFramesCompanion.insert({
    required String id,
    required String workspaceId,
    required String sessionId,
    this.mediaId = const Value.absent(),
    required DateTime capturedAt,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.headingDeg = const Value.absent(),
    required double blurScore,
    required String quality,
    this.reshootTaskId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       sessionId = Value(sessionId),
       capturedAt = Value(capturedAt),
       blurScore = Value(blurScore),
       quality = Value(quality);
  static Insertable<InspectionFrame> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? sessionId,
    Expression<String>? mediaId,
    Expression<DateTime>? capturedAt,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<double>? accuracyM,
    Expression<double>? headingDeg,
    Expression<double>? blurScore,
    Expression<String>? quality,
    Expression<String>? reshootTaskId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (sessionId != null) 'session_id': sessionId,
      if (mediaId != null) 'media_id': mediaId,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracy_m': accuracyM,
      if (headingDeg != null) 'heading_deg': headingDeg,
      if (blurScore != null) 'blur_score': blurScore,
      if (quality != null) 'quality': quality,
      if (reshootTaskId != null) 'reshoot_task_id': reshootTaskId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionFramesCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<String>? sessionId,
    Value<String?>? mediaId,
    Value<DateTime>? capturedAt,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<double?>? accuracyM,
    Value<double?>? headingDeg,
    Value<double>? blurScore,
    Value<String>? quality,
    Value<String?>? reshootTaskId,
    Value<int>? rowid,
  }) {
    return InspectionFramesCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      sessionId: sessionId ?? this.sessionId,
      mediaId: mediaId ?? this.mediaId,
      capturedAt: capturedAt ?? this.capturedAt,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      accuracyM: accuracyM ?? this.accuracyM,
      headingDeg: headingDeg ?? this.headingDeg,
      blurScore: blurScore ?? this.blurScore,
      quality: quality ?? this.quality,
      reshootTaskId: reshootTaskId ?? this.reshootTaskId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (accuracyM.present) {
      map['accuracy_m'] = Variable<double>(accuracyM.value);
    }
    if (headingDeg.present) {
      map['heading_deg'] = Variable<double>(headingDeg.value);
    }
    if (blurScore.present) {
      map['blur_score'] = Variable<double>(blurScore.value);
    }
    if (quality.present) {
      map['quality'] = Variable<String>(quality.value);
    }
    if (reshootTaskId.present) {
      map['reshoot_task_id'] = Variable<String>(reshootTaskId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionFramesCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('sessionId: $sessionId, ')
          ..write('mediaId: $mediaId, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('blurScore: $blurScore, ')
          ..write('quality: $quality, ')
          ..write('reshootTaskId: $reshootTaskId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReshootTasksTable extends ReshootTasks
    with TableInfo<$ReshootTasksTable, ReshootTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReshootTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headingDegMeta = const VerificationMeta(
    'headingDeg',
  );
  @override
  late final GeneratedColumn<double> headingDeg = GeneratedColumn<double>(
    'heading_deg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workspaceId,
    sessionId,
    reason,
    description,
    headingDeg,
    lat,
    lng,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reshoot_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReshootTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('heading_deg')) {
      context.handle(
        _headingDegMeta,
        headingDeg.isAcceptableOrUnknown(data['heading_deg']!, _headingDegMeta),
      );
    } else if (isInserting) {
      context.missing(_headingDegMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReshootTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReshootTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      headingDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading_deg'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReshootTasksTable createAlias(String alias) {
    return $ReshootTasksTable(attachedDatabase, alias);
  }
}

class ReshootTask extends DataClass implements Insertable<ReshootTask> {
  final String id;
  final String workspaceId;
  final String sessionId;
  final String reason;
  final String description;
  final double headingDeg;
  final double? lat;
  final double? lng;
  final String status;
  final DateTime createdAt;
  const ReshootTask({
    required this.id,
    required this.workspaceId,
    required this.sessionId,
    required this.reason,
    required this.description,
    required this.headingDeg,
    this.lat,
    this.lng,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['session_id'] = Variable<String>(sessionId);
    map['reason'] = Variable<String>(reason);
    map['description'] = Variable<String>(description);
    map['heading_deg'] = Variable<double>(headingDeg);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReshootTasksCompanion toCompanion(bool nullToAbsent) {
    return ReshootTasksCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      sessionId: Value(sessionId),
      reason: Value(reason),
      description: Value(description),
      headingDeg: Value(headingDeg),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ReshootTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReshootTask(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      reason: serializer.fromJson<String>(json['reason']),
      description: serializer.fromJson<String>(json['description']),
      headingDeg: serializer.fromJson<double>(json['headingDeg']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'sessionId': serializer.toJson<String>(sessionId),
      'reason': serializer.toJson<String>(reason),
      'description': serializer.toJson<String>(description),
      'headingDeg': serializer.toJson<double>(headingDeg),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReshootTask copyWith({
    String? id,
    String? workspaceId,
    String? sessionId,
    String? reason,
    String? description,
    double? headingDeg,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    String? status,
    DateTime? createdAt,
  }) => ReshootTask(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    sessionId: sessionId ?? this.sessionId,
    reason: reason ?? this.reason,
    description: description ?? this.description,
    headingDeg: headingDeg ?? this.headingDeg,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ReshootTask copyWithCompanion(ReshootTasksCompanion data) {
    return ReshootTask(
      id: data.id.present ? data.id.value : this.id,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      reason: data.reason.present ? data.reason.value : this.reason,
      description: data.description.present
          ? data.description.value
          : this.description,
      headingDeg: data.headingDeg.present
          ? data.headingDeg.value
          : this.headingDeg,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReshootTask(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('sessionId: $sessionId, ')
          ..write('reason: $reason, ')
          ..write('description: $description, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workspaceId,
    sessionId,
    reason,
    description,
    headingDeg,
    lat,
    lng,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReshootTask &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.sessionId == this.sessionId &&
          other.reason == this.reason &&
          other.description == this.description &&
          other.headingDeg == this.headingDeg &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ReshootTasksCompanion extends UpdateCompanion<ReshootTask> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> sessionId;
  final Value<String> reason;
  final Value<String> description;
  final Value<double> headingDeg;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReshootTasksCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.reason = const Value.absent(),
    this.description = const Value.absent(),
    this.headingDeg = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReshootTasksCompanion.insert({
    required String id,
    required String workspaceId,
    required String sessionId,
    required String reason,
    required String description,
    required double headingDeg,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workspaceId = Value(workspaceId),
       sessionId = Value(sessionId),
       reason = Value(reason),
       description = Value(description),
       headingDeg = Value(headingDeg),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ReshootTask> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? sessionId,
    Expression<String>? reason,
    Expression<String>? description,
    Expression<double>? headingDeg,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (sessionId != null) 'session_id': sessionId,
      if (reason != null) 'reason': reason,
      if (description != null) 'description': description,
      if (headingDeg != null) 'heading_deg': headingDeg,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReshootTasksCompanion copyWith({
    Value<String>? id,
    Value<String>? workspaceId,
    Value<String>? sessionId,
    Value<String>? reason,
    Value<String>? description,
    Value<double>? headingDeg,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReshootTasksCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      sessionId: sessionId ?? this.sessionId,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      headingDeg: headingDeg ?? this.headingDeg,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (headingDeg.present) {
      map['heading_deg'] = Variable<double>(headingDeg.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReshootTasksCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('sessionId: $sessionId, ')
          ..write('reason: $reason, ')
          ..write('description: $description, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackPointsTable extends TrackPoints
    with TableInfo<$TrackPointsTable, TrackPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<String> trackId = GeneratedColumn<String>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMMeta = const VerificationMeta(
    'accuracyM',
  );
  @override
  late final GeneratedColumn<double> accuracyM = GeneratedColumn<double>(
    'accuracy_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [seq, trackId, lat, lng, accuracyM, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('accuracy_m')) {
      context.handle(
        _accuracyMMeta,
        accuracyM.isAcceptableOrUnknown(data['accuracy_m']!, _accuracyMMeta),
      );
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  TrackPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackPoint(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}track_id'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      accuracyM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_m'],
      ),
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $TrackPointsTable createAlias(String alias) {
    return $TrackPointsTable(attachedDatabase, alias);
  }
}

class TrackPoint extends DataClass implements Insertable<TrackPoint> {
  final int seq;
  final String trackId;
  final double lat;
  final double lng;
  final double? accuracyM;
  final DateTime at;
  const TrackPoint({
    required this.seq,
    required this.trackId,
    required this.lat,
    required this.lng,
    this.accuracyM,
    required this.at,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['track_id'] = Variable<String>(trackId);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    if (!nullToAbsent || accuracyM != null) {
      map['accuracy_m'] = Variable<double>(accuracyM);
    }
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  TrackPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackPointsCompanion(
      seq: Value(seq),
      trackId: Value(trackId),
      lat: Value(lat),
      lng: Value(lng),
      accuracyM: accuracyM == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracyM),
      at: Value(at),
    );
  }

  factory TrackPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackPoint(
      seq: serializer.fromJson<int>(json['seq']),
      trackId: serializer.fromJson<String>(json['trackId']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      accuracyM: serializer.fromJson<double?>(json['accuracyM']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'trackId': serializer.toJson<String>(trackId),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'accuracyM': serializer.toJson<double?>(accuracyM),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  TrackPoint copyWith({
    int? seq,
    String? trackId,
    double? lat,
    double? lng,
    Value<double?> accuracyM = const Value.absent(),
    DateTime? at,
  }) => TrackPoint(
    seq: seq ?? this.seq,
    trackId: trackId ?? this.trackId,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    accuracyM: accuracyM.present ? accuracyM.value : this.accuracyM,
    at: at ?? this.at,
  );
  TrackPoint copyWithCompanion(TrackPointsCompanion data) {
    return TrackPoint(
      seq: data.seq.present ? data.seq.value : this.seq,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      accuracyM: data.accuracyM.present ? data.accuracyM.value : this.accuracyM,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackPoint(')
          ..write('seq: $seq, ')
          ..write('trackId: $trackId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seq, trackId, lat, lng, accuracyM, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackPoint &&
          other.seq == this.seq &&
          other.trackId == this.trackId &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.accuracyM == this.accuracyM &&
          other.at == this.at);
}

class TrackPointsCompanion extends UpdateCompanion<TrackPoint> {
  final Value<int> seq;
  final Value<String> trackId;
  final Value<double> lat;
  final Value<double> lng;
  final Value<double?> accuracyM;
  final Value<DateTime> at;
  const TrackPointsCompanion({
    this.seq = const Value.absent(),
    this.trackId = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.accuracyM = const Value.absent(),
    this.at = const Value.absent(),
  });
  TrackPointsCompanion.insert({
    this.seq = const Value.absent(),
    required String trackId,
    required double lat,
    required double lng,
    this.accuracyM = const Value.absent(),
    required DateTime at,
  }) : trackId = Value(trackId),
       lat = Value(lat),
       lng = Value(lng),
       at = Value(at);
  static Insertable<TrackPoint> custom({
    Expression<int>? seq,
    Expression<String>? trackId,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<double>? accuracyM,
    Expression<DateTime>? at,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (trackId != null) 'track_id': trackId,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (accuracyM != null) 'accuracy_m': accuracyM,
      if (at != null) 'at': at,
    });
  }

  TrackPointsCompanion copyWith({
    Value<int>? seq,
    Value<String>? trackId,
    Value<double>? lat,
    Value<double>? lng,
    Value<double?>? accuracyM,
    Value<DateTime>? at,
  }) {
    return TrackPointsCompanion(
      seq: seq ?? this.seq,
      trackId: trackId ?? this.trackId,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      accuracyM: accuracyM ?? this.accuracyM,
      at: at ?? this.at,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<String>(trackId.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (accuracyM.present) {
      map['accuracy_m'] = Variable<double>(accuracyM.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointsCompanion(')
          ..write('seq: $seq, ')
          ..write('trackId: $trackId, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('accuracyM: $accuracyM, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }
}

class $OutboxTable extends Outbox with TableInfo<$OutboxTable, OutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workspaceIdMeta = const VerificationMeta(
    'workspaceId',
  );
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
    'workspace_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    workspaceId,
    entity,
    entityId,
    op,
    payloadJson,
    createdAt,
    status,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
        _workspaceIdMeta,
        workspaceId.isAcceptableOrUnknown(
          data['workspace_id']!,
          _workspaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workspaceIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxData(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      workspaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workspace_id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $OutboxTable createAlias(String alias) {
    return $OutboxTable(attachedDatabase, alias);
  }
}

class OutboxData extends DataClass implements Insertable<OutboxData> {
  final int seq;
  final String workspaceId;
  final String entity;
  final String entityId;
  final String op;
  final String payloadJson;
  final DateTime createdAt;
  final String status;
  final int attempts;
  final String? lastError;
  const OutboxData({
    required this.seq,
    required this.workspaceId,
    required this.entity,
    required this.entityId,
    required this.op,
    required this.payloadJson,
    required this.createdAt,
    required this.status,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  OutboxCompanion toCompanion(bool nullToAbsent) {
    return OutboxCompanion(
      seq: Value(seq),
      workspaceId: Value(workspaceId),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory OutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxData(
      seq: serializer.fromJson<int>(json['seq']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  OutboxData copyWith({
    int? seq,
    String? workspaceId,
    String? entity,
    String? entityId,
    String? op,
    String? payloadJson,
    DateTime? createdAt,
    String? status,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => OutboxData(
    seq: seq ?? this.seq,
    workspaceId: workspaceId ?? this.workspaceId,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  OutboxData copyWithCompanion(OutboxCompanion data) {
    return OutboxData(
      seq: data.seq.present ? data.seq.value : this.seq,
      workspaceId: data.workspaceId.present
          ? data.workspaceId.value
          : this.workspaceId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxData(')
          ..write('seq: $seq, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    workspaceId,
    entity,
    entityId,
    op,
    payloadJson,
    createdAt,
    status,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxData &&
          other.seq == this.seq &&
          other.workspaceId == this.workspaceId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class OutboxCompanion extends UpdateCompanion<OutboxData> {
  final Value<int> seq;
  final Value<String> workspaceId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  const OutboxCompanion({
    this.seq = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  OutboxCompanion.insert({
    this.seq = const Value.absent(),
    required String workspaceId,
    required String entity,
    required String entityId,
    required String op,
    required String payloadJson,
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : workspaceId = Value(workspaceId),
       entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<OutboxData> custom({
    Expression<int>? seq,
    Expression<String>? workspaceId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
    });
  }

  OutboxCompanion copyWith({
    Value<int>? seq,
    Value<String>? workspaceId,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? attempts,
    Value<String?>? lastError,
  }) {
    return OutboxCompanion(
      seq: seq ?? this.seq,
      workspaceId: workspaceId ?? this.workspaceId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxCompanion(')
          ..write('seq: $seq, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $WorkspacesTable workspaces = $WorkspacesTable(this);
  late final $MembershipsTable memberships = $MembershipsTable(this);
  late final $FieldsTable fields = $FieldsTable(this);
  late final $FieldBoundaryVersionsTable fieldBoundaryVersions =
      $FieldBoundaryVersionsTable(this);
  late final $LandParcelsTable landParcels = $LandParcelsTable(this);
  late final $FieldParcelsTable fieldParcels = $FieldParcelsTable(this);
  late final $LandRelationsTable landRelations = $LandRelationsTable(this);
  late final $CropSeasonsTable cropSeasons = $CropSeasonsTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $AssignmentsTable assignments = $AssignmentsTable(this);
  late final $AssignmentEventsTable assignmentEvents = $AssignmentEventsTable(
    this,
  );
  late final $WorkReportsTable workReports = $WorkReportsTable(this);
  late final $WorkRecordsTable workRecords = $WorkRecordsTable(this);
  late final $WorkRecordInputsTable workRecordInputs = $WorkRecordInputsTable(
    this,
  );
  late final $RecordRevisionsTable recordRevisions = $RecordRevisionsTable(
    this,
  );
  late final $MediaAssetsTable mediaAssets = $MediaAssetsTable(this);
  late final $InspectionSessionsTable inspectionSessions =
      $InspectionSessionsTable(this);
  late final $InspectionFramesTable inspectionFrames = $InspectionFramesTable(
    this,
  );
  late final $ReshootTasksTable reshootTasks = $ReshootTasksTable(this);
  late final $TrackPointsTable trackPoints = $TrackPointsTable(this);
  late final $OutboxTable outbox = $OutboxTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    workspaces,
    memberships,
    fields,
    fieldBoundaryVersions,
    landParcels,
    fieldParcels,
    landRelations,
    cropSeasons,
    contacts,
    tasks,
    assignments,
    assignmentEvents,
    workReports,
    workRecords,
    workRecordInputs,
    recordRevisions,
    mediaAssets,
    inspectionSessions,
    inspectionFrames,
    reshootTasks,
    trackPoints,
    outbox,
    settings,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  required String displayName,
  Value<String> identityKind,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> displayName,
  Value<String> identityKind,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityKind => $composableBuilder(
    column: $table.identityKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityKind => $composableBuilder(
    column: $table.identityKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identityKind => $composableBuilder(
    column: $table.identityKind,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> identityKind = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                displayName: displayName,
                identityKind: identityKind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                Value<String> identityKind = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                identityKind: identityKind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$WorkspacesTableCreateCompanionBuilder = WorkspacesCompanion Function({
  required String id,
  required String name,
  required DateTime createdAt,
  required String createdBy,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$WorkspacesTableUpdateCompanionBuilder = WorkspacesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

class $$WorkspacesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkspacesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkspacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkspacesTable> {
  $$WorkspacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$WorkspacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkspacesTable,
          Workspace,
          $$WorkspacesTableFilterComposer,
          $$WorkspacesTableOrderingComposer,
          $$WorkspacesTableAnnotationComposer,
          $$WorkspacesTableCreateCompanionBuilder,
          $$WorkspacesTableUpdateCompanionBuilder,
          (
            Workspace,
            BaseReferences<_$AppDatabase, $WorkspacesTable, Workspace>,
          ),
          Workspace,
          PrefetchHooks Function()
        > {
  $$WorkspacesTableTableManager(_$AppDatabase db, $WorkspacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkspacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkspacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkspacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                createdBy: createdBy,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                required String createdBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkspacesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                createdBy: createdBy,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkspacesTable, Workspace>(table),
                  BaseReferences<_$AppDatabase, $WorkspacesTable, Workspace>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkspacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkspacesTable,
      Workspace,
      $$WorkspacesTableFilterComposer,
      $$WorkspacesTableOrderingComposer,
      $$WorkspacesTableAnnotationComposer,
      $$WorkspacesTableCreateCompanionBuilder,
      $$WorkspacesTableUpdateCompanionBuilder,
      (Workspace, BaseReferences<_$AppDatabase, $WorkspacesTable, Workspace>),
      Workspace,
      PrefetchHooks Function()
    >;
typedef $$MembershipsTableCreateCompanionBuilder =
    MembershipsCompanion Function({
      required String workspaceId,
      required String userId,
      required String role,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$MembershipsTableUpdateCompanionBuilder =
    MembershipsCompanion Function({
      Value<String> workspaceId,
      Value<String> userId,
      Value<String> role,
      Value<String> status,
      Value<int> rowid,
    });

class $$MembershipsTableFilterComposer
    extends Composer<_$AppDatabase, $MembershipsTable> {
  $$MembershipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MembershipsTableOrderingComposer
    extends Composer<_$AppDatabase, $MembershipsTable> {
  $$MembershipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembershipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembershipsTable> {
  $$MembershipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$MembershipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembershipsTable,
          Membership,
          $$MembershipsTableFilterComposer,
          $$MembershipsTableOrderingComposer,
          $$MembershipsTableAnnotationComposer,
          $$MembershipsTableCreateCompanionBuilder,
          $$MembershipsTableUpdateCompanionBuilder,
          (
            Membership,
            BaseReferences<_$AppDatabase, $MembershipsTable, Membership>,
          ),
          Membership,
          PrefetchHooks Function()
        > {
  $$MembershipsTableTableManager(_$AppDatabase db, $MembershipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembershipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembershipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembershipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> workspaceId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembershipsCompanion(
                workspaceId: workspaceId,
                userId: userId,
                role: role,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workspaceId,
                required String userId,
                required String role,
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembershipsCompanion.insert(
                workspaceId: workspaceId,
                userId: userId,
                role: role,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MembershipsTable, Membership>(table),
                  BaseReferences<_$AppDatabase, $MembershipsTable, Membership>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MembershipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembershipsTable,
      Membership,
      $$MembershipsTableFilterComposer,
      $$MembershipsTableOrderingComposer,
      $$MembershipsTableAnnotationComposer,
      $$MembershipsTableCreateCompanionBuilder,
      $$MembershipsTableUpdateCompanionBuilder,
      (
        Membership,
        BaseReferences<_$AppDatabase, $MembershipsTable, Membership>,
      ),
      Membership,
      PrefetchHooks Function()
    >;
typedef $$FieldsTableCreateCompanionBuilder = FieldsCompanion Function({
  required String id,
  required String workspaceId,
  Value<int> version,
  required DateTime createdAt,
  required String createdBy,
  required DateTime updatedAt,
  required String updatedBy,
  Value<DateTime?> archivedAt,
  required String name,
  Value<String> aliases,
  Value<double?> areaM2,
  Value<String?> areaMethod,
  Value<String> notes,
  Value<int> rowid,
});
typedef $$FieldsTableUpdateCompanionBuilder = FieldsCompanion Function({
  Value<String> id,
  Value<String> workspaceId,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<DateTime> updatedAt,
  Value<String> updatedBy,
  Value<DateTime?> archivedAt,
  Value<String> name,
  Value<String> aliases,
  Value<double?> areaM2,
  Value<String?> areaMethod,
  Value<String> notes,
  Value<int> rowid,
});

class $$FieldsTableFilterComposer
    extends Composer<_$AppDatabase, $FieldsTable> {
  $$FieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get areaMethod => $composableBuilder(
    column: $table.areaMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $FieldsTable> {
  $$FieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get areaMethod => $composableBuilder(
    column: $table.areaMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FieldsTable> {
  $$FieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<String> get areaMethod => $composableBuilder(
    column: $table.areaMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$FieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FieldsTable,
          Field,
          $$FieldsTableFilterComposer,
          $$FieldsTableOrderingComposer,
          $$FieldsTableAnnotationComposer,
          $$FieldsTableCreateCompanionBuilder,
          $$FieldsTableUpdateCompanionBuilder,
          (Field, BaseReferences<_$AppDatabase, $FieldsTable, Field>),
          Field,
          PrefetchHooks Function()
        > {
  $$FieldsTableTableManager(_$AppDatabase db, $FieldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FieldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> aliases = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<String?> areaMethod = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FieldsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                name: name,
                aliases: aliases,
                areaM2: areaM2,
                areaMethod: areaMethod,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String name,
                Value<String> aliases = const Value.absent(),
                Value<double?> areaM2 = const Value.absent(),
                Value<String?> areaMethod = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FieldsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                name: name,
                aliases: aliases,
                areaM2: areaM2,
                areaMethod: areaMethod,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FieldsTable, Field>(table),
                  BaseReferences<_$AppDatabase, $FieldsTable, Field>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FieldsTable,
      Field,
      $$FieldsTableFilterComposer,
      $$FieldsTableOrderingComposer,
      $$FieldsTableAnnotationComposer,
      $$FieldsTableCreateCompanionBuilder,
      $$FieldsTableUpdateCompanionBuilder,
      (Field, BaseReferences<_$AppDatabase, $FieldsTable, Field>),
      Field,
      PrefetchHooks Function()
    >;
typedef $$FieldBoundaryVersionsTableCreateCompanionBuilder =
    FieldBoundaryVersionsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String fieldId,
      required String pointsJson,
      required String source,
      Value<double?> medianAccuracyM,
      required double areaM2,
      required String status,
      Value<int> rowid,
    });
typedef $$FieldBoundaryVersionsTableUpdateCompanionBuilder =
    FieldBoundaryVersionsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> fieldId,
      Value<String> pointsJson,
      Value<String> source,
      Value<double?> medianAccuracyM,
      Value<double> areaM2,
      Value<String> status,
      Value<int> rowid,
    });

class $$FieldBoundaryVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $FieldBoundaryVersionsTable> {
  $$FieldBoundaryVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get medianAccuracyM => $composableBuilder(
    column: $table.medianAccuracyM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FieldBoundaryVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FieldBoundaryVersionsTable> {
  $$FieldBoundaryVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get medianAccuracyM => $composableBuilder(
    column: $table.medianAccuracyM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get areaM2 => $composableBuilder(
    column: $table.areaM2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FieldBoundaryVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FieldBoundaryVersionsTable> {
  $$FieldBoundaryVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get pointsJson => $composableBuilder(
    column: $table.pointsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get medianAccuracyM => $composableBuilder(
    column: $table.medianAccuracyM,
    builder: (column) => column,
  );

  GeneratedColumn<double> get areaM2 =>
      $composableBuilder(column: $table.areaM2, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$FieldBoundaryVersionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FieldBoundaryVersionsTable,
          FieldBoundaryVersion,
          $$FieldBoundaryVersionsTableFilterComposer,
          $$FieldBoundaryVersionsTableOrderingComposer,
          $$FieldBoundaryVersionsTableAnnotationComposer,
          $$FieldBoundaryVersionsTableCreateCompanionBuilder,
          $$FieldBoundaryVersionsTableUpdateCompanionBuilder,
          (
            FieldBoundaryVersion,
            BaseReferences<
              _$AppDatabase,
              $FieldBoundaryVersionsTable,
              FieldBoundaryVersion
            >,
          ),
          FieldBoundaryVersion,
          PrefetchHooks Function()
        > {
  $$FieldBoundaryVersionsTableTableManager(
    _$AppDatabase db,
    $FieldBoundaryVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FieldBoundaryVersionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FieldBoundaryVersionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FieldBoundaryVersionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<String> pointsJson = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<double?> medianAccuracyM = const Value.absent(),
                Value<double> areaM2 = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FieldBoundaryVersionsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                pointsJson: pointsJson,
                source: source,
                medianAccuracyM: medianAccuracyM,
                areaM2: areaM2,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String fieldId,
                required String pointsJson,
                required String source,
                Value<double?> medianAccuracyM = const Value.absent(),
                required double areaM2,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => FieldBoundaryVersionsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                pointsJson: pointsJson,
                source: source,
                medianAccuracyM: medianAccuracyM,
                areaM2: areaM2,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $FieldBoundaryVersionsTable,
                    FieldBoundaryVersion
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FieldBoundaryVersionsTable,
                    FieldBoundaryVersion
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FieldBoundaryVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FieldBoundaryVersionsTable,
      FieldBoundaryVersion,
      $$FieldBoundaryVersionsTableFilterComposer,
      $$FieldBoundaryVersionsTableOrderingComposer,
      $$FieldBoundaryVersionsTableAnnotationComposer,
      $$FieldBoundaryVersionsTableCreateCompanionBuilder,
      $$FieldBoundaryVersionsTableUpdateCompanionBuilder,
      (
        FieldBoundaryVersion,
        BaseReferences<
          _$AppDatabase,
          $FieldBoundaryVersionsTable,
          FieldBoundaryVersion
        >,
      ),
      FieldBoundaryVersion,
      PrefetchHooks Function()
    >;
typedef $$LandParcelsTableCreateCompanionBuilder =
    LandParcelsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String parcelCode,
      Value<String> notes,
      Value<int> rowid,
    });
typedef $$LandParcelsTableUpdateCompanionBuilder =
    LandParcelsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> parcelCode,
      Value<String> notes,
      Value<int> rowid,
    });

class $$LandParcelsTableFilterComposer
    extends Composer<_$AppDatabase, $LandParcelsTable> {
  $$LandParcelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelCode => $composableBuilder(
    column: $table.parcelCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LandParcelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LandParcelsTable> {
  $$LandParcelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelCode => $composableBuilder(
    column: $table.parcelCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LandParcelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LandParcelsTable> {
  $$LandParcelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parcelCode => $composableBuilder(
    column: $table.parcelCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$LandParcelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LandParcelsTable,
          LandParcel,
          $$LandParcelsTableFilterComposer,
          $$LandParcelsTableOrderingComposer,
          $$LandParcelsTableAnnotationComposer,
          $$LandParcelsTableCreateCompanionBuilder,
          $$LandParcelsTableUpdateCompanionBuilder,
          (
            LandParcel,
            BaseReferences<_$AppDatabase, $LandParcelsTable, LandParcel>,
          ),
          LandParcel,
          PrefetchHooks Function()
        > {
  $$LandParcelsTableTableManager(_$AppDatabase db, $LandParcelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LandParcelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LandParcelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LandParcelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> parcelCode = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LandParcelsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                parcelCode: parcelCode,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String parcelCode,
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LandParcelsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                parcelCode: parcelCode,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LandParcelsTable, LandParcel>(table),
                  BaseReferences<_$AppDatabase, $LandParcelsTable, LandParcel>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LandParcelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LandParcelsTable,
      LandParcel,
      $$LandParcelsTableFilterComposer,
      $$LandParcelsTableOrderingComposer,
      $$LandParcelsTableAnnotationComposer,
      $$LandParcelsTableCreateCompanionBuilder,
      $$LandParcelsTableUpdateCompanionBuilder,
      (
        LandParcel,
        BaseReferences<_$AppDatabase, $LandParcelsTable, LandParcel>,
      ),
      LandParcel,
      PrefetchHooks Function()
    >;
typedef $$FieldParcelsTableCreateCompanionBuilder =
    FieldParcelsCompanion Function({
      required String workspaceId,
      required String fieldId,
      required String parcelId,
      Value<int> rowid,
    });
typedef $$FieldParcelsTableUpdateCompanionBuilder =
    FieldParcelsCompanion Function({
      Value<String> workspaceId,
      Value<String> fieldId,
      Value<String> parcelId,
      Value<int> rowid,
    });

class $$FieldParcelsTableFilterComposer
    extends Composer<_$AppDatabase, $FieldParcelsTable> {
  $$FieldParcelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FieldParcelsTableOrderingComposer
    extends Composer<_$AppDatabase, $FieldParcelsTable> {
  $$FieldParcelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FieldParcelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FieldParcelsTable> {
  $$FieldParcelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get parcelId =>
      $composableBuilder(column: $table.parcelId, builder: (column) => column);
}

class $$FieldParcelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FieldParcelsTable,
          FieldParcel,
          $$FieldParcelsTableFilterComposer,
          $$FieldParcelsTableOrderingComposer,
          $$FieldParcelsTableAnnotationComposer,
          $$FieldParcelsTableCreateCompanionBuilder,
          $$FieldParcelsTableUpdateCompanionBuilder,
          (
            FieldParcel,
            BaseReferences<_$AppDatabase, $FieldParcelsTable, FieldParcel>,
          ),
          FieldParcel,
          PrefetchHooks Function()
        > {
  $$FieldParcelsTableTableManager(_$AppDatabase db, $FieldParcelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FieldParcelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FieldParcelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FieldParcelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> workspaceId = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<String> parcelId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FieldParcelsCompanion(
                workspaceId: workspaceId,
                fieldId: fieldId,
                parcelId: parcelId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String workspaceId,
                required String fieldId,
                required String parcelId,
                Value<int> rowid = const Value.absent(),
              }) => FieldParcelsCompanion.insert(
                workspaceId: workspaceId,
                fieldId: fieldId,
                parcelId: parcelId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FieldParcelsTable, FieldParcel>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FieldParcelsTable,
                    FieldParcel
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FieldParcelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FieldParcelsTable,
      FieldParcel,
      $$FieldParcelsTableFilterComposer,
      $$FieldParcelsTableOrderingComposer,
      $$FieldParcelsTableAnnotationComposer,
      $$FieldParcelsTableCreateCompanionBuilder,
      $$FieldParcelsTableUpdateCompanionBuilder,
      (
        FieldParcel,
        BaseReferences<_$AppDatabase, $FieldParcelsTable, FieldParcel>,
      ),
      FieldParcel,
      PrefetchHooks Function()
    >;
typedef $$LandRelationsTableCreateCompanionBuilder =
    LandRelationsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String parcelId,
      required String partyName,
      required String kind,
      Value<String> share,
      Value<DateTime?> periodStart,
      Value<DateTime?> periodEnd,
      Value<String?> rentAmount,
      Value<String> verification,
      Value<int> rowid,
    });
typedef $$LandRelationsTableUpdateCompanionBuilder =
    LandRelationsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> parcelId,
      Value<String> partyName,
      Value<String> kind,
      Value<String> share,
      Value<DateTime?> periodStart,
      Value<DateTime?> periodEnd,
      Value<String?> rentAmount,
      Value<String> verification,
      Value<int> rowid,
    });

class $$LandRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $LandRelationsTable> {
  $$LandRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get share => $composableBuilder(
    column: $table.share,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rentAmount => $composableBuilder(
    column: $table.rentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verification => $composableBuilder(
    column: $table.verification,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LandRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LandRelationsTable> {
  $$LandRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parcelId => $composableBuilder(
    column: $table.parcelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partyName => $composableBuilder(
    column: $table.partyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get share => $composableBuilder(
    column: $table.share,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodEnd => $composableBuilder(
    column: $table.periodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rentAmount => $composableBuilder(
    column: $table.rentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verification => $composableBuilder(
    column: $table.verification,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LandRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LandRelationsTable> {
  $$LandRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parcelId =>
      $composableBuilder(column: $table.parcelId, builder: (column) => column);

  GeneratedColumn<String> get partyName =>
      $composableBuilder(column: $table.partyName, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get share =>
      $composableBuilder(column: $table.share, builder: (column) => column);

  GeneratedColumn<DateTime> get periodStart => $composableBuilder(
    column: $table.periodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodEnd =>
      $composableBuilder(column: $table.periodEnd, builder: (column) => column);

  GeneratedColumn<String> get rentAmount => $composableBuilder(
    column: $table.rentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verification => $composableBuilder(
    column: $table.verification,
    builder: (column) => column,
  );
}

class $$LandRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LandRelationsTable,
          LandRelation,
          $$LandRelationsTableFilterComposer,
          $$LandRelationsTableOrderingComposer,
          $$LandRelationsTableAnnotationComposer,
          $$LandRelationsTableCreateCompanionBuilder,
          $$LandRelationsTableUpdateCompanionBuilder,
          (
            LandRelation,
            BaseReferences<_$AppDatabase, $LandRelationsTable, LandRelation>,
          ),
          LandRelation,
          PrefetchHooks Function()
        > {
  $$LandRelationsTableTableManager(_$AppDatabase db, $LandRelationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LandRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LandRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LandRelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> parcelId = const Value.absent(),
                Value<String> partyName = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> share = const Value.absent(),
                Value<DateTime?> periodStart = const Value.absent(),
                Value<DateTime?> periodEnd = const Value.absent(),
                Value<String?> rentAmount = const Value.absent(),
                Value<String> verification = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LandRelationsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                parcelId: parcelId,
                partyName: partyName,
                kind: kind,
                share: share,
                periodStart: periodStart,
                periodEnd: periodEnd,
                rentAmount: rentAmount,
                verification: verification,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String parcelId,
                required String partyName,
                required String kind,
                Value<String> share = const Value.absent(),
                Value<DateTime?> periodStart = const Value.absent(),
                Value<DateTime?> periodEnd = const Value.absent(),
                Value<String?> rentAmount = const Value.absent(),
                Value<String> verification = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LandRelationsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                parcelId: parcelId,
                partyName: partyName,
                kind: kind,
                share: share,
                periodStart: periodStart,
                periodEnd: periodEnd,
                rentAmount: rentAmount,
                verification: verification,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LandRelationsTable, LandRelation>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LandRelationsTable,
                    LandRelation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LandRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LandRelationsTable,
      LandRelation,
      $$LandRelationsTableFilterComposer,
      $$LandRelationsTableOrderingComposer,
      $$LandRelationsTableAnnotationComposer,
      $$LandRelationsTableCreateCompanionBuilder,
      $$LandRelationsTableUpdateCompanionBuilder,
      (
        LandRelation,
        BaseReferences<_$AppDatabase, $LandRelationsTable, LandRelation>,
      ),
      LandRelation,
      PrefetchHooks Function()
    >;
typedef $$CropSeasonsTableCreateCompanionBuilder =
    CropSeasonsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String fieldId,
      required String name,
      required String cropName,
      Value<String> variety,
      required String status,
      Value<DateTime?> plannedStart,
      Value<DateTime?> actualStart,
      Value<DateTime?> plannedEnd,
      Value<DateTime?> actualEnd,
      Value<int> rowid,
    });
typedef $$CropSeasonsTableUpdateCompanionBuilder =
    CropSeasonsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> fieldId,
      Value<String> name,
      Value<String> cropName,
      Value<String> variety,
      Value<String> status,
      Value<DateTime?> plannedStart,
      Value<DateTime?> actualStart,
      Value<DateTime?> plannedEnd,
      Value<DateTime?> actualEnd,
      Value<int> rowid,
    });

class $$CropSeasonsTableFilterComposer
    extends Composer<_$AppDatabase, $CropSeasonsTable> {
  $$CropSeasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cropName => $composableBuilder(
    column: $table.cropName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variety => $composableBuilder(
    column: $table.variety,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedStart => $composableBuilder(
    column: $table.plannedStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedEnd => $composableBuilder(
    column: $table.plannedEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CropSeasonsTableOrderingComposer
    extends Composer<_$AppDatabase, $CropSeasonsTable> {
  $$CropSeasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cropName => $composableBuilder(
    column: $table.cropName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variety => $composableBuilder(
    column: $table.variety,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedStart => $composableBuilder(
    column: $table.plannedStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedEnd => $composableBuilder(
    column: $table.plannedEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CropSeasonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CropSeasonsTable> {
  $$CropSeasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get cropName =>
      $composableBuilder(column: $table.cropName, builder: (column) => column);

  GeneratedColumn<String> get variety =>
      $composableBuilder(column: $table.variety, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedStart => $composableBuilder(
    column: $table.plannedStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get plannedEnd => $composableBuilder(
    column: $table.plannedEnd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualEnd =>
      $composableBuilder(column: $table.actualEnd, builder: (column) => column);
}

class $$CropSeasonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CropSeasonsTable,
          CropSeason,
          $$CropSeasonsTableFilterComposer,
          $$CropSeasonsTableOrderingComposer,
          $$CropSeasonsTableAnnotationComposer,
          $$CropSeasonsTableCreateCompanionBuilder,
          $$CropSeasonsTableUpdateCompanionBuilder,
          (
            CropSeason,
            BaseReferences<_$AppDatabase, $CropSeasonsTable, CropSeason>,
          ),
          CropSeason,
          PrefetchHooks Function()
        > {
  $$CropSeasonsTableTableManager(_$AppDatabase db, $CropSeasonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CropSeasonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CropSeasonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CropSeasonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> cropName = const Value.absent(),
                Value<String> variety = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> plannedStart = const Value.absent(),
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> plannedEnd = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CropSeasonsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                name: name,
                cropName: cropName,
                variety: variety,
                status: status,
                plannedStart: plannedStart,
                actualStart: actualStart,
                plannedEnd: plannedEnd,
                actualEnd: actualEnd,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String fieldId,
                required String name,
                required String cropName,
                Value<String> variety = const Value.absent(),
                required String status,
                Value<DateTime?> plannedStart = const Value.absent(),
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> plannedEnd = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CropSeasonsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                name: name,
                cropName: cropName,
                variety: variety,
                status: status,
                plannedStart: plannedStart,
                actualStart: actualStart,
                plannedEnd: plannedEnd,
                actualEnd: actualEnd,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CropSeasonsTable, CropSeason>(table),
                  BaseReferences<_$AppDatabase, $CropSeasonsTable, CropSeason>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CropSeasonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CropSeasonsTable,
      CropSeason,
      $$CropSeasonsTableFilterComposer,
      $$CropSeasonsTableOrderingComposer,
      $$CropSeasonsTableAnnotationComposer,
      $$CropSeasonsTableCreateCompanionBuilder,
      $$CropSeasonsTableUpdateCompanionBuilder,
      (
        CropSeason,
        BaseReferences<_$AppDatabase, $CropSeasonsTable, CropSeason>,
      ),
      CropSeason,
      PrefetchHooks Function()
    >;
typedef $$ContactsTableCreateCompanionBuilder = ContactsCompanion Function({
  required String id,
  required String workspaceId,
  Value<int> version,
  required DateTime createdAt,
  required String createdBy,
  required DateTime updatedAt,
  required String updatedBy,
  Value<DateTime?> archivedAt,
  required String name,
  Value<String> nickname,
  Value<String> phone,
  Value<String> preferredChannel,
  Value<String> workConstraints,
  Value<String> notes,
  Value<String?> linkedUserId,
  Value<int> rowid,
});
typedef $$ContactsTableUpdateCompanionBuilder = ContactsCompanion Function({
  Value<String> id,
  Value<String> workspaceId,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<DateTime> updatedAt,
  Value<String> updatedBy,
  Value<DateTime?> archivedAt,
  Value<String> name,
  Value<String> nickname,
  Value<String> phone,
  Value<String> preferredChannel,
  Value<String> workConstraints,
  Value<String> notes,
  Value<String?> linkedUserId,
  Value<int> rowid,
});

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredChannel => $composableBuilder(
    column: $table.preferredChannel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workConstraints => $composableBuilder(
    column: $table.workConstraints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedUserId => $composableBuilder(
    column: $table.linkedUserId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredChannel => $composableBuilder(
    column: $table.preferredChannel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workConstraints => $composableBuilder(
    column: $table.workConstraints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedUserId => $composableBuilder(
    column: $table.linkedUserId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get preferredChannel => $composableBuilder(
    column: $table.preferredChannel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workConstraints => $composableBuilder(
    column: $table.workConstraints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get linkedUserId => $composableBuilder(
    column: $table.linkedUserId,
    builder: (column) => column,
  );
}

class $$ContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContactsTable,
          Contact,
          $$ContactsTableFilterComposer,
          $$ContactsTableOrderingComposer,
          $$ContactsTableAnnotationComposer,
          $$ContactsTableCreateCompanionBuilder,
          $$ContactsTableUpdateCompanionBuilder,
          (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
          Contact,
          PrefetchHooks Function()
        > {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> preferredChannel = const Value.absent(),
                Value<String> workConstraints = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> linkedUserId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                name: name,
                nickname: nickname,
                phone: phone,
                preferredChannel: preferredChannel,
                workConstraints: workConstraints,
                notes: notes,
                linkedUserId: linkedUserId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String name,
                Value<String> nickname = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> preferredChannel = const Value.absent(),
                Value<String> workConstraints = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> linkedUserId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContactsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                name: name,
                nickname: nickname,
                phone: phone,
                preferredChannel: preferredChannel,
                workConstraints: workConstraints,
                notes: notes,
                linkedUserId: linkedUserId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContactsTable, Contact>(table),
                  BaseReferences<_$AppDatabase, $ContactsTable, Contact>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContactsTable,
      Contact,
      $$ContactsTableFilterComposer,
      $$ContactsTableOrderingComposer,
      $$ContactsTableAnnotationComposer,
      $$ContactsTableCreateCompanionBuilder,
      $$ContactsTableUpdateCompanionBuilder,
      (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
      Contact,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  required String workspaceId,
  Value<int> version,
  required DateTime createdAt,
  required String createdBy,
  required DateTime updatedAt,
  required String updatedBy,
  Value<DateTime?> archivedAt,
  required String fieldId,
  Value<String?> seasonId,
  required String title,
  required String workType,
  required String status,
  Value<DateTime?> plannedStart,
  Value<DateTime?> plannedEnd,
  Value<DateTime?> meetAt,
  Value<String> meetPlace,
  Value<int> headcountNeeded,
  Value<String> notes,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> workspaceId,
  Value<int> version,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<DateTime> updatedAt,
  Value<String> updatedBy,
  Value<DateTime?> archivedAt,
  Value<String> fieldId,
  Value<String?> seasonId,
  Value<String> title,
  Value<String> workType,
  Value<String> status,
  Value<DateTime?> plannedStart,
  Value<DateTime?> plannedEnd,
  Value<DateTime?> meetAt,
  Value<String> meetPlace,
  Value<int> headcountNeeded,
  Value<String> notes,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seasonId => $composableBuilder(
    column: $table.seasonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workType => $composableBuilder(
    column: $table.workType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedStart => $composableBuilder(
    column: $table.plannedStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedEnd => $composableBuilder(
    column: $table.plannedEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get meetAt => $composableBuilder(
    column: $table.meetAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meetPlace => $composableBuilder(
    column: $table.meetPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get headcountNeeded => $composableBuilder(
    column: $table.headcountNeeded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seasonId => $composableBuilder(
    column: $table.seasonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workType => $composableBuilder(
    column: $table.workType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedStart => $composableBuilder(
    column: $table.plannedStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedEnd => $composableBuilder(
    column: $table.plannedEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get meetAt => $composableBuilder(
    column: $table.meetAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meetPlace => $composableBuilder(
    column: $table.meetPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get headcountNeeded => $composableBuilder(
    column: $table.headcountNeeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get seasonId =>
      $composableBuilder(column: $table.seasonId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get workType =>
      $composableBuilder(column: $table.workType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedStart => $composableBuilder(
    column: $table.plannedStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get plannedEnd => $composableBuilder(
    column: $table.plannedEnd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get meetAt =>
      $composableBuilder(column: $table.meetAt, builder: (column) => column);

  GeneratedColumn<String> get meetPlace =>
      $composableBuilder(column: $table.meetPlace, builder: (column) => column);

  GeneratedColumn<int> get headcountNeeded => $composableBuilder(
    column: $table.headcountNeeded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<String?> seasonId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> workType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> plannedStart = const Value.absent(),
                Value<DateTime?> plannedEnd = const Value.absent(),
                Value<DateTime?> meetAt = const Value.absent(),
                Value<String> meetPlace = const Value.absent(),
                Value<int> headcountNeeded = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                seasonId: seasonId,
                title: title,
                workType: workType,
                status: status,
                plannedStart: plannedStart,
                plannedEnd: plannedEnd,
                meetAt: meetAt,
                meetPlace: meetPlace,
                headcountNeeded: headcountNeeded,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String fieldId,
                Value<String?> seasonId = const Value.absent(),
                required String title,
                required String workType,
                required String status,
                Value<DateTime?> plannedStart = const Value.absent(),
                Value<DateTime?> plannedEnd = const Value.absent(),
                Value<DateTime?> meetAt = const Value.absent(),
                Value<String> meetPlace = const Value.absent(),
                Value<int> headcountNeeded = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                seasonId: seasonId,
                title: title,
                workType: workType,
                status: status,
                plannedStart: plannedStart,
                plannedEnd: plannedEnd,
                meetAt: meetAt,
                meetPlace: meetPlace,
                headcountNeeded: headcountNeeded,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  BaseReferences<_$AppDatabase, $TasksTable, Task>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$AssignmentsTableCreateCompanionBuilder =
    AssignmentsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String taskId,
      required String contactId,
      Value<String> role,
      required String status,
      Value<String?> wageRateSnapshot,
      Value<int> rowid,
    });
typedef $$AssignmentsTableUpdateCompanionBuilder =
    AssignmentsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> taskId,
      Value<String> contactId,
      Value<String> role,
      Value<String> status,
      Value<String?> wageRateSnapshot,
      Value<int> rowid,
    });

class $$AssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AssignmentsTable> {
  $$AssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wageRateSnapshot => $composableBuilder(
    column: $table.wageRateSnapshot,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssignmentsTable> {
  $$AssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactId => $composableBuilder(
    column: $table.contactId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wageRateSnapshot => $composableBuilder(
    column: $table.wageRateSnapshot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssignmentsTable> {
  $$AssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get contactId =>
      $composableBuilder(column: $table.contactId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get wageRateSnapshot => $composableBuilder(
    column: $table.wageRateSnapshot,
    builder: (column) => column,
  );
}

class $$AssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssignmentsTable,
          Assignment,
          $$AssignmentsTableFilterComposer,
          $$AssignmentsTableOrderingComposer,
          $$AssignmentsTableAnnotationComposer,
          $$AssignmentsTableCreateCompanionBuilder,
          $$AssignmentsTableUpdateCompanionBuilder,
          (
            Assignment,
            BaseReferences<_$AppDatabase, $AssignmentsTable, Assignment>,
          ),
          Assignment,
          PrefetchHooks Function()
        > {
  $$AssignmentsTableTableManager(_$AppDatabase db, $AssignmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssignmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> contactId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> wageRateSnapshot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssignmentsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                taskId: taskId,
                contactId: contactId,
                role: role,
                status: status,
                wageRateSnapshot: wageRateSnapshot,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String taskId,
                required String contactId,
                Value<String> role = const Value.absent(),
                required String status,
                Value<String?> wageRateSnapshot = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssignmentsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                taskId: taskId,
                contactId: contactId,
                role: role,
                status: status,
                wageRateSnapshot: wageRateSnapshot,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssignmentsTable, Assignment>(table),
                  BaseReferences<_$AppDatabase, $AssignmentsTable, Assignment>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssignmentsTable,
      Assignment,
      $$AssignmentsTableFilterComposer,
      $$AssignmentsTableOrderingComposer,
      $$AssignmentsTableAnnotationComposer,
      $$AssignmentsTableCreateCompanionBuilder,
      $$AssignmentsTableUpdateCompanionBuilder,
      (
        Assignment,
        BaseReferences<_$AppDatabase, $AssignmentsTable, Assignment>,
      ),
      Assignment,
      PrefetchHooks Function()
    >;
typedef $$AssignmentEventsTableCreateCompanionBuilder =
    AssignmentEventsCompanion Function({
      required String id,
      required String workspaceId,
      required String assignmentId,
      required String action,
      required String fromStatus,
      required String toStatus,
      Value<String> channel,
      Value<String> note,
      required DateTime at,
      required String by,
      Value<int> rowid,
    });
typedef $$AssignmentEventsTableUpdateCompanionBuilder =
    AssignmentEventsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<String> assignmentId,
      Value<String> action,
      Value<String> fromStatus,
      Value<String> toStatus,
      Value<String> channel,
      Value<String> note,
      Value<DateTime> at,
      Value<String> by,
      Value<int> rowid,
    });

class $$AssignmentEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AssignmentEventsTable> {
  $$AssignmentEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get by => $composableBuilder(
    column: $table.by,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssignmentEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssignmentEventsTable> {
  $$AssignmentEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get by => $composableBuilder(
    column: $table.by,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssignmentEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssignmentEventsTable> {
  $$AssignmentEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assignmentId => $composableBuilder(
    column: $table.assignmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get by =>
      $composableBuilder(column: $table.by, builder: (column) => column);
}

class $$AssignmentEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssignmentEventsTable,
          AssignmentEvent,
          $$AssignmentEventsTableFilterComposer,
          $$AssignmentEventsTableOrderingComposer,
          $$AssignmentEventsTableAnnotationComposer,
          $$AssignmentEventsTableCreateCompanionBuilder,
          $$AssignmentEventsTableUpdateCompanionBuilder,
          (
            AssignmentEvent,
            BaseReferences<
              _$AppDatabase,
              $AssignmentEventsTable,
              AssignmentEvent
            >,
          ),
          AssignmentEvent,
          PrefetchHooks Function()
        > {
  $$AssignmentEventsTableTableManager(
    _$AppDatabase db,
    $AssignmentEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssignmentEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssignmentEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssignmentEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<String> assignmentId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> fromStatus = const Value.absent(),
                Value<String> toStatus = const Value.absent(),
                Value<String> channel = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> by = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssignmentEventsCompanion(
                id: id,
                workspaceId: workspaceId,
                assignmentId: assignmentId,
                action: action,
                fromStatus: fromStatus,
                toStatus: toStatus,
                channel: channel,
                note: note,
                at: at,
                by: by,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                required String assignmentId,
                required String action,
                required String fromStatus,
                required String toStatus,
                Value<String> channel = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime at,
                required String by,
                Value<int> rowid = const Value.absent(),
              }) => AssignmentEventsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                assignmentId: assignmentId,
                action: action,
                fromStatus: fromStatus,
                toStatus: toStatus,
                channel: channel,
                note: note,
                at: at,
                by: by,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssignmentEventsTable, AssignmentEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AssignmentEventsTable,
                    AssignmentEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssignmentEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssignmentEventsTable,
      AssignmentEvent,
      $$AssignmentEventsTableFilterComposer,
      $$AssignmentEventsTableOrderingComposer,
      $$AssignmentEventsTableAnnotationComposer,
      $$AssignmentEventsTableCreateCompanionBuilder,
      $$AssignmentEventsTableUpdateCompanionBuilder,
      (
        AssignmentEvent,
        BaseReferences<_$AppDatabase, $AssignmentEventsTable, AssignmentEvent>,
      ),
      AssignmentEvent,
      PrefetchHooks Function()
    >;
typedef $$WorkReportsTableCreateCompanionBuilder =
    WorkReportsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      Value<String?> taskId,
      required String fieldId,
      Value<String> reportedByKind,
      required String reporterName,
      Value<DateTime?> actualStart,
      Value<DateTime?> actualEnd,
      Value<String> rawText,
      Value<String> rawQuantityText,
      Value<String> pesticideClaim,
      required String status,
      Value<String> reviewNote,
      Value<DateTime?> submittedAt,
      Value<int> rowid,
    });
typedef $$WorkReportsTableUpdateCompanionBuilder =
    WorkReportsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String?> taskId,
      Value<String> fieldId,
      Value<String> reportedByKind,
      Value<String> reporterName,
      Value<DateTime?> actualStart,
      Value<DateTime?> actualEnd,
      Value<String> rawText,
      Value<String> rawQuantityText,
      Value<String> pesticideClaim,
      Value<String> status,
      Value<String> reviewNote,
      Value<DateTime?> submittedAt,
      Value<int> rowid,
    });

class $$WorkReportsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkReportsTable> {
  $$WorkReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportedByKind => $composableBuilder(
    column: $table.reportedByKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reporterName => $composableBuilder(
    column: $table.reporterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawQuantityText => $composableBuilder(
    column: $table.rawQuantityText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pesticideClaim => $composableBuilder(
    column: $table.pesticideClaim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkReportsTable> {
  $$WorkReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportedByKind => $composableBuilder(
    column: $table.reportedByKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reporterName => $composableBuilder(
    column: $table.reporterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualEnd => $composableBuilder(
    column: $table.actualEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawQuantityText => $composableBuilder(
    column: $table.rawQuantityText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pesticideClaim => $composableBuilder(
    column: $table.pesticideClaim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkReportsTable> {
  $$WorkReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get reportedByKind => $composableBuilder(
    column: $table.reportedByKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reporterName => $composableBuilder(
    column: $table.reporterName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualStart => $composableBuilder(
    column: $table.actualStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualEnd =>
      $composableBuilder(column: $table.actualEnd, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<String> get rawQuantityText => $composableBuilder(
    column: $table.rawQuantityText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pesticideClaim => $composableBuilder(
    column: $table.pesticideClaim,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reviewNote => $composableBuilder(
    column: $table.reviewNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );
}

class $$WorkReportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkReportsTable,
          WorkReport,
          $$WorkReportsTableFilterComposer,
          $$WorkReportsTableOrderingComposer,
          $$WorkReportsTableAnnotationComposer,
          $$WorkReportsTableCreateCompanionBuilder,
          $$WorkReportsTableUpdateCompanionBuilder,
          (
            WorkReport,
            BaseReferences<_$AppDatabase, $WorkReportsTable, WorkReport>,
          ),
          WorkReport,
          PrefetchHooks Function()
        > {
  $$WorkReportsTableTableManager(_$AppDatabase db, $WorkReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<String> reportedByKind = const Value.absent(),
                Value<String> reporterName = const Value.absent(),
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<String> rawQuantityText = const Value.absent(),
                Value<String> pesticideClaim = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> reviewNote = const Value.absent(),
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkReportsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                taskId: taskId,
                fieldId: fieldId,
                reportedByKind: reportedByKind,
                reporterName: reporterName,
                actualStart: actualStart,
                actualEnd: actualEnd,
                rawText: rawText,
                rawQuantityText: rawQuantityText,
                pesticideClaim: pesticideClaim,
                status: status,
                reviewNote: reviewNote,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                required String fieldId,
                Value<String> reportedByKind = const Value.absent(),
                required String reporterName,
                Value<DateTime?> actualStart = const Value.absent(),
                Value<DateTime?> actualEnd = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<String> rawQuantityText = const Value.absent(),
                Value<String> pesticideClaim = const Value.absent(),
                required String status,
                Value<String> reviewNote = const Value.absent(),
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkReportsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                taskId: taskId,
                fieldId: fieldId,
                reportedByKind: reportedByKind,
                reporterName: reporterName,
                actualStart: actualStart,
                actualEnd: actualEnd,
                rawText: rawText,
                rawQuantityText: rawQuantityText,
                pesticideClaim: pesticideClaim,
                status: status,
                reviewNote: reviewNote,
                submittedAt: submittedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkReportsTable, WorkReport>(table),
                  BaseReferences<_$AppDatabase, $WorkReportsTable, WorkReport>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkReportsTable,
      WorkReport,
      $$WorkReportsTableFilterComposer,
      $$WorkReportsTableOrderingComposer,
      $$WorkReportsTableAnnotationComposer,
      $$WorkReportsTableCreateCompanionBuilder,
      $$WorkReportsTableUpdateCompanionBuilder,
      (
        WorkReport,
        BaseReferences<_$AppDatabase, $WorkReportsTable, WorkReport>,
      ),
      WorkReport,
      PrefetchHooks Function()
    >;
typedef $$WorkRecordsTableCreateCompanionBuilder =
    WorkRecordsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String reportId,
      required String fieldId,
      Value<String?> seasonId,
      required String workType,
      required DateTime performedOn,
      required String summary,
      required String pesticideStatus,
      required String status,
      required String confirmedBy,
      required DateTime confirmedAt,
      Value<int> rowid,
    });
typedef $$WorkRecordsTableUpdateCompanionBuilder =
    WorkRecordsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> reportId,
      Value<String> fieldId,
      Value<String?> seasonId,
      Value<String> workType,
      Value<DateTime> performedOn,
      Value<String> summary,
      Value<String> pesticideStatus,
      Value<String> status,
      Value<String> confirmedBy,
      Value<DateTime> confirmedAt,
      Value<int> rowid,
    });

class $$WorkRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seasonId => $composableBuilder(
    column: $table.seasonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workType => $composableBuilder(
    column: $table.workType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performedOn => $composableBuilder(
    column: $table.performedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pesticideStatus => $composableBuilder(
    column: $table.pesticideStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedBy => $composableBuilder(
    column: $table.confirmedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seasonId => $composableBuilder(
    column: $table.seasonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workType => $composableBuilder(
    column: $table.workType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedOn => $composableBuilder(
    column: $table.performedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pesticideStatus => $composableBuilder(
    column: $table.pesticideStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedBy => $composableBuilder(
    column: $table.confirmedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportId =>
      $composableBuilder(column: $table.reportId, builder: (column) => column);

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<String> get seasonId =>
      $composableBuilder(column: $table.seasonId, builder: (column) => column);

  GeneratedColumn<String> get workType =>
      $composableBuilder(column: $table.workType, builder: (column) => column);

  GeneratedColumn<DateTime> get performedOn => $composableBuilder(
    column: $table.performedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get pesticideStatus => $composableBuilder(
    column: $table.pesticideStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get confirmedBy => $composableBuilder(
    column: $table.confirmedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );
}

class $$WorkRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkRecordsTable,
          WorkRecord,
          $$WorkRecordsTableFilterComposer,
          $$WorkRecordsTableOrderingComposer,
          $$WorkRecordsTableAnnotationComposer,
          $$WorkRecordsTableCreateCompanionBuilder,
          $$WorkRecordsTableUpdateCompanionBuilder,
          (
            WorkRecord,
            BaseReferences<_$AppDatabase, $WorkRecordsTable, WorkRecord>,
          ),
          WorkRecord,
          PrefetchHooks Function()
        > {
  $$WorkRecordsTableTableManager(_$AppDatabase db, $WorkRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> reportId = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<String?> seasonId = const Value.absent(),
                Value<String> workType = const Value.absent(),
                Value<DateTime> performedOn = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> pesticideStatus = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> confirmedBy = const Value.absent(),
                Value<DateTime> confirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                reportId: reportId,
                fieldId: fieldId,
                seasonId: seasonId,
                workType: workType,
                performedOn: performedOn,
                summary: summary,
                pesticideStatus: pesticideStatus,
                status: status,
                confirmedBy: confirmedBy,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String reportId,
                required String fieldId,
                Value<String?> seasonId = const Value.absent(),
                required String workType,
                required DateTime performedOn,
                required String summary,
                required String pesticideStatus,
                required String status,
                required String confirmedBy,
                required DateTime confirmedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                reportId: reportId,
                fieldId: fieldId,
                seasonId: seasonId,
                workType: workType,
                performedOn: performedOn,
                summary: summary,
                pesticideStatus: pesticideStatus,
                status: status,
                confirmedBy: confirmedBy,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkRecordsTable, WorkRecord>(table),
                  BaseReferences<_$AppDatabase, $WorkRecordsTable, WorkRecord>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkRecordsTable,
      WorkRecord,
      $$WorkRecordsTableFilterComposer,
      $$WorkRecordsTableOrderingComposer,
      $$WorkRecordsTableAnnotationComposer,
      $$WorkRecordsTableCreateCompanionBuilder,
      $$WorkRecordsTableUpdateCompanionBuilder,
      (
        WorkRecord,
        BaseReferences<_$AppDatabase, $WorkRecordsTable, WorkRecord>,
      ),
      WorkRecord,
      PrefetchHooks Function()
    >;
typedef $$WorkRecordInputsTableCreateCompanionBuilder =
    WorkRecordInputsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String recordId,
      Value<String> productName,
      required String rawQuantityText,
      Value<String?> quantity,
      Value<String?> unitCode,
      Value<String> conversionBasis,
      required String status,
      Value<int> rowid,
    });
typedef $$WorkRecordInputsTableUpdateCompanionBuilder =
    WorkRecordInputsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> recordId,
      Value<String> productName,
      Value<String> rawQuantityText,
      Value<String?> quantity,
      Value<String?> unitCode,
      Value<String> conversionBasis,
      Value<String> status,
      Value<int> rowid,
    });

class $$WorkRecordInputsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkRecordInputsTable> {
  $$WorkRecordInputsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawQuantityText => $composableBuilder(
    column: $table.rawQuantityText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitCode => $composableBuilder(
    column: $table.unitCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversionBasis => $composableBuilder(
    column: $table.conversionBasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkRecordInputsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkRecordInputsTable> {
  $$WorkRecordInputsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawQuantityText => $composableBuilder(
    column: $table.rawQuantityText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitCode => $composableBuilder(
    column: $table.unitCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversionBasis => $composableBuilder(
    column: $table.conversionBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkRecordInputsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkRecordInputsTable> {
  $$WorkRecordInputsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawQuantityText => $composableBuilder(
    column: $table.rawQuantityText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unitCode =>
      $composableBuilder(column: $table.unitCode, builder: (column) => column);

  GeneratedColumn<String> get conversionBasis => $composableBuilder(
    column: $table.conversionBasis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$WorkRecordInputsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkRecordInputsTable,
          WorkRecordInput,
          $$WorkRecordInputsTableFilterComposer,
          $$WorkRecordInputsTableOrderingComposer,
          $$WorkRecordInputsTableAnnotationComposer,
          $$WorkRecordInputsTableCreateCompanionBuilder,
          $$WorkRecordInputsTableUpdateCompanionBuilder,
          (
            WorkRecordInput,
            BaseReferences<
              _$AppDatabase,
              $WorkRecordInputsTable,
              WorkRecordInput
            >,
          ),
          WorkRecordInput,
          PrefetchHooks Function()
        > {
  $$WorkRecordInputsTableTableManager(
    _$AppDatabase db,
    $WorkRecordInputsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkRecordInputsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkRecordInputsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkRecordInputsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> rawQuantityText = const Value.absent(),
                Value<String?> quantity = const Value.absent(),
                Value<String?> unitCode = const Value.absent(),
                Value<String> conversionBasis = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordInputsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                recordId: recordId,
                productName: productName,
                rawQuantityText: rawQuantityText,
                quantity: quantity,
                unitCode: unitCode,
                conversionBasis: conversionBasis,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String recordId,
                Value<String> productName = const Value.absent(),
                required String rawQuantityText,
                Value<String?> quantity = const Value.absent(),
                Value<String?> unitCode = const Value.absent(),
                Value<String> conversionBasis = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordInputsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                recordId: recordId,
                productName: productName,
                rawQuantityText: rawQuantityText,
                quantity: quantity,
                unitCode: unitCode,
                conversionBasis: conversionBasis,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkRecordInputsTable, WorkRecordInput>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WorkRecordInputsTable,
                    WorkRecordInput
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkRecordInputsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkRecordInputsTable,
      WorkRecordInput,
      $$WorkRecordInputsTableFilterComposer,
      $$WorkRecordInputsTableOrderingComposer,
      $$WorkRecordInputsTableAnnotationComposer,
      $$WorkRecordInputsTableCreateCompanionBuilder,
      $$WorkRecordInputsTableUpdateCompanionBuilder,
      (
        WorkRecordInput,
        BaseReferences<_$AppDatabase, $WorkRecordInputsTable, WorkRecordInput>,
      ),
      WorkRecordInput,
      PrefetchHooks Function()
    >;
typedef $$RecordRevisionsTableCreateCompanionBuilder =
    RecordRevisionsCompanion Function({
      required String id,
      required String workspaceId,
      required String recordId,
      required String beforeJson,
      required String afterJson,
      required String reason,
      required String by,
      required DateTime at,
      Value<int> rowid,
    });
typedef $$RecordRevisionsTableUpdateCompanionBuilder =
    RecordRevisionsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<String> recordId,
      Value<String> beforeJson,
      Value<String> afterJson,
      Value<String> reason,
      Value<String> by,
      Value<DateTime> at,
      Value<int> rowid,
    });

class $$RecordRevisionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordRevisionsTable> {
  $$RecordRevisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get by => $composableBuilder(
    column: $table.by,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordRevisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordRevisionsTable> {
  $$RecordRevisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get by => $composableBuilder(
    column: $table.by,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordRevisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordRevisionsTable> {
  $$RecordRevisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afterJson =>
      $composableBuilder(column: $table.afterJson, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get by =>
      $composableBuilder(column: $table.by, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$RecordRevisionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordRevisionsTable,
          RecordRevision,
          $$RecordRevisionsTableFilterComposer,
          $$RecordRevisionsTableOrderingComposer,
          $$RecordRevisionsTableAnnotationComposer,
          $$RecordRevisionsTableCreateCompanionBuilder,
          $$RecordRevisionsTableUpdateCompanionBuilder,
          (
            RecordRevision,
            BaseReferences<
              _$AppDatabase,
              $RecordRevisionsTable,
              RecordRevision
            >,
          ),
          RecordRevision,
          PrefetchHooks Function()
        > {
  $$RecordRevisionsTableTableManager(
    _$AppDatabase db,
    $RecordRevisionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordRevisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordRevisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordRevisionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> beforeJson = const Value.absent(),
                Value<String> afterJson = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> by = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordRevisionsCompanion(
                id: id,
                workspaceId: workspaceId,
                recordId: recordId,
                beforeJson: beforeJson,
                afterJson: afterJson,
                reason: reason,
                by: by,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                required String recordId,
                required String beforeJson,
                required String afterJson,
                required String reason,
                required String by,
                required DateTime at,
                Value<int> rowid = const Value.absent(),
              }) => RecordRevisionsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                recordId: recordId,
                beforeJson: beforeJson,
                afterJson: afterJson,
                reason: reason,
                by: by,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordRevisionsTable, RecordRevision>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecordRevisionsTable,
                    RecordRevision
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordRevisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordRevisionsTable,
      RecordRevision,
      $$RecordRevisionsTableFilterComposer,
      $$RecordRevisionsTableOrderingComposer,
      $$RecordRevisionsTableAnnotationComposer,
      $$RecordRevisionsTableCreateCompanionBuilder,
      $$RecordRevisionsTableUpdateCompanionBuilder,
      (
        RecordRevision,
        BaseReferences<_$AppDatabase, $RecordRevisionsTable, RecordRevision>,
      ),
      RecordRevision,
      PrefetchHooks Function()
    >;
typedef $$MediaAssetsTableCreateCompanionBuilder =
    MediaAssetsCompanion Function({
      required String id,
      required String workspaceId,
      required String ownerKind,
      required String ownerId,
      required String localPath,
      Value<String> kind,
      Value<String> mime,
      required int sizeBytes,
      required String sha256,
      required DateTime capturedAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<double?> accuracyM,
      Value<double?> headingDeg,
      required String clientUploadId,
      required String uploadStatus,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MediaAssetsTableUpdateCompanionBuilder =
    MediaAssetsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<String> ownerKind,
      Value<String> ownerId,
      Value<String> localPath,
      Value<String> kind,
      Value<String> mime,
      Value<int> sizeBytes,
      Value<String> sha256,
      Value<DateTime> capturedAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<double?> accuracyM,
      Value<double?> headingDeg,
      Value<String> clientUploadId,
      Value<String> uploadStatus,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MediaAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerKind => $composableBuilder(
    column: $table.ownerKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUploadId => $composableBuilder(
    column: $table.clientUploadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerKind => $composableBuilder(
    column: $table.ownerKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUploadId => $composableBuilder(
    column: $table.clientUploadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaAssetsTable> {
  $$MediaAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerKind =>
      $composableBuilder(column: $table.ownerKind, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get mime =>
      $composableBuilder(column: $table.mime, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<double> get accuracyM =>
      $composableBuilder(column: $table.accuracyM, builder: (column) => column);

  GeneratedColumn<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientUploadId => $composableBuilder(
    column: $table.clientUploadId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get uploadStatus => $composableBuilder(
    column: $table.uploadStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MediaAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaAssetsTable,
          MediaAsset,
          $$MediaAssetsTableFilterComposer,
          $$MediaAssetsTableOrderingComposer,
          $$MediaAssetsTableAnnotationComposer,
          $$MediaAssetsTableCreateCompanionBuilder,
          $$MediaAssetsTableUpdateCompanionBuilder,
          (
            MediaAsset,
            BaseReferences<_$AppDatabase, $MediaAssetsTable, MediaAsset>,
          ),
          MediaAsset,
          PrefetchHooks Function()
        > {
  $$MediaAssetsTableTableManager(_$AppDatabase db, $MediaAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<String> ownerKind = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> mime = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> accuracyM = const Value.absent(),
                Value<double?> headingDeg = const Value.absent(),
                Value<String> clientUploadId = const Value.absent(),
                Value<String> uploadStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion(
                id: id,
                workspaceId: workspaceId,
                ownerKind: ownerKind,
                ownerId: ownerId,
                localPath: localPath,
                kind: kind,
                mime: mime,
                sizeBytes: sizeBytes,
                sha256: sha256,
                capturedAt: capturedAt,
                lat: lat,
                lng: lng,
                accuracyM: accuracyM,
                headingDeg: headingDeg,
                clientUploadId: clientUploadId,
                uploadStatus: uploadStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                required String ownerKind,
                required String ownerId,
                required String localPath,
                Value<String> kind = const Value.absent(),
                Value<String> mime = const Value.absent(),
                required int sizeBytes,
                required String sha256,
                required DateTime capturedAt,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> accuracyM = const Value.absent(),
                Value<double?> headingDeg = const Value.absent(),
                required String clientUploadId,
                required String uploadStatus,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                ownerKind: ownerKind,
                ownerId: ownerId,
                localPath: localPath,
                kind: kind,
                mime: mime,
                sizeBytes: sizeBytes,
                sha256: sha256,
                capturedAt: capturedAt,
                lat: lat,
                lng: lng,
                accuracyM: accuracyM,
                headingDeg: headingDeg,
                clientUploadId: clientUploadId,
                uploadStatus: uploadStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaAssetsTable, MediaAsset>(table),
                  BaseReferences<_$AppDatabase, $MediaAssetsTable, MediaAsset>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaAssetsTable,
      MediaAsset,
      $$MediaAssetsTableFilterComposer,
      $$MediaAssetsTableOrderingComposer,
      $$MediaAssetsTableAnnotationComposer,
      $$MediaAssetsTableCreateCompanionBuilder,
      $$MediaAssetsTableUpdateCompanionBuilder,
      (
        MediaAsset,
        BaseReferences<_$AppDatabase, $MediaAssetsTable, MediaAsset>,
      ),
      MediaAsset,
      PrefetchHooks Function()
    >;
typedef $$InspectionSessionsTableCreateCompanionBuilder =
    InspectionSessionsCompanion Function({
      required String id,
      required String workspaceId,
      Value<int> version,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> archivedAt,
      required String fieldId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required String status,
      Value<int> keptFrames,
      Value<int> skippedFrames,
      Value<int> rowid,
    });
typedef $$InspectionSessionsTableUpdateCompanionBuilder =
    InspectionSessionsCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<int> version,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> archivedAt,
      Value<String> fieldId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<int> keptFrames,
      Value<int> skippedFrames,
      Value<int> rowid,
    });

class $$InspectionSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionSessionsTable> {
  $$InspectionSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get keptFrames => $composableBuilder(
    column: $table.keptFrames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skippedFrames => $composableBuilder(
    column: $table.skippedFrames,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionSessionsTable> {
  $$InspectionSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldId => $composableBuilder(
    column: $table.fieldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get keptFrames => $composableBuilder(
    column: $table.keptFrames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skippedFrames => $composableBuilder(
    column: $table.skippedFrames,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionSessionsTable> {
  $$InspectionSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldId =>
      $composableBuilder(column: $table.fieldId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get keptFrames => $composableBuilder(
    column: $table.keptFrames,
    builder: (column) => column,
  );

  GeneratedColumn<int> get skippedFrames => $composableBuilder(
    column: $table.skippedFrames,
    builder: (column) => column,
  );
}

class $$InspectionSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionSessionsTable,
          InspectionSession,
          $$InspectionSessionsTableFilterComposer,
          $$InspectionSessionsTableOrderingComposer,
          $$InspectionSessionsTableAnnotationComposer,
          $$InspectionSessionsTableCreateCompanionBuilder,
          $$InspectionSessionsTableUpdateCompanionBuilder,
          (
            InspectionSession,
            BaseReferences<
              _$AppDatabase,
              $InspectionSessionsTable,
              InspectionSession
            >,
          ),
          InspectionSession,
          PrefetchHooks Function()
        > {
  $$InspectionSessionsTableTableManager(
    _$AppDatabase db,
    $InspectionSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> fieldId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> keptFrames = const Value.absent(),
                Value<int> skippedFrames = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionSessionsCompanion(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                keptFrames: keptFrames,
                skippedFrames: skippedFrames,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                Value<int> version = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> archivedAt = const Value.absent(),
                required String fieldId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required String status,
                Value<int> keptFrames = const Value.absent(),
                Value<int> skippedFrames = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionSessionsCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                version: version,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                archivedAt: archivedAt,
                fieldId: fieldId,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                keptFrames: keptFrames,
                skippedFrames: skippedFrames,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionSessionsTable, InspectionSession>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InspectionSessionsTable,
                    InspectionSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionSessionsTable,
      InspectionSession,
      $$InspectionSessionsTableFilterComposer,
      $$InspectionSessionsTableOrderingComposer,
      $$InspectionSessionsTableAnnotationComposer,
      $$InspectionSessionsTableCreateCompanionBuilder,
      $$InspectionSessionsTableUpdateCompanionBuilder,
      (
        InspectionSession,
        BaseReferences<
          _$AppDatabase,
          $InspectionSessionsTable,
          InspectionSession
        >,
      ),
      InspectionSession,
      PrefetchHooks Function()
    >;
typedef $$InspectionFramesTableCreateCompanionBuilder =
    InspectionFramesCompanion Function({
      required String id,
      required String workspaceId,
      required String sessionId,
      Value<String?> mediaId,
      required DateTime capturedAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<double?> accuracyM,
      Value<double?> headingDeg,
      required double blurScore,
      required String quality,
      Value<String?> reshootTaskId,
      Value<int> rowid,
    });
typedef $$InspectionFramesTableUpdateCompanionBuilder =
    InspectionFramesCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<String> sessionId,
      Value<String?> mediaId,
      Value<DateTime> capturedAt,
      Value<double?> lat,
      Value<double?> lng,
      Value<double?> accuracyM,
      Value<double?> headingDeg,
      Value<double> blurScore,
      Value<String> quality,
      Value<String?> reshootTaskId,
      Value<int> rowid,
    });

class $$InspectionFramesTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionFramesTable> {
  $$InspectionFramesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get blurScore => $composableBuilder(
    column: $table.blurScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reshootTaskId => $composableBuilder(
    column: $table.reshootTaskId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionFramesTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionFramesTable> {
  $$InspectionFramesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get blurScore => $composableBuilder(
    column: $table.blurScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reshootTaskId => $composableBuilder(
    column: $table.reshootTaskId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionFramesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionFramesTable> {
  $$InspectionFramesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<double> get accuracyM =>
      $composableBuilder(column: $table.accuracyM, builder: (column) => column);

  GeneratedColumn<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get blurScore =>
      $composableBuilder(column: $table.blurScore, builder: (column) => column);

  GeneratedColumn<String> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<String> get reshootTaskId => $composableBuilder(
    column: $table.reshootTaskId,
    builder: (column) => column,
  );
}

class $$InspectionFramesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionFramesTable,
          InspectionFrame,
          $$InspectionFramesTableFilterComposer,
          $$InspectionFramesTableOrderingComposer,
          $$InspectionFramesTableAnnotationComposer,
          $$InspectionFramesTableCreateCompanionBuilder,
          $$InspectionFramesTableUpdateCompanionBuilder,
          (
            InspectionFrame,
            BaseReferences<
              _$AppDatabase,
              $InspectionFramesTable,
              InspectionFrame
            >,
          ),
          InspectionFrame,
          PrefetchHooks Function()
        > {
  $$InspectionFramesTableTableManager(
    _$AppDatabase db,
    $InspectionFramesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionFramesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionFramesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionFramesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String?> mediaId = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> accuracyM = const Value.absent(),
                Value<double?> headingDeg = const Value.absent(),
                Value<double> blurScore = const Value.absent(),
                Value<String> quality = const Value.absent(),
                Value<String?> reshootTaskId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionFramesCompanion(
                id: id,
                workspaceId: workspaceId,
                sessionId: sessionId,
                mediaId: mediaId,
                capturedAt: capturedAt,
                lat: lat,
                lng: lng,
                accuracyM: accuracyM,
                headingDeg: headingDeg,
                blurScore: blurScore,
                quality: quality,
                reshootTaskId: reshootTaskId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                required String sessionId,
                Value<String?> mediaId = const Value.absent(),
                required DateTime capturedAt,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<double?> accuracyM = const Value.absent(),
                Value<double?> headingDeg = const Value.absent(),
                required double blurScore,
                required String quality,
                Value<String?> reshootTaskId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionFramesCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                sessionId: sessionId,
                mediaId: mediaId,
                capturedAt: capturedAt,
                lat: lat,
                lng: lng,
                accuracyM: accuracyM,
                headingDeg: headingDeg,
                blurScore: blurScore,
                quality: quality,
                reshootTaskId: reshootTaskId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InspectionFramesTable, InspectionFrame>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $InspectionFramesTable,
                    InspectionFrame
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionFramesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionFramesTable,
      InspectionFrame,
      $$InspectionFramesTableFilterComposer,
      $$InspectionFramesTableOrderingComposer,
      $$InspectionFramesTableAnnotationComposer,
      $$InspectionFramesTableCreateCompanionBuilder,
      $$InspectionFramesTableUpdateCompanionBuilder,
      (
        InspectionFrame,
        BaseReferences<_$AppDatabase, $InspectionFramesTable, InspectionFrame>,
      ),
      InspectionFrame,
      PrefetchHooks Function()
    >;
typedef $$ReshootTasksTableCreateCompanionBuilder =
    ReshootTasksCompanion Function({
      required String id,
      required String workspaceId,
      required String sessionId,
      required String reason,
      required String description,
      required double headingDeg,
      Value<double?> lat,
      Value<double?> lng,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReshootTasksTableUpdateCompanionBuilder =
    ReshootTasksCompanion Function({
      Value<String> id,
      Value<String> workspaceId,
      Value<String> sessionId,
      Value<String> reason,
      Value<String> description,
      Value<double> headingDeg,
      Value<double?> lat,
      Value<double?> lng,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ReshootTasksTableFilterComposer
    extends Composer<_$AppDatabase, $ReshootTasksTable> {
  $$ReshootTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReshootTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $ReshootTasksTable> {
  $$ReshootTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReshootTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReshootTasksTable> {
  $$ReshootTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReshootTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReshootTasksTable,
          ReshootTask,
          $$ReshootTasksTableFilterComposer,
          $$ReshootTasksTableOrderingComposer,
          $$ReshootTasksTableAnnotationComposer,
          $$ReshootTasksTableCreateCompanionBuilder,
          $$ReshootTasksTableUpdateCompanionBuilder,
          (
            ReshootTask,
            BaseReferences<_$AppDatabase, $ReshootTasksTable, ReshootTask>,
          ),
          ReshootTask,
          PrefetchHooks Function()
        > {
  $$ReshootTasksTableTableManager(_$AppDatabase db, $ReshootTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReshootTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReshootTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReshootTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> headingDeg = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReshootTasksCompanion(
                id: id,
                workspaceId: workspaceId,
                sessionId: sessionId,
                reason: reason,
                description: description,
                headingDeg: headingDeg,
                lat: lat,
                lng: lng,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workspaceId,
                required String sessionId,
                required String reason,
                required String description,
                required double headingDeg,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReshootTasksCompanion.insert(
                id: id,
                workspaceId: workspaceId,
                sessionId: sessionId,
                reason: reason,
                description: description,
                headingDeg: headingDeg,
                lat: lat,
                lng: lng,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReshootTasksTable, ReshootTask>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReshootTasksTable,
                    ReshootTask
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReshootTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReshootTasksTable,
      ReshootTask,
      $$ReshootTasksTableFilterComposer,
      $$ReshootTasksTableOrderingComposer,
      $$ReshootTasksTableAnnotationComposer,
      $$ReshootTasksTableCreateCompanionBuilder,
      $$ReshootTasksTableUpdateCompanionBuilder,
      (
        ReshootTask,
        BaseReferences<_$AppDatabase, $ReshootTasksTable, ReshootTask>,
      ),
      ReshootTask,
      PrefetchHooks Function()
    >;
typedef $$TrackPointsTableCreateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> seq,
      required String trackId,
      required double lat,
      required double lng,
      Value<double?> accuracyM,
      required DateTime at,
    });
typedef $$TrackPointsTableUpdateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> seq,
      Value<String> trackId,
      Value<double> lat,
      Value<double> lng,
      Value<double?> accuracyM,
      Value<DateTime> at,
    });

class $$TrackPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackId => $composableBuilder(
    column: $table.trackId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyM => $composableBuilder(
    column: $table.accuracyM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get trackId =>
      $composableBuilder(column: $table.trackId, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<double> get accuracyM =>
      $composableBuilder(column: $table.accuracyM, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$TrackPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackPointsTable,
          TrackPoint,
          $$TrackPointsTableFilterComposer,
          $$TrackPointsTableOrderingComposer,
          $$TrackPointsTableAnnotationComposer,
          $$TrackPointsTableCreateCompanionBuilder,
          $$TrackPointsTableUpdateCompanionBuilder,
          (
            TrackPoint,
            BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPoint>,
          ),
          TrackPoint,
          PrefetchHooks Function()
        > {
  $$TrackPointsTableTableManager(_$AppDatabase db, $TrackPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> trackId = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<double?> accuracyM = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
              }) => TrackPointsCompanion(
                seq: seq,
                trackId: trackId,
                lat: lat,
                lng: lng,
                accuracyM: accuracyM,
                at: at,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String trackId,
                required double lat,
                required double lng,
                Value<double?> accuracyM = const Value.absent(),
                required DateTime at,
              }) => TrackPointsCompanion.insert(
                seq: seq,
                trackId: trackId,
                lat: lat,
                lng: lng,
                accuracyM: accuracyM,
                at: at,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TrackPointsTable, TrackPoint>(table),
                  BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPoint>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackPointsTable,
      TrackPoint,
      $$TrackPointsTableFilterComposer,
      $$TrackPointsTableOrderingComposer,
      $$TrackPointsTableAnnotationComposer,
      $$TrackPointsTableCreateCompanionBuilder,
      $$TrackPointsTableUpdateCompanionBuilder,
      (
        TrackPoint,
        BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPoint>,
      ),
      TrackPoint,
      PrefetchHooks Function()
    >;
typedef $$OutboxTableCreateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  required String workspaceId,
  required String entity,
  required String entityId,
  required String op,
  required String payloadJson,
  required DateTime createdAt,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
});
typedef $$OutboxTableUpdateCompanionBuilder = OutboxCompanion Function({
  Value<int> seq,
  Value<String> workspaceId,
  Value<String> entity,
  Value<String> entityId,
  Value<String> op,
  Value<String> payloadJson,
  Value<DateTime> createdAt,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
});

class $$OutboxTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxTable> {
  $$OutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
    column: $table.workspaceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$OutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxTable,
          OutboxData,
          $$OutboxTableFilterComposer,
          $$OutboxTableOrderingComposer,
          $$OutboxTableAnnotationComposer,
          $$OutboxTableCreateCompanionBuilder,
          $$OutboxTableUpdateCompanionBuilder,
          (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
          OutboxData,
          PrefetchHooks Function()
        > {
  $$OutboxTableTableManager(_$AppDatabase db, $OutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> workspaceId = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxCompanion(
                seq: seq,
                workspaceId: workspaceId,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
                attempts: attempts,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String workspaceId,
                required String entity,
                required String entityId,
                required String op,
                required String payloadJson,
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => OutboxCompanion.insert(
                seq: seq,
                workspaceId: workspaceId,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
                attempts: attempts,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxTable, OutboxData>(table),
                  BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxTable,
      OutboxData,
      $$OutboxTableFilterComposer,
      $$OutboxTableOrderingComposer,
      $$OutboxTableAnnotationComposer,
      $$OutboxTableCreateCompanionBuilder,
      $$OutboxTableUpdateCompanionBuilder,
      (OutboxData, BaseReferences<_$AppDatabase, $OutboxTable, OutboxData>),
      OutboxData,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$WorkspacesTableTableManager get workspaces =>
      $$WorkspacesTableTableManager(_db, _db.workspaces);
  $$MembershipsTableTableManager get memberships =>
      $$MembershipsTableTableManager(_db, _db.memberships);
  $$FieldsTableTableManager get fields =>
      $$FieldsTableTableManager(_db, _db.fields);
  $$FieldBoundaryVersionsTableTableManager get fieldBoundaryVersions =>
      $$FieldBoundaryVersionsTableTableManager(_db, _db.fieldBoundaryVersions);
  $$LandParcelsTableTableManager get landParcels =>
      $$LandParcelsTableTableManager(_db, _db.landParcels);
  $$FieldParcelsTableTableManager get fieldParcels =>
      $$FieldParcelsTableTableManager(_db, _db.fieldParcels);
  $$LandRelationsTableTableManager get landRelations =>
      $$LandRelationsTableTableManager(_db, _db.landRelations);
  $$CropSeasonsTableTableManager get cropSeasons =>
      $$CropSeasonsTableTableManager(_db, _db.cropSeasons);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$AssignmentsTableTableManager get assignments =>
      $$AssignmentsTableTableManager(_db, _db.assignments);
  $$AssignmentEventsTableTableManager get assignmentEvents =>
      $$AssignmentEventsTableTableManager(_db, _db.assignmentEvents);
  $$WorkReportsTableTableManager get workReports =>
      $$WorkReportsTableTableManager(_db, _db.workReports);
  $$WorkRecordsTableTableManager get workRecords =>
      $$WorkRecordsTableTableManager(_db, _db.workRecords);
  $$WorkRecordInputsTableTableManager get workRecordInputs =>
      $$WorkRecordInputsTableTableManager(_db, _db.workRecordInputs);
  $$RecordRevisionsTableTableManager get recordRevisions =>
      $$RecordRevisionsTableTableManager(_db, _db.recordRevisions);
  $$MediaAssetsTableTableManager get mediaAssets =>
      $$MediaAssetsTableTableManager(_db, _db.mediaAssets);
  $$InspectionSessionsTableTableManager get inspectionSessions =>
      $$InspectionSessionsTableTableManager(_db, _db.inspectionSessions);
  $$InspectionFramesTableTableManager get inspectionFrames =>
      $$InspectionFramesTableTableManager(_db, _db.inspectionFrames);
  $$ReshootTasksTableTableManager get reshootTasks =>
      $$ReshootTasksTableTableManager(_db, _db.reshootTasks);
  $$TrackPointsTableTableManager get trackPoints =>
      $$TrackPointsTableTableManager(_db, _db.trackPoints);
  $$OutboxTableTableManager get outbox =>
      $$OutboxTableTableManager(_db, _db.outbox);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
