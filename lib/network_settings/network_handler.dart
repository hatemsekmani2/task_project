import 'dart:convert';
import 'dart:developer';

import 'package:task_project/local_storage/local_storage_handler.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart';

import 'network_constants.dart';
import 'network_handler_http_methods.dart';

class NetworkHandler {
  final dio = createDio;
  final tokenDio = Dio(BaseOptions(baseUrl: NetworkConstants.mainRoute));
  final authDio = createAuthDio;

  NetworkHandler._internal();

  static final _singleton = NetworkHandler._internal();

  factory NetworkHandler() => _singleton;

  static Dio get createDio {
    var dio = Dio(BaseOptions(
      baseUrl: NetworkConstants.mainRoute,
      receiveTimeout: const Duration(seconds: 40),
      connectTimeout: const Duration(seconds: 40),
      sendTimeout: const Duration(seconds: 40),
    ));

    dio.interceptors.addAll({
      AppInterceptors(dio),
    });
    return dio;
  }

  static Dio get createAuthDio {
    var authDio = Dio(BaseOptions(
      baseUrl: NetworkConstants.mainRoute,
      receiveTimeout: const Duration(seconds: 40), // 15 seconds
      connectTimeout: const Duration(seconds: 40),
      sendTimeout: const Duration(seconds: 40),
    ));

    // authDio.interceptors.addAll({
    //   AppInterceptors(authDio),
    // });
    return authDio;
  }
}

class AppInterceptors extends Interceptor {
  final Dio? dio;

  LocalStorageHandler localStorageHandler = LocalStorageHandler.getInstance();

  static bool refreshingToken = false;
  //LoaderController loaderController = Get.put(LoaderController());
  // final MessagesHandlerController msgHandlerController =
  //     Get.put(MessagesHandlerController());
  // final AuthController authController = Get.put(AuthController());
  // final UserInfoController userInfoController = Get.put(UserInfoController());
  AppInterceptors(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    const token = NetworkConstants.token;


    // options.method != 'POST' ? loaderController.loading(true) : null;
    // options.headers = {
    //   "Content-Type": "application/json",
    //   "accept": "*/*",
    //   "Authorization": "bearer "
    // };
    // options.headers['Authorization'] = 'bearer $token';
    // options.headers = {
    //   'Authorization': 'bearer $token',
    // };
    if (token == null || token.isEmpty || options.uri.path.contains("token")) {
      options.headers = {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
      };
      print('not auth');
    } else if (token.isNotEmpty || token != null) {
      options.headers = {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "$token",
        "Accept-Encoding": "gzip, deflate, br",
        // "Content-Type": "application/json",
      };
    }
    log('===========================================Request : =================================>>>\n\n\n');
    log(options.uri.path);
    log(options.headers.toString());
    log(options.data.toString());
    log('======================================================================================>>>\n\n\n');
    return handler.next(options);
  }

  @override
  void onResponse(
      response,
      ResponseInterceptorHandler handler,
      ) {
    log('<<<===========================================Response : =================================\n\n\n');

    log(

        'RESPONSE[${response.statusCode}] => Data: ${response.data}',
      name: response.realUri.path
    );
    log('<<<======================================================================================\n\n\n');

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
   // LoaderController loaderController = Get.put(LoaderController());
   // MessagesHandlerController msgController =
   // Get.put(MessagesHandlerController());
   // LoginController loginController = Get.put(LoginController());
   // loaderController.loading(true);
   // msgController.showErrorMessage('${err.response!.data}');
    print(
      'ERROR[${err.response!.statusCode}] => PATH: ${err.response!.data}  to ${err.response!.realUri.path}',
    );

    if (err.response!.statusCode == 401) {
      if(!refreshingToken) {
        refreshingToken = true;
        NetworkHandlerHttpMethods.getInstance().makeHttpPostCall("api/identity/token/refresh", body: {"token": (LocalStorageHandler.getInstance().getString("token")??"").replaceAll("bearer ", ""), "refreshToken": LocalStorageHandler.getInstance().getString("refreshToken")!}).then((value) {
          Map<String , dynamic>? entries = jsonDecode(value.body)["data"];
          for (int i = 0; i < entries!.keys.toList().length;i++){
            if(entries.keys.toList()[i].contains("Token") ||entries.keys.toList()[i].contains("token")){
            if(entries.keys.toList()[i]=="token") {
              LocalStorageHandler.getInstance().setString(entries.keys.toList()[i], "bearer ${entries.values.toList()[i]}");
              log("token :${entries.keys.toList()[i]}");
            }
            else {
              LocalStorageHandler.getInstance().setString(entries.keys.toList()[i], entries.values.toList()[i].toString());
              log(LocalStorageHandler.getInstance().getString(entries.keys.toList()[i])!);

            }
            }
          }
          refreshingToken = false;
          //Statics.showToast(AppLanguage.lan == 'ar'? "الرجاء إعادة المحاولة":"Please retry");

        });
      }
      //loginController.getRefreshToken();
    } else if (err.response!.statusCode == 403) {
      if(!refreshingToken) {
        refreshingToken = true;
        NetworkHandlerHttpMethods.getInstance().makeHttpPostCall("api/identity/token/refresh", body: {"token": (LocalStorageHandler.getInstance().getString("token")??"").replaceAll("bearer ", ""), "refreshToken": LocalStorageHandler.getInstance().getString("refreshToken")!}).then((value) {
          Map<String , dynamic>? entries = jsonDecode(value.body)["data"];
          for (int i = 0; i < entries!.keys.toList().length;i++){
            if(entries.keys.toList()[i].contains("Token") ||entries.keys.toList()[i].contains("token")){
              if(entries.keys.toList()[i]=="token") {
                LocalStorageHandler.getInstance().setString(entries.keys.toList()[i], "bearer ${entries.values.toList()[i]}");
                log("token :${entries.keys.toList()[i]}");
              }
              else {
                LocalStorageHandler.getInstance().setString(entries.keys.toList()[i], entries.values.toList()[i].toString());
                log(LocalStorageHandler.getInstance().getString(entries.keys.toList()[i])!);

              }
            }
          }
          refreshingToken = false;
       //   Statics.showToast(AppLanguage.lan == 'ar'? "الرجاء إعادة المحاولة":"Please retry");

        });
      }      //  loginController.getRefreshToken();
    } else if (err.response!.statusCode == 500) {

     // msgController.showErrorMessage('Server error'.tr);
    }
//  switch (err.type) {
//   case dio.connectTimeout:
//   case DioError.sendTimeout:
//   case DioErrorType.receiveTimeout:
//     throw DeadlineExceededException(err.requestOptions);
//   case DioErrorType.response:
//     switch (err.response?.statusCode) {
//       case 400:
//         throw BadRequestException(err.requestOptions);
//       case 401:
//         throw UnauthorizedException(err.requestOptions);
//       case 404:
//         throw NotFoundException(err.requestOptions);
//       case 409:
//         throw ConflictException(err.requestOptions);
//       case 500:
//         throw InternalServerErrorException(err.requestOptions);
//     }
//     break;
//   case DioErrorType.cancel:
//     break;
//   case DioErrorType.other:
//     throw NoInternetConnectionException(err.requestOptions);
// }
    handler.next(err);
  //  loaderController.loading(false);
    return super.onError(err, handler);
    // return null;
  }
}