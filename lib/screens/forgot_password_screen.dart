import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/bloc/event/login_event.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:kmschool/widgets/CommonTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/AppLocalizations.dart';
import '../app/router.dart';
import '../bloc/logic_bloc/login_bloc.dart';
import '../data/api/ApiService.dart';
import '../bloc/state/common_state.dart';
import '../utils/center_loader.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/BottomButtonWidget.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/CommonPasswordTextField.dart';
import '../widgets/CustomToastWidget.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/TopBarWidget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _oldPasswordText = TextEditingController();
  final _newPasswordText = TextEditingController();
  final _confirmPassword = TextEditingController();

  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool isLoading = false;
  bool isLogin = false;
  bool error = false;
  FToast? fToast;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = LoginBloc();
    _oldPasswordFocus.addListener(_onFocusOldChange);
    _newPasswordFocus.addListener(_onFocusNewChange);
    _confirmPassword.addListener(_onFocusConfirmChange);
    newPasswordListener();
    oldPasswordListener();
    confirmPasswordListener();
    fToast = FToast();
    fToast?.init(context);
    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
      setState(() {});
    });
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  showCustomToast() {
    Widget toast = const CustomToastWidget(
      msg: 'The password has been successfully changed.',
      image: 'assets/images/resend_icon.png',
      email: "",
      scale: 1.5,
    );

    fToast?.showToast(
        child: toast,
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 5),
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: 200,
            left: 30,
            right: 30,
            child: child,
          );
        });
  }

  void _onFocusOldChange() {
    setState(() {
      debugPrint("Focus: ${_oldPasswordFocus.hasFocus.toString()}");
    });
  }

  void _onFocusNewChange() {
    setState(() {
      debugPrint("Focus: ${_oldPasswordFocus.hasFocus.toString()}");
    });
  }

  void _onFocusConfirmChange() {
    setState(() {
      debugPrint("Focus: ${_oldPasswordFocus.hasFocus.toString()}");
    });
  }

  void oldPasswordListener() {
    _oldPasswordText.addListener(() {
      //here you have the changes of your textfield
      if (kDebugMode) {
        print("value: ${_oldPasswordText.text.toString()}");
      }
      //use setState to rebuild the widget
      setState(() {
        bool validPassword =
            isValidPassword(context, _oldPasswordText.text.toString().trim());
        if (!validPassword) {
          error = true;
        } else {
          error = false;
        }
        if (kDebugMode) {
          print("error: $error");
        }
      });
    });
  }

  void newPasswordListener() {
    _newPasswordText.addListener(() {
      //here you have the changes of your textfield
      if (kDebugMode) {
        print("value: ${_newPasswordText.text.toString()}");
      }
      //use setState to rebuild the widget
      setState(() {
        bool validPassword =
            isValidPassword(context, _newPasswordText.text.toString().trim());
        if (!validPassword) {
          error = true;
        } else {
          error = false;
        }
        if (kDebugMode) {
          print("error: $error");
        }
      });
    });
  }

  void confirmPasswordListener() {
    _confirmPassword.addListener(() {
      //here you have the changes of your textfield
      if (kDebugMode) {
        print("value: ${_confirmPassword.text.toString()}");
      }
      //use setState to rebuild the widget
      setState(() {
        bool validPassword =
            isValidPassword(context, _confirmPassword.text.toString().trim());
        if (!validPassword) {
          error = true;
        } else {
          error = false;
        }
        if (kDebugMode) {
          print("error: $error");
        }
      });
    });
  }

  changedPassword() {
    Future.delayed(Duration.zero, () {
      if (!isLoading) {
        showCustomToast();
        context.push(Routes.signIn);
        isLoading = true;
      }
    });
  }

  clickOnRecoverPassword(String newPassword, String confirmPassword) {
    if (newPassword.toString() == confirmPassword.toString()) {
      loginBloc.add(GetChangePasswordButtonPressed(
          oldPassword: _oldPasswordText.text.toString(),
          parentId: SharedPrefs().getParentId().toString(),
          newPassword: newPassword,
          confirmPassword: confirmPassword));
      error = false;
    } else {
      //_confirmPasswordFocus.requestFocus();
      toast("Please enter same password", true);
      error = true;
    }
  }
  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }
  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => loginBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          child: BlocBuilder<LoginBloc, CommonState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return buildHomeContainer(context, mq, true);
              } else if (state is GetChangePasswordState) {
                if (state.response["status"] == 400) {
                  toast("wrong old password", false);
                } else {
                  changedPassword();
                }

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
              onTapRight: () {
                //context.push(Routes.accountInfo);
              },
              leftIcon: 'assets/icons/menu.png',
              rightIcon: 'assets/icons/user.png',
              title: "Change Password",
              rightVisibility: false,
              leftVisibility: true,
              bottomTextVisibility: false,
              subTitle: '',
              screen: 'chp',
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 100),
              child: ButtonWidget(
                margin: 40,
                name: "Change Password".toUpperCase(),
                icon: "",
                visibility: false,
                padding: 0,
                onTap: () {
                  clickOnRecoverPassword(_newPasswordText.text.toString(),
                      _confirmPassword.text.toString());
                  //callSetReminderApi();
                },
                size: 12,
                scale: 2,
                height: 50,
                decoration: kSelectedDecoration,
                textColors: Colors.white,
                rightVisibility: false,
                weight: FontWeight.w400,
                iconColor: Colors.white,
              )),
          Container(
            margin:
                const EdgeInsets.only(bottom: 10, top: 82, left: 32, right: 32),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: [
                buildPasswordContainer(context, mq),
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
          ),
        ],
      ),
    );
  }

  Widget buildPasswordContainer(BuildContext context, Size mq) {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              50.height,
              Text("Old Password",
                  textAlign: TextAlign.center,
                  style: textStyle(
                    Colors.black,
                    18,
                    0.5,
                    FontWeight.w400,
                  )),
              5.height,
              Stack(children: [
                CommonPasswordTextField(
                  controller: _oldPasswordText,
                  hintText: "Password",
                  text: "",
                  isFocused: false,
                  textColor: Colors.black,
                  focus: _oldPasswordFocus,
                  textSize: 16,
                  weight: FontWeight.w400,
                  hintColor: Colors.black26,
                  obscurePassword: _obscureOldPassword,
                  error: false,
                  wrongError: false,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 13, right: 10),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _toggleOldPasswordVisibility,
                    child: Icon(
                      _obscureOldPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: kBaseColor,
                    ),
                  ),
                ),
              ]),
              15.height,
              Text("New Password",
                  textAlign: TextAlign.center,
                  style: textStyle(
                    Colors.black,
                    18,
                    0.5,
                    FontWeight.w400,
                  )),
              5.height,
              Stack(children: [
                CommonPasswordTextField(
                  controller: _newPasswordText,
                  hintText: "New Password",
                  text: "",
                  isFocused: false,
                  textColor: Colors.black,
                  focus: _newPasswordFocus,
                  textSize: 16,
                  weight: FontWeight.w400,
                  hintColor: Colors.black26,
                  obscurePassword: _obscureNewPassword,
                  error: false,
                  wrongError: false,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 13, right: 10),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _toggleNewPasswordVisibility,
                    child: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: kBaseColor,
                    ),
                  ),
                ),
              ]),
              15.height,
              Text("Confirm New Password",
                  textAlign: TextAlign.center,
                  style: textStyle(
                    Colors.black,
                    18,
                    0.5,
                    FontWeight.w400,
                  )),
              5.height,
              Stack(children: [
                CommonPasswordTextField(
                  controller: _confirmPassword,
                  hintText: "New Password",
                  text: "",
                  isFocused: false,
                  textColor: Colors.black,
                  focus: _confirmPasswordFocus,
                  textSize: 16,
                  weight: FontWeight.w400,
                  hintColor: Colors.black26,
                  obscurePassword: _obscureConfirmPassword,
                  error: false,
                  wrongError: false,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 13, right: 10),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _toggleConfirmPasswordVisibility,
                    child: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: kBaseColor,
                    ),
                  ),
                ),
              ])
              ,
            ]));
  }
}
