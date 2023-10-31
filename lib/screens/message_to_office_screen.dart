import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/bloc/event/send_message_event.dart';
import 'package:kmschool/bloc/state/common_state.dart';

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:kmschool/widgets/CommonNoteTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/router.dart';
import '../bloc/logic_bloc/get_device_bloc.dart';
import '../bloc/logic_bloc/send_message_bloc.dart';
import '../bloc/state/get_device_state.dart';
import '../model/DeviceResponse.dart';

import '../model/SchoolMessageResponse.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/CommonTextField.dart';
import '../widgets/MessageItemWidget.dart';
import '../widgets/SelectionWidget.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';

class MessageToOfficePage extends StatefulWidget {
  const MessageToOfficePage({Key? key}) : super(key: key);

  @override
  MessageToOfficePageState createState() => MessageToOfficePageState();
}

class MessageToOfficePageState extends State<MessageToOfficePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _subjectText = TextEditingController();
  final _descriptionText = TextEditingController();
  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  bool isLoading = false;
  bool isLogin = false;
  bool selection = true;
  List<SchoolMessages> officeMessagesList = [];

  final sendMessageBloc = SendMessageBloc();

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });
    sendMessageBloc.add(GetOfficeSentMessages(
        studentId: SharedPrefs().getStudentId().toString()));
  }

  getData() {}

  void sendMessageFun(String sub, String message) {
    //  bool validPassword = isValidPassword(context, password);
    if (sub.isEmpty) {
      toast("Please enter subject", false);
    } else if (message.isEmpty) {
      toast("Please enter message", false);
    } else {
      sendMessageBloc.add(SendToOfficeButtonPressed(
          studentId: SharedPrefs().getStudentId().toString(),
          subject: sub,
          message: message));
    }
  }

  setData(dynamic messages) {
    officeMessagesList.clear();
    try {
      var messagesResponse = SchoolMessagesResponse.fromJson(messages);
      int status = messagesResponse.status;
      String message = messagesResponse.message;
      if (status == 200) {
        officeMessagesList.addAll(messagesResponse.result);
      }

      if (kDebugMode) {
        print(officeMessagesList);
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
              } else if (state is SuccessState) {
                try {
                  sendMessageBloc.add(GetOfficeSentMessages(
                      studentId: SharedPrefs().getStudentId().toString()));
                  _subjectText.text = "";
                  _descriptionText.text = "";
                  toast("Message Sent", true);
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
                return buildHomeContainer(context, mq);
              } else if (state is UserDataSuccessState) {
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
    return  Container(
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
                title: "Message To Office",
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
                },
                leftIcon: 'assets/icons/menu.png',
                rightIcon: 'assets/icons/user.png',
                title: "Message To Office",
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
                  primary: false,
                  children: [
                    buildSelectionTab(),
                    30.height,
                    selection
                        ? buildComposeMessageContainer()
                        : buildMessageListContainer()
                    //  buildMessageContainer()
                  ],
                ),
              ),
            )
          ],
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
        mainAxisSize: MainAxisSize.min,
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
          officeMessagesList.isNotEmpty
              ? ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: officeMessagesList.length,
                  itemBuilder: (context, index) {
                    return MessageItemWidget(
                      subject:
                          "Subject: ${officeMessagesList[index].vchsubject}",
                      description: officeMessagesList[index].txtmessage,
                      date: officeMessagesList[index].currtime,
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
}
