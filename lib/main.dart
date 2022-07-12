import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/layout/shop_app/cubit/states.dart';
import 'package:untitled/layout/shop_app/shop_layout.dart';
import 'package:untitled/modules/shop_app/login/shop_login_screen.dart';
import 'package:untitled/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:untitled/network/components/constants.dart';
import 'package:untitled/network/local/cache_helper.dart';
import 'package:untitled/network/remote/shop_dio_helper.dart';
import 'package:untitled/styles/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ShopDioHelper.init();
  await CacheHelper.init();

  Widget widget;

  bool? onBoarding = CacheHelper.getDate(key: 'onboarding');
  token = CacheHelper.getDate(key: 'token');
  if (onBoarding != null) {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = ShopLoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
      // debugPrint(isDark.toString());
    },
    blocObserver: MyBlocObserver(),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Widget startWidget;

  MyApp({Key? key, required this.startWidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()
        ..getHomeData()
        ..getCategoryData()
        ..getFavData()
        ..getUserData(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Directionality(

                textDirection: ShopCubit.get(context).check ,
                child: startWidget),
          );
        },
      ),
    );
  }
}
