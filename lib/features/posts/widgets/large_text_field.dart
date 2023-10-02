import 'package:flutter/material.dart';
class LargeTextField extends StatefulWidget {
  final TextEditingController controller;
  const LargeTextField(this.controller,{super.key});

  @override
  State<LargeTextField> createState() => _LargeTextFieldState();
}

class _LargeTextFieldState extends State<LargeTextField> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: w,
          margin: EdgeInsets.symmetric(vertical: w/160),
          child: Text("Content : ",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 15)),
        ),
        Container(
          width: w-w/20,
          margin: EdgeInsets.symmetric(vertical: w/80),


          height: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*(19/20)/3<150?150:MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*(19/20)/3,
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Theme.of(context).primaryColor,),
              borderRadius: BorderRadius.circular(5)

          ),
          child: TextField(
            keyboardType: TextInputType.multiline,


            minLines: 1,//Normal textInputField will be displayed
            maxLines: 10,

            controller: widget.controller,
            style: TextStyle(fontSize:15,color:Theme.of(context).primaryColor),

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              border: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5)

              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5)

              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5)

              ),


            ),
          ),
        ),
      ],
    );
  }
}
