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
import 'greeting.dart' as _i2;
import 'app_user.dart' as _i3;
import 'auth_response.dart' as _i4;
import 'auth_token.dart' as _i5;
import 'battle_record.dart' as _i6;
import 'creature.dart' as _i7;
import 'creature_type.dart' as _i8;
import 'register_request.dart' as _i9;
import 'tournament.dart' as _i10;
import 'tournament_participant.dart' as _i11;
import 'transaction.dart' as _i12;
export 'greeting.dart';
export 'app_user.dart';
export 'auth_response.dart';
export 'auth_token.dart';
export 'battle_record.dart';
export 'creature.dart';
export 'creature_type.dart';
export 'register_request.dart';
export 'tournament.dart';
export 'tournament_participant.dart';
export 'transaction.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.AppUser) {
      return _i3.AppUser.fromJson(data) as T;
    }
    if (t == _i4.AuthResponse) {
      return _i4.AuthResponse.fromJson(data) as T;
    }
    if (t == _i5.AuthToken) {
      return _i5.AuthToken.fromJson(data) as T;
    }
    if (t == _i6.BattleRecord) {
      return _i6.BattleRecord.fromJson(data) as T;
    }
    if (t == _i7.Creature) {
      return _i7.Creature.fromJson(data) as T;
    }
    if (t == _i8.CreatureType) {
      return _i8.CreatureType.fromJson(data) as T;
    }
    if (t == _i9.RegisterRequest) {
      return _i9.RegisterRequest.fromJson(data) as T;
    }
    if (t == _i10.Tournament) {
      return _i10.Tournament.fromJson(data) as T;
    }
    if (t == _i11.TournamentParticipant) {
      return _i11.TournamentParticipant.fromJson(data) as T;
    }
    if (t == _i12.Transaction) {
      return _i12.Transaction.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AppUser?>()) {
      return (data != null ? _i3.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthResponse?>()) {
      return (data != null ? _i4.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuthToken?>()) {
      return (data != null ? _i5.AuthToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BattleRecord?>()) {
      return (data != null ? _i6.BattleRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Creature?>()) {
      return (data != null ? _i7.Creature.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CreatureType?>()) {
      return (data != null ? _i8.CreatureType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.RegisterRequest?>()) {
      return (data != null ? _i9.RegisterRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Tournament?>()) {
      return (data != null ? _i10.Tournament.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.TournamentParticipant?>()) {
      return (data != null ? _i11.TournamentParticipant.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.Transaction?>()) {
      return (data != null ? _i12.Transaction.fromJson(data) : null) as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.AppUser) {
      return 'AppUser';
    }
    if (data is _i4.AuthResponse) {
      return 'AuthResponse';
    }
    if (data is _i5.AuthToken) {
      return 'AuthToken';
    }
    if (data is _i6.BattleRecord) {
      return 'BattleRecord';
    }
    if (data is _i7.Creature) {
      return 'Creature';
    }
    if (data is _i8.CreatureType) {
      return 'CreatureType';
    }
    if (data is _i9.RegisterRequest) {
      return 'RegisterRequest';
    }
    if (data is _i10.Tournament) {
      return 'Tournament';
    }
    if (data is _i11.TournamentParticipant) {
      return 'TournamentParticipant';
    }
    if (data is _i12.Transaction) {
      return 'Transaction';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i3.AppUser>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i4.AuthResponse>(data['data']);
    }
    if (dataClassName == 'AuthToken') {
      return deserialize<_i5.AuthToken>(data['data']);
    }
    if (dataClassName == 'BattleRecord') {
      return deserialize<_i6.BattleRecord>(data['data']);
    }
    if (dataClassName == 'Creature') {
      return deserialize<_i7.Creature>(data['data']);
    }
    if (dataClassName == 'CreatureType') {
      return deserialize<_i8.CreatureType>(data['data']);
    }
    if (dataClassName == 'RegisterRequest') {
      return deserialize<_i9.RegisterRequest>(data['data']);
    }
    if (dataClassName == 'Tournament') {
      return deserialize<_i10.Tournament>(data['data']);
    }
    if (dataClassName == 'TournamentParticipant') {
      return deserialize<_i11.TournamentParticipant>(data['data']);
    }
    if (dataClassName == 'Transaction') {
      return deserialize<_i12.Transaction>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
