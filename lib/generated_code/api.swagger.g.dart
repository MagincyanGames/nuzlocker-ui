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

RegisterDto _$RegisterDtoFromJson(Map<String, dynamic> json) => RegisterDto(
      name: json['name'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      password: json['password'] as String? ?? 'default',
    );

Map<String, dynamic> _$RegisterDtoToJson(RegisterDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'password': instance.password,
    };

UserInfoDto _$UserInfoDtoFromJson(Map<String, dynamic> json) => UserInfoDto(
      name: json['name'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
    );

Map<String, dynamic> _$UserInfoDtoToJson(UserInfoDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
    };

RegisterResponseDto _$RegisterResponseDtoFromJson(Map<String, dynamic> json) =>
    RegisterResponseDto(
      user: UserInfoDto.fromJson(json['user'] as Map<String, dynamic>),
      id: json['id'] as String? ?? 'default',
      accessToken: json['access_token'] as String? ?? 'default',
      success: json['success'] as bool,
    );

Map<String, dynamic> _$RegisterResponseDtoToJson(
        RegisterResponseDto instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'id': instance.id,
      'access_token': instance.accessToken,
      'success': instance.success,
    };

ErrorResponseDto _$ErrorResponseDtoFromJson(Map<String, dynamic> json) =>
    ErrorResponseDto(
      statusCode: (json['statusCode'] as num).toDouble(),
      message: json['message'],
      error: json['error'] as String? ?? 'default',
      success: json['success'] as bool,
    );

Map<String, dynamic> _$ErrorResponseDtoToJson(ErrorResponseDto instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'error': instance.error,
      'success': instance.success,
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
      user: UserInfoDto.fromJson(json['user'] as Map<String, dynamic>),
      id: json['id'] as String? ?? 'default',
      accessToken: json['access_token'] as String? ?? 'default',
      success: json['success'] as bool,
    );

Map<String, dynamic> _$LoginResponseDtoToJson(LoginResponseDto instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'id': instance.id,
      'access_token': instance.accessToken,
      'success': instance.success,
    };

ValidateResponseDto _$ValidateResponseDtoFromJson(Map<String, dynamic> json) =>
    ValidateResponseDto(
      user: UserInfoDto.fromJson(json['user'] as Map<String, dynamic>),
      id: json['id'] as String? ?? 'default',
      accessToken: json['access_token'] as String? ?? 'default',
      success: json['success'] as bool,
    );

Map<String, dynamic> _$ValidateResponseDtoToJson(
        ValidateResponseDto instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'id': instance.id,
      'access_token': instance.accessToken,
      'success': instance.success,
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

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      mcm: (json['mcm'] as num).toDouble(),
      wcm: (json['wcm'] as num).toDouble(),
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'mcm': instance.mcm,
      'wcm': instance.wcm,
    };

EnrichedParticipantResponseDto _$EnrichedParticipantResponseDtoFromJson(
        Map<String, dynamic> json) =>
    EnrichedParticipantResponseDto(
      userId: json['userId'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
      deaths: (json['deaths'] as num).toDouble(),
      isAdmin: json['isAdmin'] as bool,
      score: Score.fromJson(json['score'] as Map<String, dynamic>),
      points: (json['points'] as num).toDouble(),
    );

Map<String, dynamic> _$EnrichedParticipantResponseDtoToJson(
        EnrichedParticipantResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'deaths': instance.deaths,
      'isAdmin': instance.isAdmin,
      'score': instance.score.toJson(),
      'points': instance.points,
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

ParticipantResultDto _$ParticipantResultDtoFromJson(
        Map<String, dynamic> json) =>
    ParticipantResultDto(
      userId: json['userId'] as String? ?? 'default',
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$ParticipantResultDtoToJson(
        ParticipantResultDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'score': instance.score,
    };

CreateBattleDto _$CreateBattleDtoFromJson(Map<String, dynamic> json) =>
    CreateBattleDto(
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status:
          CreateBattleDto.createBattleDtoStatusStatusFromJson(json['status']),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) =>
                  ParticipantResultDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bestOf: (json['bestOf'] as num).toDouble(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? 'default',
    );

Map<String, dynamic> _$CreateBattleDtoToJson(CreateBattleDto instance) =>
    <String, dynamic>{
      'participantIds': instance.participantIds,
      'status': createBattleDtoStatusToJson(instance.status),
      'results': instance.results.map((e) => e.toJson()).toList(),
      'bestOf': instance.bestOf,
      'date': instance.date?.toIso8601String(),
      'notes': instance.notes,
    };

EnrichedResultDto _$EnrichedResultDtoFromJson(Map<String, dynamic> json) =>
    EnrichedResultDto(
      userId: json['userId'] as String? ?? 'default',
      score: (json['score'] as num).toDouble(),
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
    );

Map<String, dynamic> _$EnrichedResultDtoToJson(EnrichedResultDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'score': instance.score,
      'username': instance.username,
      'name': instance.name,
    };

EnrichedParticipantDto _$EnrichedParticipantDtoFromJson(
        Map<String, dynamic> json) =>
    EnrichedParticipantDto(
      userId: json['userId'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
    );

Map<String, dynamic> _$EnrichedParticipantDtoToJson(
        EnrichedParticipantDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
    };

EnrichedBattleResponseDto _$EnrichedBattleResponseDtoFromJson(
        Map<String, dynamic> json) =>
    EnrichedBattleResponseDto(
      id: json['_id'] as String? ?? 'default',
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status: enrichedBattleResponseDtoStatusFromJson(json['status']),
      results: (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => EnrichedResultDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bestOf: (json['bestOf'] as num).toDouble(),
      lockeId: json['lockeId'] as String? ?? 'default',
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? 'default',
      createdAt: DateTime.parse(json['createdAt'] as String),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) =>
                  EnrichedParticipantDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$EnrichedBattleResponseDtoToJson(
        EnrichedBattleResponseDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'participantIds': instance.participantIds,
      'status': enrichedBattleResponseDtoStatusToJson(instance.status),
      'results': instance.results.map((e) => e.toJson()).toList(),
      'bestOf': instance.bestOf,
      'lockeId': instance.lockeId,
      'date': instance.date?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'participants': instance.participants?.map((e) => e.toJson()).toList(),
    };

UpdateBattleDto _$UpdateBattleDtoFromJson(Map<String, dynamic> json) =>
    UpdateBattleDto(
      status: updateBattleDtoStatusNullableFromJson(json['status']),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) =>
                  ParticipantResultDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      notes: json['notes'] as String? ?? 'default',
    );

Map<String, dynamic> _$UpdateBattleDtoToJson(UpdateBattleDto instance) =>
    <String, dynamic>{
      'status': updateBattleDtoStatusNullableToJson(instance.status),
      'results': instance.results?.map((e) => e.toJson()).toList(),
      'date': instance.date?.toIso8601String(),
      'notes': instance.notes,
    };

ParticipantResponseDto _$ParticipantResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ParticipantResponseDto(
      userId: json['userId'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      name: json['name'] as String? ?? 'default',
      deaths: (json['deaths'] as num).toDouble(),
      isAdmin: json['isAdmin'] as bool,
    );

Map<String, dynamic> _$ParticipantResponseDtoToJson(
        ParticipantResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'name': instance.name,
      'deaths': instance.deaths,
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

UserStatisticsDto _$UserStatisticsDtoFromJson(Map<String, dynamic> json) =>
    UserStatisticsDto(
      userId: json['userId'] as String? ?? 'default',
      username: json['username'] as String? ?? 'default',
      totalDeaths: (json['totalDeaths'] as num).toDouble(),
      averageDeathsPerLocke: (json['averageDeathsPerLocke'] as num).toDouble(),
      totalBattlesWon: (json['totalBattlesWon'] as num).toDouble(),
      totalBattlePoints: (json['totalBattlePoints'] as num).toDouble(),
      performanceScore: (json['performanceScore'] as num).toDouble(),
      rank: (json['rank'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserStatisticsDtoToJson(UserStatisticsDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'totalDeaths': instance.totalDeaths,
      'averageDeathsPerLocke': instance.averageDeathsPerLocke,
      'totalBattlesWon': instance.totalBattlesWon,
      'totalBattlePoints': instance.totalBattlePoints,
      'performanceScore': instance.performanceScore,
      'rank': instance.rank,
    };
