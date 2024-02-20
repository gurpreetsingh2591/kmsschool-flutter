import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kmschool/bloc/event/get_messages_event.dart';
import 'package:kmschool/bloc/state/common_state.dart';
import 'package:kmschool/model/TeacherMessageResponse.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/logic_bloc/messages_bloc.dart';
import '../model/SchoolMessageResponse.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/MessageItemWidget.dart';
import '../widgets/SelectionWidget.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';

class MessageFromSchoolPage extends StatefulWidget {
  const MessageFromSchoolPage({Key? key}) : super(key: key);

  @override
  MessageFromSchoolPageState createState() => MessageFromSchoolPageState();
}

class MessageFromSchoolPageState extends State<MessageFromSchoolPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  bool isLogin = false;
  bool selection = true;
  List<SchoolMessages> schoolMessages = [];
  List<TeacherMessages> teacherMessages = [];

  final messagesBloc = MessagesBloc();

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });

    messagesBloc.add(GetTeacherMessageData(
        studentId: SharedPrefs().getStudentId().toString()));

    messagesBloc.add(GetSchoolMessageData(
        studentId: SharedPrefs().getStudentId().toString()));
  }

  setSchoolData(dynamic messages) {
    try {
      var messagesResponse = SchoolMessagesResponse.fromJson(messages);
      int status = messagesResponse.status;
      String message = messagesResponse.message;
      if (status == 200) {
        setState(() {
          //schoolMessages.clear();
          schoolMessages.addAll(messagesResponse.result);
        });
      }

      if (kDebugMode) {
        print(schoolMessages);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  setTeacherData(dynamic messages) {
    try {
      var messagesResponse = TeacherMessagesResponse.fromJson(messages);
      int status = messagesResponse.status;
      String message = messagesResponse.message;

      if (kDebugMode) {
        print("messages$messagesResponse");
      }
      if (status == 200) {
        teacherMessages.clear();

        setState(() {
          teacherMessages.addAll(messagesResponse.result);
        });
      }

      if (kDebugMode) {
        print(teacherMessages);
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
      create: (context) => messagesBloc,
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
          child: BlocBuilder<MessagesBloc, CommonState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return buildHomeContainer(context, mq, isLoading);
              } else if (state is SuccessState) {
                // toast("school data get", false);
                setSchoolData(state.response);

                return buildHomeContainer(context, mq, false);
              } else if (state is UserDataSuccessState) {
                // toast("teacher data get", false);
                setTeacherData(state.response);

                return buildHomeContainer(context, mq, false);
              } else if (state is FailureState) {
                return buildHomeContainer(context, mq, false);
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
                title: "Message From School",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'mfs',
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
                    buildSelectionTab(),
                    40.height,
                    selection
                        ? buildSchoolMessageContainer()
                        : buildTeacherMessageContainer()
                  ],
                ),
              ),
            ),
            Visibility(
                visible: isLoading,
                child: Container(
                  height: 500,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      schoolMessages.isEmpty
                          ? const Center(
                              child: SpinKitFadingCircle(
                              color: kLightGray,
                              size: 80.0,
                            ))
                          : const SizedBox(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildSelectionTab() {
    return SelectionWidget(
      clickOnLeft: () {
        setState(() {
          selection = true;
          isLoading = true;
          messagesBloc.add(GetSchoolMessageData(
              studentId: SharedPrefs().getStudentId().toString()));
        });
      },
      clickOnRight: () {
        setState(() {
          selection = false;
          isLoading = true;
          messagesBloc.add(GetTeacherMessageData(
              studentId: SharedPrefs().getStudentId().toString()));
        });
      },
      selection: selection,
      leftName: "School's Messages",
      rightName: "Teacher's Messages",
    );
  }

  Widget buildTeacherMessageContainer() {
    print(teacherMessages.length);
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          teacherMessages.isNotEmpty
              ? ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: teacherMessages.length,
                  itemBuilder: (context, index) {
                    return MessageItemWidget(
                      subject: "Subject: ",
                      description: teacherMessages[index].txtmessage,
                      date: teacherMessages[index].currtime,
                    );
                  },
                )
              : Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Text(
                    kData,
                    style: textStyle(Colors.black54, 18, 0, FontWeight.w400),
                  ),
                ),
        ]);
  }

  Widget buildSchoolMessageContainer() {
    if (kDebugMode) {
      print(schoolMessages.length);
    }
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          schoolMessages.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Text(
                    kData,
                    style: textStyle(Colors.black54, 18, 0, FontWeight.w400),
                  ),
                )
              : ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: schoolMessages.length,
                  itemBuilder: (context, index) {
                    return MessageItemWidget(
                      subject: "Subject: ${schoolMessages[index].vchsubject}",
                      description: schoolMessages[index].txtmessage,
                      date: schoolMessages[index].currtime,
                    );
                  },
                ),
        ]);
  }
}
