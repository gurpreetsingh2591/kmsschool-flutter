import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kmschool/bloc/event/student_lesson_event.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/logic_bloc/get_device_bloc.dart';
import '../bloc/logic_bloc/student_lesson_bloc.dart';
import '../bloc/state/common_state.dart';
import '../model/ReminderListResponse.dart';
import '../utils/toast.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/StudentPhotosWidget.dart';
import '../widgets/TopBarWidget.dart';

class SetReminderPage extends StatefulWidget {
  const SetReminderPage({Key? key}) : super(key: key);

  @override
  SetReminderPageState createState() => SetReminderPageState();
}

class SetReminderPageState extends State<SetReminderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isLogin = false;
  final studentLessonBloc = StudentLessonBloc();

  String studentName = "";
  String studentId = "";

  List<bool> selectedItems = List.generate(10, (index) => false);
  List<ReminderList> reminderList = [];

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
    studentLessonBloc.add(const GetReminderListData());
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  getReminderListData(dynamic reminders) {
    reminderList.clear();
    try {
      var remindersResponse = ReminderListResponse.fromJson(reminders);
      dynamic status = remindersResponse.status;
      String message = remindersResponse.message;

      if (status == 200) {
        reminderList.addAll(remindersResponse.result);
      } else {
        toast("Data Not available", false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  callSetReminderApi() {
    String selectedIds = "";
    for (int i = 0; i < reminderList.length; i++) {
      if (selectedItems[i]) {
        if (selectedIds.isNotEmpty) {
          selectedIds += ",";
        }
        selectedIds += reminderList[i].id;
      }
    }
    if (kDebugMode) {
      print("Selected IDs: $selectedIds");
    }

    selectedIds.isNotEmpty
        ? studentLessonBloc
            .add(SetRemindersData(studentId: studentName, days: selectedIds))
        : toast("Please Select minimum one Reminders", false);
  }

  setReminderData(dynamic reminders) {
    reminderList.clear();
    try {
      var remindersResponse = ReminderListResponse.fromJson(reminders);
      dynamic status = remindersResponse.status;
      String message = remindersResponse.message;

      if (status == 200) {
        toast("Your Reminders are set successfully", false);
      } else {
        toast("Something went wrong, Try again", false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
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
              } else if (state is ReminderListState) {
                getReminderListData(state.response);
                return buildHomeContainer(context, mq);
              } else if (state is SetReminderListState) {
                setReminderData(state.response);

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
              onTapRight: () {

              },
              leftIcon: 'assets/icons/menu.png',
              rightIcon: 'assets/icons/user.png',
              title: "Reminder Setting",
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'mfs',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 20,
              top: 82,
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
                        text: "You Can Choose Multiple Reminder",
                        style:
                        textStyle(appBaseColor, 14, 0, FontWeight.w500),
                      ),
                      // can add more TextSpans here...
                    ],
                  ),
                ),
                20.height,
                buildCategoriesListWeb2000Container(context, mq),
                40.height,
                ButtonWidget(
                  margin: 40,
                  name: "Add Reminder".toUpperCase(),
                  icon: "",
                  visibility: false,
                  padding: 0,
                  onTap: () {
                    callSetReminderApi();
                  },
                  size: 12,
                  scale: 2,
                  height: 50,
                  decoration: kSelectedDecoration,
                  textColors: Colors.white,
                  rightVisibility: false,
                  weight: FontWeight.w400,
                  iconColor: Colors.white,
                )
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              decoration: kButtonBgDecoration,
              child:  TopBarWidget(
                onTapLeft: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                onTapRight: () {},
                leftIcon: 'assets/icons/menu.png',
                rightIcon: 'assets/icons/user.png',
                title: "Reminder Setting",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'sr',
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
                          text: "You Can Choose Multiple Reminder",
                          style:
                              textStyle(appBaseColor, 14, 0, FontWeight.w500),
                        ),
                        // can add more TextSpans here...
                      ],
                    ),
                  ),
                  20.height,
                  buildCategoriesListWeb2000Container(context, mq),
                  40.height,
                  ButtonWidget(
                    margin: 40,
                    name: "Add Reminder".toUpperCase(),
                    icon: "",
                    visibility: false,
                    padding: 0,
                    onTap: () {
                      callSetReminderApi();
                    },
                    size: 12,
                    scale: 2,
                    height: 50,
                    decoration: kSelectedDecoration,
                    textColors: Colors.white,
                    rightVisibility: false,
                    weight: FontWeight.w400,
                    iconColor: Colors.white,
                  )
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
          primary: true,
          itemCount: reminderList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: appBaseColor,
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 20),
               // visualDensity:   VisualDensity(horizontal: -4),
                title: Text(
                  reminderList[index].daystext,
                  style: textStyle(Colors.white, 12, 0, FontWeight.normal),
                ),
                leading: InkWell(
                  onTap: () {
                    setState(() {
                      selectedItems[index] = !selectedItems[index];
                    });
                  },
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: selectedItems[index]
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16.0,
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 3 / 1),
        ),
      ],
    );
  }
}
