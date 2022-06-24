import 'package:flutter/material.dart';

class Btn_main extends StatelessWidget {
  //const Btn_main({Key? key}) : super(key: key);

   String Placeholder;
  Btn_main({required this.Placeholder});
  @override
  Widget build(BuildContext context) {

    return  Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [
              Color(0x406cc51d),
              Color(0xff6CC51D),
            ]
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text(Placeholder,style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }

}
