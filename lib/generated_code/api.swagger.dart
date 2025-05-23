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

  ///Register a new user
  Future<chopper.Response<RegisterResponseDto>> apiAuthRegisterPost(
      {required RegisterDto? body}) {
    generatedMapping.putIfAbsent(
        RegisterResponseDto, () => RegisterResponseDto.fromJsonFactory);

    return _apiAuthRegisterPost(body: body);
  }

  ///Register a new user
  @Post(
    path: '/api/auth/register',
    optionalBody: true,
  )
  Future<chopper.Response<RegisterResponseDto>> _apiAuthRegisterPost(
      {@Body() required RegisterDto? body});

  ///Login with username and password
  Future<chopper.Response<LoginResponseDto>> apiAuthLoginPost(
      {required LoginDto? body}) {
    generatedMapping.putIfAbsent(
        LoginResponseDto, () => LoginResponseDto.fromJsonFactory);

    return _apiAuthLoginPost(body: body);
  }

  ///Login with username and password
  @Post(
    path: '/api/auth/login',
    optionalBody: true,
  )
  Future<chopper.Response<LoginResponseDto>> _apiAuthLoginPost(
      {@Body() required LoginDto? body});

  ///Validate JWT token and get user info
  Future<chopper.Response<ValidateResponseDto>> apiAuthValidateGet() {
    generatedMapping.putIfAbsent(
        ValidateResponseDto, () => ValidateResponseDto.fromJsonFactory);

    return _apiAuthValidateGet();
  }

  ///Validate JWT token and get user info
  @Get(path: '/api/auth/validate')
  Future<chopper.Response<ValidateResponseDto>> _apiAuthValidateGet();

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

  ///Registrar o programar una batalla en un locke
  ///@param id
  Future<chopper.Response<EnrichedBattleResponseDto>> apiLockesIdBattlesPost({
    required String? id,
    required CreateBattleDto? body,
  }) {
    generatedMapping.putIfAbsent(EnrichedBattleResponseDto,
        () => EnrichedBattleResponseDto.fromJsonFactory);

    return _apiLockesIdBattlesPost(id: id, body: body);
  }

  ///Registrar o programar una batalla en un locke
  ///@param id
  @Post(
    path: '/api/lockes/{id}/battles',
    optionalBody: true,
  )
  Future<chopper.Response<EnrichedBattleResponseDto>> _apiLockesIdBattlesPost({
    @Path('id') required String? id,
    @Body() required CreateBattleDto? body,
  });

  ///Obtener todas las batallas de un locke
  ///@param id
  Future<chopper.Response<List<EnrichedBattleResponseDto>>>
      apiLockesIdBattlesGet({required String? id}) {
    generatedMapping.putIfAbsent(EnrichedBattleResponseDto,
        () => EnrichedBattleResponseDto.fromJsonFactory);

    return _apiLockesIdBattlesGet(id: id);
  }

  ///Obtener todas las batallas de un locke
  ///@param id
  @Get(path: '/api/lockes/{id}/battles')
  Future<chopper.Response<List<EnrichedBattleResponseDto>>>
      _apiLockesIdBattlesGet({@Path('id') required String? id});

  ///Actualizar una batalla (estado, resultados, etc.)
  ///@param battleId
  Future<chopper.Response<EnrichedBattleResponseDto>>
      apiLockesBattlesBattleIdPatch({
    required String? battleId,
    required UpdateBattleDto? body,
  }) {
    generatedMapping.putIfAbsent(EnrichedBattleResponseDto,
        () => EnrichedBattleResponseDto.fromJsonFactory);

    return _apiLockesBattlesBattleIdPatch(battleId: battleId, body: body);
  }

  ///Actualizar una batalla (estado, resultados, etc.)
  ///@param battleId
  @Patch(
    path: '/api/lockes/battles/{battleId}',
    optionalBody: true,
  )
  Future<chopper.Response<EnrichedBattleResponseDto>>
      _apiLockesBattlesBattleIdPatch({
    @Path('battleId') required String? battleId,
    @Body() required UpdateBattleDto? body,
  });

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

  ///Get statistics for the authenticated user
  Future<chopper.Response<UserStatisticsDto>> apiStatisticsMeGet() {
    generatedMapping.putIfAbsent(
        UserStatisticsDto, () => UserStatisticsDto.fromJsonFactory);

    return _apiStatisticsMeGet();
  }

  ///Get statistics for the authenticated user
  @Get(path: '/api/statistics/me')
  Future<chopper.Response<UserStatisticsDto>> _apiStatisticsMeGet();

  ///Get statistics for a specific user
  ///@param userId The ID of the user to get statistics for
  Future<chopper.Response<UserStatisticsDto>> apiStatisticsUserUserIdGet(
      {required String? userId}) {
    generatedMapping.putIfAbsent(
        UserStatisticsDto, () => UserStatisticsDto.fromJsonFactory);

    return _apiStatisticsUserUserIdGet(userId: userId);
  }

  ///Get statistics for a specific user
  ///@param userId The ID of the user to get statistics for
  @Get(path: '/api/statistics/user/{userId}')
  Future<chopper.Response<UserStatisticsDto>> _apiStatisticsUserUserIdGet(
      {@Path('userId') required String? userId});

  ///Get rankings of all users based on their statistics
  Future<chopper.Response<List<UserStatisticsDto>>> apiStatisticsRankingsGet() {
    generatedMapping.putIfAbsent(
        UserStatisticsDto, () => UserStatisticsDto.fromJsonFactory);

    return _apiStatisticsRankingsGet();
  }

  ///Get rankings of all users based on their statistics
  @Get(path: '/api/statistics/rankings')
  Future<chopper.Response<List<UserStatisticsDto>>> _apiStatisticsRankingsGet();
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
class RegisterDto {
  const RegisterDto({
    required this.name,
    required this.username,
    required this.password,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterDtoFromJson(json);

  static const toJsonFactory = _$RegisterDtoToJson;
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'password', defaultValue: 'default')
  final String password;
  static const fromJsonFactory = _$RegisterDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterDto &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
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
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $RegisterDtoExtension on RegisterDto {
  RegisterDto copyWith({String? name, String? username, String? password}) {
    return RegisterDto(
        name: name ?? this.name,
        username: username ?? this.username,
        password: password ?? this.password);
  }

  RegisterDto copyWithWrapped(
      {Wrapped<String>? name,
      Wrapped<String>? username,
      Wrapped<String>? password}) {
    return RegisterDto(
        name: (name != null ? name.value : this.name),
        username: (username != null ? username.value : this.username),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class UserInfoDto {
  const UserInfoDto({
    required this.name,
    required this.username,
  });

  factory UserInfoDto.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDtoFromJson(json);

  static const toJsonFactory = _$UserInfoDtoToJson;
  Map<String, dynamic> toJson() => _$UserInfoDtoToJson(this);

  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  static const fromJsonFactory = _$UserInfoDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserInfoDto &&
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
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(username) ^
      runtimeType.hashCode;
}

extension $UserInfoDtoExtension on UserInfoDto {
  UserInfoDto copyWith({String? name, String? username}) {
    return UserInfoDto(
        name: name ?? this.name, username: username ?? this.username);
  }

  UserInfoDto copyWithWrapped(
      {Wrapped<String>? name, Wrapped<String>? username}) {
    return UserInfoDto(
        name: (name != null ? name.value : this.name),
        username: (username != null ? username.value : this.username));
  }
}

@JsonSerializable(explicitToJson: true)
class RegisterResponseDto {
  const RegisterResponseDto({
    required this.user,
    required this.id,
    required this.accessToken,
    required this.success,
  });

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);

  static const toJsonFactory = _$RegisterResponseDtoToJson;
  Map<String, dynamic> toJson() => _$RegisterResponseDtoToJson(this);

  @JsonKey(name: 'user')
  final UserInfoDto user;
  @JsonKey(name: 'id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'access_token', defaultValue: 'default')
  final String accessToken;
  @JsonKey(name: 'success')
  final bool success;
  static const fromJsonFactory = _$RegisterResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterResponseDto &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
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
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $RegisterResponseDtoExtension on RegisterResponseDto {
  RegisterResponseDto copyWith(
      {UserInfoDto? user, String? id, String? accessToken, bool? success}) {
    return RegisterResponseDto(
        user: user ?? this.user,
        id: id ?? this.id,
        accessToken: accessToken ?? this.accessToken,
        success: success ?? this.success);
  }

  RegisterResponseDto copyWithWrapped(
      {Wrapped<UserInfoDto>? user,
      Wrapped<String>? id,
      Wrapped<String>? accessToken,
      Wrapped<bool>? success}) {
    return RegisterResponseDto(
        user: (user != null ? user.value : this.user),
        id: (id != null ? id.value : this.id),
        accessToken:
            (accessToken != null ? accessToken.value : this.accessToken),
        success: (success != null ? success.value : this.success));
  }
}

@JsonSerializable(explicitToJson: true)
class ErrorResponseDto {
  const ErrorResponseDto({
    required this.statusCode,
    required this.message,
    required this.error,
    required this.success,
  });

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseDtoFromJson(json);

  static const toJsonFactory = _$ErrorResponseDtoToJson;
  Map<String, dynamic> toJson() => _$ErrorResponseDtoToJson(this);

  @JsonKey(name: 'statusCode')
  final double statusCode;
  @JsonKey(name: 'message')
  final dynamic message;
  @JsonKey(name: 'error', defaultValue: 'default')
  final String error;
  @JsonKey(name: 'success')
  final bool success;
  static const fromJsonFactory = _$ErrorResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ErrorResponseDto &&
            (identical(other.statusCode, statusCode) ||
                const DeepCollectionEquality()
                    .equals(other.statusCode, statusCode)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(other.success, success)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(statusCode) ^
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $ErrorResponseDtoExtension on ErrorResponseDto {
  ErrorResponseDto copyWith(
      {double? statusCode, dynamic message, String? error, bool? success}) {
    return ErrorResponseDto(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        error: error ?? this.error,
        success: success ?? this.success);
  }

  ErrorResponseDto copyWithWrapped(
      {Wrapped<double>? statusCode,
      Wrapped<dynamic>? message,
      Wrapped<String>? error,
      Wrapped<bool>? success}) {
    return ErrorResponseDto(
        statusCode: (statusCode != null ? statusCode.value : this.statusCode),
        message: (message != null ? message.value : this.message),
        error: (error != null ? error.value : this.error),
        success: (success != null ? success.value : this.success));
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
    required this.user,
    required this.id,
    required this.accessToken,
    required this.success,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  static const toJsonFactory = _$LoginResponseDtoToJson;
  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);

  @JsonKey(name: 'user')
  final UserInfoDto user;
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
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
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
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $LoginResponseDtoExtension on LoginResponseDto {
  LoginResponseDto copyWith(
      {UserInfoDto? user, String? id, String? accessToken, bool? success}) {
    return LoginResponseDto(
        user: user ?? this.user,
        id: id ?? this.id,
        accessToken: accessToken ?? this.accessToken,
        success: success ?? this.success);
  }

  LoginResponseDto copyWithWrapped(
      {Wrapped<UserInfoDto>? user,
      Wrapped<String>? id,
      Wrapped<String>? accessToken,
      Wrapped<bool>? success}) {
    return LoginResponseDto(
        user: (user != null ? user.value : this.user),
        id: (id != null ? id.value : this.id),
        accessToken:
            (accessToken != null ? accessToken.value : this.accessToken),
        success: (success != null ? success.value : this.success));
  }
}

@JsonSerializable(explicitToJson: true)
class ValidateResponseDto {
  const ValidateResponseDto({
    required this.user,
    required this.id,
    required this.accessToken,
    required this.success,
  });

  factory ValidateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ValidateResponseDtoFromJson(json);

  static const toJsonFactory = _$ValidateResponseDtoToJson;
  Map<String, dynamic> toJson() => _$ValidateResponseDtoToJson(this);

  @JsonKey(name: 'user')
  final UserInfoDto user;
  @JsonKey(name: 'id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'access_token', defaultValue: 'default')
  final String accessToken;
  @JsonKey(name: 'success')
  final bool success;
  static const fromJsonFactory = _$ValidateResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidateResponseDto &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)) &&
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
      const DeepCollectionEquality().hash(user) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(success) ^
      runtimeType.hashCode;
}

extension $ValidateResponseDtoExtension on ValidateResponseDto {
  ValidateResponseDto copyWith(
      {UserInfoDto? user, String? id, String? accessToken, bool? success}) {
    return ValidateResponseDto(
        user: user ?? this.user,
        id: id ?? this.id,
        accessToken: accessToken ?? this.accessToken,
        success: success ?? this.success);
  }

  ValidateResponseDto copyWithWrapped(
      {Wrapped<UserInfoDto>? user,
      Wrapped<String>? id,
      Wrapped<String>? accessToken,
      Wrapped<bool>? success}) {
    return ValidateResponseDto(
        user: (user != null ? user.value : this.user),
        id: (id != null ? id.value : this.id),
        accessToken:
            (accessToken != null ? accessToken.value : this.accessToken),
        success: (success != null ? success.value : this.success));
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
class Score {
  const Score({
    required this.mcm,
    required this.wcm,
  });

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  static const toJsonFactory = _$ScoreToJson;
  Map<String, dynamic> toJson() => _$ScoreToJson(this);

  @JsonKey(name: 'mcm')
  final double mcm;
  @JsonKey(name: 'wcm')
  final double wcm;
  static const fromJsonFactory = _$ScoreFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Score &&
            (identical(other.mcm, mcm) ||
                const DeepCollectionEquality().equals(other.mcm, mcm)) &&
            (identical(other.wcm, wcm) ||
                const DeepCollectionEquality().equals(other.wcm, wcm)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(mcm) ^
      const DeepCollectionEquality().hash(wcm) ^
      runtimeType.hashCode;
}

extension $ScoreExtension on Score {
  Score copyWith({double? mcm, double? wcm}) {
    return Score(mcm: mcm ?? this.mcm, wcm: wcm ?? this.wcm);
  }

  Score copyWithWrapped({Wrapped<double>? mcm, Wrapped<double>? wcm}) {
    return Score(
        mcm: (mcm != null ? mcm.value : this.mcm),
        wcm: (wcm != null ? wcm.value : this.wcm));
  }
}

@JsonSerializable(explicitToJson: true)
class EnrichedParticipantResponseDto {
  const EnrichedParticipantResponseDto({
    required this.userId,
    required this.username,
    required this.name,
    required this.deaths,
    required this.isAdmin,
    required this.score,
    required this.points,
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
  @JsonKey(name: 'isAdmin')
  final bool isAdmin;
  @JsonKey(name: 'score')
  final Score score;
  @JsonKey(name: 'points')
  final double points;
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
            (identical(other.isAdmin, isAdmin) ||
                const DeepCollectionEquality()
                    .equals(other.isAdmin, isAdmin)) &&
            (identical(other.score, score) ||
                const DeepCollectionEquality().equals(other.score, score)) &&
            (identical(other.points, points) ||
                const DeepCollectionEquality().equals(other.points, points)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(deaths) ^
      const DeepCollectionEquality().hash(isAdmin) ^
      const DeepCollectionEquality().hash(score) ^
      const DeepCollectionEquality().hash(points) ^
      runtimeType.hashCode;
}

extension $EnrichedParticipantResponseDtoExtension
    on EnrichedParticipantResponseDto {
  EnrichedParticipantResponseDto copyWith(
      {String? userId,
      String? username,
      String? name,
      double? deaths,
      bool? isAdmin,
      Score? score,
      double? points}) {
    return EnrichedParticipantResponseDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        name: name ?? this.name,
        deaths: deaths ?? this.deaths,
        isAdmin: isAdmin ?? this.isAdmin,
        score: score ?? this.score,
        points: points ?? this.points);
  }

  EnrichedParticipantResponseDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<String>? username,
      Wrapped<String>? name,
      Wrapped<double>? deaths,
      Wrapped<bool>? isAdmin,
      Wrapped<Score>? score,
      Wrapped<double>? points}) {
    return EnrichedParticipantResponseDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name),
        deaths: (deaths != null ? deaths.value : this.deaths),
        isAdmin: (isAdmin != null ? isAdmin.value : this.isAdmin),
        score: (score != null ? score.value : this.score),
        points: (points != null ? points.value : this.points));
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
class ParticipantResultDto {
  const ParticipantResultDto({
    required this.userId,
    required this.score,
  });

  factory ParticipantResultDto.fromJson(Map<String, dynamic> json) =>
      _$ParticipantResultDtoFromJson(json);

  static const toJsonFactory = _$ParticipantResultDtoToJson;
  Map<String, dynamic> toJson() => _$ParticipantResultDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  @JsonKey(name: 'score')
  final double score;
  static const fromJsonFactory = _$ParticipantResultDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ParticipantResultDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.score, score) ||
                const DeepCollectionEquality().equals(other.score, score)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(score) ^
      runtimeType.hashCode;
}

extension $ParticipantResultDtoExtension on ParticipantResultDto {
  ParticipantResultDto copyWith({String? userId, double? score}) {
    return ParticipantResultDto(
        userId: userId ?? this.userId, score: score ?? this.score);
  }

  ParticipantResultDto copyWithWrapped(
      {Wrapped<String>? userId, Wrapped<double>? score}) {
    return ParticipantResultDto(
        userId: (userId != null ? userId.value : this.userId),
        score: (score != null ? score.value : this.score));
  }
}

@JsonSerializable(explicitToJson: true)
class CreateBattleDto {
  const CreateBattleDto({
    required this.participantIds,
    required this.status,
    required this.results,
    required this.bestOf,
    this.date,
    required this.notes,
  });

  factory CreateBattleDto.fromJson(Map<String, dynamic> json) =>
      _$CreateBattleDtoFromJson(json);

  static const toJsonFactory = _$CreateBattleDtoToJson;
  Map<String, dynamic> toJson() => _$CreateBattleDtoToJson(this);

  @JsonKey(name: 'participantIds', defaultValue: <String>[])
  final List<String> participantIds;
  @JsonKey(
    name: 'status',
    toJson: createBattleDtoStatusToJson,
    fromJson: createBattleDtoStatusStatusFromJson,
  )
  final enums.CreateBattleDtoStatus status;
  static enums.CreateBattleDtoStatus createBattleDtoStatusStatusFromJson(
          Object? value) =>
      createBattleDtoStatusFromJson(
          value, enums.CreateBattleDtoStatus.scheduled);

  @JsonKey(name: 'results', defaultValue: <ParticipantResultDto>[])
  final List<ParticipantResultDto> results;
  @JsonKey(name: 'bestOf')
  final double bestOf;
  @JsonKey(name: 'date')
  final DateTime? date;
  @JsonKey(name: 'notes', defaultValue: 'default')
  final String notes;
  static const fromJsonFactory = _$CreateBattleDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateBattleDto &&
            (identical(other.participantIds, participantIds) ||
                const DeepCollectionEquality()
                    .equals(other.participantIds, participantIds)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.results, results) ||
                const DeepCollectionEquality()
                    .equals(other.results, results)) &&
            (identical(other.bestOf, bestOf) ||
                const DeepCollectionEquality().equals(other.bestOf, bestOf)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(participantIds) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(results) ^
      const DeepCollectionEquality().hash(bestOf) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(notes) ^
      runtimeType.hashCode;
}

extension $CreateBattleDtoExtension on CreateBattleDto {
  CreateBattleDto copyWith(
      {List<String>? participantIds,
      enums.CreateBattleDtoStatus? status,
      List<ParticipantResultDto>? results,
      double? bestOf,
      DateTime? date,
      String? notes}) {
    return CreateBattleDto(
        participantIds: participantIds ?? this.participantIds,
        status: status ?? this.status,
        results: results ?? this.results,
        bestOf: bestOf ?? this.bestOf,
        date: date ?? this.date,
        notes: notes ?? this.notes);
  }

  CreateBattleDto copyWithWrapped(
      {Wrapped<List<String>>? participantIds,
      Wrapped<enums.CreateBattleDtoStatus>? status,
      Wrapped<List<ParticipantResultDto>>? results,
      Wrapped<double>? bestOf,
      Wrapped<DateTime?>? date,
      Wrapped<String>? notes}) {
    return CreateBattleDto(
        participantIds: (participantIds != null
            ? participantIds.value
            : this.participantIds),
        status: (status != null ? status.value : this.status),
        results: (results != null ? results.value : this.results),
        bestOf: (bestOf != null ? bestOf.value : this.bestOf),
        date: (date != null ? date.value : this.date),
        notes: (notes != null ? notes.value : this.notes));
  }
}

@JsonSerializable(explicitToJson: true)
class EnrichedResultDto {
  const EnrichedResultDto({
    required this.userId,
    required this.score,
    required this.username,
    required this.name,
  });

  factory EnrichedResultDto.fromJson(Map<String, dynamic> json) =>
      _$EnrichedResultDtoFromJson(json);

  static const toJsonFactory = _$EnrichedResultDtoToJson;
  Map<String, dynamic> toJson() => _$EnrichedResultDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  @JsonKey(name: 'score')
  final double score;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  static const fromJsonFactory = _$EnrichedResultDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnrichedResultDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.score, score) ||
                const DeepCollectionEquality().equals(other.score, score)) &&
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
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(score) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $EnrichedResultDtoExtension on EnrichedResultDto {
  EnrichedResultDto copyWith(
      {String? userId, double? score, String? username, String? name}) {
    return EnrichedResultDto(
        userId: userId ?? this.userId,
        score: score ?? this.score,
        username: username ?? this.username,
        name: name ?? this.name);
  }

  EnrichedResultDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<double>? score,
      Wrapped<String>? username,
      Wrapped<String>? name}) {
    return EnrichedResultDto(
        userId: (userId != null ? userId.value : this.userId),
        score: (score != null ? score.value : this.score),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class EnrichedParticipantDto {
  const EnrichedParticipantDto({
    required this.userId,
    required this.username,
    required this.name,
  });

  factory EnrichedParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$EnrichedParticipantDtoFromJson(json);

  static const toJsonFactory = _$EnrichedParticipantDtoToJson;
  Map<String, dynamic> toJson() => _$EnrichedParticipantDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'name', defaultValue: 'default')
  final String name;
  static const fromJsonFactory = _$EnrichedParticipantDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnrichedParticipantDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
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
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $EnrichedParticipantDtoExtension on EnrichedParticipantDto {
  EnrichedParticipantDto copyWith(
      {String? userId, String? username, String? name}) {
    return EnrichedParticipantDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        name: name ?? this.name);
  }

  EnrichedParticipantDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<String>? username,
      Wrapped<String>? name}) {
    return EnrichedParticipantDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name));
  }
}

@JsonSerializable(explicitToJson: true)
class EnrichedBattleResponseDto {
  const EnrichedBattleResponseDto({
    required this.id,
    required this.participantIds,
    required this.status,
    required this.results,
    required this.bestOf,
    required this.lockeId,
    this.date,
    this.notes,
    required this.createdAt,
    this.participants,
  });

  factory EnrichedBattleResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EnrichedBattleResponseDtoFromJson(json);

  static const toJsonFactory = _$EnrichedBattleResponseDtoToJson;
  Map<String, dynamic> toJson() => _$EnrichedBattleResponseDtoToJson(this);

  @JsonKey(name: '_id', defaultValue: 'default')
  final String id;
  @JsonKey(name: 'participantIds', defaultValue: <String>[])
  final List<String> participantIds;
  @JsonKey(
    name: 'status',
    toJson: enrichedBattleResponseDtoStatusToJson,
    fromJson: enrichedBattleResponseDtoStatusFromJson,
  )
  final enums.EnrichedBattleResponseDtoStatus status;
  @JsonKey(name: 'results', defaultValue: <EnrichedResultDto>[])
  final List<EnrichedResultDto> results;
  @JsonKey(name: 'bestOf')
  final double bestOf;
  @JsonKey(name: 'lockeId', defaultValue: 'default')
  final String lockeId;
  @JsonKey(name: 'date')
  final DateTime? date;
  @JsonKey(name: 'notes', defaultValue: 'default')
  final String? notes;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'participants', defaultValue: <EnrichedParticipantDto>[])
  final List<EnrichedParticipantDto>? participants;
  static const fromJsonFactory = _$EnrichedBattleResponseDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is EnrichedBattleResponseDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.participantIds, participantIds) ||
                const DeepCollectionEquality()
                    .equals(other.participantIds, participantIds)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.results, results) ||
                const DeepCollectionEquality()
                    .equals(other.results, results)) &&
            (identical(other.bestOf, bestOf) ||
                const DeepCollectionEquality().equals(other.bestOf, bestOf)) &&
            (identical(other.lockeId, lockeId) ||
                const DeepCollectionEquality()
                    .equals(other.lockeId, lockeId)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.participants, participants) ||
                const DeepCollectionEquality()
                    .equals(other.participants, participants)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(participantIds) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(results) ^
      const DeepCollectionEquality().hash(bestOf) ^
      const DeepCollectionEquality().hash(lockeId) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(notes) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(participants) ^
      runtimeType.hashCode;
}

extension $EnrichedBattleResponseDtoExtension on EnrichedBattleResponseDto {
  EnrichedBattleResponseDto copyWith(
      {String? id,
      List<String>? participantIds,
      enums.EnrichedBattleResponseDtoStatus? status,
      List<EnrichedResultDto>? results,
      double? bestOf,
      String? lockeId,
      DateTime? date,
      String? notes,
      DateTime? createdAt,
      List<EnrichedParticipantDto>? participants}) {
    return EnrichedBattleResponseDto(
        id: id ?? this.id,
        participantIds: participantIds ?? this.participantIds,
        status: status ?? this.status,
        results: results ?? this.results,
        bestOf: bestOf ?? this.bestOf,
        lockeId: lockeId ?? this.lockeId,
        date: date ?? this.date,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        participants: participants ?? this.participants);
  }

