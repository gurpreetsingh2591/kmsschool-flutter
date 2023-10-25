import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kmschool/bloc/event/student_lesson_event.dart';
import 'package:kmschool/bloc/state/common_state.dart';

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/logic_bloc/student_lesson_bloc.dart';
import '../model/BookedMeetingResponse.dart';
import '../model/CommonResponse.dart';
import '../model/LessonRecordResponse.dart';
import '../model/StudentSubjectResponse.dart';
import '../widgets/BookingItemWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';

class LessonProgressPage extends StatefulWidget {
  const LessonProgressPage({Key? key}) : super(key: key);

  @override
  LessonProgressPageState createState() => LessonProgressPageState();
}

class LessonProgressPageState extends State<LessonProgressPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String studentId = "";
  String parentId = "";
  List<String> subjectList = [
    "Select Subject",
    "Language Arts",
    "Mathematics",
    "French",
    "punjabi",
    "Sensorial"
  ];

  bool isLoading = false;
  bool isLogin = false;
  bool selection = true;

  //List<BookingSlots> subjectList = [];
  List<LessonRecord> lessonRecord = [];

  // String selectedValue = "Select Subject";
  final studentLessonBloc = StudentLessonBloc();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String selectedValue = "Select Subject";

/*  List<String> items = [
    "Select Subject",
    "Language Arts",
    "Mathematics",
    "French",
    "punjabi",
    "Sensorial"
  ];*/

  List<StudentSubject> items = [];

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });
    studentId = SharedPrefs().getStudentId().toString();
    parentId = SharedPrefs().getParentId().toString();

    if (kDebugMode) {
      print(studentId);
      print(parentId);
    }

    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    studentLessonBloc.add(GetSubjectData(studentId: studentId, classId: '1'));

    // String selectedValue = bookingSlots[0].slot;
  }

  setLessonRecordData(dynamic lessonRecordData) {
    lessonRecord.clear();
    try {
      var lesson = LessonRecordResponse.fromJson(lessonRecordData);
      int status = lesson.status;
      String message = lesson.message;
      if (status == 200) {
        lessonRecord.addAll(lesson.result);
      }

      if (kDebugMode) {
        print(lessonRecord);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  setSubjectData(dynamic subjectData) {
    try {
      var bookingResponse = StudentSubjectResponse.fromJson(subjectData);
      dynamic status = bookingResponse.status;
      String message = bookingResponse.message;

      if (status == 200) {
        studentLessonBloc.add(GetLessonRecordData(
            studentId: studentId, subjectId: bookingResponse.result[0].id));
        final subject = StudentSubject(name: "Select Subject", id: '0');
        items.add(subject);
        items.addAll(bookingResponse.result);
      } else {
        toast("Subject Not available", false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
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
                setSubjectData(state.response);
                return buildHomeContainer(context, mq);
              } else if (state is UserDataSuccessState) {
                setLessonRecordData(state.response);
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
    return SafeArea(
      child: Container(
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
                title: "Lesson Progress",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'mwt',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  bottom: 20, top: 80, left: 16, right: 16),
              child: ListView(
                shrinkWrap: true,
                primary: true,
                children: [
                  selectSubjectDropDown(),
                  20.height,
                  buildBookingHistoryContainer()
                ],
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
                title: "Lesson Progress",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'mwt',
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    bottom: 20, top: 22, left: 16, right: 16),
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  children: [
                    selectSubjectDropDown(),
                    20.height,
                    buildBookingHistoryContainer()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget selectSubjectDropDown() {
    return Container(
        decoration: kEditTextDecoration,
        child: DropdownButton<String>(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          value: selectedValue,
          isExpanded: true,
          dropdownColor: Colors.white,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item.name,
              child: Text(
                item.name,
                style: textStyle(Colors.black, 14, 0, FontWeight.w400),
              ),
            );
          }).toList(),
          underline: Container(),
        ));
  }

  Widget buildBookingHistoryContainer() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: lessonRecord.length,
            itemBuilder: (context, index) {
              return BookingItemWidget(
                date: lessonRecord[index].lessoname,
                time: lessonRecord[index].lessonstatus,
              );
            },
          )
        ]);
  }
}
