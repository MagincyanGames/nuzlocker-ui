// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Api extends Api {
  _$Api([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Api;

  @override
  Future<Response<List<UserResponseDto>>> _apiUsersGet() {
    final Uri $url = Uri.parse('/api/users');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<UserResponseDto>, UserResponseDto>($request);
  }

  @override
  Future<Response<List<UserResponseDto>>> _apiUsersSearchGet(
      {required String? query}) {
    final Uri $url = Uri.parse('/api/users/search');
    final Map<String, dynamic> $params = <String, dynamic>{'query': query};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<UserResponseDto>, UserResponseDto>($request);
  }

  @override
  Future<Response<UserStatsResponseDto>> _apiUsersUserIdStatsGet(
      {required String? userId}) {
    final Uri $url = Uri.parse('/api/users/${userId}/stats');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<UserStatsResponseDto, UserStatsResponseDto>($request);
  }

  @override
  Future<Response<LoginResponseDto>> _apiAuthLoginPost(
      {required LoginDto? body}) {
    final Uri $url = Uri.parse('/api/auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<LoginResponseDto, LoginResponseDto>($request);
  }

  @override
  Future<Response<ValidateTokenResponseDto>> _apiAuthValidatePost(
      {required ValidateTokenDto? body}) {
    final Uri $url = Uri.parse('/api/auth/validate');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<ValidateTokenResponseDto, ValidateTokenResponseDto>($request);
  }

  @override
  Future<Response<RegisterResponseDto>> _apiAuthRegisterPost(
      {required LoginDto? body}) {
    final Uri $url = Uri.parse('/api/auth/register');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<RegisterResponseDto, RegisterResponseDto>($request);
  }

  @override
  Future<Response<EnrichedLockeResponseDto>> _apiLockesPost(
      {required CreateLockeDto? body}) {
    final Uri $url = Uri.parse('/api/lockes');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<EnrichedLockeResponseDto, EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<List<EnrichedLockeResponseDto>>> _apiLockesGet(
      {String? active}) {
    final Uri $url = Uri.parse('/api/lockes');
    final Map<String, dynamic> $params = <String, dynamic>{'active': active};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<EnrichedLockeResponseDto>,
        EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<EnrichedLockeResponseDto>> _apiLockesIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/lockes/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<EnrichedLockeResponseDto, EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<EnrichedLockeResponseDto>> _apiLockesIdPatch({
    required String? id,
    required UpdateLockeDto? body,
  }) {
    final Uri $url = Uri.parse('/api/lockes/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<EnrichedLockeResponseDto, EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<EnrichedLockeResponseDto>> _apiLockesIdDelete(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/lockes/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client
        .send<EnrichedLockeResponseDto, EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<EnrichedLockeResponseDto>> _apiLockesIdKillsPost({
    required String? id,
    required String? userId,
    required num? count,
  }) {
    final Uri $url = Uri.parse('/api/lockes/${id}/kills');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'count': count,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<EnrichedLockeResponseDto, EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<EnrichedLockeResponseDto>> _apiLockesIdMyKillsPost({
    required String? id,
    required num? count,
  }) {
    final Uri $url = Uri.parse('/api/lockes/${id}/my-kills');
    final Map<String, dynamic> $params = <String, dynamic>{'count': count};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<EnrichedLockeResponseDto, EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<EnrichedBattleResponseDto>> _apiLockesIdBattlesPost({
    required String? id,
    required CreateBattleDto? body,
  }) {
    final Uri $url = Uri.parse('/api/lockes/${id}/battles');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<EnrichedBattleResponseDto, EnrichedBattleResponseDto>($request);
  }

  @override
  Future<Response<List<EnrichedBattleResponseDto>>> _apiLockesIdBattlesGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/lockes/${id}/battles');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<EnrichedBattleResponseDto>,
        EnrichedBattleResponseDto>($request);
  }

  @override
  Future<Response<EnrichedBattleResponseDto>> _apiLockesBattlesBattleIdPatch({
    required String? battleId,
    required UpdateBattleDto? body,
  }) {
    final Uri $url = Uri.parse('/api/lockes/battles/${battleId}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<EnrichedBattleResponseDto, EnrichedBattleResponseDto>($request);
  }

  @override
  Future<Response<List<ParticipantResponseDto>>> _apiLockesIdLeaderboardGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/lockes/${id}/leaderboard');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<List<ParticipantResponseDto>, ParticipantResponseDto>($request);
  }

  @override
  Future<Response<EnrichedLockeResponseDto>> _apiLockesIdParticipantsPost({
    required String? id,
    required AddParticipantDto? body,
  }) {
    final Uri $url = Uri.parse('/api/lockes/${id}/participants');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<EnrichedLockeResponseDto, EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<List<EnrichedLockeResponseDto>>> _apiLockesUserUserIdGet({
    required String? userId,
    String? includeParticipating,
    String? active,
  }) {
    final Uri $url = Uri.parse('/api/lockes/user/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'includeParticipating': includeParticipating,
      'active': active,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<EnrichedLockeResponseDto>,
        EnrichedLockeResponseDto>($request);
  }

  @override
  Future<Response<List<EnrichedLockeResponseDto>>> _apiLockesMyLockesGet({
    String? includeParticipating,
    String? active,
  }) {
    final Uri $url = Uri.parse('/api/lockes/my/lockes');
    final Map<String, dynamic> $params = <String, dynamic>{
      'includeParticipating': includeParticipating,
      'active': active,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<EnrichedLockeResponseDto>,
        EnrichedLockeResponseDto>($request);
  }
}
