// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponseDto _$UserResponseDtoFromJson(Map<String, dynamic> json) =>
    UserResponseDto(
      id: json['_id'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
    );

Map<String, dynamic> _$UserResponseDtoToJson(UserResponseDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'username': instance.username,
    };

UserStatsResponseDto _$UserStatsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    UserStatsResponseDto(
      userId: json['userId'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
      totalDeaths: (json['totalDeaths'] as num).toDouble(),
      averageDeathsPerLocke: (json['averageDeathsPerLocke'] as num).toDouble(),
      totalLockes: (json['totalLockes'] as num).toDouble(),
    );

Map<String, dynamic> _$UserStatsResponseDtoToJson(
        UserStatsResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'totalDeaths': instance.totalDeaths,
      'averageDeathsPerLocke': instance.averageDeathsPerLocke,
      'totalLockes': instance.totalLockes,
    };

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
      username: json['username'] as String? ?? 'default',
      password: json['password'] as String? ?? 'default',
    );

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

LoginResponseDto _$LoginResponseDtoFromJson(Map<String, dynamic> json) =>
    LoginResponseDto(
      id: json['id'] as String? ?? 'default',
      accessToken: json['access_token'] as String? ?? 'default',
      success: json['success'] as bool,
    );

Map<String, dynamic> _$LoginResponseDtoToJson(LoginResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'access_token': instance.accessToken,
      'success': instance.success,
    };

ErrorResponseDto _$ErrorResponseDtoFromJson(Map<String, dynamic> json) =>
    ErrorResponseDto(
      success: json['success'] as bool,
      message: json['message'] as String? ?? 'default',
    );

Map<String, dynamic> _$ErrorResponseDtoToJson(ErrorResponseDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };

ValidateTokenDto _$ValidateTokenDtoFromJson(Map<String, dynamic> json) =>
    ValidateTokenDto(
      token: json['token'] as String? ?? 'default',
    );

Map<String, dynamic> _$ValidateTokenDtoToJson(ValidateTokenDto instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

ValidateTokenResponseDto _$ValidateTokenResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ValidateTokenResponseDto(
      valid: json['valid'] as bool,
      id: json['id'] as String? ?? 'default',
    );

Map<String, dynamic> _$ValidateTokenResponseDtoToJson(
        ValidateTokenResponseDto instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'id': instance.id,
    };

RegisterResponseDto _$RegisterResponseDtoFromJson(Map<String, dynamic> json) =>
    RegisterResponseDto(
      id: json['id'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
    );

Map<String, dynamic> _$RegisterResponseDtoToJson(
        RegisterResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
    };

CreateLockeDto _$CreateLockeDtoFromJson(Map<String, dynamic> json) =>
    CreateLockeDto(
      name: json['name'] as String? ?? 'default',
      description: json['description'] as String? ?? 'default',
      isActive: json['isActive'] as bool? ?? true,
      adminIds: (json['adminIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateLockeDtoToJson(CreateLockeDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'isActive': instance.isActive,
      'adminIds': instance.adminIds,
    };

EnrichedParticipantResponseDto _$EnrichedParticipantResponseDtoFromJson(
        Map<String, dynamic> json) =>
    EnrichedParticipantResponseDto(
      userId: json['userId'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
      deaths: (json['deaths'] as num).toDouble(),
      points: (json['points'] as num).toDouble(),
      isAdmin: json['isAdmin'] as bool,
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$EnrichedParticipantResponseDtoToJson(
        EnrichedParticipantResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'deaths': instance.deaths,
      'points': instance.points,
      'isAdmin': instance.isAdmin,
      'score': instance.score,
    };

EnrichedLockeResponseDto _$EnrichedLockeResponseDtoFromJson(
        Map<String, dynamic> json) =>
    EnrichedLockeResponseDto(
      id: json['_id'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => EnrichedParticipantResponseDto.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
      adminIds: (json['adminIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EnrichedLockeResponseDtoToJson(
        EnrichedLockeResponseDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'adminIds': instance.adminIds,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

UpdateLockeDto _$UpdateLockeDtoFromJson(Map<String, dynamic> json) =>
    UpdateLockeDto(
      name: json['name'] as String? ?? 'default',
      description: json['description'] as String? ?? 'default',
      isActive: json['isActive'] as bool? ?? true,
      adminIds: (json['adminIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$UpdateLockeDtoToJson(UpdateLockeDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'isActive': instance.isActive,
      'adminIds': instance.adminIds,
    };

CreateBattleDto _$CreateBattleDtoFromJson(Map<String, dynamic> json) =>
    CreateBattleDto(
      lockeId: json['lockeId'] as String? ?? 'default',
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      winnerId: json['winnerId'] as String? ?? 'default',
      winCount: (json['winCount'] as num).toDouble(),
    );

Map<String, dynamic> _$CreateBattleDtoToJson(CreateBattleDto instance) =>
    <String, dynamic>{
      'lockeId': instance.lockeId,
      'participantIds': instance.participantIds,
      'winnerId': instance.winnerId,
      'winCount': instance.winCount,
    };

BattleResponseDto _$BattleResponseDtoFromJson(Map<String, dynamic> json) =>
    BattleResponseDto(
      id: json['_id'] as String? ?? 'default',
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      winnerId: json['winnerId'] as String? ?? 'default',
      winCount: (json['winCount'] as num).toDouble(),
      lockeId: json['lockeId'] as String? ?? 'default',
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BattleResponseDtoToJson(BattleResponseDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'participantIds': instance.participantIds,
      'winnerId': instance.winnerId,
      'winCount': instance.winCount,
      'lockeId': instance.lockeId,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

ParticipantResponseDto _$ParticipantResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ParticipantResponseDto(
      userId: json['userId'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
      deaths: (json['deaths'] as num).toDouble(),
      points: (json['points'] as num).toDouble(),
      isAdmin: json['isAdmin'] as bool,
    );

Map<String, dynamic> _$ParticipantResponseDtoToJson(
        ParticipantResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'deaths': instance.deaths,
      'points': instance.points,
      'isAdmin': instance.isAdmin,
    };

AddParticipantDto _$AddParticipantDtoFromJson(Map<String, dynamic> json) =>
    AddParticipantDto(
      userId: json['userId'] as String? ?? 'default',
    );

Map<String, dynamic> _$AddParticipantDtoToJson(AddParticipantDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };
