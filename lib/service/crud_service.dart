import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_auth/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrudService {
  late Dio dio;
  late String accessToken;

  CrudService() {
    dio = Dio(BaseOptions(baseUrl: apiUrl));
  }

  Future<void> _storeAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> _getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> _refreshToken() async {
    try {
      String? refreshToken = await _getRefreshToken();
      if (refreshToken == null) {
        throw Exception('Refresh token not found');
      }

      Response response = await dio.post(
        'https://api.example.com/refresh_token',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        accessToken = response.data['access_token'];
        await _storeAccessToken(accessToken);
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  Future<Response> _request(RequestOptions options) async {
    try {
      return await dio.request(options.path!, options: options);
    } on DioError catch (error) {
      if (error.response?.statusCode == 401) {
        await _refreshToken();
        options.headers['Authorization'] = 'Bearer $accessToken';
        return await dio.request(options.path!, options: options);
      } else {
        throw error;
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String path) async {
    Response response = await _request(
      RequestOptions(
        path: path,
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getById(String path, int id) async {
    Response response = await _request(
      RequestOptions(
        path: '$path/$id',
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> create(
      String path, Map<String, dynamic> data) async {
    Response response = await _request(
      RequestOptions(
        path: path,
        method: 'POST',
        headers: {'Authorization': 'Bearer $accessToken'},
        data: jsonEncode(data),
      ),
    );
    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to create data');
    }
  }

  Future<Map<String, dynamic>> update(
      String path, int id, Map<String, dynamic> data) async {
    Response response = await _request(
      RequestOptions(
        path: '$path/$id',
        method: 'PUT',
        headers: {'Authorization': 'Bearer $accessToken'},
        data: jsonEncode(data),
      ),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> delete(String path, int id) async {
    Response response = await _request(
      RequestOptions(
        path: '$path/$id',
        method: 'DELETE',
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete data');
    }
  }
}
