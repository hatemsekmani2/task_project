import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'network_handler.dart';
import 'package:dio/dio.dart';
class NetworkHandlerHttpMethods {
  static  NetworkHandler? _networkHandler;
  static  NetworkHandlerHttpMethods? _networkHandlerHttpMethods;

  NetworkHandlerHttpMethods._();

  static NetworkHandlerHttpMethods getInstance() {
    _networkHandler ??= NetworkHandler();
    _networkHandlerHttpMethods ??= NetworkHandlerHttpMethods._();
    return _networkHandlerHttpMethods!;
  }


  Future<http.Response> makeHttpCall(String url ,{header , body,  String? type}) async{
  

      Response<String> dioResponse =  await _networkHandler!.dio.get<String>(url);
      return http.Response(
        dioResponse.data!,
        dioResponse.statusCode!,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          }
      );

  }
  Future<http.Response> makeHttpPostCall(String url ,{header , required Map<String,dynamic> body,  String? type}) async{
    log("result",error: body.toString(), );
    Response<String> dioResponse =  await _networkHandler!.dio.post<String>(url , data: jsonEncode(body));
    log("kkkkkkkkkkkkkk ${dioResponse.data!.replaceAll('\\"', '"')}");
    return http.Response(
      dioResponse.data!,
      dioResponse.statusCode!,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        }
    );
  }
  Future<http.Response> makeHttpPutCall(String url ,{header , required String body,  String? type}) async{

    Response<String> dioResponse =  await _networkHandler!.dio.put<String>(url, data: body);
    return http.Response(
      dioResponse.data!,
      dioResponse.statusCode!,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        }
    );
  }
  Future<http.Response> makeHttpDeleteCall(String url ,{header ,  String? type}) async{

    Response<String> dioResponse =   await _networkHandler!.dio.delete<String>(url);
    return http.Response(
      dioResponse.data!,
      dioResponse.statusCode!,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        }
    );
  }

}