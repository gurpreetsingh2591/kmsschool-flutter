import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/router.dart';
import '../bloc/event/get_snack_menu_event.dart';
import '../bloc/logic_bloc/snack_menu_bloc.dart';
import '../bloc/state/common_state.dart';
import '../model/DeviceResponse.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/MenuItemWidget.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';


class LunchMenuPage extends StatefulWidget {
  const LunchMenuPage({Key? key}) : super(key: key);

  @override
  LunchMenuPageState createState() => LunchMenuPageState();
}

class LunchMenuPageState extends State<LunchMenuPage> {
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

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
    });

    snackMenuBloc
        .add(GetLunchData(studentId: SharedPrefs().getStudentId().toString()));
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  setData(dynamic response) {

    if (response['todaysmeal'] == null) {
      todayMeal ="Today school is OFF";
    } else {
      todayMeal="${"( "+response['currentweek']} ): "+response['todaysmeal'];

    }

    monday.add(response['result']['Week1'][0]['lunchmenu']);
    monday.add(response['result']['Week2'][0]['lunchmenu']);
    monday.add(response['result']['Week3'][0]['lunchmenu']);
    monday.add(response['result']['Week4'][0]['lunchmenu']);
    monday.add(response['result']['Week5'][0]['lunchmenu']);


    tuesday.add(response['result']['Week1'][1]['lunchmenu']);
    tuesday.add(response['result']['Week2'][1]['lunchmenu']);
    tuesday.add(response['result']['Week3'][1]['lunchmenu']);
    tuesday.add(response['result']['Week4'][1]['lunchmenu']);
    tuesday.add(response['result']['Week5'][1]['lunchmenu']);

    wednesday.add(response['result']['Week1'][2]['lunchmenu']);
    wednesday.add(response['result']['Week2'][2]['lunchmenu']);
    wednesday.add(response['result']['Week3'][2]['lunchmenu']);
    wednesday.add(response['result']['Week4'][2]['lunchmenu']);
    wednesday.add(response['result']['Week5'][2]['lunchmenu']);

    thursday.add(response['result']['Week1'][3]['lunchmenu']);
    thursday.add(response['result']['Week2'][3]['lunchmenu']);
    thursday.add(response['result']['Week3'][3]['lunchmenu']);
    thursday.add(response['result']['Week4'][3]['lunchmenu']);
    thursday.add(response['result']['Week5'][3]['lunchmenu']);

    friday.add(response['result']['Week1'][4]['lunchmenu']);
    friday.add(response['result']['Week2'][4]['lunchmenu']);
    friday.add(response['result']['Week3'][4]['lunchmenu']);
    friday.add(response['result']['Week4'][4]['lunchmenu']);
    friday.add(response['result']['Week5'][4]['lunchmenu']);
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
                title: "Lunch Menu",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'lm',

            )),
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
              child: TopBarWidget(
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

            )),
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
                          text: "Today's Menu ",
                          style:
                              textStyle(Colors.black, 14, 0, FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                              text:'$todayMeal ',
                              style: textStyle(
                                  Colors.black54, 14, 0, FontWeight.w500),
                            ),
                            // can add more TextSpans here...
                          ],
                        ),
                      ),
                    ),
                    20.height,
                    buildLunchMenuContainer()
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
            itemCount: 5,
            itemBuilder: (context, index) {
              List<dynamic> week = ["1", "2", "3", "4","5"];

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
