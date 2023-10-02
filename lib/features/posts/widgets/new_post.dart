import 'dart:developer';
import 'dart:io';
import 'package:flutter_video_info/flutter_video_info.dart';

import 'package:flutter/material.dart';
import 'package:task_project/features/posts/widgets/file_picker.dart';
import 'package:task_project/features/posts/widgets/large_text_field.dart';
import 'package:get/get.dart';
import '../controllers/posts_controller.dart';
class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController controller = TextEditingController(text: "");
  ValueNotifier<File> imageFile = ValueNotifier(File(""));
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: const Text('New Post'),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          children: [
            LargeTextField(controller),
            const SizedBox(height: 20,),
            FilePicerWidget(imageFile),
            const SizedBox(height: 60,),
            FilePicerWidget.myButton(
              context,
              title: "- Post -",
              backgroundColor: Theme.of(context).primaryColor,
              fontColor: Colors.white,
              multipleButtons: true,
              height: 40,
              width:MediaQuery.of(context).size.width/2,
              callback: () => uploadMedia(),

            ),
          ],
        ),
      ),

    );
  }

  Future<void> uploadMedia() async{
    if((controller.text!="") || (controller.text == "" && imageFile.value.path!= "")){

      if(imageFile.value.path != ""){
        var mediaData = await PostsController.getInstance().uploadMedia(imageFile.value,"1");


        if(mediaData != null) {
          VideoData? info;
          if(!(mediaData.metadata!.contentType??"").contains("image")){
            info = await FlutterVideoInfo().getVideoInfo(imageFile.value.path);
          }
          PostsController.getInstance().uploadPost(controller.text,mediaData,info);
        }
        else{
          Get.snackbar("Error While Uploading Media", "Error Happened While Uploading Media",backgroundColor: Colors.red.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
        }
      }
      else{
        PostsController.getInstance().uploadPost(controller.text,null,null);

      }
    }
    else{
      Get.snackbar("Information", "Missing content",backgroundColor: Colors.red.withOpacity(0.8),snackPosition: SnackPosition.BOTTOM);
    }
  }
}
