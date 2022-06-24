import 'dart:async';
import 'package:ecommerce/Screens/login_screen.dart';
import 'package:flutter/material.dart';
class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement( //< this
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Login_Screen();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
          children:[
            Container(
              decoration:  const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Assets/splash_images/splash.png",),fit: BoxFit.fill,

                ),
              ),
            ),
            Column(
              children:  [
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Welcome to ",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("Assets/splash_images/bigCart 1.png")
                  ],
                ),
                const SizedBox(height: 17,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(child:
                    Padding(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy ",
                        style: TextStyle(color: Color(0xff868889),fontSize: 15), maxLines: null,textAlign: TextAlign.center,),
                    ))
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("POWERED BY",style:TextStyle(fontSize: 15,color: Color(0xff868889)))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("TECH IDARA",style:TextStyle(fontSize: 20,color: Color(0xff6CC51D)))
                    ],
                  ),
                ),

              ],
            )

          ]),
    )
    );
  }
}
