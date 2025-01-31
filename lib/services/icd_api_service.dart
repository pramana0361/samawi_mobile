import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:simawi_mobile/utils/functions.dart';

class IcdApiService {
  static const _parentUri = 'https://id.who.int';
  static const _tokenEndpoint =
      "https://icdaccessmanagement.who.int/connect/token";
  static const _scope = "icdapi_access";
  static const _grantType = 'client_credentials';
  static const _clientID =
      'c7305c6d-4676-4b44-8933-2869e9c8b0b0_02bda0f2-d643-41de-aa10-127389d09de4'; // ICD API WHO client id
  static const _clientSecret =
      'l3BPvG05RqnO7VYpi7H4wPqiy40VWsBZsuR57QiHVN4='; // ICD API WHO client secret

  static IcdApiService? _instance;
  factory IcdApiService() => _instance ??= IcdApiService._();
  IcdApiService._();

  Future<String> initIcdApi() async {
    try {
      final data = {
        'client_id': _clientID,
        'client_secret': _clientSecret,
        'scope': _scope,
        'grant_type': _grantType,
      };
      final res = await http.post(Uri.parse(_tokenEndpoint), body: data);
      final accessToken = json.decode(res.body)['access_token'];
      printDebug('ICD API initIcdApi() success: $accessToken');
      return accessToken;
    } catch (e) {
      printDebug('ICD API initIcdApi() error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> request(String path,
      {required String accessToken}) async {
    try {
      final url = Uri.parse(_parentUri + path);
      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
          'Accept-Language': 'en',
          'API-Version': 'v2'
        },
      );
      final data = json.decode(res.body);
      printDebug('ICD API request($path) success: $data');
      return data;
    } catch (e) {
      printDebug('ICD API request($path) error: $e', isError: true);
      return Future.error(e);
    }
  }
}
