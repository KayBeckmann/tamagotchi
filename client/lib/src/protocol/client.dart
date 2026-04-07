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
import 'dart:async' as _i2;
import 'package:tamagotchi_server_client/src/protocol/auth_response.dart'
    as _i3;
import 'package:tamagotchi_server_client/src/protocol/app_user.dart' as _i4;
import 'package:tamagotchi_server_client/src/protocol/greeting.dart' as _i5;
import 'protocol.dart' as _i6;

/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Register a new user account.
  _i2.Future<_i3.AuthResponse> register(
    String username,
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth',
        'register',
        {
          'username': username,
          'email': email,
          'password': password,
        },
      );

  /// Login with email and password.
  _i2.Future<_i3.AuthResponse> login(
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth',
        'login',
        {
          'email': email,
          'password': password,
        },
      );

  /// Refresh the access token using a refresh token.
  _i2.Future<_i3.AuthResponse> refreshToken(String refreshToken) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth',
        'refreshToken',
        {'refreshToken': refreshToken},
      );

  /// Logout - invalidate the refresh token.
  _i2.Future<void> logout(String refreshToken) =>
      caller.callServerEndpoint<void>(
        'auth',
        'logout',
        {'refreshToken': refreshToken},
      );

  /// Logout from all devices.
  _i2.Future<void> logoutAll(int userId) => caller.callServerEndpoint<void>(
        'auth',
        'logoutAll',
        {'userId': userId},
      );

  /// Delete user account (GDPR compliant).
  _i2.Future<void> deleteAccount(
    int userId,
    String password,
  ) =>
      caller.callServerEndpoint<void>(
        'auth',
        'deleteAccount',
        {
          'userId': userId,
          'password': password,
        },
      );

  /// Get current user profile by ID.
  _i2.Future<_i4.AppUser?> getProfile(int userId) =>
      caller.callServerEndpoint<_i4.AppUser?>(
        'auth',
        'getProfile',
        {'userId': userId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i5.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i5.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i6.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    auth = EndpointAuth(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAuth auth;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'auth': auth,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
