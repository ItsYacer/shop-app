import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/cubit.dart';
import 'package:untitled/layout/shop_app/shop_layout.dart';
import 'package:untitled/modules/shop_app/login/cubit/cubit.dart';
import 'package:untitled/modules/shop_app/login/cubit/state.dart';
import 'package:untitled/network/components/components.dart';
import 'package:untitled/network/components/constants.dart';
import 'package:untitled/network/local/cache_helper.dart';

import '../register/shop_register_screen.dart';

// ignore: must_be_immutable
class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({Key? key}) : super(key: key);
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            //هنا بقي لو انت في الاسيتيت دي هات بتعمل كده عشان تبعت بقي مع الوج ان لو صح لاسكرينه الهوم
            if (state.loginModel.status == true) {
             debugPrint(state.loginModel.message);
             debugPrint(state.loginModel.data?.token);
             token =state.loginModel.data!.token!;
             CacheHelper.saveData(key: 'token', value: state.loginModel.data?.token).then((value) {
               showToast(message: state.loginModel.message.toString(), state: ToastState.SUCCESS);
               ShopCubit.get(context).getUserData();
               ShopCubit.get(context).getFavData();
               navigateAndFinish(context, ShopLayout());
             });
            } else {
              showToast(message: state.loginModel.message.toString(), state: ToastState.ERROR);
              debugPrint(state.loginModel.message);
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
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.teal,fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 30.0,
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
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          onFieldSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).loginUsers(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Password is to short';
                            }
                            return null;
                          },
                          prefixIcon: Icons.lock,
                          suffixIcon: ShopLoginCubit.get(context).suffix,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          label: 'Password',
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                // debugPrint(emailController.text);
                                // debugPrint(passwordController.text);
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).loginUsers(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'LOGIN'),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account? '),
                            defaultTextButton(
                              onPressed: () {
                                navigateTo(context,  ShopRegisterScreen());
                              },
                              text: 'register now ',
                            ),
                          ],
                        )
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
