import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/login_model.dart';
import 'package:untitled/modules/shop_app/register/cubit/state.dart';
import 'package:untitled/network/end_point.dart';
import 'package:untitled/network/remote/shop_dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());


  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  ShopLoginModel? registerModel;

  void registerUsers({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());
    ShopDioHelper.postDate(url: REGISTER, data: {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
    }).then((value) {
      registerModel = ShopLoginModel.formJson(value.data);
      print(value.toString());
      emit(ShopRegisterSuccessState(registerModel!));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
      debugPrint(error.toString());
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_off_outlined;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ShopRegisterChangPasswordVisibilityState());
  }
@override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
