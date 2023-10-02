import 'package:flutter/material.dart';
class CommonThings {
  static Future<void> showLoadingDialog(BuildContext context, String s) async{
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => true,
            child: Directionality(
              textDirection: TextDirection.ltr,

              child: SimpleDialog(

                children: [
              Container(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),strokeWidth: 1.5),
                    const SizedBox(height: 5,),
                    Text(s.replaceAll("?", ""),style: TextStyle(color:Theme.of(context).primaryColor, fontSize: 13,fontWeight:FontWeight.w500),)
                  ],
                ),
              ),)
                ],
              ),
            ),
          );
        }
    );
  }
}