
import 'package:ecommerce/Models/All_Product_response.dart';
import 'package:ecommerce/Models/all_categories_model.dart';
import 'package:ecommerce/Models/login_response.dart';
import 'package:flutter/material.dart';

import '../Models/logout_response.dart';
import '../Models/signup_response.dart';

class MyInheritedWidget extends InheritedWidget{
  final AppStateWidgetState state;
  MyInheritedWidget({required super.child, required this.state});
  static AppStateWidgetState? of(BuildContext context)=>
      context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()?.state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)=>true;
}

class AppStateWidget extends StatefulWidget {
  final Widget child;
  const AppStateWidget({Key? key,required this.child}) : super(key: key);
  @override
  AppStateWidgetState createState() => AppStateWidgetState();
}

class AppStateWidgetState extends State<AppStateWidget> {
  UserData? userData;
  SignupData? signupUserData;
  LogoutData?logoutUserData;

  List<AllCategoriesData>?categories;
  List<AllProductData>?products;
  List<AllProductData>?productsByCaategories;
  String?productTitle;
  List<bool>? addLikeOrNot;
  List<bool>? addToCartOrNot;
  List<int>? productCount;
  List<AllProductData>? cartProducts;
  double subTotal = 0;


  updateUserData(UserData userUpdateData)=>setState((){
    userData=userUpdateData;
  });
  updateSignupUser(SignupData SignupUpdateData)=>setState((){
    signupUserData=SignupUpdateData;
  });
  updateLogoutUser(LogoutData logoutUpdateData)=>setState((){
    logoutUserData=logoutUpdateData;
  });

  updateCategory(List<AllCategoriesData>category)=>setState((){
    categories=category;
  });
  updateProducts(List<AllProductData> updateProducts)=>setState((){
    products=updateProducts;
  });
  updateProductsByCategories(List<AllProductData> updateProductsByCategories)=>setState((){
    productsByCaategories=updateProductsByCategories;
  });

  updateProductsTitle(String title)=>setState((){
  productTitle=title;
});

  updateLikeorNot(List<bool>addLike)=>setState((){
  addLikeOrNot=addLike;
});

  updateAddToCartOrNot(List<bool> addtoCartOrNotUpdate)=>setState((){
    addToCartOrNot=addtoCartOrNotUpdate;
  });

  updateProductCount(List<int> ProductUpdateCount)=>setState((){
    productCount=ProductUpdateCount;
  });

  updateCartproducts(List<AllProductData> CartProductUpdate)=>setState((){
    cartProducts=CartProductUpdate;
  });

  updateSubTotal(double subTotalUpdate)=>setState((){
    subTotal=subTotalUpdate;
  });
  deleteCartItem(int index)=> setState((){
    addToCartOrNot![index] = true;
    productCount![index] = 1;
  });


  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(child: widget.child, state: this);
  }
}
