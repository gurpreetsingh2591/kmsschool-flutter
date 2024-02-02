import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kmschool/bloc/event/student_lesson_event.dart';
import 'package:kmschool/bloc/state/common_state.dart';

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/logic_bloc/student_lesson_bloc.dart';
import '../model/LessonRecordResponse.dart';
import '../model/StudentSubjectResponse.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/StudentLessonRecordWidget.dart';
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
  String studentJournal = "";

/*  List<String> subjectList = [
    "Select Subject",
    "Language Arts",
    "Mathematics",
    "French",
    "punjabi",
    "Sensorial"
  ];*/

  bool isLoading = false;
  bool isLogin = false;
  bool selection = true;

  List<LessonRecord> lessonRecord = [];
  final studentLessonBloc = StudentLessonBloc();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String selectedValue = "All Subjects";
  String subjectId = "";
  String subjectName = "";

  List<StudentSubject> subjectList = [];

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
      studentJournal=lesson.draft[0].description.toString();
      if (kDebugMode) {
        print("status----$status");
      }
      if (status == 200) {
        lessonRecord.addAll(lesson.result);
      }

      if (kDebugMode) {
        print("lessonRecord----$lessonRecord");
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
        final subject = StudentSubject(
            name: "All Subjects", id: 'all');
        subjectList.add(subject);
        subjectList.addAll(bookingResponse.result);
        studentLessonBloc.add(GetLessonRecordData(
            studentId: studentId, subjectId: "all"));
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
    final mq = MediaQuery
        .of(context)
        .size;
    return BlocProvider(
      create: (context) => studentLessonBloc,
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
              title: "Work in Progress",
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'mwt',
            ),
          ),
          Container(
            margin:
            const EdgeInsets.only(bottom: 20, top: 82, left: 16, right: 16),
            child: ListView(
              shrinkWrap: true,
              primary: true,
              children: [
                Text("Select a subject below to view the progress.",style: textStyle(Colors.black, 14, 0, FontWeight.w400),),
                10.height,
                selectSubjectDropDown(),
                20.height,
                lessonRecord.isNotEmpty
                    ?buildLessonListContainer():SizedBox()
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
    );
  }

  Widget buildHomeContainer(BuildContext context, Size mq) {
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: boxImageDashboardBgDecoration(),
        child: Column(
            mainAxisSize: MainAxisSize.max,
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
                  title: "Work in Progress",
                  rightVisibility: false,
                  leftVisibility: true,
                  bottomTextVisibility: false,
                  subTitle: '',
                  screen: 'mwt',
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 40, top: 22, left: 16, right: 16),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      Text("Select a subject below to view the progress.",style: textStyle(Colors.black, 14, 0, FontWeight.w400),),
                      10.height,
                      selectSubjectDropDown(),
                      20.height,
                      lessonRecord.isNotEmpty
                          ? buildLessonListContainer()
                          : Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 50),
                        child: Text(
                          kData,
                          style: textStyle(
                              Colors.black54, 18, 0, FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 50,
                          decoration: kInnerDecoration,
                          alignment: Alignment.bottomCenter,
                          child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("Student Journal:$studentJournal",style: textStyle(Colors.white, 16, 0,FontWeight.normal),)
                              ]),
                        ),
                      ]),
                ),


            ]));
  }

  Widget selectSubjectDropDown() {
    return Container(
      height: 50,
      decoration: kEditTextDecoration,
      child: DropdownButton<String>(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        value: selectedValue,
        isExpanded: true,
        dropdownColor: Colors.white,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;

            for (int i = 0; i < subjectList.length; i++) {
              if (selectedValue.toLowerCase() ==
                  subjectList[i].name.toLowerCase()) {
                subjectId = subjectList[i].id;
                subjectName=subjectList[i].name;
                if (kDebugMode) {
                  print("subjectId--$subjectId");
                }
              }
            }
            if (kDebugMode) {
              print("subjectId--$subjectId");
            }
            studentLessonBloc.add(GetLessonRecordData(
                studentId: studentId, subjectId: subjectId));
          });
        },
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        // Ensure this line is included

        items: subjectList.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Text(
              item.name,
              style: textStyle(Colors.black, 14, 0, FontWeight.w400),
            ),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }

  Widget buildLessonListContainer() {
    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: kMessageItemDecoration,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(

                  padding: const EdgeInsets.all(10),
                  decoration: kMessageItemDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child:  Text(
                              "Primary Subject",
                              textAlign: TextAlign.center,
                              style: textStyle(
                                  Colors.black, 15, 0, FontWeight.w500),
                            ),
                          ),

                      ),
                      5.width,
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child:  Text(
                              "Lesson Title",
                              textAlign: TextAlign.center,
                              style: textStyle(
                                  Colors.black, 15, 0, FontWeight.w500),
                            ),

                        ),
                      ),
                      5.width,
                  Visibility(
                    visible: false,
                    child:  Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "PL",
                            style: textStyle(
                                Colors.black87, 14, 0, FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),),
                      5.width,
                  Visibility(
                    visible: false,
                    child:  Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "PR",
                            style: textStyle(
                                Colors.black87, 14, 0, FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),),
                      5.width,
                     Visibility(
                       visible: false,
                       child:  Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Status",
                            style: textStyle(
                                Colors.black87, 14, 0, FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),),
                    ],
                  )),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: lessonRecord.length,
                itemBuilder: (context, index) {
                  return StudentLessonRecordWidget(
                    lessonPlanId: lessonRecord[index].lessonPlanId ?? "",
                    classId: lessonRecord[index].classId ?? "",
                    lessonName: lessonRecord[index].lessonName ?? "",
                    statusEd: lessonRecord[index].statusEd ?? "0",
                    statusPg: lessonRecord[index].statusPg ?? "0",
                    statusPi: lessonRecord[index].statusPi ?? "0",
                    lessonPlaned: lessonRecord[index].lessonPlaned ?? "0",
                    lessonPresented: lessonRecord[index].lessonPresented ?? "0", primarySubject: lessonRecord[index].primarySubject??subjectName,
                  );
                },
              )
            ]));
  }
}
