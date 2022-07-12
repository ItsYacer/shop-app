import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/modules/shop_app/search/cubit/cubit.dart';
import 'package:untitled/modules/shop_app/search/cubit/states.dart';
import 'package:untitled/network/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final searchController = TextEditingController();
  Key searchKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: searchKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please Entre What You Need To Search';
                          }
                          return null;
                        },
                        prefixIcon: Icons.search,
                        label: 'Search',
                        onFieldSubmitted: (text) {
                          SearchCubit.get(context).search(text);
                        }),
                    const SizedBox(
                      height: 5.0,
                    ),
                    if (state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildListItem(
                              SearchCubit.get(context).model.data!.data![index],
                              context,
                              isOldPrice: false),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount:
                              SearchCubit.get(context).model.data!.data!.length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
