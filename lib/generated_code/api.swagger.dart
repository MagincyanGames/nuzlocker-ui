// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'api.enums.swagger.dart' as enums;
export 'api.enums.swagger.dart';

part 'api.swagger.chopper.dart';
part 'api.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Api extends ChopperService {
  static Api create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Api(client);
    }

    final newClient = ChopperClient(
        services: [_$Api()],
        converter: converter ?? $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        client: httpClient,
        authenticator: authenticator,
        errorConverter: errorConverter,
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Api(newClient);
  }

  ///Obtener todos los usuarios
  Future<chopper.Response<List<UserResponseDto>>> apiUsersGet() {
    generatedMapping.putIfAbsent(
        UserResponseDto, () => UserResponseDto.fromJsonFactory);

    return _apiUsersGet();
  }

  ///Obtener todos los usuarios
  @Get(path: '/api/users')
  Future<chopper.Response<List<UserResponseDto>>> _apiUsersGet();

  ///Buscar usuarios por username
  ///@param query Texto a buscar en el username (mínimo 3 caracteres)
  Future<chopper.Response<List<UserResponseDto>>> apiUsersSearchGet(
      {required String? query}) {
    generatedMapping.putIfAbsent(
        UserResponseDto, () => UserResponseDto.fromJsonFactory);

    return _apiUsersSearchGet(query: query);
  }

  ///Buscar usuarios por username
  ///@param query Texto a buscar en el username (mínimo 3 caracteres)
  @Get(path: '/api/users/search')
  Future<chopper.Response<List<UserResponseDto>>> _apiUsersSearchGet(
      {@Query('query') required String? query});

  ///Obtener estadísticas globales de un usuario
  ///@param userId ID del usuario
  Future<chopper.Response<UserStatsResponseDto>> apiUsersUserIdStatsGet(
      {required String? userId}) {
    generatedMapping.putIfAbsent(
        UserStatsResponseDto, () => UserStatsResponseDto.fromJsonFactory);

    return _apiUsersUserIdStatsGet(userId: userId);
  }

  ///Obtener estadísticas globales de un usuario
  ///@param userId ID del usuario
  @Get(path: '/api/users/{userId}/stats')
  Future<chopper.Response<UserStatsResponseDto>> _apiUsersUserIdStatsGet(
      {@Path('userId') required String? userId});

  ///Iniciar sesión de usuario
  Future<chopper.Response<LoginResponseDto>> apiAuthLoginPost(
      {required LoginDto? body}) {
    generatedMapping.putIfAbsent(
        LoginResponseDto, () => LoginResponseDto.fromJsonFactory);

    return _apiAuthLoginPost(body: body);
  }

  ///Iniciar sesión de usuario
  @Post(
    path: '/api/auth/login',
    optionalBody: true,
  )
  Future<chopper.Response<LoginResponseDto>> _apiAuthLoginPost(
      {@Body() required LoginDto? body});

  ///Validar token JWT
  Future<chopper.Response<ValidateTokenResponseDto>> apiAuthValidatePost(
      {required ValidateTokenDto? body}) {
    generatedMapping.putIfAbsent(ValidateTokenResponseDto,
        () => ValidateTokenResponseDto.fromJsonFactory);

    return _apiAuthValidatePost(body: body);
  }

  ///Validar token JWT
  @Post(
    path: '/api/auth/validate',
    optionalBody: true,
  )
  Future<chopper.Response<ValidateTokenResponseDto>> _apiAuthValidatePost(
      {@Body() required ValidateTokenDto? body});

  ///Registrar nuevo usuario
  Future<chopper.Response<RegisterResponseDto>> apiAuthRegisterPost(
      {required LoginDto? body}) {
    generatedMapping.putIfAbsent(
        RegisterResponseDto, () => RegisterResponseDto.fromJsonFactory);

    return _apiAuthRegisterPost(body: body);
  }

  ///Registrar nuevo usuario
  @Post(
    path: '/api/auth/register',
    optionalBody: true,
  )
  Future<chopper.Response<RegisterResponseDto>> _apiAuthRegisterPost(
      {@Body() required LoginDto? body});

  ///Crear un nuevo locke
  Future<chopper.Response<EnrichedLockeResponseDto>> apiLockesPost(
      {required CreateLockeDto? body}) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesPost(body: body);
  }

  ///Crear un nuevo locke
  @Post(
    path: '/api/lockes',
    optionalBody: true,
  )
  Future<chopper.Response<EnrichedLockeResponseDto>> _apiLockesPost(
      {@Body() required CreateLockeDto? body});

  ///Obtener todos los lockes
  ///@param active Filtrar por estado activo. Si se omite, devuelve todos los lockes independientemente de su estado.
  Future<chopper.Response<List<EnrichedLockeResponseDto>>> apiLockesGet(
      {enums.ApiLockesGetActive? active}) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesGet(active: active?.value?.toString());
  }

  ///Obtener todos los lockes
  ///@param active Filtrar por estado activo. Si se omite, devuelve todos los lockes independientemente de su estado.
  @Get(path: '/api/lockes')
  Future<chopper.Response<List<EnrichedLockeResponseDto>>> _apiLockesGet(
      {@Query('active') String? active});

  ///Obtener un locke por ID
  ///@param id
  Future<chopper.Response<EnrichedLockeResponseDto>> apiLockesIdGet(
      {required String? id}) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesIdGet(id: id);
  }

  ///Obtener un locke por ID
  ///@param id
  @Get(path: '/api/lockes/{id}')
  Future<chopper.Response<EnrichedLockeResponseDto>> _apiLockesIdGet(
      {@Path('id') required String? id});

  ///Actualizar un locke
  ///@param id
  Future<chopper.Response<EnrichedLockeResponseDto>> apiLockesIdPatch({
    required String? id,
    required UpdateLockeDto? body,
  }) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesIdPatch(id: id, body: body);
  }

  ///Actualizar un locke
  ///@param id
  @Patch(
    path: '/api/lockes/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<EnrichedLockeResponseDto>> _apiLockesIdPatch({
    @Path('id') required String? id,
    @Body() required UpdateLockeDto? body,
  });

  ///Desactivar un locke
  ///@param id
  Future<chopper.Response<EnrichedLockeResponseDto>> apiLockesIdDelete(
      {required String? id}) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesIdDelete(id: id);
  }

  ///Desactivar un locke
  ///@param id
  @Delete(path: '/api/lockes/{id}')
  Future<chopper.Response<EnrichedLockeResponseDto>> _apiLockesIdDelete(
      {@Path('id') required String? id});

  ///Registrar una muerte en un locke
  ///@param id
  ///@param userId
  ///@param count
  Future<chopper.Response<EnrichedLockeResponseDto>> apiLockesIdKillsPost({
    required String? id,
    required String? userId,
    required num? count,
  }) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesIdKillsPost(id: id, userId: userId, count: count);
  }

  ///Registrar una muerte en un locke
  ///@param id
  ///@param userId
  ///@param count
  @Post(
    path: '/api/lockes/{id}/kills',
    optionalBody: true,
  )
  Future<chopper.Response<EnrichedLockeResponseDto>> _apiLockesIdKillsPost({
    @Path('id') required String? id,
    @Query('userId') required String? userId,
    @Query('count') required num? count,
  });

  ///Registrar una muerte propia en un locke
  ///@param id
  ///@param count
  Future<chopper.Response<EnrichedLockeResponseDto>> apiLockesIdMyKillsPost({
    required String? id,
    required num? count,
  }) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesIdMyKillsPost(id: id, count: count);
  }

  ///Registrar una muerte propia en un locke
  ///@param id
  ///@param count
  @Post(
    path: '/api/lockes/{id}/my-kills',
    optionalBody: true,
  )
  Future<chopper.Response<EnrichedLockeResponseDto>> _apiLockesIdMyKillsPost({
    @Path('id') required String? id,
    @Query('count') required num? count,
  });

  ///Registrar una batalla en un locke
  ///@param id
  Future<chopper.Response<BattleResponseDto>> apiLockesIdBattlesPost({
    required String? id,
    required CreateBattleDto? body,
  }) {
    generatedMapping.putIfAbsent(
        BattleResponseDto, () => BattleResponseDto.fromJsonFactory);

    return _apiLockesIdBattlesPost(id: id, body: body);
  }

  ///Registrar una batalla en un locke
  ///@param id
  @Post(
    path: '/api/lockes/{id}/battles',
    optionalBody: true,
  )
  Future<chopper.Response<BattleResponseDto>> _apiLockesIdBattlesPost({
    @Path('id') required String? id,
    @Body() required CreateBattleDto? body,
  });

  ///Obtener todas las batallas de un locke
  ///@param id
  Future<chopper.Response<List<BattleResponseDto>>> apiLockesIdBattlesGet(
      {required String? id}) {
    generatedMapping.putIfAbsent(
        BattleResponseDto, () => BattleResponseDto.fromJsonFactory);

    return _apiLockesIdBattlesGet(id: id);
  }

  ///Obtener todas las batallas de un locke
  ///@param id
  @Get(path: '/api/lockes/{id}/battles')
  Future<chopper.Response<List<BattleResponseDto>>> _apiLockesIdBattlesGet(
      {@Path('id') required String? id});

  ///Obtener clasificación de participantes en un locke
  ///@param id
  Future<chopper.Response<List<ParticipantResponseDto>>>
      apiLockesIdLeaderboardGet({required String? id}) {
    generatedMapping.putIfAbsent(
        ParticipantResponseDto, () => ParticipantResponseDto.fromJsonFactory);

    return _apiLockesIdLeaderboardGet(id: id);
  }

  ///Obtener clasificación de participantes en un locke
  ///@param id
  @Get(path: '/api/lockes/{id}/leaderboard')
  Future<chopper.Response<List<ParticipantResponseDto>>>
      _apiLockesIdLeaderboardGet({@Path('id') required String? id});

  ///Agregar un participante a un locke
  ///@param id
  Future<chopper.Response<EnrichedLockeResponseDto>>
      apiLockesIdParticipantsPost({
    required String? id,
    required AddParticipantDto? body,
  }) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesIdParticipantsPost(id: id, body: body);
  }

  ///Agregar un participante a un locke
  ///@param id
  @Post(
    path: '/api/lockes/{id}/participants',
    optionalBody: true,
  )
  Future<chopper.Response<EnrichedLockeResponseDto>>
      _apiLockesIdParticipantsPost({
    @Path('id') required String? id,
    @Body() required AddParticipantDto? body,
  });

  ///Obtener lockes de un usuario específico
  ///@param userId
  ///@param includeParticipating Incluir lockes donde el usuario es solo participante. Por defecto es true.
  ///@param active Filtrar por estado activo. Si se omite, devuelve todos los lockes independientemente de su estado.
  Future<chopper.Response<List<EnrichedLockeResponseDto>>>
      apiLockesUserUserIdGet({
    required String? userId,
    enums.ApiLockesUserUserIdGetIncludeParticipating? includeParticipating,
    enums.ApiLockesUserUserIdGetActive? active,
  }) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesUserUserIdGet(
        userId: userId,
        includeParticipating: includeParticipating?.value?.toString(),
        active: active?.value?.toString());
  }

  ///Obtener lockes de un usuario específico
  ///@param userId
  ///@param includeParticipating Incluir lockes donde el usuario es solo participante. Por defecto es true.
  ///@param active Filtrar por estado activo. Si se omite, devuelve todos los lockes independientemente de su estado.
  @Get(path: '/api/lockes/user/{userId}')
  Future<chopper.Response<List<EnrichedLockeResponseDto>>>
      _apiLockesUserUserIdGet({
    @Path('userId') required String? userId,
    @Query('includeParticipating') String? includeParticipating,
    @Query('active') String? active,
  });

  ///Obtener lockes del usuario autenticado
  ///@param includeParticipating Incluir lockes donde el usuario es solo participante. Por defecto es true.
  ///@param active Filtrar por estado activo. Si se omite, devuelve todos los lockes independientemente de su estado.
  Future<chopper.Response<List<EnrichedLockeResponseDto>>>
      apiLockesMyLockesGet({
    enums.ApiLockesMyLockesGetIncludeParticipating? includeParticipating,
    enums.ApiLockesMyLockesGetActive? active,
  }) {
    generatedMapping.putIfAbsent(EnrichedLockeResponseDto,
        () => EnrichedLockeResponseDto.fromJsonFactory);

    return _apiLockesMyLockesGet(
        includeParticipating: includeParticipating?.value?.toString(),
        active: active?.value?.toString());
  }

  ///Obtener lockes del usuario autenticado
  ///@param includeParticipating Incluir lockes donde el usuario es solo participante. Por defecto es true.
  ///@param active Filtrar por estado activo. Si se omite, devuelve todos los lockes independientemente de su estado.
  @Get(path: '/api/lockes/my/lockes')
  Future<chopper.Response<List<EnrichedLockeResponseDto>>>
      _apiLockesMyLockesGet({
    @Query('includeParticipating') String? includeParticipating,
    @Query('active') String? active,
  });
}

