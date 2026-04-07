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

/// A Bitcoin transaction record.
abstract class Transaction implements _i1.SerializableModel {
  Transaction._({
    this.id,
    required this.userId,
    required this.type,
    required this.amountSat,
    required this.description,
    this.referenceId,
    this.paymentHash,
    required this.status,
    required this.createdAt,
  });

  factory Transaction({
    int? id,
    required int userId,
    required String type,
    required int amountSat,
    required String description,
    int? referenceId,
    String? paymentHash,
    required String status,
    required DateTime createdAt,
  }) = _TransactionImpl;

  factory Transaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return Transaction(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      type: jsonSerialization['type'] as String,
      amountSat: jsonSerialization['amountSat'] as int,
      description: jsonSerialization['description'] as String,
      referenceId: jsonSerialization['referenceId'] as int?,
      paymentHash: jsonSerialization['paymentHash'] as String?,
      status: jsonSerialization['status'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the user.
  int userId;

  /// Type: deposit, withdrawal, tournament_entry, tournament_prize, battle_reward, shop_purchase.
  String type;

  /// Amount in Satoshis (positive = credit, negative = debit).
  int amountSat;

  /// Description of the transaction.
  String description;

  /// Related entity ID (tournament ID, battle ID, etc.).
  int? referenceId;

  /// Lightning invoice or payment hash.
  String? paymentHash;

  /// Status: pending, completed, failed.
  String status;

  /// Timestamp of the transaction.
  DateTime createdAt;

  /// Returns a shallow copy of this [Transaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Transaction copyWith({
    int? id,
    int? userId,
    String? type,
    int? amountSat,
    String? description,
    int? referenceId,
    String? paymentHash,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      'amountSat': amountSat,
      'description': description,
      if (referenceId != null) 'referenceId': referenceId,
      if (paymentHash != null) 'paymentHash': paymentHash,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransactionImpl extends Transaction {
  _TransactionImpl({
    int? id,
    required int userId,
    required String type,
    required int amountSat,
    required String description,
    int? referenceId,
    String? paymentHash,
    required String status,
    required DateTime createdAt,
  }) : super._(
          id: id,
          userId: userId,
          type: type,
          amountSat: amountSat,
          description: description,
          referenceId: referenceId,
          paymentHash: paymentHash,
          status: status,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Transaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Transaction copyWith({
    Object? id = _Undefined,
    int? userId,
    String? type,
    int? amountSat,
    String? description,
    Object? referenceId = _Undefined,
    Object? paymentHash = _Undefined,
    String? status,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amountSat: amountSat ?? this.amountSat,
      description: description ?? this.description,
      referenceId: referenceId is int? ? referenceId : this.referenceId,
      paymentHash: paymentHash is String? ? paymentHash : this.paymentHash,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
