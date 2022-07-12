import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/modules/shop_app/login/shop_login_screen.dart';
import 'package:untitled/network/components/components.dart';
import 'package:untitled/network/local/cache_helper.dart';
import 'package:untitled/styles/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var controller = PageController();
  bool isLast = false;
  final List<BoardingModel> boarding = [
    BoardingModel(
      image: const AssetImage('assets/images/onboarding1.jpg'),
      title: 'Be sure to implement preventive measures to reduce the COVID-19 virus',
      body: 'Prevention is better than cure',
    ),
    BoardingModel(
      image: const AssetImage('assets/images/onboarding2.jpg'),
      title: 'best selling products ',
      body: 'original products',
    ),
    BoardingModel(
      image: const AssetImage('assets/images/onboarding3.jpg'),
      title: 'Huge discounts up!',
      body: 'BIG Sell',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 0.0,
        actions: [
          defaultTextButton(
              onPressed: () {
                submit(context);
              },
              text: 'skip',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                controller: controller,
                // physics: NeverScrollableScrollPhysics(),
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                    debugPrint('last');
                  } else {
                    isLast = false;
                  }
                  debugPrint('is not last');
                },
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: controller,
                  count: boarding.length,
                  effect:  const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      spacing: 5.0,
                      expansionFactor: 4.0),
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    if (isLast) {
                      submit(context);
                    } else {
                      controller.nextPage(
                        duration: const Duration(
                          milliseconds: 100,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: model.image,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Text(
            model.title,
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            model.body,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
        ],
      );
}

class BoardingModel {
  final AssetImage image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

void submit(context) {
  CacheHelper.saveData(key: 'onboarding', value: true).then((value) {
    if (value) {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}