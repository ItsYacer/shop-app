import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/layout/shop_app/cubit/states.dart';
import 'package:untitled/modules/shop_app/search/search_screen.dart';
import 'package:untitled/network/components/components.dart';

class ShopLayout extends StatelessWidget {
  ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: Text(
              ShopCubit.salla,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 2.0,
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context, SearchScreen());
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    maxRadius: 18,
                    backgroundColor: Colors.white,
                    child: MaterialButton(
                      onPressed: () {
                        ShopCubit.get(context).changLang();
                      },
                      padding: EdgeInsets.zero,
                      minWidth: 2.0,
                      child:  Text(
                        ShopCubit.lang,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.cyan),
                      ),
                    )),
              )
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedFontSize: 16,
            unselectedItemColor: Colors.cyan,
            selectedItemColor: Colors.deepPurple,
            onTap: (index) {
              cubit.changeBottom(index);
            },
            currentIndex: cubit.currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: ShopCubit.home),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.category),
                  label: ShopCubit.categories),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: ShopCubit.navFavorites),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings), label: ShopCubit.setting),
            ],
          ),
        );
      },
    );
  }
}
