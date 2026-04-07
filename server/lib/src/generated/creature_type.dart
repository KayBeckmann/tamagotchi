/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A type/species of creature that can be chosen by users.
abstract class CreatureType
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CreatureType._({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.element,
    required this.baseAttack,
    required this.baseDefense,
    required this.baseSpeed,
    required this.baseHp,
    required this.spritePath,
    required this.isAvailable,
  });

  factory CreatureType({
    int? id,
    required String name,
    required String description,
    required String category,
    required String element,
    required int baseAttack,
    required int baseDefense,
    required int baseSpeed,
    required int baseHp,
    required String spritePath,
    required bool isAvailable,
  }) = _CreatureTypeImpl;

  factory CreatureType.fromJson(Map<String, dynamic> jsonSerialization) {
    return CreatureType(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      element: jsonSerialization['element'] as String,
      baseAttack: jsonSerialization['baseAttack'] as int,
      baseDefense: jsonSerialization['baseDefense'] as int,
      baseSpeed: jsonSerialization['baseSpeed'] as int,
      baseHp: jsonSerialization['baseHp'] as int,
      spritePath: jsonSerialization['spritePath'] as String,
      isAvailable: jsonSerialization['isAvailable'] as bool,
    );
  }

  static final t = CreatureTypeTable();

  static const db = CreatureTypeRepository._();

  @override
  int? id;

  /// Display name of the creature type.
  String name;

  /// Description of the creature type.
  String description;

  /// Category: 'animal' or 'monster'.
  String category;

  /// Element type (fire, water, earth, air, dark, light).
  String element;

  /// Base attack value.
  int baseAttack;

  /// Base defense value.
  int baseDefense;

  /// Base speed value.
  int baseSpeed;

  /// Base max HP for battles.
  int baseHp;

  /// Asset path for the sprite.
  String spritePath;

  /// Whether this creature type is available for selection.
  bool isAvailable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CreatureType]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreatureType copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    String? element,
    int? baseAttack,
    int? baseDefense,
    int? baseSpeed,
    int? baseHp,
    String? spritePath,
    bool? isAvailable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'element': element,
      'baseAttack': baseAttack,
      'baseDefense': baseDefense,
      'baseSpeed': baseSpeed,
      'baseHp': baseHp,
      'spritePath': spritePath,
      'isAvailable': isAvailable,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'category': category,
      'element': element,
      'baseAttack': baseAttack,
      'baseDefense': baseDefense,
      'baseSpeed': baseSpeed,
      'baseHp': baseHp,
      'spritePath': spritePath,
      'isAvailable': isAvailable,
    };
  }

  static CreatureTypeInclude include() {
    return CreatureTypeInclude._();
  }

  static CreatureTypeIncludeList includeList({
    _i1.WhereExpressionBuilder<CreatureTypeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreatureTypeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatureTypeTable>? orderByList,
    CreatureTypeInclude? include,
  }) {
    return CreatureTypeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CreatureType.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CreatureType.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreatureTypeImpl extends CreatureType {
  _CreatureTypeImpl({
    int? id,
    required String name,
    required String description,
    required String category,
    required String element,
    required int baseAttack,
    required int baseDefense,
    required int baseSpeed,
    required int baseHp,
    required String spritePath,
    required bool isAvailable,
  }) : super._(
          id: id,
          name: name,
          description: description,
          category: category,
          element: element,
          baseAttack: baseAttack,
          baseDefense: baseDefense,
          baseSpeed: baseSpeed,
          baseHp: baseHp,
          spritePath: spritePath,
          isAvailable: isAvailable,
        );

  /// Returns a shallow copy of this [CreatureType]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreatureType copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    String? category,
    String? element,
    int? baseAttack,
    int? baseDefense,
    int? baseSpeed,
    int? baseHp,
    String? spritePath,
    bool? isAvailable,
  }) {
    return CreatureType(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      element: element ?? this.element,
      baseAttack: baseAttack ?? this.baseAttack,
      baseDefense: baseDefense ?? this.baseDefense,
      baseSpeed: baseSpeed ?? this.baseSpeed,
      baseHp: baseHp ?? this.baseHp,
      spritePath: spritePath ?? this.spritePath,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class CreatureTypeTable extends _i1.Table<int?> {
  CreatureTypeTable({super.tableRelation})
      : super(tableName: 'creature_types') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    element = _i1.ColumnString(
      'element',
      this,
    );
    baseAttack = _i1.ColumnInt(
      'baseAttack',
      this,
    );
    baseDefense = _i1.ColumnInt(
      'baseDefense',
      this,
    );
    baseSpeed = _i1.ColumnInt(
      'baseSpeed',
      this,
    );
    baseHp = _i1.ColumnInt(
      'baseHp',
      this,
    );
    spritePath = _i1.ColumnString(
      'spritePath',
      this,
    );
    isAvailable = _i1.ColumnBool(
      'isAvailable',
      this,
    );
  }

  /// Display name of the creature type.
  late final _i1.ColumnString name;

  /// Description of the creature type.
  late final _i1.ColumnString description;

  /// Category: 'animal' or 'monster'.
  late final _i1.ColumnString category;

  /// Element type (fire, water, earth, air, dark, light).
  late final _i1.ColumnString element;

  /// Base attack value.
  late final _i1.ColumnInt baseAttack;

  /// Base defense value.
  late final _i1.ColumnInt baseDefense;

  /// Base speed value.
  late final _i1.ColumnInt baseSpeed;

  /// Base max HP for battles.
  late final _i1.ColumnInt baseHp;

  /// Asset path for the sprite.
  late final _i1.ColumnString spritePath;

  /// Whether this creature type is available for selection.
  late final _i1.ColumnBool isAvailable;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        description,
        category,
        element,
        baseAttack,
        baseDefense,
        baseSpeed,
        baseHp,
        spritePath,
        isAvailable,
      ];
}

