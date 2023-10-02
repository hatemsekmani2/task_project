import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:task_project/features/posts/widgets/all_posts.dart';
import '../../../common/common.dart';
import '../../../network_settings/network_constants.dart';
import '../../../network_settings/network_handler_http_methods.dart';
import '../models/AllPostResponse.dart';
import '../general_variables.dart';
import '../states/states.dart';
class PostsController extends GetxController{
  PostsController._();
  List<Items> posts = [];
  AllPostResponse? _allPostResponse ;
  static PostsController? _instance;
   PostsStates currentState = const InitialPostsState();
   PostsStates loadingPostsState = const LoadingPostsState();
   PostsStates finishedLoadingPostsState = const PostsFinishedLoadingState();
   PostsStates loadingPostsForFirstTimeState = const LoadingPostsForFirstTimeState();
   PostsStates errorLoadingPostsState = const PostsErrorLoadingState();
  static PostsController getInstance(){
    _instance = PostsController();
    return _instance!;
  }
  PostsController();

  Future<void> getPosts({bool? refreshlatestPosts}) async{
   try{
     if(refreshlatestPosts!=null){

       currentState = loadingPostsForFirstTimeState;
       GeneralVariables.currentPageNumber = 1;
       GeneralVariables.getAllPostsUrl = "api/posts/v1/all?page=1";
       posts = [];
       update();
     }
    else if(GeneralVariables.currentPageNumber == 1) {
      currentState = loadingPostsForFirstTimeState;
      update();

    }
    else{
      currentState = loadingPostsState;

      update();
    }


    http.Response currentPagePostsResponse = await NetworkHandlerHttpMethods.getInstance().makeHttpCall(GeneralVariables.getAllPostsUrl);
    if(currentPagePostsResponse.statusCode == 200) {
      _allPostResponse = AllPostResponse.fromJson(jsonDecode(currentPagePostsResponse.body));
      if(_allPostResponse!.data !=null
          && _allPostResponse!.data!.items!=null
          && _allPostResponse!.data!.items!.isNotEmpty) {
        for (var item in _allPostResponse!.data!.items!) {
          posts.add(item);
        }

        GeneralVariables.getAllPostsUrl = _allPostResponse!.data!.nextPageUrl!.replaceAll(NetworkConstants.mainRoute, "");
        GeneralVariables.currentPageNumber++;
        currentState = finishedLoadingPostsState;
        update();
      }
    }

    else{
      currentState = errorLoadingPostsState;
      Get.snackbar("Error Happened", currentPagePostsResponse.body,backgroundColor: Colors.red.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
      update();

    }
   }
      catch(error) {
        currentState = errorLoadingPostsState;

        Get.snackbar("Error Happened", error.toString(),backgroundColor: Colors.red.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
        update();

      }
    }



  Future<TaskSnapshot?> uploadMedia(var pickedFile,String id) async{
    CommonThings.showLoadingDialog(Get.context!,"Uploading Media...");
    try{
    File file = pickedFile;
    Reference reference =  FirebaseStorage.instance.ref();
    var response = await  reference.child("images/${DateTime.now()}${file.path.split("/").last}").putFile(file);
    Navigator.of(Get.context!,rootNavigator: true).pop();
    if(response.state.toString().toLowerCase().contains("success")) {
      if((response.metadata!.contentType??"").contains('image')) {
        Get.snackbar("Information", "Image Uploaded Successfully",backgroundColor: Colors.white.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
      }
      else{
        Get.snackbar("Information", "Video Uploaded Successfully",backgroundColor: Colors.white.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);

      }
      return response;
     }
     else{
       return null;
     }
    }
    catch (e) {
      Navigator.of(Get.context!,rootNavigator: true).pop();
      Get.snackbar("Error", e.toString(),backgroundColor: Colors.red.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
      return null;
    }


  }

  Future<void> uploadPost(String content,TaskSnapshot? mediaData, info) async{
    try{
    CommonThings.showLoadingDialog(Get.context!, "Posting....");
    var body = <String,dynamic>{};
    if(mediaData!=null) {
      String url = await mediaData.ref.getDownloadURL();
      body = {
        "content": content, //required without media.
        "media": [
          {
            "src_url": url, //required
            "src_thum": "", //optional
            "src_icon": "", //optional
            "media_type": (mediaData.metadata!.contentType??"").contains("image")?"Image":"Video", //required
            "mime_type": (mediaData.metadata!.contentType??""), //required
            "fullPath": mediaData.ref.fullPath, //required ex:posts/media-3702f
            "width": info!=null ? info.width : null, //integer, required when media_type is Video
            "height": info!=null ? info.height : null, //integer, required when media_type is Video
            "size": mediaData.metadata!.size??0 //required
          }
        ],
        "friends_ids": [] // The IDs of the profiles ,array, optinoal
      };
     }
    else{
      body = {
        "content": content, //required without media.
        "media": [],
        "friends_ids": [] // The IDs of the profiles ,array, optinoal
      };
    }
      NetworkHandlerHttpMethods.getInstance().makeHttpPostCall("api/posts/v1/add", body: body).then((value) {
        if(value.statusCode == 200 || value.statusCode == 201) {
          Get.snackbar("Posting Done", "Post is Uploaded Successfully",backgroundColor: Colors.white.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM,);

          //GeneralVariables.currentPageNumber = 1;
         // GeneralVariables.getAllPostsUrl = "api/posts/v1/all?page=${GeneralVariables.currentPageNumber}";
         // posts = [];

          Timer(const Duration(seconds: 2),() {

            GeneralVariables.postsController.getPosts(refreshlatestPosts: true);
            Navigator.of(Get.context!, rootNavigator: true)
                  .popUntil(ModalRoute.withName("/posts"));





            },);

        }
        else{
          Navigator.of(Get.context!).pop();
          Get.snackbar("Post Error", value.body,backgroundColor: Colors.red.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
        }
      });

    }
    catch(e) {
      Navigator.of(Get.context!,rootNavigator: true).pop();
     Get.snackbar("Error Uploading Post", e.toString(),backgroundColor: Colors.red.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
    }
  }

  }
