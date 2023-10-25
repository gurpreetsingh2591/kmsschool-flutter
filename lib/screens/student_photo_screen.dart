import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
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
import '../widgets/StudentPhotosWidget.dart';
import '../widgets/TopBarWidget.dart';

class StudentPhotoPage extends StatefulWidget {
  const StudentPhotoPage({Key? key}) : super(key: key);

  @override
  StudentPhotoPageState createState() => StudentPhotoPageState();
}

class StudentPhotoPageState extends State<StudentPhotoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isLogin = false;
  final getDeviceBloc = GetDeviceBloc();
  List<String> studentPhotos = [];
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
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width *
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
              title: "Student Photos",
              rightVisibility: true,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'sp',
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
        constraints: BoxConstraints(
          maxHeight: mq.height,
        ),
        decoration: boxImageDashboardBgDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: appBaseColor,
                // <-- SEE HERE
                statusBarIconBrightness: Brightness.dark,
                //<-- For Android SEE HERE (dark icons)
                statusBarBrightness:
                    Brightness.light, //<-- For iOS SEE HERE (dark icons)
              ),
              backgroundColor: appBaseColor,
              centerTitle: true,
              title: Container(
                height: 60,
                decoration: kButtonBgDecoration,
                child: TopBarWidget(
                  onTapLeft: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  onTapRight: () {},
                  leftIcon: 'assets/icons/menu.png',
                  rightIcon: 'assets/icons/user.png',
                  title: "Student Photos",
                  rightVisibility: true,
                  leftVisibility: false,
                  bottomTextVisibility: false,
                  subTitle: '',
                  screen: 'home',
                ),
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
                      text: "",
                      style: textStyle(Colors.black, 14, 0, FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Annual Function Photos",
                          style:
                              textStyle(appBaseColor, 18, 0, FontWeight.w500),
                        ),
                        // can add more TextSpans here...
                      ],
                    ),
                  ),
                  20.height,
                  buildCategoriesListWeb2000Container(context, mq),
                  20.height,
                  Linkify(
                    onOpen: (link) async {
                      if (!await launchUrl(Uri.parse(
                          "https://1drv.ms/f/s!AvubYmOtiPPidD4_iDsccWggi98?e=ea6cqQ"))) {
                        throw Exception('Could not launch ${link.url}');
                      }
                    },
                    text: "See More",
                    style: TextStyle(color: appBaseColor),
                    linkStyle: TextStyle(color: Colors.red),
                  ),
                 /* GestureDetector(
                      onTap: () {
                        toast('clicl', false);
                        Uri uri = Uri.parse(
                            "https://1drv.ms/f/s!AvubYmOtiPPidD4_iDsccWggi98?e=ea6cqQ");
                        launchUrl(uri);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Text.rich(
                          textAlign: TextAlign.right,
                          TextSpan(
                            text: "See",
                            style:
                                textStyle(Colors.black, 14, 0, FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: " More...          ",
                                style: textStyle(
                                    appBaseColor, 18, 0, FontWeight.w500),
                              ),
                              // can add more TextSpans here...
                            ],
                          ),
                        ),
                      )),*/
                ],
              ),
            ),
          ],
        ),
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
          itemCount: photos.length,
          itemBuilder: (BuildContext context, int index) {
            return StudentPhotosWidget(
              driveLink: photos[index],
              image: photos[index],
              click: () {},
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
