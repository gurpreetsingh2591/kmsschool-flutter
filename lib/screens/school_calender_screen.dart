import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kmschool/bloc/event/student_lesson_event.dart';
import 'package:kmschool/bloc/logic_bloc/student_lesson_bloc.dart';
import 'package:kmschool/bloc/state/common_state.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList, WeekdayFormat;
import 'package:kmschool/utils/extensions/extensions.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/EventDatesResponse.dart';
import '../utils/toast.dart';
import '../widgets/ColoredSafeArea.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/EventTypeColorWidget.dart';
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

  List<EvenDates> evenDatesList = [];
  Map<DateTime, List<Event>>? dateTime;
  String _startDate = "";
  String _endDate = "";

  final studentLessonBloc = StudentLessonBloc();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  final EventList<Event> _markedDateMap = EventList<Event>(events: {});

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

    studentLessonBloc.add(const GetEventsData());
  }

  getEventDates(dynamic events) {
    try {
      var eventDatesResponse = EventDatesResponse.fromJson(events);
      dynamic status = eventDatesResponse.status;
      String message = eventDatesResponse.message;
      _markedDateMap.clear();
      evenDatesList.clear();
      if (status == 200) {
        evenDatesList.addAll(eventDatesResponse.result);
        if (kDebugMode) {
          print("evenDatesList--$evenDatesList");
        }

        for (var eventData in evenDatesList) {
          String startDate = eventData.start;
          String endDate = eventData.end;
          _startDate = startDate.split(" ")[0];
          _endDate = endDate.split(" ")[0];
          List<String> startDateParts = startDate
              .split(" ")[0]
              .split("/"); // Split by space and then by slash
          int sYear = int.parse(startDateParts[2]);
          int sMonth = int.parse(startDateParts[0]);
          int sDay = int.parse(startDateParts[1]);
          DateTime startConvertedDate = DateTime(sYear, sMonth, sDay);

          List<String> endDateParts = endDate
              .split(" ")[0]
              .split("/"); // Split by space and then by slash
          int year = int.parse(endDateParts[2]);
          int month = int.parse(endDateParts[0]);
          int day = int.parse(endDateParts[1]);
          DateTime endConvertedDate = DateTime(year, month, day);

          if (startDate.split(" ")[0] == endDate.split(" ")[0]) {
            final formatted =
                DateFormat('yyyy,MM,dd').format(startConvertedDate);
            final String title = eventData.title;
            // print(title);
            final String className = eventData.className;
            final String color = eventData.color;

            var event = Event(date: startConvertedDate);
            if (className == "H" || className == "P") {
              event = Event(
                date: startConvertedDate,
                title: title,
                dot: Container(
                  decoration: circleRedBox,
                  height: 35.0,
                  width: 35.0,
                ),
              );
            } else if (className == "M") {
              event = Event(
                date: startConvertedDate,
                title: title,
                dot: Container(
                  decoration: circleBlueBox,
                  height: 35.0,
                  width: 35.0,
                ),
              );
            } else if (className == "G" || className == "W") {
              event = Event(
                date: startConvertedDate,
                title: title,
                dot: Container(
                  decoration: circleMitiBox,
                  height: 35.0,
                  width: 35.0,
                ),
              );
            } else if (className == "S") {
              event = Event(
                date: startConvertedDate,
                title: title,
                dot: Container(
                  decoration: circleYellowBox,
                  height: 35.0,
                  width: 35.0,
                ),
              );
            }

            _markedDateMap.add(startConvertedDate, event);

            /*  if (kDebugMode) {
              print("_markedDateMap$_markedDateMap");
              print("dateTime$dateTime");
              print("eventData--$eventData");
              print("convertedDate--$startConvertedDate");
              print("dateParts--$dateParts");
              print("year--$year");
              print("month--$month");
              print("day--$day");
              print("formatted--$formatted");
            }*/
          } else {
            DateTime currentDate = startConvertedDate;
            while (currentDate.isBefore(endConvertedDate)) {
              final formatted = DateFormat('yyyy,MM,dd').format(currentDate);
              final String title = eventData.title;
              final String className = eventData.className;
              final String color = eventData.color;
              //print(title);

              var event = Event(date: endConvertedDate);
              if (className == "H" || className == "P") {
                event = Event(
                  date: currentDate,
                  title: title,
                  dot: Container(
                    decoration: circleRedBox,
                    height: 35.0,
                    width: 35.0,
                  ),
                );
              } else if (className == "M") {
                event = Event(
                  date: currentDate,
                  title: title,
                  dot: Container(
                    decoration: circleBlueBox,
                    height: 35.0,
                    width: 35.0,
                  ),
                );
              } else if (className == "G" || className == "W") {
                event = Event(
                  date: currentDate,
                  title: title,
                  dot: Container(
                    decoration: circleMitiBox,
                    height: 35.0,
                    width: 35.0,
                  ),
                );
              } else if (className == "S") {
                event = Event(
                  date: currentDate,
                  title: title,
                  dot: Container(
                    decoration: circleYellowBox,
                    height: 35.0,
                    width: 35.0,
                  ),
                );
              }

              _markedDateMap.add(currentDate, event);

              // Increment the current date
              currentDate = currentDate.add(const Duration(days: 1));
            }
          }
        }
      } else {
        toast("Sorry, Slot is not booked, Please Try Again", false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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

/*  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {

      DateTime(2023,11,20): [
        Event(
          date: DateTime(2023, 10, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            decoration: circleRedBox,
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
            decoration: circleBlueBox,
            height: 35.0,
            width: 35.0,
          ),
        ),
      ],
    },
  );*/

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
              } else if (state is GetEventsListState) {
                getEventDates(state.response);
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
              title: "School Calender",
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'mwt',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 60,
            ),
            child: ListView(
              shrinkWrap: true,
              primary: true,
              children: [
                buildCalenderView(),
                100.height,
                buildBookingHistoryContainer(),
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
    return SafeArea(
      child: Container(
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
                title: "School Calender",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'sc',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: [
                  buildCalenderView(),
                  100.height,
                  buildBookingHistoryContainer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCalenderView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          setState(() => selectedDate = date);

          String? eventName = "";

          for (var event in events) {
            eventName = event.title;

          }

          eventName!.isNotEmpty
              ? showAlertDialog(context, eventName, "$_startDate To $_endDate")
              : null;
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
        selectedDayButtonColor: Colors.transparent,
        selectedDayTextStyle: const TextStyle(color: Colors.black),
        weekDayFormat: WeekdayFormat.short,
        weekdayTextStyle: const TextStyle(color: appBaseColor),
        weekFormat: false,
        markedDatesMap: _markedDateMap,
        height: 420.0,
        selectedDateTime: selectedDate,
        daysHaveCircularBorder: true,
        markedDateMoreCustomDecoration: circleRedBox,

        /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }

  Widget buildBookingHistoryContainer() {
    return Container(
        alignment: Alignment.bottomCenter, child: const EventTypeColorWidget());
  }

  showAlertDialog(BuildContext context, String title, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title,style: textStyle(Colors.black, 16, 0, FontWeight.w500),),
      content: Text(msg,style: textStyle(Colors.black, 16, 0, FontWeight.w500)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
