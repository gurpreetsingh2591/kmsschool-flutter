import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/bloc/state/meeting_state.dart';
import 'package:kmschool/model/BookingSlotsResponse.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;

import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/router.dart';
import '../bloc/event/meeting_slot_event.dart';
import '../bloc/logic_bloc/get_device_bloc.dart';
import '../bloc/logic_bloc/meeting_bloc.dart';
import '../bloc/state/get_device_state.dart';
import '../model/BookedMeetingResponse.dart';
import '../model/CommonResponse.dart';
import '../model/DeviceResponse.dart';

import '../widgets/BookingItemWidget.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/SelectionWidget.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';

class SchoolCalenderPage extends StatefulWidget {
  const SchoolCalenderPage({Key? key}) : super(key: key);

  @override
  SchoolCalenderPageState createState() => SchoolCalenderPageState();
}

class SchoolCalenderPageState extends State<SchoolCalenderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String studentId = "";
  String parentId = "";

  bool isLoading = false;
  bool isLogin = false;
  bool selection = true;

  //List<BookingSlots> subjectList = [];
  List<BookedMeeting> bookedMeetings = [];

  // String selectedValue = "Select Subject";
  final meetingBloc = MeetingBloc();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";

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

    meetingBloc.add(
        GetOfficeTimeSlotsByDate(date: formattedDate, studentId: studentId));

    // String selectedValue = bookingSlots[0].slot;
  }

  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );
  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2023, 11, 20): [
        Event(
          date: DateTime(2023, 10, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            decoration: circleBox,
            height: 35.0,
            width: 35.0,
          ),
        ),
      ],
      DateTime(2023, 10, 20): [
        Event(
          date: DateTime(2023, 10, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
      ],
    },
  );

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => meetingBloc,
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
          child: BlocBuilder<MeetingBloc, MeetingState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return loaderBar(context, mq);
              } else if (state is GetOfficeSlotState) {
                //setOfficeSlotData(state.response);
                return buildHomeContainer(context, mq);
              } else if (state is GetOfficeBookingSuccessState) {
                return buildHomeContainer(context, mq);
              } else if (state is GetOfficeBookedSuccessState) {
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
                children: [buildBookingHistoryContainer()],
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
                    buildCalenderView(),
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

  /*Widget buildCalenderView() {
    return Container(child: const Text(""));
  }*/

  Widget buildCalenderView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events) {
            setState(() => selectedDate = date);
          },
          weekendTextStyle: const TextStyle(
            color: Colors.black87,
          ),
          customDayBuilder: (
            /// you can provide your own build function to make custom day containers
            bool isSelectable,
            int index,
            bool isSelectedDay,
            bool isToday,
            bool isPrevMonthDay,
            TextStyle textStyle,
            bool isNextMonthDay,
            bool isThisMonthDay,
            DateTime day,
          ) {
            /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
            /// This way you can build custom containers for specific days only, leaving rest as default.
            // Example: every 15th of month, we have a flight, we can place an icon in the container like that:

          },
          weekFormat: false,
          markedDatesMap: _markedDateMap,
          height: 420.0,
          selectedDateTime: selectedDate,
          daysHaveCircularBorder: true,
          markedDateMoreCustomDecoration: circleBox,

          /// null for not rendering any border, true for circular border, false for rectangular border
          ),
    );
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
            itemCount: bookedMeetings.length,
            itemBuilder: (context, index) {
              return BookingItemWidget(
                date: bookedMeetings[index].meetdate,
                time: bookedMeetings[index].meettime,
              );
            },
          )
        ]);
  }
}
