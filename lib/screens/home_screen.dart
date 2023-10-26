import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app/router.dart';
import '../bloc/logic_bloc/get_device_bloc.dart';

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
  final getDeviceBloc = GetDeviceBloc();
  List<Map<String, dynamic>> retrievedStudents = [];
  String studentName = "";

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
  }

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
    return Scaffold(
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
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 757) {
                return buildHomeContainer(context, mq);
              } else {
                return buildHomeContainer(context, mq);
              }
            }),
      ),
    );
  }

  Widget loaderBar(BuildContext context, Size mq) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: mq.height,
      ),
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
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: boxImageDashboardBgDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Container(
                height: 60,
                decoration: kButtonBgDecoration,
                child: TopBarWidget(
                  onTapLeft: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  onTapRight: () {
                  },
                  leftIcon: 'assets/icons/menu.png',
                  rightIcon: 'assets/icons/user.png',
                  title: "Home",
                  rightVisibility: true,
                  leftVisibility: false,
                  bottomTextVisibility: false,
                  subTitle: '',
                  screen: 'home',
                ),
              ),

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
    ),)
    ,
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