  EnrichedBattleResponseDto copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<List<String>>? participantIds,
      Wrapped<enums.EnrichedBattleResponseDtoStatus>? status,
      Wrapped<List<EnrichedResultDto>>? results,
      Wrapped<double>? bestOf,
      Wrapped<String>? lockeId,
      Wrapped<DateTime?>? date,
      Wrapped<String?>? notes,
      Wrapped<DateTime>? createdAt,
      Wrapped<List<EnrichedParticipantDto>?>? participants}) {
    return EnrichedBattleResponseDto(
        id: (id != null ? id.value : this.id),
        participantIds: (participantIds != null
            ? participantIds.value
            : this.participantIds),
        status: (status != null ? status.value : this.status),
        results: (results != null ? results.value : this.results),
        bestOf: (bestOf != null ? bestOf.value : this.bestOf),
        lockeId: (lockeId != null ? lockeId.value : this.lockeId),
        date: (date != null ? date.value : this.date),
        notes: (notes != null ? notes.value : this.notes),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt),
        participants:
            (participants != null ? participants.value : this.participants));
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateBattleDto {
  const UpdateBattleDto({
    this.status,
    this.results,
    this.date,
    this.notes,
  });

  factory UpdateBattleDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateBattleDtoFromJson(json);

  static const toJsonFactory = _$UpdateBattleDtoToJson;
  Map<String, dynamic> toJson() => _$UpdateBattleDtoToJson(this);

  @JsonKey(
    name: 'status',
    toJson: updateBattleDtoStatusNullableToJson,
    fromJson: updateBattleDtoStatusNullableFromJson,
  )
  final enums.UpdateBattleDtoStatus? status;
  @JsonKey(name: 'results', defaultValue: <ParticipantResultDto>[])
  final List<ParticipantResultDto>? results;
  @JsonKey(name: 'date')
  final DateTime? date;
  @JsonKey(name: 'notes', defaultValue: 'default')
  final String? notes;
  static const fromJsonFactory = _$UpdateBattleDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateBattleDto &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.results, results) ||
                const DeepCollectionEquality()
                    .equals(other.results, results)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.notes, notes) ||
                const DeepCollectionEquality().equals(other.notes, notes)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(results) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(notes) ^
      runtimeType.hashCode;
}

