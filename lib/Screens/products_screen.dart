import 'package:ecommerce/State/state.dart';
import 'package:flutter/material.dart';

import 'cart_sceen.dart';
class products_display extends StatefulWidget {
  const products_display({Key? key}) : super(key: key);

  @override
  State<products_display> createState() => _products_displayState();
}

class _products_displayState extends State<products_display> {
  int counter=1;
  bool addToCart=false;
  List<bool> cartOrNot = [true,true,true,true,true,true];

  @override


  Widget build(BuildContext context) {
    var MyAppState=MyInheritedWidget.of(context);
    double heightVariable = MediaQuery.of(context).size.height;
    double widthVariable = MediaQuery.of(context).size.width;

    return MyAppState?.productTitle != "" ? Scaffold(
      backgroundColor: const Color(0xffF4F5F9),
        floatingActionButton:FloatingActionButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const add_to_cart()));

        },
          backgroundColor: const Color(0xff6CC51D),
          child: const Icon(Icons.shopping_bag_outlined),

        ),

        appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.menu_outlined),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(MyAppState?.productTitle ??"",style: const TextStyle(color: Colors.black),),
      ),
      body:SingleChildScrollView(
        child:
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
             MyAppState?.productsByCaategories!=null?
             SizedBox(
                height: 800,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: MyAppState?.productsByCaategories?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: ((widthVariable/2)/(heightVariable/2.5))),
                  itemBuilder: ProductItems,
                ),
              ):const Center(child: Text("No Product Available"))
            ],
          ),
        ),
      )
    )
        :Scaffold(
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.menu_outlined),
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.black),
          shadowColor: Colors.white,

          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(MyAppState?.productTitle ??"",style: const TextStyle(color: Colors.black),),
        ),
        backgroundColor: const Color(0xFFF4F5F9),
    body: const Center(child: Text("No Products Available"),
    ));
  }
  Widget ProductItems(BuildContext context, int index){
    var myAppState = MyInheritedWidget.of(context);
    String startColor = "0xFF";
    return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,bottom: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius. circular(0),
              ),
              // color: Colors.white,
              // margin: EdgeInsets.only(left: 17,top: 5,bottom: 16),
              child: GridTile(
                footer:
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: myAppState?.productsByCaategories![0].catId == 1?(myAppState?.addToCartOrNot![5]) == true ?addingToCart():cartCount(5)
                        : (myAppState?.addToCartOrNot![index]) == true ?addingToCart():cartCount(index)),

                child: Container(
                  height: 35,
                  decoration: const BoxDecoration(
                      border:Border(top: BorderSide(width: 1, color: Colors.white),)
                  ),

                ),
              ),
            ),
          ),

          Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 85,
                          width: 85,
                          child: CircleAvatar(
                            maxRadius: 20,
                            backgroundColor: Color(int.parse("$startColor${myAppState?.products![index].color?.substring(1)}")).withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 80,
                              width: 100,
                              child: Image.network(myAppState?.products![index].image ?? "")
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("\$${myAppState?.products![index].price.toString() ??""}", style: const TextStyle(
                      color: Color(0xFF6CC51D),
                      fontFamily: "Poppins",
                      fontSize: 13
                  ),),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(myAppState?.products![index].title ?? "", style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  ),),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(myAppState?.products![index].unit ?? "", style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 13,
                    color: Color(0xFF868889),
                  ),),

                ],
              ),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.only(left: 20,right: 10),
                child: Divider(color: Color(0xffEBEBEB),thickness: 1,),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row( mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: (){

                        if(!(myAppState?.addLikeOrNot![index])!) {
                          setState(() {
                            myAppState?.addLikeOrNot![index] = true;                          });
                        }
                        else{
                          setState(() {
                            myAppState?.addLikeOrNot![index] = false;
                          });
                        }
                      },
                      child:myAppState?.addLikeOrNot![index]!=true? const Icon(
                          Icons.favorite_border,color: Color(0xFFCACACE)): Icon(Icons.favorite,color: Colors.red,))
                ]),
          )]
    );

  }
  Row cartCount(int index){
    var MyAppState=MyInheritedWidget.of(context);
    // subTotalPrice?.add((MyAppState?.products![index].price)!*(MyAppState?.productCount![index])!);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: (){
          if((MyAppState?.productCount![index])!>1){
            setState((){
             MyAppState?.productCount![index]--;
            });
          }
        },
            icon: const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Icon(Icons.remove,color: Color(0xFF6CC51D),),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text((MyAppState?.productCount![index]).toString(),style: TextStyle(fontSize: 15),),
        ),
        IconButton(onPressed: (){
          setState(() {
            MyAppState?.productCount![index]++;

          });
        },
            icon: const Padding(
              padding: EdgeInsets.only(top:15),
              child: Icon(Icons.add,color: Color(0xFF6CC51D)),
            ))
      ],
    );

  }
  Row addingToCart(){
    return
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Padding(
           padding: const EdgeInsets.only(bottom: 8),
           child: Row(
             children: const [
               Icon(Icons.shopping_bag_outlined,color: Color(0xff6CC51D),),
               Text("Add to cart",style: TextStyle(fontSize: 12,fontFamily: "Poppins",),),
             ],
           ),
         )
        ],
      );
  }

}
