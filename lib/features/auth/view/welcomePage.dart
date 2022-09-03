import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysocial_app/core/components/buttons/primaryButton.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: SizedBox(
          height: 0.97.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Text(
                'Welcome to Catch Up',
                style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 9.h),
              Text(
                'The campus social network...',
                style: TextStyle(
                  fontSize: 17.h,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/brands/welcome_image.png',
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 22),
                child: Column(
                  children: [
                    Text(
                      'For Students, By Students',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 17.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            type: 'dim',
                            text: 'Get started',
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Login',
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
