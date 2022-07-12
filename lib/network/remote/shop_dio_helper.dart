import 'package:dio/dio.dart';

class ShopDioHelper {
  static Dio shopDio = Dio();

  static init() {
    shopDio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    String? url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    shopDio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token, //authorization
    };
    return shopDio.get(
      url!,
      queryParameters: query,
    );
  }

  static Future<Response> postDate({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    shopDio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    return await shopDio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    shopDio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type': 'application/json',
    };

    return await shopDio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