@JsonSerializable(explicitToJson: true)
class UserResponseDto {
  const UserResponseDto({
    required this.id,
    required this.name,
    required this.username,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserResponseDtoFromJson(json);

  static const toJsonFactory = _$UserResponseDtoToJson;
  Map<String, dynamic> toJson() => _$UserResponseDtoToJson(this);

  @JsonKey(name: '_id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  static const fromJsonFactory = _$UserResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(username) ^
      runtimeType.hashCode;
}

extension $UserResponseDtoExtension on UserResponseDto {
  UserResponseDto copyWith({String? id, String? name, String? username}) {
    return UserResponseDto(
        id: id ?? this.id,
        name: name ?? this.name,
        username: username ?? this.username);
  }

  UserResponseDto copyWithWrapped(
      {Wrapped<String>? id, Wrapped<String>? name, Wrapped<String>? username}) {
    return UserResponseDto(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        username: (username != null ? username.value : this.username));
  }
}

@JsonSerializable(explicitToJson: true)
class UserStatsResponseDto {
  const UserStatsResponseDto({
    required this.userId,
    required this.username,
    this.name,
    required this.totalDeaths,
    required this.averageDeathsPerLocke,
    required this.totalLockes,
  });

  factory UserStatsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatsResponseDtoFromJson(json);

  static const toJsonFactory = _$UserStatsResponseDtoToJson;
  Map<String, dynamic> toJson() => _$UserStatsResponseDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String? name;
  @JsonKey(name: 'totalDeaths')
  final double totalDeaths;
  @JsonKey(name: 'averageDeathsPerLocke')
  final double averageDeathsPerLocke;
  @JsonKey(name: 'totalLockes')
  final double totalLockes;
  static const fromJsonFactory = _$UserStatsResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserStatsResponseDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.totalDeaths, totalDeaths) ||
                const DeepCollectionEquality()
                    .equals(other.totalDeaths, totalDeaths)) &&
            (identical(other.averageDeathsPerLocke, averageDeathsPerLocke) ||
                const DeepCollectionEquality().equals(
                    other.averageDeathsPerLocke, averageDeathsPerLocke)) &&
            (identical(other.totalLockes, totalLockes) ||
                const DeepCollectionEquality()
                    .equals(other.totalLockes, totalLockes)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(totalDeaths) ^
      const DeepCollectionEquality().hash(averageDeathsPerLocke) ^
      const DeepCollectionEquality().hash(totalLockes) ^
      runtimeType.hashCode;
}

extension $UserStatsResponseDtoExtension on UserStatsResponseDto {
  UserStatsResponseDto copyWith(
      {String? userId,
      String? username,
      String? name,
      double? totalDeaths,
      double? averageDeathsPerLocke,
      double? totalLockes}) {
    return UserStatsResponseDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        name: name ?? this.name,
        totalDeaths: totalDeaths ?? this.totalDeaths,
        averageDeathsPerLocke:
            averageDeathsPerLocke ?? this.averageDeathsPerLocke,
        totalLockes: totalLockes ?? this.totalLockes);
  }

  UserStatsResponseDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<String>? username,
      Wrapped<String?>? name,
      Wrapped<double>? totalDeaths,
      Wrapped<double>? averageDeathsPerLocke,
      Wrapped<double>? totalLockes}) {
    return UserStatsResponseDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name),
        totalDeaths:
            (totalDeaths != null ? totalDeaths.value : this.totalDeaths),
        averageDeathsPerLocke: (averageDeathsPerLocke != null
            ? averageDeathsPerLocke.value
            : this.averageDeathsPerLocke),
        totalLockes:
            (totalLockes != null ? totalLockes.value : this.totalLockes));
  }
}

