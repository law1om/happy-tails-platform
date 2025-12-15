import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8080/api";
  static String? _token;
  static const String _tokenKey = 'auth_token';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static String? getToken() {
    return _token;
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Map<String, String> _getHeaders({bool needsAuth = false}) {
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (needsAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    } else if (needsAuth && _token == null) {
      print('WARNING: Auth required but no token available!');
    }
    return headers;
  }

  static dynamic _jsonDecodeUtf8(http.Response response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  // Животные
  static Future<List<dynamic>> getAnimals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/animals'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load animals');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Авторизация
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);

        // Пробуем разные варианты структуры ответа
        if (data['data'] != null && data['data']['token'] != null) {
          _token = data['data']['token'];
        } else if (data['token'] != null) {
          _token = data['token'];
        } else if (data['data'] != null &&
            data['data']['accessToken'] != null) {
          _token = data['data']['accessToken'];
        }

        return data;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  static Future<Map<String, dynamic>> register(
      String email, String password, String fullName, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);

        // Пробуем разные варианты структуры ответа
        if (data['data'] != null && data['data']['token'] != null) {
          _token = data['data']['token'];
        } else if (data['token'] != null) {
          _token = data['token'];
        } else if (data['data'] != null &&
            data['data']['accessToken'] != null) {
          _token = data['data']['accessToken'];
        }

        return data;
      } else {
        final error = _jsonDecodeUtf8(response);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Register error: $e');
    }
  }

  // События
  static Future<List<dynamic>> getEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Донаты
  static Future<Map<String, dynamic>> createDonation(
      double amount, int? animalId, int? eventId, String? message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode({
          'amount': amount,
          'animalId': animalId,
          'eventId': eventId,
          'message': message
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to create donation');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить мои донаты
  static Future<List<dynamic>> getMyDonations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/my'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load donations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить текущего пользователя
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== ADOPTION PROFILES ==========

  // Создать анкету усыновителя
  static Future<Map<String, dynamic>> createAdoptionProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/adoption-profiles'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(profileData),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to create adoption profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить мою анкету
  static Future<Map<String, dynamic>?> getMyAdoptionProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/adoption-profiles/my'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load adoption profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Обновить анкету
  static Future<Map<String, dynamic>> updateAdoptionProfile(
      int id, Map<String, dynamic> profileData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/adoption-profiles/$id'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(profileData),
      );
      if (response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to update adoption profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== APPLICATIONS ==========

  // Создать заявку на усыновление
  static Future<Map<String, dynamic>> createApplication(int animalId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/applications'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode({'animalId': animalId}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        final error = _jsonDecodeUtf8(response);
        throw Exception(error['message'] ?? 'Failed to create application');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить мои заявки
  static Future<List<dynamic>> getMyApplications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/applications/my'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load applications');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить все заявки (для админа)
  static Future<List<dynamic>> getAllApplications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/applications'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load applications');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Обновить статус заявки (для админа)
  static Future<Map<String, dynamic>> updateApplicationStatus(
      int id, String status, String? comment) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/applications/$id/status'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode({'status': status, 'adminComment': comment}),
      );
      if (response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to update application status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== EVENTS ==========

  // Создать событие (для админа)
  static Future<Map<String, dynamic>> createEvent(
      Map<String, dynamic> eventData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(eventData),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to create event');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Обновить событие (для админа)
  static Future<Map<String, dynamic>> updateEvent(
      int id, Map<String, dynamic> eventData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/events/$id'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(eventData),
      );
      if (response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to update event');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Удалить событие (для админа)
  static Future<void> deleteEvent(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$id'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Записаться на событие
  static Future<Map<String, dynamic>> registerForEvent(int eventId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events/$eventId/register'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        final error = _jsonDecodeUtf8(response);
        throw Exception(error['message'] ?? 'Failed to register for event');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Отменить регистрацию на событие
  static Future<void> unregisterFromEvent(int eventId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$eventId/register'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to unregister from event');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить мои события
  static Future<List<dynamic>> getMyEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/my'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load my events');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Проверка регистрации пользователя на событие
  static Future<bool> isRegisteredForEvent(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId/is-registered'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        // Ожидаем { success: true, data: true/false }
        final value = data['data'];
        if (value is bool) return value;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ========== ANIMALS ==========

  // Создать животное (для админа)
  static Future<Map<String, dynamic>> createAnimal(
      Map<String, dynamic> animalData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/animals'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(animalData),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to create animal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Обновить животное (для админа)
  static Future<Map<String, dynamic>> updateAnimal(
      int id, Map<String, dynamic> animalData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/animals/$id'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(animalData),
      );
      if (response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to update animal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Удалить животное (для админа)
  static Future<void> deleteAnimal(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/animals/$id'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete animal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить животное по ID
  static Future<Map<String, dynamic>> getAnimalById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/animals/$id'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to load animal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== USERS (для админа) ==========

  // Получить всех пользователей
  static Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Обновить статус пользователя
  static Future<Map<String, dynamic>> updateUserStatus(
      int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id/status'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode({'status': status}),
      );
      if (response.statusCode == 200) {
        return _jsonDecodeUtf8(response);
      } else {
        throw Exception('Failed to update user status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Удалить пользователя
  static Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== ADOPTION HISTORY ==========

  // Получить историю усыновлений
  static Future<List<dynamic>> getAdoptionHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/adoptions/history'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load adoption history');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить историю пользователя
  static Future<Map<String, dynamic>> getUserHistory(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/history'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to load user history');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ========== SHELTERS ==========

  // Получить все приюты
  static Future<List<dynamic>> getShelters() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/shelters'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load shelters');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить приют по ID
  static Future<Map<String, dynamic>> getShelterById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/shelters/$id'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to load shelter');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Создать приют (только для админа)
  static Future<Map<String, dynamic>> createShelter(
      Map<String, dynamic> shelterData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shelters'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(shelterData),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to create shelter');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Обновить приют (только для админа)
  static Future<Map<String, dynamic>> updateShelter(
      int id, Map<String, dynamic> shelterData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/shelters/$id'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode(shelterData),
      );
      if (response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to update shelter');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Удалить приют (только для админа)
  static Future<void> deleteShelter(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/shelters/$id'),
        headers: _getHeaders(needsAuth: true),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete shelter');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Пожертвовать приюту
  static Future<Map<String, dynamic>> donateShelter(
      int shelterId, double amount, String? message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations'),
        headers: _getHeaders(needsAuth: true),
        body: json.encode({
          'shelterId': shelterId,
          'amount': amount,
          'message': message,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = _jsonDecodeUtf8(response);
        return data['data'] ?? {};
      } else {
        throw Exception('Failed to create donation');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
