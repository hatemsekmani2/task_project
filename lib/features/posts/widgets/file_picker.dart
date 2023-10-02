import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
class FilePicerWidget extends StatefulWidget {
  final ValueNotifier<File> imageFile;
  const FilePicerWidget(this.imageFile,{super.key});

  @override
  State<FilePicerWidget> createState() => _FilePicerWidgetState();

  static Widget myButton(context,{required String title, required Function() callback, required Color backgroundColor, required Color fontColor, required double width, required double height, bool? isRounded, bool? multipleButtons}) {
    return Container(
        width: width,
        margin:multipleButtons!=null ? null:  EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width-width)/2),
        height: height,
        child: MaterialButton(
          onPressed: callback,
          elevation: 3,
          color: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height)),
          child: Text(title,style: TextStyle(color: fontColor,fontSize: 15,fontWeight: FontWeight.w500,),textAlign: TextAlign.center),
        ));
  }

}

class _FilePicerWidgetState extends State<FilePicerWidget> {
  ValueNotifier<bool> notifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    
    String s = "";
    
      return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context , value , _) => Center(
          child: Container(
            width:MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Text("Pick Image or Video",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15,),maxLines: 1)),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          width:MediaQuery.of(context).size.width/3,
                          child:  FilePicerWidget.myButton(
                            context,
                            title: "Pick File",
                            backgroundColor: Theme.of(context).primaryColor,
                            fontColor: Colors.white,
                            multipleButtons: true,
                            height: 30,
                            width:MediaQuery.of(context).size.width/3,
                            callback: () async{
                              if((await Permission.storage.status) != PermissionStatus.granted){
                                Permission.storage.request().then((value) {
                                  FilePicker.platform.pickFiles(type: FileType.custom,allowMultiple: false,allowedExtensions: ["jpg","jpeg","gif","png","mp4","mkv","flv","mpeg"]).then((pickedFile) {
                                    PlatformFile image = pickedFile!.files[0];

                                    if(image!=null&&["jpg","jpeg","gif","png","mp4","mkv","flv","mpeg"].where((element) => image.path!.contains(".$element")).toList().isNotEmpty){
                                      notifier.value = false;

                                      widget.imageFile.value = File(image.path!);
                                      notifier.value = true;

                                    }

                                    else{

                                      Get.snackbar( "Unsupported file formate", "Unsupported file formate",);

                                    }
                                  });
                                });}
                              else{
                                FilePicker.platform.pickFiles(type: FileType.custom,allowMultiple: false,allowedExtensions:["jpg","jpeg","gif","png","mp4","mkv","flv","mpeg"]).then((pickedFile) {
                                  PlatformFile image = pickedFile!.files[0];

                                  if(image!=null&&["jpg","jpeg","gif","png","mp4","mkv","flv","mpeg"].where((element) => image.path!.contains(".$element")).toList().isNotEmpty){
                                    notifier.value = false;

                                    widget.imageFile.value = File(image.path!);
                                    notifier.value = true;

                                  }
                                  else{

                                    Get.snackbar( "Unsupported file formate", "Unsupported file formate",);

                                  }
                                });
                              }
                            },

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/100,),

                    if (widget.imageFile.value.path == "") const SizedBox() else Container(
                      margin: EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.width*(1/40),horizontal: 2.5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow:  (widget.imageFile!.value.path.split("/")[ widget.imageFile!.value.path.split("/").length-1])=="" ?null :
                          [
                            BoxShadow(offset: const Offset(0,1),blurRadius: 2,color: Theme.of(context).primaryColor.withOpacity(0.3))
                          ]
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 5,),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: Text(
                                  (widget.imageFile!.value.path.split("/")[ widget.imageFile!.value.path.split("/").length-1])==""?("") : (widget.imageFile!.value.path.split("/")[ widget.imageFile.value!.path.split("/").length-1]),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 2
                              ),
                            ),
                          ),
                          (widget.imageFile!.value.path.split("/")[ widget.imageFile!.value.path.split("/").length-1])==""?const SizedBox() :   IconButton(onPressed: (){
                            OpenFilex.open(widget.imageFile.value.path);

                          }, icon: Text("Open",style: TextStyle(fontSize: 12,color: Theme.of(context).primaryColor,decoration: TextDecoration.underline),))
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),

                  ],
                ),
                const SizedBox(height: 10,),
                /*
              (!imageNotifier2.value)?
              Container(width: w-w/10,decoration: BoxDecoration(border:Border.all(color: Colors.white,width: 2)),child: Image.network(Statics.imageUrl+LocalStorageHandler.getInstance().getString("license")!,
                errorBuilder: (context,object,trace) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: SizedBox());}
                ,width: w-w/10,fit: BoxFit.fitWidth,)):
*/
              ],
            ),
          ),
        ),
      );
    
  }

}