extension $UpdateBattleDtoExtension on UpdateBattleDto {
  UpdateBattleDto copyWith(
      {enums.UpdateBattleDtoStatus? status,
      List<ParticipantResultDto>? results,
      DateTime? date,
      String? notes}) {
    return UpdateBattleDto(
        status: status ?? this.status,
        results: results ?? this.results,
        date: date ?? this.date,
        notes: notes ?? this.notes);
  }

  UpdateBattleDto copyWithWrapped(
      {Wrapped<enums.UpdateBattleDtoStatus?>? status,
      Wrapped<List<ParticipantResultDto>?>? results,
      Wrapped<DateTime?>? date,
      Wrapped<String?>? notes}) {
    return UpdateBattleDto(
        status: (status != null ? status.value : this.status),
        results: (results != null ? results.value : this.results),
        date: (date != null ? date.value : this.date),
        notes: (notes != null ? notes.value : this.notes));
  }
}

@JsonSerializable(explicitToJson: true)
class ParticipantResponseDto {
  const ParticipantResponseDto({
    required this.userId,
    required this.username,
    required this.name,
    required this.deaths,
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
      const DeepCollectionEquality().hash(isAdmin) ^
      runtimeType.hashCode;
}

extension $ParticipantResponseDtoExtension on ParticipantResponseDto {
  ParticipantResponseDto copyWith(
      {String? userId,
      String? username,
      String? name,
      double? deaths,
      bool? isAdmin}) {
    return ParticipantResponseDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        name: name ?? this.name,
        deaths: deaths ?? this.deaths,
        isAdmin: isAdmin ?? this.isAdmin);
  }

  ParticipantResponseDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<String>? username,
      Wrapped<String>? name,
      Wrapped<double>? deaths,
      Wrapped<bool>? isAdmin}) {
    return ParticipantResponseDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        name: (name != null ? name.value : this.name),
        deaths: (deaths != null ? deaths.value : this.deaths),
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

@JsonSerializable(explicitToJson: true)
class UserStatisticsDto {
  const UserStatisticsDto({
    required this.userId,
    required this.username,
    required this.totalDeaths,
    required this.averageDeathsPerLocke,
    required this.totalBattlesWon,
    required this.totalBattlePoints,
    required this.performanceScore,
    this.rank,
  });

  factory UserStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticsDtoFromJson(json);

  static const toJsonFactory = _$UserStatisticsDtoToJson;
  Map<String, dynamic> toJson() => _$UserStatisticsDtoToJson(this);

  @JsonKey(name: 'userId', defaultValue: 'default')
  final String userId;
  @JsonKey(name: 'username', defaultValue: 'default')
  final String username;
  @JsonKey(name: 'totalDeaths')
  final double totalDeaths;
  @JsonKey(name: 'averageDeathsPerLocke')
  final double averageDeathsPerLocke;
  @JsonKey(name: 'totalBattlesWon')
  final double totalBattlesWon;
  @JsonKey(name: 'totalBattlePoints')
  final double totalBattlePoints;
  @JsonKey(name: 'performanceScore')
  final double performanceScore;
  @JsonKey(name: 'rank')
  final double? rank;
  static const fromJsonFactory = _$UserStatisticsDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserStatisticsDto &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.totalDeaths, totalDeaths) ||
                const DeepCollectionEquality()
                    .equals(other.totalDeaths, totalDeaths)) &&
            (identical(other.averageDeathsPerLocke, averageDeathsPerLocke) ||
                const DeepCollectionEquality().equals(
                    other.averageDeathsPerLocke, averageDeathsPerLocke)) &&
            (identical(other.totalBattlesWon, totalBattlesWon) ||
                const DeepCollectionEquality()
                    .equals(other.totalBattlesWon, totalBattlesWon)) &&
            (identical(other.totalBattlePoints, totalBattlePoints) ||
                const DeepCollectionEquality()
                    .equals(other.totalBattlePoints, totalBattlePoints)) &&
            (identical(other.performanceScore, performanceScore) ||
                const DeepCollectionEquality()
                    .equals(other.performanceScore, performanceScore)) &&
            (identical(other.rank, rank) ||
                const DeepCollectionEquality().equals(other.rank, rank)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(totalDeaths) ^
      const DeepCollectionEquality().hash(averageDeathsPerLocke) ^
      const DeepCollectionEquality().hash(totalBattlesWon) ^
      const DeepCollectionEquality().hash(totalBattlePoints) ^
      const DeepCollectionEquality().hash(performanceScore) ^
      const DeepCollectionEquality().hash(rank) ^
      runtimeType.hashCode;
}

