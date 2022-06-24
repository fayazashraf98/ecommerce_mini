import 'dart:convert';
import 'package:ecommerce/State/state.dart';
import 'package:ecommerce/Widgets/Btn_Container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/signup_response.dart';
class Signup_Screen extends StatefulWidget {

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<Signup_Screen> {
  TextEditingController username=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();
  bool _isObscure=true;
  bool isLoading=false;
  SignupData? signupUserData;
  String? error;
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
                        image: AssetImage("Assets/Signup_image/signup.png"),fit: BoxFit.cover,
                      )
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 330),
                   child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffF4F5F9),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16,top: 30),
                        child: Column(children: [
                          Row(children: const [Text("Create account",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),],),
                          const SizedBox(height: 2,),
                          Row(children: const [Text("Quickly create account",style: TextStyle(color:Color(0xff868889),fontSize: 15,),)],),
                          const SizedBox(height: 25,),
                          Form(
                            child: Builder(
                                builder: (context) {
                                  return
                                    Column(
                                      children: [
                                      !isLoading?Column(
                                        children: [
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                fillColor: Colors.white, filled: true,
                                                hintText: "Email Address",
                                                hintStyle: TextStyle(color: Color(0xff868889),fontSize: 15),
                                                prefixIcon: Icon(Icons.email_outlined)
                                            ),
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
                                          const SizedBox(height: 10,),
                                          TextFormField(
                                            decoration:  const InputDecoration(
                                              fillColor: Colors.white, filled: true,
                                              border: InputBorder.none,
                                              hintText: "Phone number",
                                              hintStyle: TextStyle(color: Color(0xff868889),fontSize: 15),
                                              prefixIcon: Icon(Icons.call),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            controller: phone,
                                            validator: (CurrentValue){
                                              var nonNullValue=CurrentValue??'';
                                              if(nonNullValue.isEmpty){
                                                return ("Phone number is required");
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFormField(

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
                                        ],
                                      ):const Center(child: CircularProgressIndicator()),

                                        const SizedBox(height: 15,),
                                        GestureDetector(onTap: (){
                                          if(Form.of(context)?.validate()?? false){
                                            Signup(context);
                                          }
                                        }, child:
                                       Btn_main(Placeholder: "Signup",)
                                        ),
                                        const SizedBox(height: 17,),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 45),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text("Already have an account ? ",style: TextStyle( color: Color(0xff868889),fontSize: 15),),
                                              GestureDetector(onTap: (){
                                                Navigator.of(context).pop();
                                              },
                                                child: const Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),)
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


  void Signup(BuildContext context)async {
    var url=Uri.parse("http://ishaqhassan.com:2000/user");
    setState((){
      isLoading=true;
    });
    try{
      var response=await http.post(url,body:{
        'email':username.text,
        'phone':phone.text,
        'password':password.text,
      });
      var responseJson=SignupResponse.fromJson(jsonDecode(response.body));
      setState((){
        signupUserData=responseJson.data;
      });
      UpdatingSignupUserToData(context);
      if(signupUserData!=null){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("user Created Successfully",
                  style: TextStyle(color: Colors.blue),),
              ],
            )));
        Navigator.of(context).pop();
      }
    }
        catch(e){
         if(signupUserData?.email==signupUserData?.email){
           ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content:
               Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: const [
                   Text("this email is Already Taken.",
                     style: TextStyle(color: Colors.red),),
                 ],
               )));
         }
      print(e);
      setState((){
        error=e.toString();
      });
        }
    setState((){
      isLoading=false;
    });
  }

  void UpdatingSignupUserToData(BuildContext context) {
    var MyAppState=MyInheritedWidget.of(context);
    MyAppState?.updateSignupUser(signupUserData!);
  }
  
}
