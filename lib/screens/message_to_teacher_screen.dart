import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/bloc/event/send_message_event.dart';

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/AppLocalizations.dart';
import '../app/router.dart';
import '../bloc/logic_bloc/get_device_bloc.dart';
import '../bloc/logic_bloc/send_message_bloc.dart';
import '../bloc/state/common_state.dart';
import '../bloc/state/get_device_state.dart';
import '../bloc/event/get_device_event.dart';
import '../model/DeviceResponse.dart';

import '../model/SchoolMessageResponse.dart';
import '../utils/toast.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/CommonNoteTextField.dart';
import '../widgets/CommonTextField.dart';
import '../widgets/DashboardtemWidget.dart';
import '../widgets/MessageItemWidget.dart';
import '../widgets/SelectionWidget.dart';
import 'controller/LanguageProvider.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MessageToTeacherPage extends StatefulWidget {
  const MessageToTeacherPage({Key? key}) : super(key: key);

  @override
  MessageToTeacherPageState createState() => MessageToTeacherPageState();
}

class MessageToTeacherPageState extends State<MessageToTeacherPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _subjectText = TextEditingController();
  final _descriptionText = TextEditingController();
  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  bool isLoading = false;
  bool isLogin = false;
  bool selection = true;
  List<SchoolMessages> teacherMessagesList = [];
  final sendMessageBloc = SendMessageBloc();

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });

    sendMessageBloc.add(GetTeacherSentMessages(
        studentId: SharedPrefs().getStudentId().toString()));
  }

  setData(dynamic messages) {
    teacherMessagesList.clear();
    try {
      var messagesResponse = SchoolMessagesResponse.fromJson(messages);
      int status = messagesResponse.status;
      String message = messagesResponse.message;
      if (status == 200) {
        teacherMessagesList.addAll(messagesResponse.result);
      }

      if (kDebugMode) {
        print(teacherMessagesList);
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
  void sendMessageFun(String sub, String message) {
    //  bool validPassword = isValidPassword(context, password);
    if (sub.isEmpty) {
      toast("Please enter subject", false);
    } else if (message.isEmpty) {
      toast("Please enter message", false);
    } else {
      sendMessageBloc.add(SendToTeacherButtonPressed(
          studentId: SharedPrefs().getStudentId().toString(),
          subject: sub,
          message: message));
    }
  }
  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => sendMessageBloc,
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
          child: BlocBuilder<SendMessageBloc, CommonState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return loaderBar(context, mq);
              } else if (state is TeacherSendSuccessState) {
                try {
                  sendMessageBloc.add(GetTeacherSentMessages(
                      studentId: SharedPrefs().getStudentId().toString()));
                  _subjectText.text = "";
                  _descriptionText.text = "";
                  toast("Message has been Sent", true);
                }catch(e){
                  if (kDebugMode) {
                    print(e);
                  }
                }
                return buildHomeContainer(context, mq);
              } else if (state is TeacherSentListDataSuccessState) {
                setData(state.response);
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
                onTapRight: () {

                },
                leftIcon: 'assets/icons/menu.png',
                rightIcon: 'assets/icons/user.png',
                title: "Message to Teacher",
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
                    bottom: 20, top: 82, left: 16, right: 16),
                child: ListView(
                  shrinkWrap: true,
                  primary: true,
                  children: [
                    buildSelectionTab(),
                    40.height,
                    buildComposeMessageContainer()
                  ],
                ),
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
                onTapRight: () {
                },
                leftIcon: 'assets/icons/menu.png',
                rightIcon: 'assets/icons/user.png',
                title: "Message to Teacher",
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
                        ? buildComposeMessageContainer()
                        : buildMessageListContainer()
                  ],
                ),
              ),
            )
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
        });
      },
      clickOnRight: () {
        setState(() {
          selection = false;
        });
      },
      selection: selection,
      leftName: "Compose Message",
      rightName: "Sent Message",
    );
  }

  Widget buildComposeMessageContainer() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonTextField(
            controller: _subjectText,
            hintText: "Subject",
            text: "",
            isFocused: false,
            textColor: Colors.black87,
            focus: _subjectFocus,
            textSize: 16,
            weight: FontWeight.w400,
            hintColor: Colors.black26,
            error: false,
            wrongError: false,
            decoration: kEditTextDecoration,
            padding: 16,
          ),
          20.height,
          CommonNoteTextField(
              controller: _descriptionText,
              hintText: "Message",
              text: "",
              isFocused: false,
              textColor: Colors.black87,
              focus: _descriptionFocus,
              textSize: 16,
              weight: FontWeight.w400,
              hintColor: Colors.black26,
              error: false,
              wrongError: false,
              decoration: kEditTextDecoration,
              padding: 16),
          40.height,
          ButtonWidget(
            margin: 0,
            name: "Send".toUpperCase(),
            icon: "",
            visibility: false,
            padding: 0,
            onTap: () {

              sendMessageFun(_subjectText.text.toString().trim(),
                  _descriptionText.text.trim().toString());
            },
            size: 12,
            scale: 2,
            height: 50,
            decoration: kSelectedDecoration,
            textColors: Colors.white,
            rightVisibility: false,
            weight: FontWeight.w400,
            iconColor: Colors.white,
          ),
        ]);
  }

  Widget buildMessageListContainer() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          teacherMessagesList.isNotEmpty?ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: teacherMessagesList.length,
            itemBuilder: (context, index) {
              return MessageItemWidget(
                subject: "Subject: ${teacherMessagesList[index].vchsubject}",
                description: teacherMessagesList[index].txtmessage,
                date: teacherMessagesList[index].currtime,
              );
            },
          ):Container(
            margin: const EdgeInsets.only(top: 50),
            child: Text(
              kData,
              style: textStyle(Colors.black54, 18, 0, FontWeight.w400),
            ),
          ),
        ]);
  }
}