extension $UserStatisticsDtoExtension on UserStatisticsDto {
  UserStatisticsDto copyWith(
      {String? userId,
      String? username,
      double? totalDeaths,
      double? averageDeathsPerLocke,
      double? totalBattlesWon,
      double? totalBattlePoints,
      double? performanceScore,
      double? rank}) {
    return UserStatisticsDto(
        userId: userId ?? this.userId,
        username: username ?? this.username,
        totalDeaths: totalDeaths ?? this.totalDeaths,
        averageDeathsPerLocke:
            averageDeathsPerLocke ?? this.averageDeathsPerLocke,
        totalBattlesWon: totalBattlesWon ?? this.totalBattlesWon,
        totalBattlePoints: totalBattlePoints ?? this.totalBattlePoints,
        performanceScore: performanceScore ?? this.performanceScore,
        rank: rank ?? this.rank);
  }

  UserStatisticsDto copyWithWrapped(
      {Wrapped<String>? userId,
      Wrapped<String>? username,
      Wrapped<double>? totalDeaths,
      Wrapped<double>? averageDeathsPerLocke,
      Wrapped<double>? totalBattlesWon,
      Wrapped<double>? totalBattlePoints,
      Wrapped<double>? performanceScore,
      Wrapped<double?>? rank}) {
    return UserStatisticsDto(
        userId: (userId != null ? userId.value : this.userId),
        username: (username != null ? username.value : this.username),
        totalDeaths:
            (totalDeaths != null ? totalDeaths.value : this.totalDeaths),
        averageDeathsPerLocke: (averageDeathsPerLocke != null
            ? averageDeathsPerLocke.value
            : this.averageDeathsPerLocke),
        totalBattlesWon: (totalBattlesWon != null
            ? totalBattlesWon.value
            : this.totalBattlesWon),
        totalBattlePoints: (totalBattlePoints != null
            ? totalBattlePoints.value
            : this.totalBattlePoints),
        performanceScore: (performanceScore != null
            ? performanceScore.value
            : this.performanceScore),
        rank: (rank != null ? rank.value : this.rank));
  }
}

