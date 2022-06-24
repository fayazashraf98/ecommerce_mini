import 'dart:convert';
import 'dart:io';

import 'package:ecommerce/Screens/orderSuccess_screen.dart';
import 'package:ecommerce/State/state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/createOrder_response.dart';
import '../Widgets/Btn_Container.dart';
import '../Widgets/TextField_CheckOut.dart';
class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}
class _CheckoutState extends State<Checkout> {
  TextEditingController name= TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController number= TextEditingController();
  TextEditingController address= TextEditingController();
  TextEditingController zipcode= TextEditingController();
  TextEditingController city= TextEditingController();
  TextEditingController country= TextEditingController();
  CreateOrderResponse? orderResponse;
  bool isLoading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Shopping Cart",style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child:
        Form(
    child: Builder(
    builder: (context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17,right: 17,top: 10,bottom: 20),
      child: Column(
      children: [
      !isLoading?  Column(children: [
        TextFields(keybordtype: TextInputType.text, Placeholder: 'Name', controller: name, pr_icon: Icons.account_circle_outlined,ReturenStatement: 'Name is Required',),
        const SizedBox(height: 15,),
        TextFields(keybordtype: TextInputType.emailAddress,  Placeholder: 'Email Address', controller: email, pr_icon: Icons.email_outlined,ReturenStatement: 'Email is Required',),
        const SizedBox(height: 15,),
        TextFields(keybordtype: TextInputType.phone,  Placeholder: 'Phone number', controller: number, pr_icon: Icons.phone,ReturenStatement: 'Phone Number is Required',),
        const SizedBox(height: 15,),
        TextFields(keybordtype: TextInputType.text,  Placeholder: 'Address', controller: address, pr_icon: Icons.location_on_outlined,ReturenStatement: 'Address is Required',),
        const SizedBox(height: 15,),
        TextFields(keybordtype: TextInputType.number,  Placeholder: 'Zip code', controller: zipcode, pr_icon: Icons.margin,ReturenStatement: 'zip code is Required',),
        const SizedBox(height: 15,),
        TextFields(keybordtype: TextInputType.text,  Placeholder: 'City', controller: city, pr_icon: Icons.location_city,ReturenStatement: 'City is Required',),
        const SizedBox(height: 15,),
        TextFields(keybordtype: TextInputType.text,  Placeholder: 'Country', controller: country, pr_icon: Icons.sports_basketball_outlined,ReturenStatement: 'Country is Required',),
      ],
      ):
      const Center(child:  CircularProgressIndicator()),
      const SizedBox(height: 17,),
      GestureDetector(onTap: (){
      if(Form.of(context)?.validate()?? false){
      CheckOut();
      }
      }, child:
      Btn_main(Placeholder: "Next",)
      ),]),);}),),
      ));
  }

  void CheckOut()async {
    var MyAppState=MyInheritedWidget.of(context);
    var url=Uri.parse("http://ishaqhassan.com:2000/order");
    setState((){
      isLoading=true;
    });
    var listOfItems = <dynamic>[];
    var map = <String, dynamic>{};
    int index = 0;

    for (var product in (MyAppState?.products)!){
      if(!(MyAppState?.addToCartOrNot![index])!){
        map["id"] = product.id;
        map["catId"] = product.catId;
        map["title"] = product.title;
        map["unit"] = product.unit;
        map["stockAvailable"] = product.stockAvailable;
        map["image"] = product.image;
        map["color"] = product.color;
        map["price"] = product.price;
        map["qty"] = product.qty;
        listOfItems.add(map);
        index++;
      }
    }
    var body = <String,dynamic>{
      "name":name.text,
      "email":email.text,
      "phoneNumber":number.text,
      "address":address.text,
      "zip":zipcode.text,
      "city":city.text,
      "country":country.text,
      "items":listOfItems,
    };
    try{
      http.Response response = await http.post(url,
          headers: {'Content-Type':'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: (MyAppState?.userData?.accessToken)!},
          body: jsonEncode(body)
      );
      var responseJSON = CreateOrderResponse.fromJson(jsonDecode(response.body));
      setState(() {
        orderResponse = responseJSON;
      });
      if(orderResponse != null){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const OrderSuccess()));
      }

      if (response.statusCode == 200){
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderSuccess()));
      }else {
        print(response.reasonPhrase.toString());
      }
    }
    catch(e){
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });
    
  }}
