import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/layout/shop_app/cubit/states.dart';
import 'package:untitled/models/categories_model.dart';
import 'package:untitled/models/home_model.dart';
import 'package:untitled/network/components/components.dart';
import 'package:untitled/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavoritesDataStates){
          if(state.model.status ==false){
            showToast(message: state.model.message, state: ToastState.ERROR);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null ,
            builder: (context) =>
                productBuilder(ShopCubit.get(context).homeModel!,ShopCubit.get(context).categoriesModel!,context),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget productBuilder(HomeModel model , CategoriesModel categoriesModel,context) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model.data.banners
                    .map((e) => Image(
                          image: NetworkImage(e.image),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ))
                    .toList(),
                options: CarouselOptions(
                  height: 200,
                  initialPage: 0,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                )),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.cyan,
                    child:  Center(
                      child: Text(
                        ShopCubit.categories,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index) =>buildCategoriesItem(categoriesModel.data.data[index]),
                      separatorBuilder: (context,index) =>const SizedBox(width: 5.0,),
                      itemCount: categoriesModel.data.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    color: Colors.cyan,
                    child: Center(
                      child: Text(
                        ShopCubit.products,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0,),
            Container(
              color: Colors.grey[200],
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.7,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(model.data.products.length,
                    (index) => buildGridProduct(model.data.products[index],context)),
              ),
            )
          ],
        ),
      );

  Widget buildCategoriesItem(Data_Model model) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage(
                model.image),
            height: 100.0,
            width: 100,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100.0,
            color: Colors.indigo[200],
            child: Text(
              model.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      );

  Widget buildGridProduct(ProductModel model ,context) => Container(
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image),
                  width: double.infinity,
                  height: 200.0,
                ),
                if (model.discount != 0)
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      color: Colors.red,
                      child: const Text(
                        'Discount',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1.3,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()} LE',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice.round()}LE',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              height: 1.3,
                              decoration: TextDecoration.lineThrough),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                         ShopCubit.get(context).changeFavorites(model.id);
                          // debugPrint(ShopCubit.get(context).favorites.toString());
                          // debugPrint(model.id.toString());
                        },
                        icon: CircleAvatar(
                          backgroundColor: ShopCubit.get(context).favorites[model.id]as bool ?defaultColor :Colors.grey,
                          radius: 15.0,
                          child:  const Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

}
