import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required VoidCallback? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 30.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onFieldSubmitted,
  Function(String)? onChange,
  VoidCallback? onTap,
  VoidCallback? suffixPressed,
  String? Function(String?)? validate,
  required String label,
  required IconData prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
}) =>
    TextFormField(
      // style: const TextStyle(
      //   fontSize: 25.0,
      // ),
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChange,
      validator: validate,
      obscureText: isPassword,
      onTap: onTap,

      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
        suffix: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffixIcon),
        ),
      ),
    );

Widget defaultTextButton({
  required VoidCallback? onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(text.toUpperCase()),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        // navigateTo(
        //   context,
        //   WebViewScreen(article['url']),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Container(
                height: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${article['title']}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
          ],
        ),
      ),
    );

Widget articleBuilder(list, context, {isSearch = false}) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => myDivider(),
        itemCount: 10,
      ),
      fallback: (context) => isSearch
          ? Container()
          : const Center(child: CircularProgressIndicator()),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

void showToast({
  required String message,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  late Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListItem(model, context, {bool isOldPrice = true}) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image.toString()),
                  width: 120,
                  height: 120.0,
                ),
                if (1 != 0)
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          model.price.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: defaultColor,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        if (model.discount != 0 && isOldPrice)
                          Text(
                            model.oldPrice.toString(),
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
                            ShopCubit.get(context)
                                .changeFavorites(model.id!.toInt());
                            // debugPrint(ShopCubit.get(context).favorites.toString());
                            // debugPrint(model.id.toString());
                          },
                          icon: CircleAvatar(
                            backgroundColor: ShopCubit.get(context)
                                    .favorites[model.id] as bool
                                ? defaultColor
                                : Colors.grey,
                            radius: 15.0,
                            child: const Icon(
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
            ),
          ],
        ),
      ),
    );

PreferredSizeWidget buildDefaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? action,
}) =>
    AppBar(
      title: Text(title!,style: const TextStyle(
        color: Colors.grey

      ),),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios_sharp,
          color: Colors.grey,
        ),
      ),
      actions: action,
    );
