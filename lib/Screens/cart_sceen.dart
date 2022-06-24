import 'package:ecommerce/State/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Widgets/Btn_Container.dart';
import 'checkout_screen.dart';


class add_to_cart extends StatefulWidget {
  const add_to_cart({Key? key}) : super(key: key);

  @override
  State<add_to_cart> createState() => _add_to_cartState();
}

class _add_to_cartState extends State<add_to_cart> {
  @override
  List<double> subTotalList = [];
  double subTotalAmount = 0.0;
  double shippingFee=1.6;
  void initState() {
    subTotalAmount = 0.0;
  }


  Widget build(BuildContext context) {
    var MyAppState=MyInheritedWidget.of(context);
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F9),
      appBar:AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),

        title: const Text("Shopping Cart",style: TextStyle(color: Colors.black),),
      ),
      body:
      Column(
        children: [
        SizedBox(
       height: 355,
       child:
       Row(children: [
         Expanded(
           child: ListView.builder(
            itemCount: MyAppState?.products?.length,
             itemBuilder: (context, index){
               return Slidable(
                   endActionPane: ActionPane(
                     key: ValueKey(index),
                     motion: const StretchMotion(),
                     children: [
                       SlidableAction(
                         // An action can be bigger than the others.
                         onPressed: (context){
                           MyAppState?.deleteCartItem(index);
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                             content: Text("${MyAppState?.products![index].title} is removed from cart"),
                           ));
                         },
                         backgroundColor: Colors.red,
                         foregroundColor: Colors.white,
                         icon: Icons.delete,
                       ),
                     ],
                   ),
                   child: updateCartItems(context, index)
               );
             },
           ),
         ),
       ],),
       ),
          const Spacer(),
          Container(

            decoration: const BoxDecoration(
          color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 17,right: 17,top: 22,bottom: 20),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Subtotal",style: TextStyle(color: Color(0xff868889),fontSize: 12),),
                      Row(children: [
                        Text("\$${updatePrice(context).toStringAsFixed(2)}",style: TextStyle(color: Color(0xff868889),fontSize: 12),),

                      ],),

                ],),
                  const SizedBox(height: 7,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Shipping charges",style: TextStyle(color: Color(0xff868889),fontSize: 12),),

                      Row(children: [
                        Text("\$$shippingFee",style: const TextStyle(color: Color(0xff868889),fontSize: 12),),

                      ],),

                    ],),
                  const SizedBox(height: 20,),
                  const Divider(color: Color(0xffEBEBEB),thickness: 2,),
                  const SizedBox(height: 10,),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${(updatePrice(context) + shippingFee).toStringAsFixed(2)}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      Row(children: const [
                        Text("Subtotal",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),

                      ],),

                    ],),
                  const SizedBox(height: 20,),

                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const Checkout()));
                    },
                    child:
                    Btn_main(Placeholder: "Checkout",)
                  )

                ],
              ),
            ),

          )
        ],
      )
    );
  }

  Widget updateCartItems(BuildContext context, index) {
    var myAppState = MyInheritedWidget.of(context);
    String startColor = "0xFF";
    double productPrice = (myAppState?.products![index].price)!;
    int productQuantity = (myAppState?.productCount![index])!;
    subTotalAmount += (productPrice * productQuantity);
    return !(myAppState?.addToCartOrNot![index])!?Card(
      margin: const EdgeInsets.only(left: 17,right: 17,top: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0)),
      child: SizedBox(
        height: 115,
        child: ListTile(
          leading: CircleAvatar(
              maxRadius: 35,
              backgroundColor: Color(int.parse("$startColor${myAppState?.products![index].color?.substring(1)}")).withOpacity(0.2),
              child: Image.network(myAppState?.products![index].image ?? "")
          ),
          title: SizedBox(
            height: 120,
            width: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${myAppState?.products![index].price.toString() ?? ""} x ${myAppState?.productCount![index].toString()}",
                      style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "poppins",
                          color: Color(0xFF6CC51D)),
                    ),
                    Text(myAppState?.products![index].title ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontFamily: "Poppins")),
                    Text(
                      myAppState?.products![index].unit ?? "",
                      style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "poppins",
                          color: Colors.grey),
                    )
                  ],
                ),

            Column(
              children: [
                IconButton(onPressed: (){
                  setState(() {
                    myAppState?.productCount![index]++;
                  });
                }, icon: const Icon(
                  Icons.add, color: Color(0xFF6CC51D),)),
                Text(myAppState?.productCount![index].toString() ?? "", style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                ),),
                IconButton(onPressed: (){
                  if ((myAppState?.productCount![index])!>1){
                    setState(() {
                      myAppState?.productCount![index]--;
                    });
                  }
                }, icon: const Icon(Icons.remove, color: Color(0xFF6CC51D),)),
              ],
            )
              ],
            ),
          ),
        ),
      ),
    ): Container();
  }
  double updatePrice(BuildContext context){
    double subTotal = 0.0;
    var myAppState = MyInheritedWidget.of(context);
    for(int i=0; i<(myAppState?.products?.length)!; i++){
      if (myAppState?.addToCartOrNot![i] == false){
        subTotal += (myAppState?.products![i].price)! * (myAppState?.productCount![i])!;
      }
    }return subTotal;
  }

  }

