import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/bloc/state/meeting_state.dart';

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/router.dart';
import '../bloc/logic_bloc/get_device_bloc.dart';

import '../bloc/logic_bloc/meeting_bloc.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/DashboardtemWidget.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isLogin = false;
  List<Map<String, dynamic>> retrievedStudents = [];
  String studentName = "";
  final meetingBloc = MeetingBloc();

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });

    setState(() {
      studentName = SharedPrefs().getUserFullName().toString();
    });
    getStudentList();
    _configureFirebaseMessaging();
  }
  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: $message");
      }
      // Handle notification when the app is in the foreground
      //_handleNotification(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessageOpenedApp: $message");
      }
      // Handle notification when the app is in the background and opened by tapping on the notification
      _handleNotification(message.data);

    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      if (kDebugMode) {
        print("onBackgroundMessage: $message");
      }
      // Handle notification when the app is terminated
      _handleNotification(message.data);
    });
  }

  void _handleNotification(Map<String, dynamic> message) {
    // Extract the screen name from the data payload
    String screenName = message['screen'];
    if (kDebugMode) {
      print('Received notification for screen: $screenName');
    }

    // Navigate to the corresponding screen
    switch (screenName) {
      case "calendar":
        print('Navigating to school calendar');
        context.push(Routes.schoolCalender);
        break;
      case "message_to_parent":
        print('Navigating to message to parent');
        context.push(Routes.messageFromSchool);
        break;
      case "Lunch":
        print('Navigating to lunch menu');
        context.push(Routes.lunchMenu);
        break;
      case "Snack":
        print('Navigating to snack menu');
        context.push(Routes.snackMenu);
        break;
      case "photos":
        print('Navigating to student photos');
        context.push(Routes.studentPhotos);
        break;
      default:
        print('Navigating to main home');
        context.push(Routes.mainHome);
    }
  }