@JsonSerializable(explicitToJson: true)
class LoginDto {
  const LoginDto({
    required this.username,
    required this.password,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  static const toJsonFactory = _$LoginDtoToJson;
  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);

  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'password', defaultValue: 'default')
  final String password;
  static const fromJsonFactory = _$LoginDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginDto &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $LoginDtoExtension on LoginDto {
  LoginDto copyWith({String? username, String? password}) {
    return LoginDto(
        username: username ?? this.username,
        password: password ?? this.password);
  }

  LoginDto copyWithWrapped(
      {Wrapped<String>? username, Wrapped<String>? password}) {
    return LoginDto(
        username: (username != null ? username.value : this.username),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class LoginResponseDto {
  const LoginResponseDto({
    required this.id,
    required this.accessToken,
    required this.success,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  static const toJsonFactory = _$LoginResponseDtoToJson;
  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);

  @JsonKey(name: 'id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'access_token', defaultValue: 'default')
  final String accessToken;
  @JsonKey(name: 'success')
  final bool success;
  static const fromJsonFactory = _$LoginResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality()
                    .equals(other.accessToken, accessToken)) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(other.success, success)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $LoginResponseDtoExtension on LoginResponseDto {
  LoginResponseDto copyWith({String? id, String? accessToken, bool? success}) {
    return LoginResponseDto(
        id: id ?? this.id,
        accessToken: accessToken ?? this.accessToken,
        success: success ?? this.success);
  }

  LoginResponseDto copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? accessToken,
      Wrapped<bool>? success}) {
    return LoginResponseDto(
        id: (id != null ? id.value : this.id),
        accessToken:
            (accessToken != null ? accessToken.value : this.accessToken),
        success: (success != null ? success.value : this.success));
  }
}

@JsonSerializable(explicitToJson: true)
class ErrorResponseDto {
  const ErrorResponseDto({
    required this.success,
    required this.message,
  });

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseDtoFromJson(json);

  static const toJsonFactory = _$ErrorResponseDtoToJson;
  Map<String, dynamic> toJson() => _$ErrorResponseDtoToJson(this);

  @JsonKey(name: 'success')
  final bool success;
  @JsonKey(name: 'message', defaultValue: 'default')
  final String message;
  static const fromJsonFactory = _$ErrorResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ErrorResponseDto &&
            (identical(other.success, success) ||
                const DeepCollectionEquality()
                    .equals(other.success, success)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(success) ^
      const DeepCollectionEquality().hash(message) ^
      runtimeType.hashCode;
}

extension $ErrorResponseDtoExtension on ErrorResponseDto {
  ErrorResponseDto copyWith({bool? success, String? message}) {
    return ErrorResponseDto(
        success: success ?? this.success, message: message ?? this.message);
  }

  ErrorResponseDto copyWithWrapped(
      {Wrapped<bool>? success, Wrapped<String>? message}) {
    return ErrorResponseDto(
        success: (success != null ? success.value : this.success),
        message: (message != null ? message.value : this.message));
  }
}

@JsonSerializable(explicitToJson: true)
class ValidateTokenDto {
  const ValidateTokenDto({
    required this.token,
  });

  factory ValidateTokenDto.fromJson(Map<String, dynamic> json) =>
      _$ValidateTokenDtoFromJson(json);

  static const toJsonFactory = _$ValidateTokenDtoToJson;
  Map<String, dynamic> toJson() => _$ValidateTokenDtoToJson(this);

  @JsonKey(name: 'token', defaultValue: 'default')
  final String token;
  static const fromJsonFactory = _$ValidateTokenDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidateTokenDto &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(token) ^ runtimeType.hashCode;
}

extension $ValidateTokenDtoExtension on ValidateTokenDto {
  ValidateTokenDto copyWith({String? token}) {
    return ValidateTokenDto(token: token ?? this.token);
  }

  ValidateTokenDto copyWithWrapped({Wrapped<String>? token}) {
    return ValidateTokenDto(token: (token != null ? token.value : this.token));
  }
}

@JsonSerializable(explicitToJson: true)
class ValidateTokenResponseDto {
  const ValidateTokenResponseDto({
    required this.valid,
    this.id,
  });

  factory ValidateTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ValidateTokenResponseDtoFromJson(json);

  static const toJsonFactory = _$ValidateTokenResponseDtoToJson;
  Map<String, dynamic> toJson() => _$ValidateTokenResponseDtoToJson(this);

  @JsonKey(name: 'valid')
  final bool valid;
  @JsonKey(name: 'id', defaultValue: 'default')
  final String? id;
  static const fromJsonFactory = _$ValidateTokenResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidateTokenResponseDto &&
            (identical(other.valid, valid) ||
                const DeepCollectionEquality().equals(other.valid, valid)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(valid) ^
      const DeepCollectionEquality().hash(id) ^
      runtimeType.hashCode;
}

extension $ValidateTokenResponseDtoExtension on ValidateTokenResponseDto {
  ValidateTokenResponseDto copyWith({bool? valid, String? id}) {
    return ValidateTokenResponseDto(
        valid: valid ?? this.valid, id: id ?? this.id);
  }

  ValidateTokenResponseDto copyWithWrapped(
      {Wrapped<bool>? valid, Wrapped<String?>? id}) {
    return ValidateTokenResponseDto(
        valid: (valid != null ? valid.value : this.valid),
        id: (id != null ? id.value : this.id));
  }
}

@JsonSerializable(explicitToJson: true)
class RegisterResponseDto {
  const RegisterResponseDto({
    required this.id,
    required this.username,
    this.name,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  static const toJsonFactory = _$RegisterResponseDtoToJson;
  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);

  @JsonKey(name: 'id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String? name;
  static const fromJsonFactory = _$RegisterResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $RegisterResponseDtoExtension on RegisterResponseDto {
  RegisterResponseDto copyWith({String? id, String? username, String? name}) {
    return RegisterResponseDto(
        id: id ?? this.id,
        username: username ?? this.username,
        name: name ?? this.name);
  }

  RegisterResponseDto copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? username,
      Wrapped<String?>? name}) {
    return RegisterResponseDto(
        id: (id != null ? id.value : this.id),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class CreateLockeDto {
  const CreateLockeDto({
    required this.name,
    this.description,
    this.isActive,
    this.adminIds,
  });

  factory CreateLockeDto.fromJson(Map<String, dynamic> json) =>
      _$CreateLockeDtoFromJson(json);

  static const toJsonFactory = _$CreateLockeDtoToJson;
  Map<String, dynamic> toJson() => _$CreateLockeDtoToJson(this);

  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  @JsonKey(name: 'description', defaultValue: 'default')
  final String? description;
  @JsonKey(name: 'isActive', defaultValue: true)
  final bool? isActive;
  @JsonKey(name: 'adminIds', defaultValue: <String>[])
  final List<String>? adminIds;
  static const fromJsonFactory = _$CreateLockeDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateLockeDto &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.adminIds, adminIds) ||
                const DeepCollectionEquality()
                    .equals(other.adminIds, adminIds)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(adminIds) ^
      runtimeType.hashCode;
}

extension $CreateLockeDtoExtension on CreateLockeDto {
  CreateLockeDto copyWith(
      {String? name,
      String? description,
      bool? isActive,
      List<String>? adminIds}) {
    return CreateLockeDto(
        name: name ?? this.name,
        description: description ?? this.description,
        isActive: isActive ?? this.isActive,
        adminIds: adminIds ?? this.adminIds);
  }

  CreateLockeDto copyWithWrapped(
      {Wrapped<String>? name,
      Wrapped<String?>? description,
      Wrapped<bool?>? isActive,
      Wrapped<List<String>?>? adminIds}) {
    return CreateLockeDto(
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        isActive: (isActive != null ? isActive.value : this.isActive),
        adminIds: (adminIds != null ? adminIds.value : this.adminIds));
  }
}

@JsonSerializable(explicitToJson: true)
class EnrichedParticipantResponseDto {
  const EnrichedParticipantResponseDto({
    required this.userId,
    required this.username,
    required this.name,
    required this.deaths,
    required this.points,
    required this.isAdmin,
    required this.score,
  });

  factory EnrichedParticipantResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EnrichedParticipantResponseDtoFromJson(json);

  static const toJsonFactory = _$EnrichedParticipantResponseDtoToJson;
  Map<String, dynamic> toJson() => _$EnrichedParticipantResponseDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  @JsonKey(name: 'deaths')
  final double deaths;
  @JsonKey(name: 'points')
  final double points;
  @JsonKey(name: 'isAdmin')
  final bool isAdmin;
  @JsonKey(name: 'score')
  final double score;
  static const fromJsonFactory = _$EnrichedParticipantResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnrichedParticipantResponseDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.deaths, deaths) ||
                const DeepCollectionEquality().equals(other.deaths, deaths)) &&
            (identical(other.points, points) ||
                const DeepCollectionEquality().equals(other.points, points)) &&
            (identical(other.isAdmin, isAdmin) ||
                const DeepCollectionEquality()
                    .equals(other.isAdmin, isAdmin)) &&
            (identical(other.score, score) ||
                const DeepCollectionEquality().equals(other.score, score)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(deaths) ^
      const DeepCollectionEquality().hash(points) ^
      const DeepCollectionEquality().hash(isAdmin) ^
      const DeepCollectionEquality().hash(score) ^
      runtimeType.hashCode;
}

extension $EnrichedParticipantResponseDtoExtension
    on EnrichedParticipantResponseDto {
  EnrichedParticipantResponseDto copyWith(
      {String? userId,
      String? username,
      String? name,
      double? deaths,
      double? points,
      bool? isAdmin,
      double? score}) {
    return EnrichedParticipantResponseDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        name: name ?? this.name,
        deaths: deaths ?? this.deaths,
        points: points ?? this.points,
        isAdmin: isAdmin ?? this.isAdmin,
        score: score ?? this.score);
  }

  EnrichedParticipantResponseDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<String>? username,
      Wrapped<String>? name,
      Wrapped<double>? deaths,
      Wrapped<double>? points,
      Wrapped<bool>? isAdmin,
      Wrapped<double>? score}) {
    return EnrichedParticipantResponseDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name),
        deaths: (deaths != null ? deaths.value : this.deaths),
        points: (points != null ? points.value : this.points),
        isAdmin: (isAdmin != null ? isAdmin.value : this.isAdmin),
        score: (score != null ? score.value : this.score));
  }
}

@JsonSerializable(explicitToJson: true)
class EnrichedLockeResponseDto {
  const EnrichedLockeResponseDto({
    required this.id,
    required this.name,
    required this.participants,
    required this.adminIds,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EnrichedLockeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EnrichedLockeResponseDtoFromJson(json);

  static const toJsonFactory = _$EnrichedLockeResponseDtoToJson;
  Map<String, dynamic> toJson() => _$EnrichedLockeResponseDtoToJson(this);

  @JsonKey(name: '_id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  @JsonKey(
      name: 'participants', defaultValue: <EnrichedParticipantResponseDto>[])
  final List<EnrichedParticipantResponseDto> participants;
  @JsonKey(name: 'adminIds', defaultValue: <String>[])
  final List<String> adminIds;
  @JsonKey(name: 'isActive')
  final bool isActive;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  static const fromJsonFactory = _$EnrichedLockeResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnrichedLockeResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.participants, participants) ||
                const DeepCollectionEquality()
                    .equals(other.participants, participants)) &&
            (identical(other.adminIds, adminIds) ||
                const DeepCollectionEquality()
                    .equals(other.adminIds, adminIds)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality()
                    .equals(other.updatedAt, updatedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(participants) ^
      const DeepCollectionEquality().hash(adminIds) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $EnrichedLockeResponseDtoExtension on EnrichedLockeResponseDto {
  EnrichedLockeResponseDto copyWith(
      {String? id,
      String? name,
      List<EnrichedParticipantResponseDto>? participants,
      List<String>? adminIds,
      bool? isActive,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    return EnrichedLockeResponseDto(
        id: id ?? this.id,
        name: name ?? this.name,
        participants: participants ?? this.participants,
        adminIds: adminIds ?? this.adminIds,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  EnrichedLockeResponseDto copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? name,
      Wrapped<List<EnrichedParticipantResponseDto>>? participants,
      Wrapped<List<String>>? adminIds,
      Wrapped<bool>? isActive,
      Wrapped<DateTime>? createdAt,
      Wrapped<DateTime>? updatedAt}) {
    return EnrichedLockeResponseDto(
        id: (id != null ? id.value : this.id),
        name: (name != null ? name.value : this.name),
        participants:
            (participants != null ? participants.value : this.participants),
        adminIds: (adminIds != null ? adminIds.value : this.adminIds),
        isActive: (isActive != null ? isActive.value : this.isActive),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt));
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateLockeDto {
  const UpdateLockeDto({
    this.name,
    this.description,
    this.isActive,
    this.adminIds,
  });

  factory UpdateLockeDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateLockeDtoFromJson(json);

  static const toJsonFactory = _$UpdateLockeDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateLockeDtoToJson(this);

  @JsonKey(name: 'name', defaultValue: 'default')
  final String? name;
  @JsonKey(name: 'description', defaultValue: 'default')
  final String? description;
  @JsonKey(name: 'isActive', defaultValue: true)
  final bool? isActive;
  @JsonKey(name: 'adminIds', defaultValue: <String>[])
  final List<String>? adminIds;
  static const fromJsonFactory = _$UpdateLockeDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateLockeDto &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.adminIds, adminIds) ||
                const DeepCollectionEquality()
                    .equals(other.adminIds, adminIds)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(adminIds) ^
      runtimeType.hashCode;
}

extension $UpdateLockeDtoExtension on UpdateLockeDto {
  UpdateLockeDto copyWith(
      {String? name,
      String? description,
      bool? isActive,
      List<String>? adminIds}) {
    return UpdateLockeDto(
        name: name ?? this.name,
        description: description ?? this.description,
        isActive: isActive ?? this.isActive,
        adminIds: adminIds ?? this.adminIds);
  }

  UpdateLockeDto copyWithWrapped(
      {Wrapped<String?>? name,
      Wrapped<String?>? description,
      Wrapped<bool?>? isActive,
      Wrapped<List<String>?>? adminIds}) {
    return UpdateLockeDto(
        name: (name != null ? name.value : this.name),
        description:
            (description != null ? description.value : this.description),
        isActive: (isActive != null ? isActive.value : this.isActive),
        adminIds: (adminIds != null ? adminIds.value : this.adminIds));
  }
}

@JsonSerializable(explicitToJson: true)
class CreateBattleDto {
  const CreateBattleDto({
    required this.lockeId,
    required this.participantIds,
    required this.winnerId,
    required this.winCount,
  });

  factory CreateBattleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateBattleDtoFromJson(json);

  static const toJsonFactory = _$CreateBattleDtoToJson;
  Map<String, dynamic> toJson() => _$CreateBattleDtoToJson(this);

  @JsonKey(name: 'lockeId', defaultValue: 'default')
  final String lockeId;
  @JsonKey(name: 'participantIds', defaultValue: <String>[])
  final List<String> participantIds;
  @JsonKey(name: 'winnerId', defaultValue: 'default')
  final String winnerId;
  @JsonKey(name: 'winCount')
  final double winCount;
  static const fromJsonFactory = _$CreateBattleDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateBattleDto &&
            (identical(other.lockeId, lockeId) ||
                const DeepCollectionEquality()
                    .equals(other.lockeId, lockeId)) &&
            (identical(other.participantIds, participantIds) ||
                const DeepCollectionEquality()
                    .equals(other.participantIds, participantIds)) &&
            (identical(other.winnerId, winnerId) ||
                const DeepCollectionEquality()
                    .equals(other.winnerId, winnerId)) &&
            (identical(other.winCount, winCount) ||
                const DeepCollectionEquality()
                    .equals(other.winCount, winCount)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(lockeId) ^
      const DeepCollectionEquality().hash(participantIds) ^
      const DeepCollectionEquality().hash(winnerId) ^
      const DeepCollectionEquality().hash(winCount) ^
      runtimeType.hashCode;
}

extension $CreateBattleDtoExtension on CreateBattleDto {
  CreateBattleDto copyWith(
      {String? lockeId,
      List<String>? participantIds,
      String? winnerId,
      double? winCount}) {
    return CreateBattleDto(
        lockeId: lockeId ?? this.lockeId,
        participantIds: participantIds ?? this.participantIds,
        winnerId: winnerId ?? this.winnerId,
        winCount: winCount ?? this.winCount);
  }

  CreateBattleDto copyWithWrapped(
      {Wrapped<String>? lockeId,
      Wrapped<List<String>>? participantIds,
      Wrapped<String>? winnerId,
      Wrapped<double>? winCount}) {
    return CreateBattleDto(
        lockeId: (lockeId != null ? lockeId.value : this.lockeId),
        participantIds: (participantIds != null
            ? participantIds.value
            : this.participantIds),
        winnerId: (winnerId != null ? winnerId.value : this.winnerId),
        winCount: (winCount != null ? winCount.value : this.winCount));
  }
}

@JsonSerializable(explicitToJson: true)
class BattleResponseDto {
  const BattleResponseDto({
    required this.id,
    required this.participantIds,
    required this.winnerId,
    required this.winCount,
    required this.lockeId,
    required this.date,
    required this.createdAt,
  });

  factory BattleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BattleResponseDtoFromJson(json);

  static const toJsonFactory = _$BattleResponseDtoToJson;
  Map<String, dynamic> toJson() => _$BattleResponseDtoToJson(this);

  @JsonKey(name: '_id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'participantIds', defaultValue: <String>[])
  final List<String> participantIds;
  @JsonKey(name: 'winnerId', defaultValue: 'default')
  final String winnerId;
  @JsonKey(name: 'winCount')
  final double winCount;
  @JsonKey(name: 'lockeId', defaultValue: 'default')
  final String lockeId;
  @JsonKey(name: 'date')
  final DateTime date;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  static const fromJsonFactory = _$BattleResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BattleResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.participantIds, participantIds) ||
                const DeepCollectionEquality()
                    .equals(other.participantIds, participantIds)) &&
            (identical(other.winnerId, winnerId) ||
                const DeepCollectionEquality()
                    .equals(other.winnerId, winnerId)) &&
            (identical(other.winCount, winCount) ||
                const DeepCollectionEquality()
                    .equals(other.winCount, winCount)) &&
            (identical(other.lockeId, lockeId) ||
                const DeepCollectionEquality()
                    .equals(other.lockeId, lockeId)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(participantIds) ^
      const DeepCollectionEquality().hash(winnerId) ^
      const DeepCollectionEquality().hash(winCount) ^
      const DeepCollectionEquality().hash(lockeId) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(createdAt) ^
      runtimeType.hashCode;
}

extension $BattleResponseDtoExtension on BattleResponseDto {
  BattleResponseDto copyWith(
      {String? id,
      List<String>? participantIds,
      String? winnerId,
      double? winCount,
      String? lockeId,
      DateTime? date,
      DateTime? createdAt}) {
    return BattleResponseDto(
        id: id ?? this.id,
        participantIds: participantIds ?? this.participantIds,
        winnerId: winnerId ?? this.winnerId,
        winCount: winCount ?? this.winCount,
        lockeId: lockeId ?? this.lockeId,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt);
  }

  BattleResponseDto copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<String>>? participantIds,
      Wrapped<String>? winnerId,
      Wrapped<double>? winCount,
      Wrapped<String>? lockeId,
      Wrapped<DateTime>? date,
      Wrapped<DateTime>? createdAt}) {
    return BattleResponseDto(
        id: (id != null ? id.value : this.id),
        participantIds: (participantIds != null
            ? participantIds.value
            : this.participantIds),
        winnerId: (winnerId != null ? winnerId.value : this.winnerId),
        winCount: (winCount != null ? winCount.value : this.winCount),
        lockeId: (lockeId != null ? lockeId.value : this.lockeId),
        date: (date != null ? date.value : this.date),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt));
  }
}

@JsonSerializable(explicitToJson: true)
class ParticipantResponseDto {
  const ParticipantResponseDto({
    required this.userId,
    required this.username,
    required this.name,
    required this.deaths,
    required this.points,
    required this.isAdmin,
  });

  factory ParticipantResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ParticipantResponseDtoFromJson(json);

  static const toJsonFactory = _$ParticipantResponseDtoToJson;
  Map<String, dynamic> toJson() => _$ParticipantResponseDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  @JsonKey(name: 'deaths')
  final double deaths;
  @JsonKey(name: 'points')
  final double points;
  @JsonKey(name: 'isAdmin')
  final bool isAdmin;
  static const fromJsonFactory = _$ParticipantResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ParticipantResponseDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.deaths, deaths) ||
                const DeepCollectionEquality().equals(other.deaths, deaths)) &&
            (identical(other.points, points) ||
                const DeepCollectionEquality().equals(other.points, points)) &&
            (identical(other.isAdmin, isAdmin) ||
                const DeepCollectionEquality().equals(other.isAdmin, isAdmin)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(deaths) ^
      const DeepCollectionEquality().hash(points) ^
      const DeepCollectionEquality().hash(isAdmin) ^
      runtimeType.hashCode;
}

extension $ParticipantResponseDtoExtension on ParticipantResponseDto {
  ParticipantResponseDto copyWith(
      {String? userId,
      String? username,
      String? name,
      double? deaths,
      double? points,
      bool? isAdmin}) {
    return ParticipantResponseDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        name: name ?? this.name,
        deaths: deaths ?? this.deaths,
        points: points ?? this.points,
        isAdmin: isAdmin ?? this.isAdmin);
  }

  ParticipantResponseDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<String>? username,
      Wrapped<String>? name,
      Wrapped<double>? deaths,
      Wrapped<double>? points,
      Wrapped<bool>? isAdmin}) {
    return ParticipantResponseDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name),
        deaths: (deaths != null ? deaths.value : this.deaths),
        points: (points != null ? points.value : this.points),
        isAdmin: (isAdmin != null ? isAdmin.value : this.isAdmin));
  }
}

