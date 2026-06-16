import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'main.dart' show Catatan;

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  // Base URL API
  static const String _baseUrl =
      'https://besab-production.up.railway.app/api';

  // API Key
  static const String _apiKey =
      '8f38b5fbf0bc437285f2c62ed6e447eab56f78c8f95239a7';

  static const Duration _timeout = Duration(seconds: 10);

  Map<String, String> get _headers => {
    'X-API-Key': _apiKey,
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // =====================
  // GET ALL
  // =====================

  Future<List<Catatan>> getAll() async {
    final res = await _send(
          () => http.get(
        Uri.parse('$_baseUrl/catatan'),
        headers: _headers,
      ),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    final list =
    (body['data'] as List).cast<Map<String, dynamic>>();

    return list.map(Catatan.fromJson).toList();
  }

  // =====================
  // GET BY ID
  // =====================

  Future<Catatan> getById(int id) async {
    final res = await _send(
          () => http.get(
        Uri.parse('$_baseUrl/catatan/$id'),
        headers: _headers,
      ),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    return Catatan.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  // =====================
  // INSERT
  // =====================

  Future<Catatan> insert(Catatan c) async {
    final res = await _send(
          () => http.post(
        Uri.parse('$_baseUrl/catatan'),
        headers: _headers,
        body: jsonEncode(c.toJson()),
      ),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    return Catatan.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  // =====================
  // UPDATE
  // =====================

  Future<Catatan> update(Catatan c) async {
    assert(c.id != null);

    final res = await _send(
          () => http.put(
        Uri.parse('$_baseUrl/catatan/${c.id}'),
        headers: _headers,
        body: jsonEncode(c.toJson()),
      ),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    return Catatan.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  // =====================
  // DELETE
  // =====================

  Future<void> delete(int id) async {
    await _send(
          () => http.delete(
        Uri.parse('$_baseUrl/catatan/$id'),
        headers: _headers,
      ),
    );
  }

  // =====================
  // HELPER REQUEST
  // =====================

  Future<http.Response> _send(
      Future<http.Response> Function() req,
      ) async {
    try {
      // Cek koneksi internet
      final connectivity =
      await Connectivity().checkConnectivity();

      if (connectivity.contains(
        ConnectivityResult.none,
      )) {
        throw ApiException(
          0,
          'Tidak ada koneksi internet.',
        );
      }

      final res = await req().timeout(_timeout);

      if (res.statusCode >= 200 &&
          res.statusCode < 300) {
        return res;
      }

      throw ApiException(
        res.statusCode,
        _extractMessage(res),
      );
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException(
        0,
        'Server tidak merespons (timeout).',
      );
    } on http.ClientException {
      throw ApiException(
        0,
        'Connection error.',
      );
    } on SocketException {
      throw ApiException(
        0,
        'Connection error.',
      );
    } catch (_) {
      throw ApiException(
        0,
        'Connection error.',
      );
    }
  }

  // =====================
  // AMBIL PESAN ERROR API
  // =====================

  String _extractMessage(http.Response res) {
    try {
      final body =
      jsonDecode(res.body) as Map<String, dynamic>;

      final message =
          body['message']?.toString() ??
              'HTTP ${res.statusCode}';

      return 'HTTP ${res.statusCode}: $message';
    } catch (_) {
      return 'HTTP ${res.statusCode}';
    }
  }
}