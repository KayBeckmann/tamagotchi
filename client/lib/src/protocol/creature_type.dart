/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A type/species of creature that can be chosen by users.
abstract class CreatureType implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