@JsonSerializable(explicitToJson: true)
class AddParticipantDto {
  const AddParticipantDto({
    required this.userId,
  });

  factory AddParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$AddParticipantDtoFromJson(json);

  static const toJsonFactory = _$AddParticipantDtoToJson;
  Map<String, dynamic> toJson() => _$AddParticipantDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  static const fromJsonFactory = _$AddParticipantDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddParticipantDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^ runtimeType.hashCode;
}

extension $AddParticipantDtoExtension on AddParticipantDto {
  AddParticipantDto copyWith({String? userId}) {
    return AddParticipantDto(userId: userId ?? this.userId);
  }

  AddParticipantDto copyWithWrapped({Wrapped<String>? userId}) {
    return AddParticipantDto(
        userId: (userId != null ? userId.value : this.userId));
  }
}

String? apiLockesGetActiveNullableToJson(
    enums.ApiLockesGetActive? apiLockesGetActive) {
  return apiLockesGetActive?.value;
}

String? apiLockesGetActiveToJson(enums.ApiLockesGetActive apiLockesGetActive) {
  return apiLockesGetActive.value;
}

enums.ApiLockesGetActive apiLockesGetActiveFromJson(
  Object? apiLockesGetActive, [
  enums.ApiLockesGetActive? defaultValue,
]) {
  return enums.ApiLockesGetActive.values
          .firstWhereOrNull((e) => e.value == apiLockesGetActive) ??
      defaultValue ??
      enums.ApiLockesGetActive.swaggerGeneratedUnknown;
}

