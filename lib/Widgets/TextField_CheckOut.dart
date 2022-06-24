import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final String Placeholder;
  var pr_icon;
  var controller;
  var keybordtype;
  late final String ReturenStatement;
  TextFields({
    required this.Placeholder,
    required this.pr_icon,
    required this.controller,
    required this.ReturenStatement,
    required this.keybordtype});

  @override
  Widget build(BuildContext context) {

    return  Container(
      child: TextFormField(
        decoration:  InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.white, filled: true,
            hintText: Placeholder,
            hintStyle: TextStyle(color: const Color(0xff868889),fontSize: 15),
            prefixIcon: Icon(pr_icon,)
        ),
        keyboardType: keybordtype,
        controller: controller,
        validator: (CurrentValue){
          var nonNullValue=CurrentValue??'';
          if(nonNullValue.isEmpty){
            return (ReturenStatement);
          }
          return null;
        },
      ),
    );
  }
}
