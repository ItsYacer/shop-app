import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/layout/shop_app/cubit/states.dart';
import 'package:untitled/network/components/components.dart';
import 'package:untitled/network/components/constants.dart';
class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).userData;
        ShopCubit.get(context).emailController.text = model!.data!.email!;
        ShopCubit.get(context).nameController.text = model.data!.name!;
        ShopCubit.get(context).phoneController.text = model.data!.phone!;

        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                if(state is ShopLoadingUpdateUserDataStates)
                const LinearProgressIndicator(),
                const SizedBox(height: 20.0,),
                defaultFormField(
                    controller: ShopCubit.get(context).nameController,
                    type: TextInputType.name,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Name must be not empty';
                      }
                      return null;
                    },
                    label: 'Full Name',
                    prefixIcon: Icons.person),
                const SizedBox(
                  height: 10.0,
                ),
                defaultFormField(
                    controller: ShopCubit.get(context).emailController,
                    type: TextInputType.emailAddress,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Email address must be not empty';
                      }
                      return null;
                    },
                    label: 'Email Address',
                    prefixIcon: Icons.email_sharp),
                const SizedBox(
                  height: 10.0,
                ),
                defaultFormField(
                    controller: ShopCubit.get(context).phoneController,
                    type: TextInputType.phone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Phone must be not empty';
                      }
                      return null;
                    },
                    label: 'Phone ',
                    prefixIcon: Icons.phone_android_sharp),
                const SizedBox(
                  height: 10.0,
                ),
                defaultButton(
                    function: () {
                      signOut(context);
                    },
                    text: ShopCubit.signOut),
                const SizedBox(
                  height: 10.0,
                ),
                defaultButton(
                    function: () {
                      if (formKey.currentState!.validate()) {
                        ShopCubit.get(context).updateUserData(
                          name: ShopCubit.get(context).nameController.text,
                          email: ShopCubit.get(context).emailController.text,
                          phone: ShopCubit.get(context).phoneController.text,
                        );
                      }
                    },
                    text: ShopCubit.update)
              ],
            ),
          ),
        );
      },
    );
  }

}
