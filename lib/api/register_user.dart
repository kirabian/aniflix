import 'dart:convert';

import 'package:cinemax/api/endpoint/endpoint.dart';
import 'package:cinemax/models/get_user_model.dart';
import 'package:cinemax/models/register_user_model.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPI {
  /// Register user baru
  static Future<RegisterUserModel> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);

    final response = await http.post(
      url,
      body: {"name": name, "email": email, "password": password},
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return RegisterUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  /// Login user
  static Future<RegisterUserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);

    final response = await http.post(
      url,
      body: {"email": email, "password": password},
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = RegisterUserModel.fromJson(json.decode(response.body));

      // ✅ Ambil token dari nested data
      if (data.data?.token != null) {
        await PreferenceHandler.saveToken(data.data!.token!);
      }
      await PreferenceHandler.saveLogin();

      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Login gagal");
    }
  }

  /// Update profile user
  static Future<GetUserModel> updateUser({required String name}) async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      body: {"name": name},
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token", // ✅ pakai Bearer
      },
    );

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Update user gagal");
    }
  }

  /// Ambil profile user
  static Future<GetUserModel> getProfile() async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token", // ✅ pakai Bearer
      },
    );

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Get profile gagal");
    }
  }

  static Future<void> logout() async {
    await PreferenceHandler.removeLogin();
    await PreferenceHandler.removeToken();
  }
}
