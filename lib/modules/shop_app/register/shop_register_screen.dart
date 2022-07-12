import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/layout/shop_app/shop_layout.dart';
import 'package:untitled/modules/shop_app/register/cubit/cubit.dart';
import 'package:untitled/modules/shop_app/register/cubit/state.dart';
import 'package:untitled/network/components/components.dart';
import 'package:untitled/network/components/constants.dart';
import 'package:untitled/network/local/cache_helper.dart';

// ignore: must_be_immutable
class ShopRegisterScreen extends StatelessWidget {
  ShopRegisterScreen({Key? key}) : super(key: key);
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            //هنا بقي لو انت في الاسيتيت دي هات بتعمل كده عشان تبعت بقي مع الوج ان لو صح لاسكرينه الهوم
            if (state.registerModel.status == true) {
              debugPrint(state.registerModel.message);
              debugPrint(state.registerModel.data?.token);
              token =state.registerModel.data!.token!;
              CacheHelper.saveData(key: 'token', value: state.registerModel.data?.token).then((value) {
                showToast(message: state.registerModel.message.toString(), state: ToastState.SUCCESS);
                ShopCubit.get(context).getUserData();
                ShopCubit.get(context).getFavData();
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(message: state.registerModel.message.toString(), state: ToastState.ERROR);
              debugPrint(state.registerModel.message);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.teal),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            return null;
                          },
                          prefixIcon: Icons.person,
                          label: 'Full Name',
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Email address';
                            }
                            return null;
                          },
                          prefixIcon: Icons.email,
                          label: 'Email Address',
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          isPassword: ShopRegisterCubit.get(context).isPassword,
                          onFieldSubmitted: (value) {
                            // if (formKey.currentState!.validate()) {
                            //   ShopRegisterCubit.get(context).loginUsers(
                            //       email: emailController.text,
                            //       password: passwordController.text);
                            // }
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Password is to short';
                            }
                            return null;
                          },
                          prefixIcon: Icons.lock,
                          suffixIcon: ShopRegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            ShopRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          label: 'Password',
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Phone';
                            }
                            return null;
                          },
                          prefixIcon: Icons.phone,
                          label: 'phone',
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).registerUsers(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text);
                                  ShopCubit.get(context).getUserData();
                                  ShopCubit.get(context).getFavData();
                                }
                              },
                              text: 'LOGIN'),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
