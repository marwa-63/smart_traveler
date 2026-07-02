import 'package:dio/dio.dart';

class PhotoServices {

  final dio =Dio(
  BaseOptions(
    baseUrl: "https://api.unsplash.com/" ,
    headers: {
      "Authorization" : "Client-ID 3FrjMUqgQt1hssin5kP6xtuRqezXBmDVGJYLDE-YpXc"  }
  )
  );

  Future<String> getPhoto({required String placeName}) async{
    try {
      final response = await dio.get(
        'search/photos?',
        queryParameters: {
          'page' :1,
          'query' :placeName
        }
      );
      return response.data['results'][0]['urls']['regular'];
    } 
    on DioException catch(e){
      throw Exception( "error reaching server ${e.response}");
    }
    
  }
}