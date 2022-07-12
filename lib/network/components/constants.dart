import 'package:flutter/material.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/modules/shop_app/login/shop_login_screen.dart';
import 'package:untitled/network/components/components.dart';
import 'package:untitled/network/local/cache_helper.dart';

void signOut(context) =>CacheHelper.clearData(key: 'token').then((value) {
  ShopCubit.get(context).emailController.clear();
  ShopCubit.get(context).nameController.clear();
  ShopCubit.get(context).phoneController.clear();
  navigateAndFinish(context, ShopLoginScreen());
  });
//عشان تطبع النص كام في الكونسل

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}
String? token = '' ;
String? uId = '' ;