import 'dart:async';
import 'dart:convert';
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
import '../model/CommonResponse.dart';
import '../model/ReminderListResponse.dart';
import '../model/ReminderResponse.dart';
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
  int isLoad = 0;
  bool isLogin = false;
  final studentLessonBloc = StudentLessonBloc();

  String studentName = "";
  String studentId = "";

  List<bool> selectedItems = List.generate(5, (index) => false);
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
        if (remindersResponse.result.isNotEmpty) {
          reminderList.addAll(remindersResponse.result);
          studentLessonBloc.add(
              SetAlreadyRemindersData(studentId: studentId, days: "getbyid"));
        }
      } else {
        toast("Data Not available", false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  List<ReminderResponse> parseReminderResponse(dynamic responseBody) {
    final parsed = (responseBody as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map<ReminderResponse>((json) => ReminderResponse.fromJson(json))
        .toList();

    return parsed;
  }

  setReminderListData(dynamic reminders) {
    // Parse the response
    List<ReminderResponse> reminderResponses =
        parseReminderResponse(reminders['result']);

    // Update the UI with the selected days

    // Iterate through the response data and update the selectedItems list
    for (var response in reminderResponses) {
      List<String> selectedDays = [];
      if (response.days.isNotEmpty) {
        selectedDays = response.days.split(',');
      }

      for (int i = 0; i < reminderList.length; i++) {
        if (reminderList.isNotEmpty) {
          if (selectedDays.contains(reminderList[i].days)) {
            selectedItems[i] = true;
            callSetReminderApi();

            if (kDebugMode) {
              print("selectedItems[i]---$i--${selectedItems[i]}");
            }
          }
        }
      } /*for (int i = 0; i < reminderList.length; i++) {
        for (int j = 0; j < selectedDays.length; j++) {
          if (selectedDays[j] == reminderList[i].days) {
            selectedItems[i] = true;
          }
        }
      }*/
    }
  }

  callSetReminderApi() {
    // Create a list to store selected days
    List<String> selectedDays = [];

    for (int i = 0; i < reminderList.length; i++) {
      if (selectedItems[i]) {
        selectedDays.add(reminderList[i].days);
      }
    }

    // Join the selected days into a comma-separated string
    String selectedDaysString = selectedDays.join(',');

    if (kDebugMode) {
      print("Selected Days: $selectedDaysString");
    }

    // Check if any days are selected before making the API call
    if (selectedDays.isNotEmpty) {
      // Call the API with the selected days
      studentLessonBloc.add(
          SetRemindersData(studentId: studentId, days: selectedDaysString));
      toast("Your Reminders are set successfully", false);

    } else {
      toast("Please select at least one reminder", false);
    }
  }

/*
  callSetReminderApi() {
    String selectedIds = "";
    for (int i = 0; i < reminderList.length; i++) {
      if (selectedItems[i]) {
        if (selectedIds.isNotEmpty) {
          selectedIds += ",";
        }
        selectedIds += reminderList[i].days;
      }
    }
    if (kDebugMode) {
      print("Selected IDs: $selectedIds");
    }

    selectedIds.isNotEmpty
        ? studentLessonBloc
            .add(SetRemindersData(studentId: studentId, days: selectedIds))
        : toast("Please Select minimum one Reminders", false);
  }
*/

  setReminderData(dynamic reminders) {
    try {
      var remindersResponse = CommonResponse.fromJson(reminders);
      dynamic status = remindersResponse.status;
      String message = remindersResponse.message;

      if (status == 200) {
        if (isLoad > 0) {
          if(isLoading){
          //  toast("Your Reminders are set successfully", false);
            isLoading=false;
          }

        }
        isLoad++;
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
                return buildHomeContainer(context, mq, true);
              } else if (state is ReminderListState) {
                getReminderListData(state.response);
                return buildHomeContainer(context, mq, false);
              } else if (state is AlreadySetReminderListState) {
                if (kDebugMode) {
                  print("object${state.response}");
                }
                setReminderListData(state.response);

                return buildHomeContainer(context, mq, false);
              } else if (state is SetReminderListState) {
                setReminderData(state.response);

                return buildHomeContainer(context, mq, false);
              } else if (state is FailureState) {
                return Center(
                  child: Text('Error: ${state.error}'),
                );
              }
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 757) {
                    return buildHomeContainer(context, mq, false);
                  } else {
                    return buildHomeContainer(context, mq, false);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildHomeContainer(BuildContext context, Size mq, bool isLoading) {
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
              title: "Settings",
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'sr',
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(bottom: 20, top: 82, left: 16, right: 16),
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
                        text:
                            "Select the event reminder options for the days before you want to receive",
                        style: textStyle(appBaseColor, 14, 0, FontWeight.w500),
                      ),
                      // can add more TextSpans here...
                    ],
                  ),
                ),
                20.height,
                buildCategoriesListContainer(context, mq),
                40.height,
                ButtonWidget(
                  margin: 40,
                  name: "Save".toUpperCase(),
                  icon: "",
                  visibility: false,
                  padding: 0,
                  onTap: () {
                    isLoading=true;
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
          Visibility(
            visible: isLoading,
            child: Container(
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
          )
        ],
      ),
    );
  }

  Widget buildCategoriesListContainer(BuildContext context, Size mq) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          primary: true,
          itemCount: reminderList.isNotEmpty ? reminderList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: appBaseColor,
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 20),
                // visualDensity:   VisualDensity(horizontal: -4),
                title: Text(
                  reminderList.isNotEmpty
                      ? reminderList[index].daystext
                      : "Data not found",
                  style: textStyle(Colors.white, 12, 0, FontWeight.normal),
                ),
                leading: InkWell(
                  onTap: () {
                    setState(() {
                      if (kDebugMode) {
                        print("index--$index");
                        print("selectedItems--${selectedItems[index]}");
                      }

                      if (selectedItems[index] == true) {
                        if (kDebugMode) {
                          print(selectedItems[index]);
                        }
                        selectedItems[index] = false;
                      } else {
                        if (kDebugMode) {
                          print(selectedItems[index]);
                        }
                        // toast("index2--$index", true);
                        selectedItems[index] = true;
                        //  toast("message2--${selectedItems[index]}", false);
                      }
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