enums.ApiLockesGetActive? apiLockesGetActiveNullableFromJson(
  Object? apiLockesGetActive, [
  enums.ApiLockesGetActive? defaultValue,
]) {
  if (apiLockesGetActive == null) {
    return null;
  }
  return enums.ApiLockesGetActive.values
          .firstWhereOrNull((e) => e.value == apiLockesGetActive) ??
      defaultValue;
}

String apiLockesGetActiveExplodedListToJson(
    List<enums.ApiLockesGetActive>? apiLockesGetActive) {
  return apiLockesGetActive?.map((e) => e.value!).join(',') ?? '';
}

List<String> apiLockesGetActiveListToJson(
    List<enums.ApiLockesGetActive>? apiLockesGetActive) {
  if (apiLockesGetActive == null) {
    return [];
  }

  return apiLockesGetActive.map((e) => e.value!).toList();
}

List<enums.ApiLockesGetActive> apiLockesGetActiveListFromJson(
  List? apiLockesGetActive, [
  List<enums.ApiLockesGetActive>? defaultValue,
]) {
  if (apiLockesGetActive == null) {
    return defaultValue ?? [];
  }

  return apiLockesGetActive
      .map((e) => apiLockesGetActiveFromJson(e.toString()))
      .toList();
}

List<enums.ApiLockesGetActive>? apiLockesGetActiveNullableListFromJson(
  List? apiLockesGetActive, [
  List<enums.ApiLockesGetActive>? defaultValue,
]) {
  if (apiLockesGetActive == null) {
    return defaultValue;
  }

  return apiLockesGetActive
      .map((e) => apiLockesGetActiveFromJson(e.toString()))
      .toList();
}

