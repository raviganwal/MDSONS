import 'package:flutter/material.dart';
import 'package:mdsons/CategoryScreen/CategoryScreenList.dart';
import 'package:mdsons/CategoryScreen/CategoryProductGridViewDetails.dart';
import 'package:mdsons/CategoryScreen/ProductListGridView.dart';
import 'package:mdsons/CategoryScreen/SubCategoryList.dart';
import 'package:mdsons/HomeScreen/HomePage.dart';
import 'package:mdsons/HomeScreen/HomeProductDetails.dart';
import 'package:mdsons/LoginScreen/Login.dart';
import 'package:mdsons/ProductScreen/DetailsOrAddToCart.dart';
import 'package:mdsons/ProductScreen/Product.dart';
import 'package:mdsons/ProfileDetails/Profile.dart';
import 'package:mdsons/SplashScreen/Splash.dart';
import 'package:mdsons/TotalAddCartList/TotalAddCartList.dart';

final routes = {
  '/Splash': (BuildContext context) => new Splash(),
  '/': (BuildContext context) => new Splash(),
  Splash.tag: (context) => Splash(),
  Login.tag: (context) => Login(),
  HomePage.tag: (context) => HomePage(),
  Profile.tag: (context) => Profile(),
  Product.tag: (context) => Product(),
  CategoryScreenList.tag: (context) => CategoryScreenList(),
  SubCategoryList.tag: (context) => SubCategoryList(),
  ProductListGridView.tag: (context) => ProductListGridView(),
  DetailsOrAddToCart.tag: (context) => DetailsOrAddToCart(),
  HomeProductDetails.tag: (context) => HomeProductDetails(),
  ProductGridViewDetails.tag: (context) => ProductGridViewDetails(),
  TotalAddCartList.tag: (context) => TotalAddCartList()
};