class CreatureTypeInclude extends _i1.IncludeObject {
  CreatureTypeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CreatureType.t;
}

class CreatureTypeIncludeList extends _i1.IncludeList {
  CreatureTypeIncludeList._({
    _i1.WhereExpressionBuilder<CreatureTypeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CreatureType.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CreatureType.t;
}

class CreatureTypeRepository {
  const CreatureTypeRepository._();

  /// Returns a list of [CreatureType]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<CreatureType>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatureTypeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreatureTypeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatureTypeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CreatureType>(
      where: where?.call(CreatureType.t),
      orderBy: orderBy?.call(CreatureType.t),
      orderByList: orderByList?.call(CreatureType.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CreatureType] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<CreatureType?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatureTypeTable>? where,
    int? offset,
    _i1.OrderByBuilder<CreatureTypeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreatureTypeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CreatureType>(
      where: where?.call(CreatureType.t),
      orderBy: orderBy?.call(CreatureType.t),
      orderByList: orderByList?.call(CreatureType.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CreatureType] by its [id] or null if no such row exists.
  Future<CreatureType?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CreatureType>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CreatureType]s in the list and returns the inserted rows.
  ///
  /// The returned [CreatureType]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CreatureType>> insert(
    _i1.Session session,
    List<CreatureType> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CreatureType>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CreatureType] and returns the inserted row.
  ///
  /// The returned [CreatureType] will have its `id` field set.
  Future<CreatureType> insertRow(
    _i1.Session session,
    CreatureType row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CreatureType>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CreatureType]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CreatureType>> update(
    _i1.Session session,
    List<CreatureType> rows, {
    _i1.ColumnSelections<CreatureTypeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CreatureType>(
      rows,
      columns: columns?.call(CreatureType.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CreatureType]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CreatureType> updateRow(
    _i1.Session session,
    CreatureType row, {
    _i1.ColumnSelections<CreatureTypeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CreatureType>(
      row,
      columns: columns?.call(CreatureType.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CreatureType]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CreatureType>> delete(
    _i1.Session session,
    List<CreatureType> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CreatureType>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CreatureType].
  Future<CreatureType> deleteRow(
    _i1.Session session,
    CreatureType row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CreatureType>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CreatureType>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CreatureTypeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CreatureType>(
      where: where(CreatureType.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreatureTypeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CreatureType>(
      where: where?.call(CreatureType.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
