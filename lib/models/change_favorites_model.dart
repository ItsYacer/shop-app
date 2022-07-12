class ChangeFavoritesModel {
  late bool status;
  late String message;

  ChangeFavoritesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
}
