import 'package:eroll/core/widgets/button_widget.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/app_texts.dart';
import 'package:eroll/core/constants/resource_path.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/onboarding/components/animated_wrapper_widget.dart';
import 'package:eroll/features/onboarding/components/onboard_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedWrapperWidget(
                      index: 1,
                      child: Text(
                        'What\'s New',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    SizedBox(height: 30),
                    AnimatedWrapperWidget(
                      index: 2,
                      child: OnboardTileWidget(
                        icon: CupertinoIcons.person_2_square_stack_fill,
                        iconColor: AppColors.blueAccent,
                        title: AppTexts.onBoardTitle1,
                        subTitle: AppTexts.onBoardSubTitle1,
                      ),
                    ),

                    AnimatedWrapperWidget(
                      index: 3,
                      child: OnboardTileWidget(
                        icon: CupertinoIcons.square_stack_3d_up_fill,
                        iconColor: AppColors.red,
                        title: AppTexts.onBoardTitle2,
                        subTitle: AppTexts.onBoardSubTitle2,
                      ),
                    ),

                    AnimatedWrapperWidget(
                      index: 4,
                      child: OnboardTileWidget(
                        icon: CupertinoIcons.square_favorites_fill,
                        iconColor: AppColors.teal,
                        title: AppTexts.onBoardTitle3,
                        subTitle: AppTexts.onBoardSubTitle3,
                      ),
                    ),

                    AnimatedWrapperWidget(
                      index: 5,
                      child: OnboardTileWidget(
                        icon: CupertinoIcons.chart_bar_square_fill,
                        iconColor: AppColors.deepPurple,
                        title: AppTexts.onBoardTitle4,
                        subTitle: AppTexts.onBoardSubTitle4,
                      ),
                    ),

                    SizedBox(height: 30),
                    AnimatedWrapperWidget(
                      index: 6,
                      child: ButtonWidget(
                        btnText: AppTexts.continueText,
                        btnColor: AppColors.primaryColor,
                        btnAction: () async {
                          setState(() => isLoading = true);
                          var ticker = controller.forward();
                          await ticker.whenComplete(() {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRouteNames.bottomNavScreen,
                            );
                          });
                        },
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 700,
                    child: LottieBuilder.asset(
                      controller: controller,
                      AssetPath.partyEffectJsonPath,
                      fit: BoxFit.fill,
                      repeat: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
