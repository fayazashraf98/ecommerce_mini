import 'dart:convert';

import 'package:ecommerce/Models/All_Product_response.dart';
import 'package:ecommerce/Models/all_categories_model.dart';
import 'package:ecommerce/Models/login_response.dart';
import 'package:ecommerce/Screens/Dashboard_Screen.dart';
import 'package:ecommerce/Screens/signup_screen.dart';
import 'package:ecommerce/State/state.dart';
import 'package:flutter/material.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
import 'package:http/http.dart' as http;

import '../Widgets/Btn_Container.dart';

class Login_Screen extends StatefulWidget {

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  bool _isObscure=true;
  bool isLoading=false;
  String? error;
  UserData? userData;
  List<AllCategoriesData>? categories;
  List<AllProductData>? products;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor:Colors.transparent,
        elevation: 0,
      ),

     body:SingleChildScrollView(

       child: Column(
         children: [
           Stack(
             children: [
               Container(
                 height: 350,
                 decoration: const BoxDecoration(
                   image: DecorationImage(
                     image: AssetImage("Assets/Login_image/login.png"),fit: BoxFit.cover,
                   )
                 ),
               ),

             Padding(
               padding: const EdgeInsets.only(top: 330),
               child:
               Container(
                  decoration: const BoxDecoration(
                         color: Color(0xffF4F5F9),
                         borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                       ),
                       child:
                       Padding(
                         padding: const EdgeInsets.only(left: 17,right: 17,top: 29),
                         child: Column(children: [
                           Row(children: const [Text("Welcome back !",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),],),
                           const SizedBox(height: 2,),
                           Row(children: const [Text("Sign in to your account",style: TextStyle(color:Color(0xff868889),fontSize: 15,),)],),
                           const SizedBox(height: 25,),
                           Form(
                             child: Builder(
                                 builder: (context) {
                                   return Column(
                                     children: [
                                   !isLoading?  Column(children: [
                                  // if(error!=null)Text("there was an error $error"),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 6),
                                         child: TextFormField(
                                           decoration: const InputDecoration(
                                               border: InputBorder.none,
                                               fillColor: Colors.white, filled: true,
                                               hintText: "Email Address",
                                               hintStyle: TextStyle(color: Color(0xff868889),fontSize: 15),
                                               prefixIcon: Icon(Icons.email_outlined)
                                           ),
                                           keyboardType: TextInputType.emailAddress,
                                           controller: username,
                                           validator: (CurrentValue){
                                             var nonNullValue=CurrentValue??'';
                                             if(nonNullValue.isEmpty){
                                               return ("username is required");
                                             }
                                             if(!nonNullValue.contains("@")){
                                               return ("username should contains @");
                                             }
                                             return null;
                                           },
                                         ),
                                       ),

                                       const SizedBox(height: 15,),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 7),
                                         child: TextFormField(

                                           decoration:  InputDecoration(
                                             fillColor: Colors.white, filled: true,
                                             border: InputBorder.none,
                                             hintText: "Password",
                                             hintStyle: const TextStyle(color: Color(0xff868889),fontSize: 15),

                                             prefixIcon: const Icon(Icons.lock_outline_rounded),
                                             suffixIcon: GestureDetector(
                                               onTap: (){
                                                 setState((){
                                                   _isObscure=!_isObscure;
                                                 });
                                               },
                                               child: Icon(_isObscure?Icons.visibility:Icons.visibility_off),
                                             ),
                                           ),
                                           obscureText: _isObscure,
                                           controller: password,
                                           validator: (PassCurrentValue){
                                             var passNonNullValue=PassCurrentValue??"";
                                             if(passNonNullValue.isEmpty){
                                               return ("Password is required");
                                             }
                                             else if(passNonNullValue.length<6){
                                               return ("Password Must be more than 5 characters");
                                             }
                                             return null;
                                           },
                                         ),
                                       ),
                                     ],
                                     ): const Center(child:  CircularProgressIndicator()),

                                       const SizedBox(height: 20,),
                                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                         children: [
                                           Switcher(
                                             value: false,
                                             colorOff: Colors.grey.withOpacity(0.3),
                                             colorOn: Colors.green,
                                             onChanged: (bool state) {
                                             },
                                             size: SwitcherSize.small,
                                           ),
                                          Row(
                                            children: const [
                                              Text(
                                                 "Remember me",
                                                 style: TextStyle(
                                                     color: Color(0xff868889), fontSize: 15),
                                               ),
                                            ],
                                          ),
                                           Padding(
                                             padding: const EdgeInsets.only(left: 20),
                                             child: Row(
                                               children: [
                                                 GestureDetector(
                                                   onTap: () {},
                                                   child: const Text(
                                                     "Forgot password",
                                                     style: TextStyle(
                                                         color: Color(0xff407EC7), fontSize: 15),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           )
                                         ],
                                       ),
                                        const SizedBox(height: 17,),
                                       GestureDetector(onTap: (){
                                         if(Form.of(context)?.validate()?? false){
                                           login(context);
                                         }
                                       }, child:Btn_main(Placeholder: "Login",)

                                       ),
                                        const SizedBox(height: 17,),
                                       Padding(
                                         padding: const EdgeInsets.only(bottom: 45),
                                         child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             const Text("Don’t have an account ? ",style: TextStyle( color: Color(0xff868889),fontSize: 15),),
                                             GestureDetector(onTap: (){
                                               Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Signup_Screen()));
                                             },
                                             child: const Text("sign up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),)
                                           ],
                                         ),
                                       ),
                                   ]
                                   );
                                 }
                             ),
                           )
                         ],),
                       ),
                     )
             )
             ],
           ),

         ],
       ),
     ),
    );
  }

   void login(BuildContext context)async {
    var url = Uri.parse('http://ishaqhassan.com:2000/user/signin');
    setState((){
      isLoading=true;
    });
    try {
      var response =
      await http.post(url, body: {'email': username.text, 'password': password.text});
      var responseJSON = LoginResponse.fromJson(jsonDecode(response.body));
      setState(() {
        userData = responseJSON.data;
      });
      updatingUserDataToState (context);
      if (userData != null) {
        await getAllCategories (context);
        await getAllProducts(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Login Successfully",
                  style: TextStyle(color: Colors.blue),),
              ],
            )));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  const Deshboard()));
      }
    }
        catch(e){
          setState(() {
            error = e.toString();
          });
          if(userData?.email != username.text &&
              userData?.password != password.text) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Email or Password invalid!!",
                      style: TextStyle(color: Colors.red),),
                  ],
                ))
            );
          }
        }
    setState((){
      isLoading=false;
    });
  }

  Future<void> getAllCategories(BuildContext context)async {
    var url = Uri.parse('http://ishaqhassan.com:2000/category');
    var myAppState = MyInheritedWidget.of(context);
    setState((){
      isLoading=true;
    });
    try {
      var response = await http.get(url,headers:{"Authorization":"Bearer ${myAppState?.userData?.accessToken}"});
      var responseJSON = AllCategoriesResponce.fromJson(jsonDecode(response.body));
      setState(() {
        categories=responseJSON.data;
      });
      updatingCategoriesToState(context);
    }
    catch(e){
      setState(() {
        error = e.toString();
      });
    }
    setState((){
      isLoading=false;
    });
  }

  Future<void> getAllProducts(BuildContext context)async {
    var url = Uri.parse('http://ishaqhassan.com:2000/product');
    var myAppState = MyInheritedWidget.of(context);
    setState((){
      isLoading=true;
    });
    try {
      var response = await http.get(url,headers:{"Authorization":"Bearer ${myAppState?.userData?.accessToken}"});
      var responseJSON = AllProductResponse.fromJson(jsonDecode(response.body));
      setState(() {
        products=responseJSON.data;
      });
      updatingProuductsToState(context);
    }
    catch(e){
      setState(() {
       error = e.toString();
      });
    }
    setState((){
      isLoading=false;
    });
  }

   updatingUserDataToState(BuildContext context) {
    var myAppState=MyInheritedWidget.of(context);
    myAppState?.updateUserData(userData!);
  }

   updatingCategoriesToState(BuildContext context) {
    var myAppState=MyInheritedWidget.of(context);
    myAppState?.updateCategory(categories!);
  }
  updatingProuductsToState(BuildContext context){
    var myAppState=MyInheritedWidget.of(context);
    myAppState?.updateProducts(products!);
  }
}