/*
  void _handleNotification(Map<String, dynamic> message) {
    // Extract the screen name from the data payload
    String screenName = message['payload']['screen'];

    // Navigate to the corresponding screen
    if (screenName == "calendar") {
      // Example of using named routes for navigation
      context.push(Routes.schoolCalender);
      //Navigator.pushNamed(context, '/$screenName');
    }else if (screenName == "message_to_parent") {
      // Example of using named routes for navigation
      context.push(Routes.messageToTeacher);
      //Navigator.pushNamed(context, '/$screenName');
    }else if (screenName == "Lunch") {
      // Example of using named routes for navigation
      context.push(Routes.lunchMenu);
      //Navigator.pushNamed(context, '/$screenName');
    }else if (screenName == "Snack") {
      // Example of using named routes for navigation
      context.push(Routes.snackMenu);
      //Navigator.pushNamed(context, '/$screenName');
    }else if (screenName == "photos") {
      // Example of using named routes for navigation
      context.push(Routes.studentPhotos);
      //Navigator.pushNamed(context, '/$screenName');
    }else  {
      // Example of using named routes for navigation
      context.push(Routes.mainHome);
      //Navigator.pushNamed(context, '/$screenName');
    }
  }
*/
  getStudentList() async {
    retrievedStudents.clear();

    retrievedStudents = await SharedPrefs().getStudents();

    if (kDebugMode) {
      print(retrievedStudents);
    }
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery
        .of(context)
        .size;
    return  BlocProvider(
      create: (context) => meetingBloc,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width *
              0.75, // 75% of screen will be occupied
          child: Drawer(
            backgroundColor: Colors.white,
            child: DrawerWidget(
              contexts: context,
            ),
          ), //Drawer
        ),
        body: ColoredSafeArea(
          child: BlocBuilder<MeetingBloc, MeetingState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return loaderBar(context, mq);
              } else if (state is GetOfficeSlotState) {
                return buildHomeContainer(context, mq);
              } else if (state is FailureState) {
                return Center(
                  child: Text('Error: ${state.error}'),
                );
              }
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 757) {
                    return buildHomeContainer(context, mq);
                  } else {
                    return buildHomeContainer(context, mq);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget loaderBar(BuildContext context, Size mq) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: boxImageDashboardBgDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 60,
            decoration: kButtonBgDecoration,
            child: TopBarWidget(
              onTapLeft: () {
              },
              onTapRight: () {
              },
              leftIcon: 'assets/icons/menu.png',
              rightIcon: 'assets/icons/user.png',
              title: "Home",
              rightVisibility: true,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'home',

            ),),

          Container(
            margin: const EdgeInsets.only(
              bottom: 20,
              top: 82,
              left: 16,
            ),
            child: Stack(
              children: [
                Container(
                  height: 500,
                  margin: const EdgeInsets.only(bottom: 20, top: 80),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: SpinKitFadingCircle(
                            color: kLightGray,
                            size: 80.0,
                          ))
                    ],
                  ),
                ),


                Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                    text: "Welcome, ",
                    style: textStyle(Colors.black, 14, 0, FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text:studentName,
                        style:
                        textStyle(appBaseColor, 14, 0, FontWeight.w500),
                      ),
                      // can add more TextSpans here...
                    ],
                  ),
                ),
                20.height,
                buildCategoriesListWeb2000Container(context, mq),
              ],
            ),
          ),
        ],
      ),
    );Container(
      constraints: const BoxConstraints.expand(),
      decoration: boxImageDashboardBgDecoration(),
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Stack(
          children: [
            TopBarWidget(
              onTapLeft: () {},
              onTapRight: () {},
              leftIcon: 'assets/icons/menu.png',
              rightIcon: 'assets/icons/user.png',
              title: "Home",
              rightVisibility: true,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'home',
            ),
            Container(
              height: 500,
              margin: const EdgeInsets.only(bottom: 20, top: 80),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: SpinKitFadingCircle(
                        color: kLightGray,
                        size: 80.0,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHomeContainer(BuildContext context, Size mq) {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: boxImageDashboardBgDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               height: 60,
               decoration: kButtonBgDecoration,
                child: TopBarWidget(
                  onTapLeft: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  onTapRight: () {
                    context.push(Routes.accountInfo);

                  },
                  leftIcon: 'assets/icons/menu.png',
                  rightIcon: 'assets/icons/user.png',
                  title: "Home",
                  rightVisibility: true,
                  leftVisibility: true,
                  bottomTextVisibility: false,
                  subTitle: '',
                  screen: 'home',

              ),),

            Container(
              margin: const EdgeInsets.only(
                bottom: 20,
                top: 22,
                left: 16,
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: [
                  Text.rich(
                    textAlign: TextAlign.left,
                    TextSpan(
                        text: "Welcome, ",
                        style: textStyle(Colors.black, 14, 0, FontWeight.w500),
                        children: <TextSpan>[
                    TextSpan(
                    text:studentName,
                    style:
                        textStyle(appBaseColor, 14, 0, FontWeight.w500),
                  ),
                  // can add more TextSpans here...
                ],
              ),
            ),
            20.height,
            buildCategoriesListWeb2000Container(context, mq),
          ],
        ),
      ),
      ],
    ),
    );
  }

  Widget buildCategoriesListWeb2000Container(BuildContext context, Size mq) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          reverse: false,
          shrinkWrap: true,
          primary: false,
          itemCount: dashboardList.length,
          itemBuilder: (BuildContext context, int index) {
            return DashboardItemWidget(
              name: dashboardList[index]['name'],
              image: dashboardList[index]['image'],
              click: () {
                if (index == 0) {
                  context.push(Routes.lunchMenu);
                } else if (index == 1) {
                  context.push(Routes.snackMenu);
                } else if (index == 2) {
                  context.push(Routes.schoolCalender);
                } else if (index == 3) {
                  context.push(Routes.messageFromSchool);
                } else if (index == 4) {
                  context.push(Routes.meetingWithTeacher);
                } else if (index == 5) {
                  context.push(Routes.meetingWithOffice);
                } else if (index == 6) {
                  context.push(Routes.messageToOffice);
                } else if (index == 7) {
                  context.push(Routes.messageToTeacher);
                } else if (index == 8) {
                  context.push(Routes.studentPhotos);
                } else if (index == 9) {
                  context.push(Routes.lessonProgress);
                } else if (index == 10) {
                  context.push(Routes.setReminder);
                } else if (index == 11) {
                  context.push(Routes.switchChild);
                }
              },
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2 / 2,
          ),
        )
      ],
    );
  }
}
