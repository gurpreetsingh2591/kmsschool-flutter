import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kmschool/bloc/event/student_lesson_event.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/logic_bloc/student_lesson_bloc.dart';
import '../bloc/state/common_state.dart';
import '../widgets/ColoredSafeArea.dart';
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
  final studentLessonBloc = StudentLessonBloc();
  List<String> studentPhotos = [];
  String studentName = "";
  String studentId = "";
  String driveLink = "";

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });

    setState(() {
      studentName = SharedPrefs().getUserFullName().toString();
      studentId = SharedPrefs().getStudentId().toString();
    });
    studentLessonBloc.add(GetStudentPhotosData(studentId: studentId));
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  getStudentPhotos(dynamic data) {

    try {
      studentPhotos = (data['photos'] as List).cast<String>();
      driveLink = data['students_data'][0]['onedrivelink'];

      if (kDebugMode) {
        print(studentPhotos);
        print(driveLink);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error:$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => studentLessonBloc,
      child: Scaffold(
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
          child: BlocBuilder<StudentLessonBloc, CommonState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return loaderBar(context, mq);
              } else if (state is SuccessState) {
                return buildHomeContainer(context, mq);
              } else if (state is GetStudentPhotosState) {

                getStudentPhotos(state.response);
                return buildHomeContainer(context, mq);
              } else if (state is FailureState) {
                return buildHomeContainer(context, mq);
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
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'mwt',
            ),
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
    );
  }

  Widget buildHomeContainer(BuildContext context, Size mq) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: mq.height,
      ),
      decoration: boxImageDashboardBgDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
              rightVisibility: false,
              leftVisibility: true,
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
                    text: "",
                    style: textStyle(Colors.black, 14, 0, FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Photos",
                        style: textStyle(appBaseColor, 18, 0, FontWeight.w500),
                      ),
                      // can add more TextSpans here...
                    ],
                  ),
                ),
                20.height,
                buildCategoriesListWeb2000Container(context, mq),
                20.height,
                GestureDetector(
                    onTap: () async {
                      Uri uri = Uri.parse(
                          "https://1drv.ms/f/s!AvubYmOtiPPidD4_iDsccWggi98?e=ea6cqQ");
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.platformDefault);
                      } else {
                        throw 'Could not launch $uri';
                      }
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
                    )),
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
          itemCount: studentPhotos.length,
          itemBuilder: (BuildContext context, int index) {
            return StudentPhotosWidget(
              driveLink: driveLink,
              image: studentPhotos[index],
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
