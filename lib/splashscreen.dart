import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hustle/main.dart';
import 'package:hustle/sizes_helper.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String languageSelected;
  String theme = 'light';
  startTime() async {
    var _duration = new Duration(seconds: 2);

    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    theme = myPrefs.getString('theme');
    print(theme);
    if (myPrefs.containsKey('theme')) {
      if (theme == 'system') {
        final Brightness brightness =
            await MediaQuery.of(context).platformBrightness;
        print(brightness);
        if (brightness == Brightness.dark) {
          Get.off(
            Counters('dark'),
          );
        } else {
          Get.off(
            Counters('light'),
          );
        }
      } else {
        Get.off(
          Counters(theme),
        );
      }
    } else {
      final Brightness brightness =
          await MediaQuery.of(context).platformBrightness;
      print(brightness);
      if (brightness == Brightness.dark) {
        Get.off(
          Counters('dark'),
        );
      } else {
        Get.off(
          Counters('light'),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(48, 63, 159, 1),
        systemNavigationBarColor: Color.fromRGBO(48, 63, 159, 1),
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(48, 63, 159, 1),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Spacer(
                flex: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/icon/Hustle_foreground.png',
                    height: displayWidth(context) * 0.5,
                  ),
                ],
              ),
              Spacer(
                flex: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
