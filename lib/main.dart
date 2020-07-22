import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hustle/counter.dart';
import 'package:hustle/sizes_helper.dart';
import 'package:hustle/splashscreen.dart';
import 'package:intl/intl.dart';
import 'colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(CounterAdapter());
  runApp(Hustle());
}

class Hustle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FutureBuilder(
        future: Hive.openBox('counters'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return SplashScreen();
            }
          } else {
            return Scaffold(
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
            );
          }
        },
      ),
    );
  }
}

class Counters extends StatefulWidget {
  String theme;
  Counters(this.theme);
  @override
  CountersState createState() => CountersState(theme);
}

addCounter(
  String title,
  int count,
) {
  Counter counter = Counter(count: count, title: title);
  Hive.box('counters').add(counter);
  counterList.add(
    Counter(
      title: title,
      count: count,
    ),
  );
}

var now = DateTime.now();
var today = DateFormat("EEEE, MMM d").format(now);
var appbackgroundColor = appBackgroundLight;
var animbackgroundColor = animBackgroundLight;
var titletextColor = titletextLight;
var counterColor = counterLight;
var countColor = countLight;
var userinputColor = userinputLight;
var deleteColor = deleteLight;
var warningColor = warningLight;
var navigationColor = navigationLight;

class CountersState extends State<Counters> {
  String theme;
  CountersState(this.theme);
  void saveTheme() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    print(theme);
    myPrefs.setString('theme', theme);
  }

  void fetchTheme() async {
    print(theme);

    if (theme == 'light') {
      setState(() {
        appbackgroundColor = appBackgroundLight;
        animbackgroundColor = animBackgroundLight;
        titletextColor = titletextLight;
        counterColor = counterLight;
        countColor = countLight;
        userinputColor = userinputLight;
        deleteColor = deleteLight;
        warningColor = warningLight;
        navigationColor = navigationLight;
      });
    }
    if (theme == 'dark') {
      setState(() {
        appbackgroundColor = appBackgroundDark;
        animbackgroundColor = animBackgroundDark;
        titletextColor = titletextDark;
        counterColor = counterDark;
        countColor = countDark;
        userinputColor = userinputDark;
        deleteColor = deleteDark;
        warningColor = warningDark;
        navigationColor = navigationDark;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final window = WidgetsBinding.instance.window;
    window.onPlatformBrightnessChanged = () async {
      if (theme == 'system') {
        final changedBrightness = await window.platformBrightness;
        if (changedBrightness == Brightness.dark) {
          setState(() {
            appbackgroundColor = appBackgroundDark;
            animbackgroundColor = animBackgroundDark;
            titletextColor = titletextDark;
            counterColor = counterDark;
            countColor = countDark;
            userinputColor = userinputDark;
            deleteColor = deleteDark;
            warningColor = warningDark;
            navigationColor = navigationDark;
          });
        }
        if (changedBrightness == Brightness.light) {
          setState(() {
            appbackgroundColor = appBackgroundLight;
            animbackgroundColor = animBackgroundLight;
            titletextColor = titletextLight;
            counterColor = counterLight;
            countColor = countLight;
            userinputColor = userinputLight;
            deleteColor = deleteLight;
            warningColor = warningLight;
            navigationColor = navigationLight;
          });
        }
      }
    };
    setState(() {
      fetchTheme();
    });
  }

  final counterBox = Hive.box('counters');
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: appbackgroundColor,
        systemNavigationBarColor: navigationColor,
      ),
      child: Scaffold(
        backgroundColor: appbackgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  title: Text(
                                    'Enter Name of Counter',
                                    style: TextStyle(
                                      color: titletextColor,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w400,
                                      fontSize: displayWidth(context) * 0.05,
                                    ),
                                  ),
                                  content: TextField(
                                    controller: myController,
                                    style: TextStyle(color: titletextColor),
                                    autofocus: true,
                                    cursorColor: titletextColor,
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                        color: appbackgroundColor,
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            color: titletextColor,
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w400,
                                            fontSize:
                                                displayWidth(context) * 0.03,
                                          ),
                                        ),
                                        onPressed: () {
                                          addCounter(
                                            myController.text,
                                            0,
                                          );
                                          Navigator.pop(context);
                                          myController.clear();
                                          setState(() {});
                                        }),
                                  ],
                                  elevation: 24,
                                  backgroundColor: userinputColor,
                                );
                              });
                        },
                        iconSize: 30,
                        disabledColor: Colors.white,
                      ),
                      Text(
                        today.toString(),
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w400,
                          color: titletextColor,
                          fontSize: displayWidth(context) * 0.07,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.lightbulb_outline),
                        color: Colors.white,
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: navigationColor,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              context: context,
                              builder: (builder) {
                                return Container(
                                  //color: animbackgroundColor,
                                  height: displayHeight(context) * 0.2,
                                  // decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Theme',
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontWeight: FontWeight.w800,
                                              color: (appbackgroundColor ==
                                                      appBackgroundLight)
                                                  ? appbackgroundColor
                                                  : titletextColor,
                                              fontSize:
                                                  displayWidth(context) * 0.06,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () {
                                              setState(() {
                                                appbackgroundColor =
                                                    appBackgroundDark;
                                                animbackgroundColor =
                                                    animBackgroundDark;
                                                titletextColor = titletextDark;
                                                counterColor = counterDark;
                                                countColor = countDark;
                                                userinputColor = userinputDark;
                                                deleteColor = deleteDark;
                                                warningColor = warningDark;
                                                navigationColor =
                                                    navigationDark;
                                                theme = 'dark';
                                                saveTheme();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Ink(
                                              width:
                                                  displayWidth(context) * 0.2,
                                              height:
                                                  displayWidth(context) * 0.2,
                                              decoration: BoxDecoration(
                                                color: appbackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/moon.png',
                                                    width:
                                                        displayWidth(context) *
                                                            0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () {
                                              setState(() {
                                                appbackgroundColor =
                                                    appBackgroundLight;
                                                animbackgroundColor =
                                                    animBackgroundLight;
                                                titletextColor = titletextLight;
                                                counterColor = counterLight;
                                                countColor = countLight;
                                                userinputColor = userinputLight;
                                                deleteColor = deleteLight;
                                                warningColor = warningLight;
                                                navigationColor =
                                                    navigationLight;
                                                theme = 'light';
                                                saveTheme();
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Ink(
                                              width:
                                                  displayWidth(context) * 0.2,
                                              height:
                                                  displayWidth(context) * 0.2,
                                              decoration: BoxDecoration(
                                                color: appbackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/sun.png',
                                                    width:
                                                        displayWidth(context) *
                                                            0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            onTap: () async {
                                              final Brightness brightness =
                                                  await MediaQuery.of(context)
                                                      .platformBrightness;
                                              print(brightness);
                                              if (brightness ==
                                                  Brightness.dark) {
                                                setState(() {
                                                  appbackgroundColor =
                                                      appBackgroundDark;
                                                  animbackgroundColor =
                                                      animBackgroundDark;
                                                  titletextColor =
                                                      titletextDark;
                                                  counterColor = counterDark;
                                                  countColor = countDark;
                                                  userinputColor =
                                                      userinputDark;
                                                  deleteColor = deleteDark;
                                                  warningColor = warningDark;
                                                  navigationColor =
                                                      navigationDark;
                                                  theme = 'system';
                                                  saveTheme();
                                                });
                                                Navigator.pop(context);
                                              } else {
                                                setState(() {
                                                  appbackgroundColor =
                                                      appBackgroundLight;
                                                  animbackgroundColor =
                                                      animBackgroundLight;
                                                  titletextColor =
                                                      titletextLight;
                                                  counterColor = counterLight;
                                                  countColor = countLight;
                                                  userinputColor =
                                                      userinputLight;
                                                  deleteColor = deleteLight;
                                                  warningColor = warningLight;
                                                  navigationColor =
                                                      navigationLight;
                                                  theme = 'system';
                                                  saveTheme();
                                                });
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Ink(
                                              width:
                                                  displayWidth(context) * 0.2,
                                              height:
                                                  displayWidth(context) * 0.2,
                                              decoration: BoxDecoration(
                                                color: appbackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/system.png',
                                                    width:
                                                        displayWidth(context) *
                                                            0.07,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: animbackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (appbackgroundColor == appBackgroundDark)
                            ? Colors.transparent
                            : Colors.black38,
                        offset: Offset(0, -5),
                        spreadRadius: 1.0,
                        blurRadius: 11.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: Center(
                      child: counterBox.length > 0
                          ? ListView.builder(
                              itemCount: counterBox.length,
                              itemBuilder: (BuildContext context, int index) {
                                final counter =
                                    counterBox.getAt(index) as Counter;
                                return Dismissible(
                                  secondaryBackground: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: deleteColor,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  background: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: deleteColor,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onDismissed: (DismissDirection direction) {
                                    setState(() {
                                      counterBox.deleteAt(index);
                                    });
                                  },
                                  key: Key(counterBox.getAt(index).title),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 50),
                                      height: 200,
                                      decoration: BoxDecoration(
                                          color: counterColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            left: 10,
                                            right: 10,
                                            bottom: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  counter.title,
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 35,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                FlatButton(
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                  color: counterColor,
                                                  shape: CircleBorder(),
                                                  onPressed: () {
                                                    counterBox.putAt(
                                                      index,
                                                      Counter(
                                                          count:
                                                              counter.count - 1,
                                                          title: counter.title),
                                                    );
                                                    setState(() {});
                                                  },
                                                  onLongPress: () {
                                                    counterBox.putAt(
                                                      index,
                                                      Counter(
                                                          count: counter.count -
                                                              10,
                                                          title: counter.title),
                                                    );
                                                    setState(() {});
                                                  },
                                                ),
                                                Text(
                                                  counter.count.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 60,
                                                    color: countColor,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                FlatButton(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  color: counterColor,
                                                  shape: CircleBorder(),
                                                  onPressed: () {
                                                    counterBox.putAt(
                                                      index,
                                                      Counter(
                                                          count:
                                                              counter.count + 1,
                                                          title: counter.title),
                                                    );
                                                    print(counter.count);
                                                    setState(() {});
                                                  },
                                                  onLongPress: () {
                                                    counterBox.putAt(
                                                      index,
                                                      Counter(
                                                          count: counter.count +
                                                              10,
                                                          title: counter.title),
                                                    );
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                FlatButton(
                                                    child: Icon(
                                                      Icons.refresh,
                                                      color: Colors.white,
                                                    ),
                                                    color: counterColor,
                                                    shape: CircleBorder(),
                                                    onPressed: () {
                                                      counterBox.putAt(
                                                        index,
                                                        Counter(
                                                            count: 0,
                                                            title:
                                                                counter.title),
                                                      );
                                                      setState(() {});
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                'No Counters',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 30,
                                  color: warningColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
