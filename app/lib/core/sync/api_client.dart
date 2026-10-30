/// 後端 API 客戶端（docs/API_CONTRACT.md v1）。
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthTokens {
  final String userId;
  final String accessToken;
  final String refreshToken;

  const AuthTokens(this.userId, this.accessToken, this.refreshToken);

  Map<String, String> toJson() => {
    'user_id': userId,
    'access_token': accessToken,
    'refresh_token': refreshToken,
  };

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    json['user_id'] as String,
    json['access_token'] as String,
    json['refresh_token'] as String,
  );
}

/// 權杖存放處。正式使用系統安全儲存（Keystore／Keychain），不存 SQLite、不進備份檔。
abstract class TokenStore {
  Future<AuthTokens?> read();
  Future<void> write(AuthTokens tokens);
  Future<void> clear();
}

class SecureTokenStore implements TokenStore {
  static const _key = 'farming_diary_auth';
  final FlutterSecureStorage _storage;

  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<AuthTokens?> read() async {
    final raw = await _storage.read(key: _key);
    return raw == null
        ? null
        : AuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> write(AuthTokens tokens) =>
      _storage.write(key: _key, value: jsonEncode(tokens.toJson()));

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

class MemoryTokenStore implements TokenStore {
  AuthTokens? tokens;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> write(AuthTokens t) async => tokens = t;

  @override
  Future<void> clear() async => tokens = null;
}

class ApiException implements Exception {
  final int status;
  final String code;
  final String message;

  const ApiException(this.status, this.code, this.message);

  bool get isAuth => status == 401;
  bool get isRevoked => status == 403 && code == 'membership_revoked';
  bool get isRetryable => status == 429 || status >= 500 || status == 0;

  @override
  String toString() =>
      status == 0 ? '連不上伺服器（$message）' : '伺服器回應 $status $code：$message';
}

class ApiClient {
  final Uri baseUrl;
  final TokenStore tokens;
  final http.Client _http;

  ApiClient(this.baseUrl, this.tokens, {http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  void close() => _http.close();

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = baseUrl.path.endsWith('/')
        ? baseUrl.path.substring(0, baseUrl.path.length - 1)
        : baseUrl.path;
    return baseUrl.replace(path: '$base$path', queryParameters: query);
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool auth = true,
    bool retried = false,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final t = await tokens.read();
      if (t == null) throw const ApiException(401, 'not_signed_in', '尚未登入伺服器');
      headers['Authorization'] = 'Bearer ${t.accessToken}';
    }
    final http.Response res;
    try {
      final request = http.Request(method, _uri(path, query))
        ..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      res = await http.Response.fromStream(
        await _http.send(request).timeout(const Duration(seconds: 30)),
      );
    } on SocketException catch (e) {
      throw ApiException(0, 'network', e.message);
    } on HttpException catch (e) {
      throw ApiException(0, 'network', e.message);
    } on http.ClientException catch (e) {
      throw ApiException(0, 'network', e.message);
    }
    if (res.statusCode == 401 && auth && !retried) {
      await _refresh();
      return _send(
        method,
        path,
        body: body,
        query: query,
        auth: auth,
        retried: true,
      );
    }
    final decoded = res.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(utf8.decode(res.bodyBytes));
    if (res.statusCode >= 400) {
      final map = decoded is Map<String, dynamic>
          ? decoded
          : const <String, dynamic>{};
      throw ApiException(
        res.statusCode,
        map['error_code'] as String? ?? 'http_${res.statusCode}',
        map['message'] as String? ?? res.reasonPhrase ?? '',
      );
    }
    return decoded as Map<String, dynamic>;
  }

  Future<void> _refresh() async {
    final t = await tokens.read();
    if (t == null) throw const ApiException(401, 'not_signed_in', '尚未登入伺服器');
    try {
      final res = await _send(
        'POST',
        '/auth/refresh',
        body: {'refresh_token': t.refreshToken},
        auth: false,
      );
      await tokens.write(
        AuthTokens(
          res['user_id'] as String? ?? t.userId,
          res['access_token'] as String,
          res['refresh_token'] as String,
        ),
      );
    } on ApiException catch (e) {
      if (e.status == 401 || e.status == 400) await tokens.clear();
      rethrow;
    }
  }

  // ───────────────────────── 認證 ─────────────────────────

  Future<AuthTokens> devLogin({
    required String displayName,
    required String localUserId,
    String deviceLabel = '',
  }) async {
    final res = await _send(
      'POST',
      '/auth/dev/login',
      body: {
        'display_name': displayName,
        'local_user_id': localUserId,
        'device_label': deviceLabel,
      },
      auth: false,
    );
    final t = AuthTokens(
      res['user_id'] as String,
      res['access_token'] as String,
      res['refresh_token'] as String,
    );
    await tokens.write(t);
    return t;
  }

  Future<void> signOut() => tokens.clear();

  // ───────────────────────── 同步 ─────────────────────────

  Future<List<Map<String, dynamic>>> push(
    List<Map<String, dynamic>> commands,
  ) async {
    final res = await _send('POST', '/sync/push', body: {'commands': commands});
    return (res['results'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> changes({String? cursor, int limit = 500}) =>
      _send(
        'GET',
        '/sync/changes',
        query: {'cursor': ?cursor, 'limit': '$limit'},
      );

  // ───────────────────────── 媒體 ─────────────────────────

  Future<Map<String, dynamic>> createUpload(Map<String, dynamic> body) =>
      _send('POST', '/uploads', body: body);

  Future<void> putUpload(
    Uri url,
    Map<String, String> headers,
    File file,
  ) async {
    final http.Response res;
    try {
      final request = http.StreamedRequest('PUT', url)..headers.addAll(headers);
      request.contentLength = await file.length();
      file.openRead().listen(
        request.sink.add,
        onDone: request.sink.close,
        onError: request.sink.addError,
      );
      res = await http.Response.fromStream(
        await _http.send(request).timeout(const Duration(minutes: 5)),
      );
    } on SocketException catch (e) {
      throw ApiException(0, 'network', e.message);
    } on http.ClientException catch (e) {
      throw ApiException(0, 'network', e.message);
    }
    if (res.statusCode >= 300) {
      throw ApiException(
        res.statusCode,
        'upload_failed',
        res.reasonPhrase ?? '',
      );
    }
  }

  Future<Map<String, dynamic>> completeUpload(String uploadId) =>
      _send('POST', '/uploads/$uploadId/complete');

  Future<Uri> mediaUrl(String mediaAssetId) async {
    final res = await _send('GET', '/media/$mediaAssetId/url');
    return Uri.parse(res['url'] as String);
  }

  Future<List<int>> download(Uri url) async {
    try {
      final res = await _http.get(url).timeout(const Duration(minutes: 2));
      if (res.statusCode >= 300) {
        throw ApiException(
          res.statusCode,
          'download_failed',
          res.reasonPhrase ?? '',
        );
      }
      return res.bodyBytes;
    } on SocketException catch (e) {
      throw ApiException(0, 'network', e.message);
    }
  }
}