String? apiLockesUserUserIdGetIncludeParticipatingNullableToJson(
    enums.ApiLockesUserUserIdGetIncludeParticipating?
        apiLockesUserUserIdGetIncludeParticipating) {
  return apiLockesUserUserIdGetIncludeParticipating?.value;
}

String? apiLockesUserUserIdGetIncludeParticipatingToJson(
    enums.ApiLockesUserUserIdGetIncludeParticipating
        apiLockesUserUserIdGetIncludeParticipating) {
  return apiLockesUserUserIdGetIncludeParticipating.value;
}

enums.ApiLockesUserUserIdGetIncludeParticipating
    apiLockesUserUserIdGetIncludeParticipatingFromJson(
  Object? apiLockesUserUserIdGetIncludeParticipating, [
  enums.ApiLockesUserUserIdGetIncludeParticipating? defaultValue,
]) {
  return enums.ApiLockesUserUserIdGetIncludeParticipating.values
          .firstWhereOrNull(
              (e) => e.value == apiLockesUserUserIdGetIncludeParticipating) ??
      defaultValue ??
      enums.ApiLockesUserUserIdGetIncludeParticipating.swaggerGeneratedUnknown;
}

enums.ApiLockesUserUserIdGetIncludeParticipating?
    apiLockesUserUserIdGetIncludeParticipatingNullableFromJson(
  Object? apiLockesUserUserIdGetIncludeParticipating, [
  enums.ApiLockesUserUserIdGetIncludeParticipating? defaultValue,
]) {
  if (apiLockesUserUserIdGetIncludeParticipating == null) {
    return null;
  }
  return enums.ApiLockesUserUserIdGetIncludeParticipating.values
          .firstWhereOrNull(
              (e) => e.value == apiLockesUserUserIdGetIncludeParticipating) ??
      defaultValue;
}