String? createBattleDtoStatusNullableToJson(
    enums.CreateBattleDtoStatus? createBattleDtoStatus) {
  return createBattleDtoStatus?.value;
}

String? createBattleDtoStatusToJson(
    enums.CreateBattleDtoStatus createBattleDtoStatus) {
  return createBattleDtoStatus.value;
}

enums.CreateBattleDtoStatus createBattleDtoStatusFromJson(
  Object? createBattleDtoStatus, [
  enums.CreateBattleDtoStatus? defaultValue,
]) {
  return enums.CreateBattleDtoStatus.values
          .firstWhereOrNull((e) => e.value == createBattleDtoStatus) ??
      defaultValue ??
      enums.CreateBattleDtoStatus.swaggerGeneratedUnknown;
}

enums.CreateBattleDtoStatus? createBattleDtoStatusNullableFromJson(
  Object? createBattleDtoStatus, [
  enums.CreateBattleDtoStatus? defaultValue,
]) {
  if (createBattleDtoStatus == null) {
    return null;
  }
  return enums.CreateBattleDtoStatus.values
          .firstWhereOrNull((e) => e.value == createBattleDtoStatus) ??
      defaultValue;
}

String createBattleDtoStatusExplodedListToJson(
    List<enums.CreateBattleDtoStatus>? createBattleDtoStatus) {
  return createBattleDtoStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> createBattleDtoStatusListToJson(
    List<enums.CreateBattleDtoStatus>? createBattleDtoStatus) {
  if (createBattleDtoStatus == null) {
    return [];
  }

  return createBattleDtoStatus.map((e) => e.value!).toList();
}

List<enums.CreateBattleDtoStatus> createBattleDtoStatusListFromJson(
  List? createBattleDtoStatus, [
  List<enums.CreateBattleDtoStatus>? defaultValue,
]) {
  if (createBattleDtoStatus == null) {
    return defaultValue ?? [];
  }

  return createBattleDtoStatus
      .map((e) => createBattleDtoStatusFromJson(e.toString()))
      .toList();
}

List<enums.CreateBattleDtoStatus>? createBattleDtoStatusNullableListFromJson(
  List? createBattleDtoStatus, [
  List<enums.CreateBattleDtoStatus>? defaultValue,
]) {
  if (createBattleDtoStatus == null) {
    return defaultValue;
  }

  return createBattleDtoStatus
      .map((e) => createBattleDtoStatusFromJson(e.toString()))
      .toList();
}

String? enrichedBattleResponseDtoStatusNullableToJson(
    enums.EnrichedBattleResponseDtoStatus? enrichedBattleResponseDtoStatus) {
  return enrichedBattleResponseDtoStatus?.value;
}

String? enrichedBattleResponseDtoStatusToJson(
    enums.EnrichedBattleResponseDtoStatus enrichedBattleResponseDtoStatus) {
  return enrichedBattleResponseDtoStatus.value;
}

enums.EnrichedBattleResponseDtoStatus enrichedBattleResponseDtoStatusFromJson(
  Object? enrichedBattleResponseDtoStatus, [
  enums.EnrichedBattleResponseDtoStatus? defaultValue,
]) {
  return enums.EnrichedBattleResponseDtoStatus.values.firstWhereOrNull(
          (e) => e.value == enrichedBattleResponseDtoStatus) ??
      defaultValue ??
      enums.EnrichedBattleResponseDtoStatus.swaggerGeneratedUnknown;
}

enums.EnrichedBattleResponseDtoStatus?
    enrichedBattleResponseDtoStatusNullableFromJson(
  Object? enrichedBattleResponseDtoStatus, [
  enums.EnrichedBattleResponseDtoStatus? defaultValue,
]) {
  if (enrichedBattleResponseDtoStatus == null) {
    return null;
  }
  return enums.EnrichedBattleResponseDtoStatus.values.firstWhereOrNull(
          (e) => e.value == enrichedBattleResponseDtoStatus) ??
      defaultValue;
}

String enrichedBattleResponseDtoStatusExplodedListToJson(
    List<enums.EnrichedBattleResponseDtoStatus>?
        enrichedBattleResponseDtoStatus) {
  return enrichedBattleResponseDtoStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> enrichedBattleResponseDtoStatusListToJson(
    List<enums.EnrichedBattleResponseDtoStatus>?
        enrichedBattleResponseDtoStatus) {
  if (enrichedBattleResponseDtoStatus == null) {
    return [];
  }

  return enrichedBattleResponseDtoStatus.map((e) => e.value!).toList();
}

List<enums.EnrichedBattleResponseDtoStatus>
    enrichedBattleResponseDtoStatusListFromJson(
  List? enrichedBattleResponseDtoStatus, [
  List<enums.EnrichedBattleResponseDtoStatus>? defaultValue,
]) {
  if (enrichedBattleResponseDtoStatus == null) {
    return defaultValue ?? [];
  }

  return enrichedBattleResponseDtoStatus
      .map((e) => enrichedBattleResponseDtoStatusFromJson(e.toString()))
      .toList();
}

List<enums.EnrichedBattleResponseDtoStatus>?
    enrichedBattleResponseDtoStatusNullableListFromJson(
  List? enrichedBattleResponseDtoStatus, [
  List<enums.EnrichedBattleResponseDtoStatus>? defaultValue,
]) {
  if (enrichedBattleResponseDtoStatus == null) {
    return defaultValue;
  }

  return enrichedBattleResponseDtoStatus
      .map((e) => enrichedBattleResponseDtoStatusFromJson(e.toString()))
      .toList();
}

String? updateBattleDtoStatusNullableToJson(
    enums.UpdateBattleDtoStatus? updateBattleDtoStatus) {
  return updateBattleDtoStatus?.value;
}

String? updateBattleDtoStatusToJson(
    enums.UpdateBattleDtoStatus updateBattleDtoStatus) {
  return updateBattleDtoStatus.value;
}

enums.UpdateBattleDtoStatus updateBattleDtoStatusFromJson(
  Object? updateBattleDtoStatus, [
  enums.UpdateBattleDtoStatus? defaultValue,
]) {
  return enums.UpdateBattleDtoStatus.values
          .firstWhereOrNull((e) => e.value == updateBattleDtoStatus) ??
      defaultValue ??
      enums.UpdateBattleDtoStatus.swaggerGeneratedUnknown;
}

enums.UpdateBattleDtoStatus? updateBattleDtoStatusNullableFromJson(
  Object? updateBattleDtoStatus, [
  enums.UpdateBattleDtoStatus? defaultValue,
]) {
  if (updateBattleDtoStatus == null) {
    return null;
  }
  return enums.UpdateBattleDtoStatus.values
          .firstWhereOrNull((e) => e.value == updateBattleDtoStatus) ??
      defaultValue;
}

String updateBattleDtoStatusExplodedListToJson(
    List<enums.UpdateBattleDtoStatus>? updateBattleDtoStatus) {
  return updateBattleDtoStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> updateBattleDtoStatusListToJson(
    List<enums.UpdateBattleDtoStatus>? updateBattleDtoStatus) {
  if (updateBattleDtoStatus == null) {
    return [];
  }

  return updateBattleDtoStatus.map((e) => e.value!).toList();
}

List<enums.UpdateBattleDtoStatus> updateBattleDtoStatusListFromJson(
  List? updateBattleDtoStatus, [
  List<enums.UpdateBattleDtoStatus>? defaultValue,
]) {
  if (updateBattleDtoStatus == null) {
    return defaultValue ?? [];
  }

  return updateBattleDtoStatus
      .map((e) => updateBattleDtoStatusFromJson(e.toString()))
      .toList();
}

List<enums.UpdateBattleDtoStatus>? updateBattleDtoStatusNullableListFromJson(
  List? updateBattleDtoStatus, [
  List<enums.UpdateBattleDtoStatus>? defaultValue,
]) {
  if (updateBattleDtoStatus == null) {
    return defaultValue;
  }

  return updateBattleDtoStatus
      .map((e) => updateBattleDtoStatusFromJson(e.toString()))
      .toList();
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
