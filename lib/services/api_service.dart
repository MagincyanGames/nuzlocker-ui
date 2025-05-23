import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated_code/api.swagger.dart';
import '../generated_code/client_index.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Api api;
  String? _token;

  bool get hasToken => _token != null;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    // Inicializar la API con opciones por defecto
    _initApi();
  }

  Future<void> init() async {
    // Recuperar token guardado si existe
    await _loadToken();
    // Reinicializar API con el token cargado
    _initApi();
  }

  void _initApi() {
    final client = ChopperClient(
      // baseUrl: Uri.parse('http://api.nuz.onara.top:6109'),
      baseUrl: Uri.parse('http://play.onara.top:3000'),
      interceptors: [
        HttpLoggingInterceptor(),
        if (_token != null) _AuthInterceptor(_token!),
      ],
      converter: $JsonSerializableConverter(),
      errorConverter: const JsonConverter(),
    );

    api = Api.create(client: client);
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    // Reinicializar la API con el nuevo token
    _initApi();
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _initApi();
  }

  // Auth endpoints
  Future<LoginResponseDto?> login(String username, String password) async {
    try {
      final response = await api.apiAuthLoginPost(
        body: LoginDto(username: username, password: password),
      );

      if (response.isSuccessful && response.body != null) {
        await setToken(response.body!.accessToken);
        return response.body;
      }
      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<RegisterResponseDto?> register(
    String username,
    String password,
    String name,
  ) async {
    try {
      final response = await api.apiAuthRegisterPost(
        body: RegisterDto(username: username, password: password, name: name),
      );

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }
      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }
  Future<List<EnrichedLockeResponseDto>> getAllLockes() async {
    try {
      final response = await api.apiLockesGet();

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error getting all lockes: $e');
      rethrow;
    }
  }


  // Locke endpoints
  Future<List<EnrichedLockeResponseDto>> getMyLockes({
    bool includeParticipating = true,
    bool? active,
  }) async {
    try {
      final includeParticipatingEnum =
          includeParticipating
              ? ApiLockesMyLockesGetIncludeParticipating.$true
              : ApiLockesMyLockesGetIncludeParticipating.$false;

      // Fix the null boolean error by using conditional logic instead of direct casting
      final ApiLockesMyLockesGetActive? activeEnum =
          active == null
              ? null
              : active
              ? ApiLockesMyLockesGetActive.$true
              : ApiLockesMyLockesGetActive.$false;

      final response = await api.apiLockesMyLockesGet(
        includeParticipating: includeParticipatingEnum,
        active: activeEnum,
      );

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error getting lockes: $e');
      rethrow;
    }
  }

  Future<EnrichedLockeResponseDto?> createLocke(
    String name, {
    String? description,
    bool isActive = true,
  }) async {
    try {
      final response = await api.apiLockesPost(
        body: CreateLockeDto(
          name: name,
          description: description,
          isActive: isActive,
        ),
      );

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error creating locke: $e');
      rethrow;
    }
  }

  Future<EnrichedLockeResponseDto?> getLockeById(String id) async {
    try {
      final response = await api.apiLockesIdGet(id: id);

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error getting locke: $e');
      rethrow;
    }
  }

  Future<EnrichedLockeResponseDto?> updateLocke(
    String id, {
    String? name,
    String? description,
    bool? isActive,
    List<String>? adminIds,
  }) async {
    try {
      final response = await api.apiLockesIdPatch(
        id: id,
        body: UpdateLockeDto(
          name: name,
          description: description,
          isActive: isActive,
          adminIds: adminIds,
        ),
      );

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error updating locke: $e');
      rethrow;
    }
  }

  Future<EnrichedLockeResponseDto?> recordKill(
    String lockeId,
    int count, {
    String? userId,
  }) async {
    try {
      final response =
          userId != null
              ? await api.apiLockesIdKillsPost(
                id: lockeId,
                userId: userId,
                count: count,
              )
              : await api.apiLockesIdMyKillsPost(id: lockeId, count: count);

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error recording kill: $e');
      rethrow;
    }
  }

  Future<List<ParticipantResponseDto>> getLeaderboard(String lockeId) async {
    try {
      final response = await api.apiLockesIdLeaderboardGet(id: lockeId);

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error getting leaderboard: $e');
      return [];
    }
  }

  // Buscar usuarios por nombre o username
  Future<List<UserResponseDto>> searchUsers(String query) async {
    try {
      final response = await api.apiUsersSearchGet(query: query);

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  // Agregar participante a un locke
  Future<EnrichedLockeResponseDto?> addParticipant(
    String lockeId,
    String userId,
  ) async {
    try {
      final response = await api.apiLockesIdParticipantsPost(
        id: lockeId,
        body: AddParticipantDto(userId: userId),
      );

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error adding participant: $e');
      rethrow;
    }
  }

  Future<List<EnrichedBattleResponseDto>> getLockleBattles(
    String lockeId,
  ) async {
    try {
      final response = await api.apiLockesIdBattlesGet(id: lockeId);

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error getting battles: $e');
      return [];
    }
  }

  // Create a battle in a locke
  Future<EnrichedBattleResponseDto?> createBattle(
    String lockeId, {
    DateTime? battleDate,
  }) async {
    try {
      final response = await api.apiLockesIdBattlesPost(
        id: lockeId,
        body: CreateBattleDto(
          date: battleDate,
          participantIds: [],
          results: [],
          status: CreateBattleDtoStatus.scheduled,
          bestOf: 3,
          notes: '',
        ),
      );

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error creating battle: $e');
      rethrow;
    }
  }

  // Update a battle
  Future<EnrichedBattleResponseDto?> updateBattle(
    String battleId, {
    List<ParticipantResultDto>? results,
    UpdateBattleDtoStatus? status,
    String? notes,
    DateTime? date,
  }) async {
    try {
      // The body would need to be defined based on the actual API implementation
      final response = await api.apiLockesBattlesBattleIdPatch(
        battleId: battleId,
        body: UpdateBattleDto(
          results: results, 
          status: status, 
          notes: notes,
          date: date,
        ),
      );

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error updating battle: $e');
      rethrow;
    }
  }

  // Update battle scores
  Future<EnrichedBattleResponseDto?> updateBattleScores(
    String battleId,
    List<ParticipantResultDto> results,
  ) async {
    try {
      final response = await api.apiLockesBattlesBattleIdPatch(
        battleId: battleId,
        body: UpdateBattleDto(results: results),
      );

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error updating battle scores: $e');
      rethrow;
    }
  }

  // Agregar este método para obtener las estadísticas del usuario autenticado
  Future<UserStatisticsDto> getMyStatistics() async {
    try {
      final response = await api.apiStatisticsMeGet();

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error obteniendo estadísticas: $e');
      rethrow;
    }
  }

  // Agregar este método para obtener rankings globales
  Future<List<UserStatisticsDto>> getGlobalRankings() async {
    try {
      final response = await api.apiStatisticsRankingsGet();

      if (response.isSuccessful && response.body != null) {
        return response.body!;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error obteniendo rankings globales: $e');
      rethrow;
    }
  }

  // Agregar este método para obtener estadísticas de un usuario específico
  Future<dynamic> getUserStatistics(String userId) async {
    try {
      final response = await api.apiStatisticsUserUserIdGet(userId: userId);

      if (response.isSuccessful && response.body != null) {
        return response.body;
      }

      throw ApiException(response.statusCode, response.error.toString());
    } catch (e) {
      debugPrint('Error obteniendo estadísticas del usuario: $e');
      rethrow;
    }
  }
}

class _AuthInterceptor implements Interceptor {
  final String token;

  _AuthInterceptor(this.token);

  @override
  Future<Request> onRequest(Request request) async {
    return request.copyWith(
      headers: {...request.headers, 'Authorization': 'Bearer $token'},
    );
  }

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = await onRequest(chain.request);
    return chain.proceed(request);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
