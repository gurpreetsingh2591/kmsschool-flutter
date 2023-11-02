import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/bloc/state/meeting_state.dart';
import 'package:kmschool/model/BookingSlotsResponse.dart';

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

class MeetingWithOfficePage extends StatefulWidget {
  const MeetingWithOfficePage({Key? key}) : super(key: key);

  @override
  MeetingWithOfficePageState createState() => MeetingWithOfficePageState();
}

class MeetingWithOfficePageState extends State<MeetingWithOfficePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String studentId = "";
  String parentId = "";

  bool isLoading = false;
  bool isLogin = false;
  bool selection = true;
  List<BookingSlots> bookingSlots = [];
  List<BookedMeeting> bookedMeetings = [];
  String selectedValue = "Select Slot";
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
    meetingBloc.add(
        GetBookedOfficeSlotsList(studentId: studentId, parentId: parentId));

    // String selectedValue = bookingSlots[0].slot;
  }

  setOfficeSlotData(dynamic slots) {
    bookingSlots.clear();
    try {
      var messagesResponse = BookingSlotsResponse.fromJson(slots);
      int status = messagesResponse.status;
      String message = messagesResponse.message;
      if (status == 200) {
        final booking = BookingSlots(slot: "Select Slot");
        bookingSlots.add(booking);
        bookingSlots.addAll(messagesResponse.result);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  slotBookingValidation() {
    if (bookingSlots.isEmpty) {
      toast("Sorry, slot is not available please change your date", false);
    } else if (bookingSlots.isNotEmpty && selectedValue == "Select Slot") {
      toast("Please Select Time slot", false);
    } else {
      showAlertDialog(context, "Book Meeting With Office",
          "Your Selected Date: $formattedDate\nYour Time Slot:$selectedValue");
    }
  }

  showAlertDialog(BuildContext context, String title, String dateTime) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          meetingBloc.add(BookOfficeTimeSlotButtonPressed(
              date: formattedDate, parentId: parentId, time: selectedValue));
        });
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(dateTime),
      actions: [
        cancelButton,
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

  showDeleteAlertDialog(BuildContext context, String meetId) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          meetingBloc.add(GetDeleteOfficeSlotsList(
            meetId: meetId,
          ));
        });
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Meeting",
        style: textStyle(Colors.black87, 18, 0, FontWeight.w500),
      ),
      content: Text("Are you sure to delete your meeting",
          style: textStyle(Colors.black87, 14, 0, FontWeight.normal)),
      actions: [
        cancelButton,
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

  setBookedHistorySlotData(dynamic bookings) {
    bookedMeetings.clear();
    try {
      var bookingResponse = BookedMeetingResponse.fromJson(bookings);
      int status = bookingResponse.status;
      String message = bookingResponse.message;
      if (status == 200) {
        bookedMeetings.addAll(bookingResponse.result);
      }

      if (kDebugMode) {
        print(bookedMeetings);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  setBookSlotData(dynamic bookings) {
    try {
      var bookingResponse = CommonResponse.fromJson(bookings);
      dynamic status = bookingResponse.status;
      String message = bookingResponse.message;

      if (message != "Invalid") {
        toast("Slot booked successfully", false);
        meetingBloc.add(
            GetBookedOfficeSlotsList(studentId: studentId, parentId: parentId));
      } else {
        toast("Sorry, Slot is not booked, Please Try Again", false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: appBaseColor, // Change the header color
            hintColor: appBaseColor, // Change the selected item color
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

        meetingBloc.add(GetOfficeTimeSlotsByDate(
            date: formattedDate, studentId: studentId));
      });
      if (kDebugMode) {
        print('Selected Date: $formattedDate');
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
      create: (context) => meetingBloc,
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
          child: BlocBuilder<MeetingBloc, MeetingState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return loaderBar(context, mq);
              } else if (state is GetOfficeSlotState) {
                setOfficeSlotData(state.response);
                return buildHomeContainer(context, mq);
              } else if (state is GetOfficeBookingSuccessState) {
                setBookSlotData(state.response);
                return buildHomeContainer(context, mq);
              } else if (state is GetOfficeBookedSuccessState) {
                setBookedHistorySlotData(state.response);
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
                onTapRight: () {},
                leftIcon: 'assets/icons/menu.png',
                rightIcon: 'assets/icons/user.png',
                title: "Meeting with Office",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'mwt',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  bottom: 20, top: 82, left: 16, right: 16),
              child: ListView(
                shrinkWrap: true,
                primary: true,
                children: [
                  buildSelectionTab(),
                  40.height,
                  selection
                      ? buildAddNewBookingContainer()
                      : buildBookingHistoryContainer()
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
                title: "Meeting with Office",
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
                    buildSelectionTab(),
                    40.height,
                    selection
                        ? buildAddNewBookingContainer()
                        : buildBookingHistoryContainer()
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
      leftName: "Add new booking",
      rightName: "Booking history",
    );
  }

  Widget buildAddNewBookingContainer() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 50,
              decoration: kEditTextDecoration,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/calender.png",
                          scale: 12,
                        ),
                      )),
                  Container(
                    width: 1,
                    // Set the width of the container to 1 for a vertical line
                    height: double.infinity,
                    // Match the height to the parent container's height
                    color: Colors.black26, // Set the color of the line
                  ),
                  Expanded(
                      flex: 7,
                      child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          }, // Specify the callback function here
                          child: Container(
                              margin:
                              const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formattedDate,
                                style: textStyle(
                                    Colors.black87, 14, 0, FontWeight.w400),
                              ))))
                ],
              )),
          20.height,
          Container(
              height: 50,
              decoration: kEditTextDecoration,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/ic_clock.png",
                          scale: 12,
                        ),
                      )),
                  Container(
                    width: 1,
                    // Set the width of the container to 1 for a vertical line
                    height: double.infinity,
                    // Match the height to the parent container's height
                    color: Colors.black26, // Set the color of the line
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        value: selectedValue,
                        isExpanded: true,
                        dropdownColor: Colors.white,

                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: bookingSlots.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.slot,
                            child: Text(
                              item.slot,
                              style: textStyle(
                                  Colors.black, 14, 0, FontWeight.w400),
                            ),
                          );
                        }).toList(),
                        underline: Container(),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/ic_down.png",
                          scale: 2.5,
                        ),
                      )),
                ],
              )),
          40.height,
          ButtonWidget(
            margin: 40,
            name: "Book Meeting".toUpperCase(),
            icon: "",
            visibility: false,
            padding: 0,
            onTap: () {
              slotBookingValidation();
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
                time: bookedMeetings[index].meettime, onTap: () {
                showDeleteAlertDialog(context,bookedMeetings[index].meet_id.toString());
              },
              );
            },
          )
        ]);
  }
}
