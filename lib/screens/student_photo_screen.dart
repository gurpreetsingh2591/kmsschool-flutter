import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kmschool/bloc/event/student_lesson_event.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/logic_bloc/student_lesson_bloc.dart';
import '../bloc/state/common_state.dart';
import '../model/PhotosResponse.dart';
import '../widgets/ColoredSafeArea.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/ImageViewerDialog.dart';
import '../widgets/StudentPhotosWidget.dart';
import '../widgets/TopBarWidget.dart';

class StudentPhotoPage extends StatefulWidget {
  const StudentPhotoPage({Key? key}) : super(key: key);

  @override
  StudentPhotoPageState createState() => StudentPhotoPageState();
}

class StudentPhotoPageState extends State<StudentPhotoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isLogin = false;
  final studentLessonBloc = StudentLessonBloc();
  List<PhotosResponse> studentPhotos = [];
  String studentName = "";
  String studentId = "";
  String driveLink = "";
  int _currentPage = 0;
  int itemsPerPage = 6;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

// Create a ScrollController
  final ScrollController _controller = ScrollController();

  // Function to scroll to the end of the ListView
  void _scrollToEnd() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

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
    _scrollController.addListener(_scrollListener);

    studentLessonBloc
        .add(GetStudentPhotosData(studentId: studentId, index: _currentPage));
  }

  _scrollListener() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // If you want to animate the scroll, use animateTo instead
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    // Reach the end of the grid view
    // You can handle any logic here when the end is reached
    // }
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  void _handleScroll(dynamic data) {
    if (_isLoading) return;

    final double maxScroll = MediaQuery.of(context).size.height;
    final double currentScroll = MediaQuery.of(context).size.height * 0.7;
    const double scrollThreshold = 50.0; // Adjust this threshold as needed

    if (maxScroll - currentScroll <= scrollThreshold) {
      // setState(() {
      _isLoading = true;
      _currentPage++;

      // });
    }
    getStudentPhotos(data);
  }

// Function to handle scrolling and load more images
/*  void _handleScroll(dynamic data) {
    if (_isLoading) return;

    final double maxScroll = MediaQuery.of(context).size.height;
    final double currentScroll = MediaQuery.of(context).size.height * 0.7;
    if (maxScroll == currentScroll) {
      setState(() {
        _isLoading = true;
        _currentPage++;
        studentLessonBloc.add(GetStudentPhotosData(studentId: studentId,index: _currentPage));
        getStudentPhotos(data);

      });
    }
  }*/
  getStudentPhotos(dynamic data) {
    try {
      studentPhotos.clear();
      var studentPhotosResponse = StudentPhotosResponse.fromJson(data);
      dynamic status = studentPhotosResponse.status;
      String message = studentPhotosResponse.message;

      if (status == 200) {
        studentPhotos.addAll(studentPhotosResponse.photos);
        if (kDebugMode) {
          print("evenDatesList--$studentPhotos");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error:$e");
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
                return buildHomeContainer(context, mq,true);
              } else if (state is SuccessState) {
                return buildHomeContainer(context, mq,false);
              } else if (state is GetStudentPhotosState) {
                _handleScroll(state.response);
                //getStudentPhotos(state.response);
                return buildHomeContainer(context, mq,false);
              } else if (state is FailureState) {
                return buildHomeContainer(context, mq,false);
              }
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 757) {
                    return buildHomeContainer(context, mq,false);
                  } else {
                    return buildHomeContainer(context, mq,false);
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
              title: "Photos",
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'mwt',
            ),
          ),
          studentPhotos.isNotEmpty
              ? buildCategoriesListContainer(context, mq)
              : SizedBox(),
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

  Widget buildHomeContainer(BuildContext context, Size mq,bool isLoading) {
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
              title: "Photos",
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'home',
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
              controller: _controller,
              children: [
                Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                    text: "",
                    style: textStyle(Colors.black, 14, 0, FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Photos",
                        style: textStyle(appBaseColor, 18, 0, FontWeight.w500),
                      ),
                      // can add more TextSpans here...
                    ],
                  ),
                ),
                20.height,
                buildCategoriesListContainer(context, mq),
                20.height,

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Visibility(
                     visible: _currentPage>0?true:false,
                     child: InkWell(
                         onTap: () async {
                           setState(() {
                             _isLoading = false;
                             _currentPage--;
                             studentLessonBloc.add(GetStudentPhotosData(
                                 studentId: studentId, index: _currentPage));
                             _scrollToEnd();
                             //_scrollListener();
                           });

                         },
                         child: Container(
                           margin: const EdgeInsets.only(right: 20),
                           child: Text.rich(
                             textAlign: TextAlign.left,
                             TextSpan(
                               text: "See",
                               style:
                               textStyle(Colors.black, 14, 0, FontWeight.w500),
                               children: <TextSpan>[
                                 TextSpan(
                                   text: " Previous",
                                   style: textStyle(
                                       appBaseColor, 18, 0, FontWeight.w500),
                                 ),
                                 // can add more TextSpans here...
                               ],
                             ),
                           ),
                         )),
                   ),
                 Visibility(
                   visible: true,
                   child: InkWell(
                       onTap: () async {
                         setState(() {
                           _isLoading = false;
                           _currentPage++;
                           studentLessonBloc.add(GetStudentPhotosData(
                               studentId: studentId, index: _currentPage));
                           _scrollToEnd();
                           //_scrollListener();
                         });
                       },
                       child: Container(
                         margin: const EdgeInsets.only(right: 20),
                         child: Text.rich(
                           textAlign: TextAlign.right,
                           TextSpan(
                             text: "See",
                             style:
                             textStyle(Colors.black, 14, 0, FontWeight.w500),
                             children: <TextSpan>[
                               TextSpan(
                                 text: " Next",
                                 style: textStyle(
                                     appBaseColor, 18, 0, FontWeight.w500),
                               ),
                               // can add more TextSpans here...
                             ],
                           ),
                         ),
                       )),
                 ),
               ],),
              ],
            ),
          ),
          Visibility(
              visible: isLoading,
              child:
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
          ),],
      ),
    );
  }

  Widget buildCategoriesListContainer(BuildContext context, Size mq) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      reverse: false,
      controller: _controller,
      itemCount: studentPhotos.length,
      itemBuilder: (BuildContext context, int index) {
        return StudentPhotosWidget(
          driveLink: driveLink,
          image: studentPhotos[index]
              .imageurl
              .toString()
              .toString()
              .replaceAll("file:///", ""),
          click: () {
            showDialog(
              context: context,
              builder: (context) {
                return ImageViewerDialog(
                  imageUrls: studentPhotos,
                  initialIndex: index,
                );
              },
            );
          },
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
      ),
    );
  }
}
