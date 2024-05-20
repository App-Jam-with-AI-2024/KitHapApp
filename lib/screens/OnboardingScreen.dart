import 'package:flutter/material.dart';
import 'package:kithap_app/colors.dart';
import 'package:kithap_app/models/onboarding_content_model.dart';
import 'package:kithap_app/screens/LoginScreen.dart';
import 'RegisterScreen.dart';

class OnboardingInfo {
  final String imageAsset;
  final String title;
  final String description;

  OnboardingInfo({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                imageAsset: onboardingPages[index].imageAsset,
                title: onboardingPages[index].title,
                description: onboardingPages[index].description,
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    if (currentIndex != onboardingPages.length - 1) {
                      _pageController.jumpToPage(onboardingPages.length - 1);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  child: Text(
                    currentIndex == onboardingPages.length - 1
                        ? 'Başla'
                        : 'Atla',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                Row(
                  children: List.generate(
                    onboardingPages.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      width: currentIndex == index ? 12 : 8,
                      height: currentIndex == index ? 12 : 8,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (currentIndex < onboardingPages.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    }
                  },
                  icon: Icon(Icons.arrow_forward, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  OnboardingPage({
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imageAsset),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
