import 'package:ecommerce/Screens/signup_screen.dart';
import 'package:ecommerce/Screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'State/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
        return AppStateWidget(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',

            home:  splash_screen(),
          ),
        );
      }
  }


