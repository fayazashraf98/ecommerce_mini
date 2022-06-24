import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/Models/All_Product_response.dart';
import 'package:ecommerce/Screens/products_screen.dart';
import 'package:ecommerce/State/state.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'cart_sceen.dart';
import 'login_screen.dart';

class Deshboard extends StatefulWidget {
  const Deshboard({Key? key}) : super(key: key);

  @override
  State<Deshboard> createState() => _DeshboardState();
}

class _DeshboardState extends State<Deshboard> {

  List<bool> likeOrNot = [false,false,false,false,false,false];
  int counter=1;
  bool addToCart=false;
  List<bool> cartOrNot = [true,true,true,true,true,true];
  List<int> productCounts = [1,1,1,1,1,1];
  List<double>? subTotalPrice;
  bool searching = false;
  TextEditingController searchField = TextEditingController();
  List<AllProductData>? itemsOnSearch;
  int activeIndex = 0;
  final sliderImages = [
    "Assets/Sliderimages/slider1.png",
    "Assets/Sliderimages/slider5.jpg",
    "Assets/Sliderimages/silder7.jpg",
  ];
  bool isLoading=false;
  String?error;
  @override
  Widget build(BuildContext context) {
    var MyAppState=MyInheritedWidget.of(context);
    double heightVariable = MediaQuery.of(context).size.height;
    double widthVariable = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton:FloatingActionButton(onPressed: () {
        updatingProductsCount(context);
        updatingCartOrNotToState(context);

        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const add_to_cart()));

      },
        backgroundColor: const Color(0xff6CC51D),
        child: const Icon(Icons.shopping_bag_outlined),

      ),

      backgroundColor:const Color(0xfff5f5f9),

      body:SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 56),
              child:
              Column(
                children: [
                  Row(children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            //  border: Border.all(color: Colors.red,width: 2),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child:
                        TextField(
                          onChanged: onSearch,
                          controller: searchField,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              hintText: "Search keywords..",
                              hintStyle: TextStyle(color: Color(0xff868889),fontSize: 15)
                          ),
                        ),
                      ),
                    ),
            Row(children: [
              IconButton(onPressed: ()async{
                await Logout(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Login_Screen()));
              }, icon: const Icon(Icons.logout_outlined,color: Color(0xff6FC622),))
            ],),
                  ],),


               const SizedBox(height: 10,),
                  if (!searching) Stack(
                    children: [
                      CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 150,
                            autoPlay: true,
                            //autoPlayInterval: Duration(seconds: 1),
                            viewportFraction: 1,
                            onPageChanged: (index, reason) =>
                                setState(() => activeIndex = index),
                          ),
                          itemCount: sliderImages.length,
                          itemBuilder: (context, index, realIndex) {
                            final urlImage = sliderImages[index];
                            return buildImage(urlImage, index);
                          }),
                      Positioned(
                        top:130,
                        left: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildIndicator(),
                          ],
                        ),
                      )

                    ],
                  ),
                  const SizedBox(height: 20,),
                  !searching?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                    Text("Categories",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    Icon(Icons.arrow_forward_ios,color: Color(0xff868889),size: 20,)
                  ],):Container(),
               const SizedBox(height: 17,),
                  !searching? SizedBox(
               height: 100,
               child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: MyAppState?.categories?.length,
                              itemBuilder:categoryItem,

                          ),
                        ),
                      ],
                    ),
           ):Container(),

                  !searching? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Featured products",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      Icon(Icons.arrow_forward_ios,color: Color(0xff868889),size: 20,)
                    ],):Container(),
                  const SizedBox(height: 32,),

                  SizedBox(
                    height: 770,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: MyAppState?.products?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        childAspectRatio: ((widthVariable/2)/(heightVariable/2.5))),
                      itemBuilder: ProductItems,

                    ),
                  ),
                ]

              ),
            ),
        ),
      ),
        
      );

  }
  Widget categoryItem(BuildContext context,int index){
    var MyAppSate=MyInheritedWidget.of(context);
    String HEXColor = "0xFF";
    return GestureDetector(
      onTap: ()async{
       await getProductByCategory(context,index+1);
       UpdatingLikeorNotToState(context);
       updatingCartOrNotToState(context);
       updatingProductsCount(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const products_display()));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: Column(
          children: [
            CircleAvatar(
              maxRadius: 22,
              backgroundColor: Color(int.parse("$HEXColor${MyAppSate?.categories![index].color?.substring(1)}")).withOpacity(0.2),
              child: CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.transparent,
              child: Image.network(MyAppSate?.categories![index].icon??""),
            ),
            ),
            const SizedBox(height: 11,),
            Text(MyAppSate?.categories![index].title?? "", style: const TextStyle(color: Color(0xff868889),fontSize: 10))
          ],
        ),
      ),
    );
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
            child: GridTile(
              footer:
              GestureDetector(
                onTap: (){
                  if(cartOrNot[index]){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("${myAppState?.products?[index].title} is added to cart")
                    ));
                  }
                  setState((){
                    cartOrNot[index]=false;
                  });
                },
                 child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                  child:
                      cartOrNot[index]?addingToCart():cartCount(context,index),
                      ),),

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

                  if(!likeOrNot[index]) {
                    setState(() {
                      likeOrNot[index] = true;
                    });
                  }
                  else{
                    setState(() {
                      likeOrNot[index] = false;
                    });
                  }
                },
                child:!likeOrNot[index]? const Icon(
                  Icons.favorite_border,color: Color(0xFFCACACE)): const Icon(Icons.favorite,color: Colors.red,))
                ]),
        )]
            );

  }
  Row cartCount(BuildContext context,int index){
    var MyAppState=MyInheritedWidget.of(context);
    subTotalPrice?.add((MyAppState?.products![index].price)!*(MyAppState?.productCount![index])!);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: (){
          if(productCounts[index]>1){
            setState((){
              productCounts[index]--;
            });
          }
        },
            icon: const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Icon(Icons.remove,color: Color(0xFF6CC51D),),
        )),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(productCounts[index].toString(),style: const TextStyle(fontSize: 15),),
        ),
        IconButton(onPressed: (){
          setState(() {
            productCounts[index]++;

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
        children: const [
          Icon(Icons.shopping_bag_outlined,color: Color(0xff6CC51D),),
          Text("Add to cart",style: TextStyle(fontSize: 12,fontFamily: "Poppins",),),
        ],
      );
  }

  Widget buildImage(String urlImage, int index) => Stack(
    children: [
    SizedBox(
    width: double.infinity,
    child: Image.asset(
      urlImage,
      fit: BoxFit.cover,
    ),
  ), Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 50,bottom: 30),
            child: Text("20% off on your\npurchase",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
          ),
  ],
)
    ],
  );
  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: sliderImages.length,
    effect: const ExpandingDotsEffect(
      activeDotColor: Color(0xff6CC51D),
      dotColor: Colors.white,
      dotHeight: 6,
      dotWidth: 6,
    ),
  );

  Future<void> getProductByCategory(BuildContext context, int prodductId)async {
    var MyAppState = MyInheritedWidget.of(context);
    var url = Uri.parse("http://ishaqhassan.com:2000/product/$prodductId");
    setState(() {
      isLoading = true;
    });
    try {
      if (MyAppState?.userData != null) {
        var response = await http.get(url, headers: {
          "Authorization": "Bearer ${MyAppState?.userData?.accessToken}",});
        var rersponeJson = AllProductResponse.fromJson(
            jsonDecode(response.body));
        MyAppState?.updateProductsByCategories(rersponeJson.data!);
      }
      if (prodductId == 1) {
        MyAppState?.updateProductsTitle("Vegetables");
      }
      else if (prodductId == 2) {
        MyAppState?.updateProductsTitle("Fruits");
      }
      else {
        MyAppState?.updateProductsTitle("");
      }
    }
    catch (e) {
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  Future<void> Logout(BuildContext context)async{
    var MyAppstate=MyInheritedWidget.of(context);
    var url = Uri.parse('http://ishaqhassan.com:2000/user/signout');
    setState((){
      isLoading=true;
    });
    try{
      if(MyAppstate?.userData != null){
        await http.get(url, headers: {"Authorization": "Bearer ${MyAppstate?.userData?.accessToken}"});
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Logout Successfully",
                  style: TextStyle(color: Colors.blue),),
              ],
            )));
      }else{
        await http.get(url, headers: {"Authorization": "Bearer ${MyAppstate?.logoutUserData?.accessToken}"});
      }
    }catch(e){
      setState(() {
        error = e.toString();
      });
    }
    setState(() {
      isLoading = false;
    });

  }

  updatingCartOrNotToState(BuildContext context){
    var MyAppState=MyInheritedWidget.of(context);
    MyAppState?.updateAddToCartOrNot(cartOrNot);
  }

  UpdatingLikeorNotToState(BuildContext context){
    var MyAppState=MyInheritedWidget.of(context);
    MyAppState?.updateLikeorNot(likeOrNot);
  }
  updatingProductsCount(BuildContext context){
    var MyAppState=MyInheritedWidget.of(context);
    MyAppState?.updateProductCount(productCounts);
  }
  void onSearch(String search) {
    var myAppState = MyInheritedWidget.of(context);
    setState(() {
      if (searchField.text.isNotEmpty){
        searching = true;
      }else{
        searching = false;
      }
      for(var i=0; i<(myAppState?.products?.length)!; i++){
        if (search.toLowerCase() == myAppState?.products![i].title?.toLowerCase()){
          itemsOnSearch?.add((myAppState?.products![i])!);

        }
      }});}
}

