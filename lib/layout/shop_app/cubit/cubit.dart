import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/states.dart';
import 'package:untitled/models/categories_model.dart';
import 'package:untitled/models/change_favorites_model.dart';
import 'package:untitled/models/favorites_model.dart';
import 'package:untitled/models/home_model.dart';
import 'package:untitled/models/login_model.dart';
import 'package:untitled/network/components/constants.dart';
import 'package:untitled/network/end_point.dart';
import 'package:untitled/network/remote/shop_dio_helper.dart';
import '../../../modules/shop_app/categories/categories_screen.dart';
import '../../../modules/shop_app/favorites/favorites_screen.dart';
import '../../../modules/shop_app/products/products_screen.dart';
import '../../../modules/shop_app/settings/setting_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialStates());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  static ShopCubit get(context) => BlocProvider.of(context);

  bool isEng = true;
  TextDirection check = TextDirection.ltr;

  static String salla = '5oD Fekra';
  static String home = 'HOME';
  static String categories = 'CATEGORIES';
  static String products = 'PRODUCTS';
  static String navFavorites = 'FAVORITES';
  static String setting = 'SETTINGS';
  static String signOut = 'SIGN OUT';
  static String update = 'UPDATE';
  static String lang = 'ع';

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen()
  ];

  void changeBottom(int index) {
    currentIndex = index;
    if (index == 2) {
      getFavData();
    }
    emit(ShopChangeBottomNavStates());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataStates());
    if (isEng) {
      ShopDioHelper.getData(
        lang: 'en',
        url: HOME,
        token: token,
      ).then((value) {
        homeModel = HomeModel.fromJson(value.data);

        for (var element in homeModel!.data.products) {
          favorites.addAll({element.id: element.inFavorites});
        }
        //debugPrint(favorites.toString());
        emit(ShopSuccessHomeDataStates());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(ShopErrorHomeDataStates());
      });
    } else {
      ShopDioHelper.getData(
        lang: 'ar',
        url: HOME,
        token: token,
      ).then((value) {
        homeModel = HomeModel.fromJson(value.data);

        for (var element in homeModel!.data.products) {
          favorites.addAll({element.id: element.inFavorites});
        }
        //debugPrint(favorites.toString());
        emit(ShopSuccessHomeDataStates());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(ShopErrorHomeDataStates());
      });
    }
  }

  CategoriesModel? categoriesModel;

  void getCategoryData() {
    if (isEng) {
      ShopDioHelper.getData(
        lang: 'en',
        url: GET_CATEGORIES,
      ).then((value) {
        categoriesModel = CategoriesModel.fromJson(value.data);
        emit(ShopSuccessCategoriesDataStates());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(ShopErrorCategoriesDataStates());
      });
    } else {
      ShopDioHelper.getData(
        lang: 'ar',
        url: GET_CATEGORIES,
      ).then((value) {
        categoriesModel = CategoriesModel.fromJson(value.data);
        emit(ShopSuccessCategoriesDataStates());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(ShopErrorCategoriesDataStates());
      });
    }
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    bool checkValue = favorites[productId] as bool;
    favorites[productId] = !checkValue;
    emit(ShopChangeFavoritesDataStates());
    ShopDioHelper.postDate(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      debugPrint(token);
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);

      if (changeFavoritesModel!.status == false) {
        favorites[productId] = checkValue;
      } else {
        getFavData();
      }
      debugPrint(value.data.toString());
      emit(ShopSuccessChangeFavoritesDataStates(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = checkValue;
      print(error.toString());
      emit(ShopErrorChangeFavoritesDataStates());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavData() {
    emit(ShopLoadingGetFavoritesDataStates());
    if (isEng) {
      ShopDioHelper.getData(url: FAVORITES, lang: 'en', token: token)
          .then((value) {
        favoritesModel = FavoritesModel.fromJson(value.data);
        debugPrint(favoritesModel?.status.toString());
        debugPrint(favoritesModel.toString());

        emit(ShopSuccessGetFavoritesDataStates());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(ShopErrorGetFavoritesDataStates());
      });
    } else {
      ShopDioHelper.getData(url: FAVORITES, lang: 'ar', token: token)
          .then((value) {
        favoritesModel = FavoritesModel.fromJson(value.data);
        debugPrint(favoritesModel?.status.toString());
        debugPrint(favoritesModel.toString());

        emit(ShopSuccessGetFavoritesDataStates());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(ShopErrorGetFavoritesDataStates());
      });
    }
  }

  ShopLoginModel? userData;

  void getUserData() {
    emit(ShopLoadingGetUserDataStates());

    ShopDioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userData = ShopLoginModel.formJson(value.data);
      debugPrint(userData!.data!.name.toString());
      emit(ShopSuccessGetUserDataStates(userData!));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorGetUserDataStates());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserDataStates());

    ShopDioHelper.putData(
        url: UPDATE_PROFILE,
        token: token,
        data: {'name': name, 'email': email, 'phone': phone}).then((value) {
      userData = ShopLoginModel.formJson(value.data);
      debugPrint(userData!.data!.name.toString());
      emit(ShopSuccessUpdateUserDataStates(userData!));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopErrorUpdateUserDataStates());
    });
  }

  void changLang() async {
    isEng = !isEng;
    if (isEng) {
      check = TextDirection.ltr;
      salla = '5oD Fekra';
      home = 'HOME';
      categories = 'CATEGORIES';
      products = 'products';
      navFavorites = 'FAVORITES';
      setting = 'SETTINGS';
      signOut = 'SIGN OUT';
      update = 'UPDATE';
      lang = 'ع';
    } else {
      check = TextDirection.rtl;
      salla = 'خد فكره';
      home = 'الرئيسيه';
      categories = 'المجموعات';
      navFavorites = 'المفضله';
      setting = 'الاعدادات';
      signOut = 'تسجيل الخروج';
      update = 'تحديث البيانات';
      products = 'المنتجات';
      lang = 'e n';
    }
    emit(ShopLoadingHomeDataStates());
    getCategoryData();
    getHomeData();
    emit(ShopLoadingGetFavoritesDataStates());
    getFavData();
    emit(ShopChangeLangState());
  }
}
