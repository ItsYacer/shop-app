import 'package:flutter/material.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/models/categories_model.dart';
import 'package:untitled/network/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => buildCategoryItem(
          ShopCubit.get(context).categoriesModel!.data.data[index]),
      separatorBuilder: (context, index) => myDivider(),
      itemCount: ShopCubit.get(context).categoriesModel!.data.data.length,
    );
  }

  Widget buildCategoryItem(Data_Model model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              model.name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      );
}
