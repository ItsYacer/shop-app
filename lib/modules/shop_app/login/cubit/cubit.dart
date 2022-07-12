import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/login_model.dart';
import 'package:untitled/modules/shop_app/login/cubit/state.dart';
import 'package:untitled/network/end_point.dart';
import 'package:untitled/network/remote/shop_dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);
  ShopLoginModel? loginModel;

  void loginUsers({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    ShopDioHelper.postDate(url: LOGIN, data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginModel = ShopLoginModel.formJson(value.data);
      print(value.toString());
      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
      debugPrint(error.toString());
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ShopChangPasswordVisibilityState());
  }


  Future<void> close() {
    // TODO: implement close
    return super.close();
  }

}
