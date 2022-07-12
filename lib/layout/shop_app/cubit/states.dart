
import 'package:untitled/models/change_favorites_model.dart';
import 'package:untitled/models/login_model.dart';

abstract class ShopStates {}

class ShopInitialStates extends ShopStates {}

class ShopChangeBottomNavStates extends ShopStates {}

class ShopLoadingHomeDataStates extends ShopStates {}

class ShopSuccessHomeDataStates extends ShopStates {}

class ShopErrorHomeDataStates extends ShopStates {}

class ShopLoadingCategoriesDataStates extends ShopStates {}

class ShopSuccessCategoriesDataStates extends ShopStates {}

class ShopErrorCategoriesDataStates extends ShopStates {}

class ShopSuccessChangeFavoritesDataStates extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesDataStates(this.model);
}

class ShopChangeFavoritesDataStates extends ShopStates {}

class ShopErrorChangeFavoritesDataStates extends ShopStates {}

class ShopSuccessGetFavoritesDataStates extends ShopStates {}

class ShopLoadingGetFavoritesDataStates extends ShopStates {}

class ShopErrorGetFavoritesDataStates extends ShopStates {}

class ShopSuccessGetUserDataStates extends ShopStates
{
  final ShopLoginModel loginModel;

  ShopSuccessGetUserDataStates(this.loginModel);

}

class ShopLoadingGetUserDataStates extends ShopStates {}

class ShopErrorGetUserDataStates extends ShopStates {}


class ShopSuccessUpdateUserDataStates extends ShopStates
{
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserDataStates(this.loginModel);

}

class ShopLoadingUpdateUserDataStates extends ShopStates {}

class ShopErrorUpdateUserDataStates extends ShopStates {}
class ShopChangeLangState extends ShopStates {}
