class HomeModel {
  late bool status;
  late DataModel data;

  HomeModel.fromJson(dynamic json) {
    status = json['status'];
    data = DataModel.fromJson(json['data']);
  }
}

class DataModel {
  late List<BannerModel> banners = [];
  late List<ProductModel> products = [];

  DataModel.fromJson(dynamic json) {
    json['banners'].forEach((element) {
      banners.add(BannerModel.fromJson(element));
    });
    json['products'].forEach((element) {
      products.add(ProductModel.fromJson(element));
    });
  }
}

class BannerModel {
  late int id;
  late String image;

  BannerModel.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
  }

}

class ProductModel {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  late bool inFavorites;
  late bool inCart;

  ProductModel.fromJson(dynamic json) {
    id =json['id'];
    price =json['price'];
    oldPrice =json['old_price'];
    discount =json['discount'];
    image =json['image'];
    name =json['name'];
    inFavorites =json['in_favorites'];
    inCart =json['in_cart'];
  }

}

