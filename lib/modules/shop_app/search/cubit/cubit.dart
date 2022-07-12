import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/search_model.dart';
import 'package:untitled/modules/shop_app/search/cubit/states.dart';
import 'package:untitled/network/components/constants.dart';
import 'package:untitled/network/end_point.dart';
import 'package:untitled/network/remote/shop_dio_helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  late SearchModel model;

  void search(String text) {
    emit(SearchLoadingState());

    ShopDioHelper.postDate(
      url: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      debugPrint(value.data.toString());
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(SearchErrorState());
    });
  }
}
