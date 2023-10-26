import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/bloc/event/get_snack_menu_event.dart';
import 'package:kmschool/bloc/state/common_state.dart';

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/AppLocalizations.dart';
import '../app/router.dart';
import '../bloc/logic_bloc/get_device_bloc.dart';
import '../bloc/logic_bloc/snack_menu_bloc.dart';
import '../bloc/state/get_device_state.dart';
import '../bloc/event/get_device_event.dart';
import '../model/DeviceResponse.dart';

import '../model/LunchMenuResponse.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/CommonNoteTextField.dart';
import '../widgets/CommonTextField.dart';
import '../widgets/DashboardtemWidget.dart';
import '../widgets/MenuItemWidget.dart';
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

class SnackMenuPage extends StatefulWidget {
  const SnackMenuPage({Key? key}) : super(key: key);

  @override
  SnackMenuPageState createState() => SnackMenuPageState();
}

class SnackMenuPageState extends State<SnackMenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isLogin = false;
  bool selection = true;
  List<Device> devices = [];
  List<Alert> alerts = [];
  List<String> monday = [];
  List<String> tuesday = [];
  List<String> wednesday = [];
  List<String> thursday = [];
  List<String> friday = [];

  final snackMenuBloc = SnackMenuBloc();
  String todayMeal = "";
  // late LunchMenuResponse lunchMenu;

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });

    snackMenuBloc
        .add(GetSnackData(studentId: SharedPrefs().getStudentId().toString()));
  }

  setData(dynamic response) {

    if (response['todaysmeal'] == null) {
     todayMeal ="Today school is OFF";
    } else {
      todayMeal=response['todaysmeal'];
    }


    monday.add(response['result']['Week1'][0]['lunchmenu']);
    monday.add(response['result']['Week2'][0]['lunchmenu']);
    monday.add(response['result']['Week3'][0]['lunchmenu']);
    monday.add(response['result']['Week4'][0]['lunchmenu']);
    tuesday.add(response['result']['Week1'][1]['lunchmenu']);
    tuesday.add(response['result']['Week2'][1]['lunchmenu']);
    tuesday.add(response['result']['Week3'][1]['lunchmenu']);
    tuesday.add(response['result']['Week4'][1]['lunchmenu']);

    wednesday.add(response['result']['Week1'][2]['lunchmenu']);
    wednesday.add(response['result']['Week2'][2]['lunchmenu']);
    wednesday.add(response['result']['Week3'][2]['lunchmenu']);
    wednesday.add(response['result']['Week4'][2]['lunchmenu']);

    thursday.add(response['result']['Week1'][3]['lunchmenu']);
    thursday.add(response['result']['Week2'][3]['lunchmenu']);
    thursday.add(response['result']['Week3'][3]['lunchmenu']);
    thursday.add(response['result']['Week4'][3]['lunchmenu']);

    friday.add(response['result']['Week1'][4]['lunchmenu']);
    friday.add(response['result']['Week2'][4]['lunchmenu']);
    friday.add(response['result']['Week3'][4]['lunchmenu']);
    friday.add(response['result']['Week4'][4]['lunchmenu']);

    /* if (lunchMenu.result!.week1 != null) {
      final mondayMenu = lunchMenu.result!.week1?['Week1']
          ?.firstWhere((item) => item.dayame == "Monday");
      if (mondayMenu != null) {
        setState(() {
          monday.add(mondayMenu.lunchmenu!);
          if (kDebugMode) {
            print("monday$monday");
          }
        });
      }
    }*/
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => snackMenuBloc,
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
          child: BlocBuilder<SnackMenuBloc, CommonState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return loaderBar(context, mq);
              } else if (state is SuccessState) {
                //lunchMenu = LunchMenuResponse.fromJson(state.response);
                setData(state.response);
                if (kDebugMode) {
                  print(state.response);
                }
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
    return  SafeArea(
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
                title: "Snack Menu",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'lm',
              ),
            ),

            Container(
              height: 500,
              margin: const EdgeInsets.only(bottom: 20, top: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  devices.isEmpty
                      ? const Center(
                      child: SpinKitFadingCircle(
                        color: kLightGray,
                        size: 80.0,
                      ))
                      : const SizedBox(),
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
              child: AppBar(
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
                title: TopBarWidget(
                onTapLeft: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                onTapRight: () {

                },
                leftIcon: 'assets/icons/menu.png',
                rightIcon: 'assets/icons/user.png',
                title: "Lunch Menu",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'lm',
              ),
            ),),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    bottom: 20, top: 22, left: 16, right: 16),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.black12,
                      child: Text.rich(
                        textAlign: TextAlign.left,
                        TextSpan(
                          text: "Today's Meal:  ",
                          style:
                          textStyle(Colors.black, 14, 0, FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                              text:todayMeal,
                              style: textStyle(
                                  Colors.black54, 14, 0, FontWeight.w500),
                            ),
                            // can add more TextSpans here...
                          ],
                        ),
                      ),
                    ),
                    20.height,

                    monday.isNotEmpty
                        ? buildLunchMenuContainer()
                        : const SizedBox()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLunchMenuContainer() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              List<dynamic> week = ["1", "2", "3", "4"];

              return MenuItemWidget(
                monday: monday,
                tuesday: tuesday,
                wednesday: wednesday,
                thursday: thursday,
                friday: friday,
                week: week,
                pos: index,
              );
            },
          )
        ]);
  }
}
