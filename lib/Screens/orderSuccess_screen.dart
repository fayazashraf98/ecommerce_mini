import 'package:ecommerce/State/state.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import '../Widgets/Btn_Container.dart';
import 'Dashboard_Screen.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess({Key? key}) : super(key: key);

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  @override
  Widget build(BuildContext context) {
    var MyAppState=MyInheritedWidget.of(context);
    return Scaffold(
      body:
      Column(
       mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          Column(
            children: [
              Column(children: [
                Image.asset("Assets/OrderSuccess_image/orderfinal.png")
              ],),
              const SizedBox(height: 40,),
              Column(children: const [
                Text("Congrats!",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),)
              ],),
              const SizedBox(height: 8,),
              Text("Your Order #${MyAppState?.userData?.id} is \n Successfully Received"),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 17,right: 17,bottom: 20),
            child: Footer(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                  onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> Deshboard()));
                  }, child:
              Btn_main(Placeholder: "Go To Home",)
              ),
            ),
          )
      ],));
  }
}