String apiLockesUserUserIdGetIncludeParticipatingExplodedListToJson(
    List<enums.ApiLockesUserUserIdGetIncludeParticipating>?
        apiLockesUserUserIdGetIncludeParticipating) {
  return apiLockesUserUserIdGetIncludeParticipating
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<String> apiLockesUserUserIdGetIncludeParticipatingListToJson(
    List<enums.ApiLockesUserUserIdGetIncludeParticipating>?
        apiLockesUserUserIdGetIncludeParticipating) {
  if (apiLockesUserUserIdGetIncludeParticipating == null) {
    return [];
  }

  return apiLockesUserUserIdGetIncludeParticipating
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiLockesUserUserIdGetIncludeParticipating>
    apiLockesUserUserIdGetIncludeParticipatingListFromJson(
  List? apiLockesUserUserIdGetIncludeParticipating, [
  List<enums.ApiLockesUserUserIdGetIncludeParticipating>? defaultValue,
]) {
  if (apiLockesUserUserIdGetIncludeParticipating == null) {
    return defaultValue ?? [];
  }

  return apiLockesUserUserIdGetIncludeParticipating
      .map((e) =>
          apiLockesUserUserIdGetIncludeParticipatingFromJson(e.toString()))
      .toList();
}

List<enums.ApiLockesUserUserIdGetIncludeParticipating>?
    apiLockesUserUserIdGetIncludeParticipatingNullableListFromJson(
  List? apiLockesUserUserIdGetIncludeParticipating, [
  List<enums.ApiLockesUserUserIdGetIncludeParticipating>? defaultValue,
]) {
  if (apiLockesUserUserIdGetIncludeParticipating == null) {
    return defaultValue;
  }

  return apiLockesUserUserIdGetIncludeParticipating
      .map((e) =>
          apiLockesUserUserIdGetIncludeParticipatingFromJson(e.toString()))
      .toList();
}

String? apiLockesUserUserIdGetActiveNullableToJson(
    enums.ApiLockesUserUserIdGetActive? apiLockesUserUserIdGetActive) {
  return apiLockesUserUserIdGetActive?.value;
}

String? apiLockesUserUserIdGetActiveToJson(
    enums.ApiLockesUserUserIdGetActive apiLockesUserUserIdGetActive) {
  return apiLockesUserUserIdGetActive.value;
}

enums.ApiLockesUserUserIdGetActive apiLockesUserUserIdGetActiveFromJson(
  Object? apiLockesUserUserIdGetActive, [
  enums.ApiLockesUserUserIdGetActive? defaultValue,
]) {
  return enums.ApiLockesUserUserIdGetActive.values
          .firstWhereOrNull((e) => e.value == apiLockesUserUserIdGetActive) ??
      defaultValue ??
      enums.ApiLockesUserUserIdGetActive.swaggerGeneratedUnknown;
}

enums.ApiLockesUserUserIdGetActive?
    apiLockesUserUserIdGetActiveNullableFromJson(
  Object? apiLockesUserUserIdGetActive, [
  enums.ApiLockesUserUserIdGetActive? defaultValue,
]) {
  if (apiLockesUserUserIdGetActive == null) {
    return null;
  }
  return enums.ApiLockesUserUserIdGetActive.values
          .firstWhereOrNull((e) => e.value == apiLockesUserUserIdGetActive) ??
      defaultValue;
}

String apiLockesUserUserIdGetActiveExplodedListToJson(
    List<enums.ApiLockesUserUserIdGetActive>? apiLockesUserUserIdGetActive) {
  return apiLockesUserUserIdGetActive?.map((e) => e.value!).join(',') ?? '';
}

List<String> apiLockesUserUserIdGetActiveListToJson(
    List<enums.ApiLockesUserUserIdGetActive>? apiLockesUserUserIdGetActive) {
  if (apiLockesUserUserIdGetActive == null) {
    return [];
  }

  return apiLockesUserUserIdGetActive.map((e) => e.value!).toList();
}

List<enums.ApiLockesUserUserIdGetActive>
    apiLockesUserUserIdGetActiveListFromJson(
  List? apiLockesUserUserIdGetActive, [
  List<enums.ApiLockesUserUserIdGetActive>? defaultValue,
]) {
  if (apiLockesUserUserIdGetActive == null) {
    return defaultValue ?? [];
  }

  return apiLockesUserUserIdGetActive
      .map((e) => apiLockesUserUserIdGetActiveFromJson(e.toString()))
      .toList();
}

List<enums.ApiLockesUserUserIdGetActive>?
    apiLockesUserUserIdGetActiveNullableListFromJson(
  List? apiLockesUserUserIdGetActive, [
  List<enums.ApiLockesUserUserIdGetActive>? defaultValue,
]) {
  if (apiLockesUserUserIdGetActive == null) {
    return defaultValue;
  }

  return apiLockesUserUserIdGetActive
      .map((e) => apiLockesUserUserIdGetActiveFromJson(e.toString()))
      .toList();
}

String? apiLockesMyLockesGetIncludeParticipatingNullableToJson(
    enums.ApiLockesMyLockesGetIncludeParticipating?
        apiLockesMyLockesGetIncludeParticipating) {
  return apiLockesMyLockesGetIncludeParticipating?.value;
}

String? apiLockesMyLockesGetIncludeParticipatingToJson(
    enums.ApiLockesMyLockesGetIncludeParticipating
        apiLockesMyLockesGetIncludeParticipating) {
  return apiLockesMyLockesGetIncludeParticipating.value;
}

enums.ApiLockesMyLockesGetIncludeParticipating
    apiLockesMyLockesGetIncludeParticipatingFromJson(
  Object? apiLockesMyLockesGetIncludeParticipating, [
  enums.ApiLockesMyLockesGetIncludeParticipating? defaultValue,
]) {
  return enums.ApiLockesMyLockesGetIncludeParticipating.values.firstWhereOrNull(
          (e) => e.value == apiLockesMyLockesGetIncludeParticipating) ??
      defaultValue ??
      enums.ApiLockesMyLockesGetIncludeParticipating.swaggerGeneratedUnknown;
}

enums.ApiLockesMyLockesGetIncludeParticipating?
    apiLockesMyLockesGetIncludeParticipatingNullableFromJson(
  Object? apiLockesMyLockesGetIncludeParticipating, [
  enums.ApiLockesMyLockesGetIncludeParticipating? defaultValue,
]) {
  if (apiLockesMyLockesGetIncludeParticipating == null) {
    return null;
  }
  return enums.ApiLockesMyLockesGetIncludeParticipating.values.firstWhereOrNull(
          (e) => e.value == apiLockesMyLockesGetIncludeParticipating) ??
      defaultValue;
}

String apiLockesMyLockesGetIncludeParticipatingExplodedListToJson(
    List<enums.ApiLockesMyLockesGetIncludeParticipating>?
        apiLockesMyLockesGetIncludeParticipating) {
  return apiLockesMyLockesGetIncludeParticipating
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<String> apiLockesMyLockesGetIncludeParticipatingListToJson(
    List<enums.ApiLockesMyLockesGetIncludeParticipating>?
        apiLockesMyLockesGetIncludeParticipating) {
  if (apiLockesMyLockesGetIncludeParticipating == null) {
    return [];
  }

  return apiLockesMyLockesGetIncludeParticipating.map((e) => e.value!).toList();
}

List<enums.ApiLockesMyLockesGetIncludeParticipating>
    apiLockesMyLockesGetIncludeParticipatingListFromJson(
  List? apiLockesMyLockesGetIncludeParticipating, [
  List<enums.ApiLockesMyLockesGetIncludeParticipating>? defaultValue,
]) {
  if (apiLockesMyLockesGetIncludeParticipating == null) {
    return defaultValue ?? [];
  }

  return apiLockesMyLockesGetIncludeParticipating
      .map(
          (e) => apiLockesMyLockesGetIncludeParticipatingFromJson(e.toString()))
      .toList();
}

List<enums.ApiLockesMyLockesGetIncludeParticipating>?
    apiLockesMyLockesGetIncludeParticipatingNullableListFromJson(
  List? apiLockesMyLockesGetIncludeParticipating, [
  List<enums.ApiLockesMyLockesGetIncludeParticipating>? defaultValue,
]) {
  if (apiLockesMyLockesGetIncludeParticipating == null) {
    return defaultValue;
  }

  return apiLockesMyLockesGetIncludeParticipating
      .map(
          (e) => apiLockesMyLockesGetIncludeParticipatingFromJson(e.toString()))
      .toList();
}

String? apiLockesMyLockesGetActiveNullableToJson(
    enums.ApiLockesMyLockesGetActive? apiLockesMyLockesGetActive) {
  return apiLockesMyLockesGetActive?.value;
}

String? apiLockesMyLockesGetActiveToJson(
    enums.ApiLockesMyLockesGetActive apiLockesMyLockesGetActive) {
  return apiLockesMyLockesGetActive.value;
}

enums.ApiLockesMyLockesGetActive apiLockesMyLockesGetActiveFromJson(
  Object? apiLockesMyLockesGetActive, [
  enums.ApiLockesMyLockesGetActive? defaultValue,
]) {
  return enums.ApiLockesMyLockesGetActive.values
          .firstWhereOrNull((e) => e.value == apiLockesMyLockesGetActive) ??
      defaultValue ??
      enums.ApiLockesMyLockesGetActive.swaggerGeneratedUnknown;
}

enums.ApiLockesMyLockesGetActive? apiLockesMyLockesGetActiveNullableFromJson(
  Object? apiLockesMyLockesGetActive, [
  enums.ApiLockesMyLockesGetActive? defaultValue,
]) {
  if (apiLockesMyLockesGetActive == null) {
    return null;
  }
  return enums.ApiLockesMyLockesGetActive.values
          .firstWhereOrNull((e) => e.value == apiLockesMyLockesGetActive) ??
      defaultValue;
}

String apiLockesMyLockesGetActiveExplodedListToJson(
    List<enums.ApiLockesMyLockesGetActive>? apiLockesMyLockesGetActive) {
  return apiLockesMyLockesGetActive?.map((e) => e.value!).join(',') ?? '';
}

List<String> apiLockesMyLockesGetActiveListToJson(
    List<enums.ApiLockesMyLockesGetActive>? apiLockesMyLockesGetActive) {
  if (apiLockesMyLockesGetActive == null) {
    return [];
  }

  return apiLockesMyLockesGetActive.map((e) => e.value!).toList();
}

List<enums.ApiLockesMyLockesGetActive> apiLockesMyLockesGetActiveListFromJson(
  List? apiLockesMyLockesGetActive, [
  List<enums.ApiLockesMyLockesGetActive>? defaultValue,
]) {
  if (apiLockesMyLockesGetActive == null) {
    return defaultValue ?? [];
  }

  return apiLockesMyLockesGetActive
      .map((e) => apiLockesMyLockesGetActiveFromJson(e.toString()))
      .toList();
}

List<enums.ApiLockesMyLockesGetActive>?
    apiLockesMyLockesGetActiveNullableListFromJson(
  List? apiLockesMyLockesGetActive, [
  List<enums.ApiLockesMyLockesGetActive>? defaultValue,
]) {
  if (apiLockesMyLockesGetActive == null) {
    return defaultValue;
  }

  return apiLockesMyLockesGetActive
      .map((e) => apiLockesMyLockesGetActiveFromJson(e.toString()))
      .toList();
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
