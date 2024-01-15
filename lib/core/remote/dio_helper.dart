import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static dioInit() {
    dio = Dio(
      BaseOptions(
        baseUrl: '',
        receiveDataWhenStatusError: true,
      ),
    );
  }

    static Future<Response> getData({
      required String url,
      Map<String, dynamic>? query,
    }) async {
      dio!.options.headers = {
        'Content-Type': 'application/json',
      };
      final res = await dio!.get(
        url,
        queryParameters: query,
      );
      return res;
    }


  static Future<Response> postData({
    required String url,
    var data,
    String? language,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio!.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return await dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
  }
}
