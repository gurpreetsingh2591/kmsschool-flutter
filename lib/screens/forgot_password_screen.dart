import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
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
import '../widgets/ColoredSafeArea.dart';
import '../widgets/CustomToastWidget.dart';
import '../widgets/TopBarWidget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailText = TextEditingController();

  final FocusNode _emailFocus = FocusNode();

  bool isLoading = false;
  bool isLogin = false;
  bool error = false;
  FToast? fToast;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusEmailChange);
    emailListener();
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
    Widget toast = CustomToastWidget(
      msg: 'Recovery email sent to',
      image: 'assets/images/resend_icon.png',
      email: _emailText.text.toString(),
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

  void _onFocusEmailChange() {
    setState(() {
      debugPrint("Focus: ${_emailFocus.hasFocus.toString()}");
    });
  }

  void emailListener() {
    _emailText.addListener(() {
      //here you have the changes of your textfield
      if (kDebugMode) {
        print("value: ${_emailText.text.toString()}");
      }
      //use setState to rebuild the widget
      setState(() {
        bool validEmail =
            isValidEmail(context, _emailText.text.toString().trim());
        if (!validEmail) {
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

  clickOnRecoverPassword() {
    bool validEmail = isValidEmail(context, _emailText.text.toString().trim());

    if (!validEmail) {
      if (_emailText.text.toString().isEmpty) {
        toast(AppLocalizations.of(context).translate('enter_email'), true);
      } else if (!EmailValidator.validate(_emailText.text.toString())) {
        toast(
            AppLocalizations.of(context).translate('enter_valid_email'), true);
      }
      _emailFocus.requestFocus();
      error = true;
    } else {
      ApiService().resetPassword(_emailText.text.toString());
      error = false;

      Future.delayed(Duration.zero, () {
        showCustomToast();
      });

      //context.pushReplacement(Routes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      /*  appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: statusBarGradient),
          ),
        ),
      ),*/
      body: ColoredSafeArea(
        child: BlocProvider(
          create: (context) => LoginBloc(),
          child: BlocConsumer<LoginBloc, CommonState>(
            listener: (context, state) {
              if (state is SuccessState) {
              } else if (state is FailureState) {
                // Handle login failure, e.g., show error message
              }
            },
            builder: (context, state) {
              if (state is LoadingState) {
                return showCenterLoader(context);
              }
              // UI code based on LoginState
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

  Widget buildHomeContainer(BuildContext context, Size mq) {
    return Container(
      /* constraints: BoxConstraints(
          maxHeight: mq.height,
        ),*/
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundDark, backgroundDark],
          stops: [0.5, 1.5],
        ),
      ),
      child: Stack(
        children: [
          BottomButtonWidget(
            name: 'recovery_email',
            onTap: () {
              !error && _emailText.text.isNotEmpty
                  ? clickOnRecoverPassword()
                  : null;
            },
            subTitle: '',
            iconVisibility: false,
            subTitleVisibility: false,
            title: 'create_an_account',
            titleVisibility: false,
            onTapTitle: () => {context.push(Routes.mainHome)},
            margin: 20,
            decoration: error || _emailText.text.isEmpty
                ? kDisabledButtonBoxDecoration
                : kButtonBoxDecoration,
            textColor: Colors.black,
            titleTextColor: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.only(
                bottom: 120, top: 22, left: 32, right: 32),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: [
                TopBarWidget(
                  onTapLeft: () {
                    context.pushReplacement(Routes.signIn);
                    // Navigator.pop(context);
                  },
                  onTapRight: () {
                    Navigator.pop(context);
                  },
                  leftIcon: 'assets/images/left_back_icon.png',
                  rightIcon: '',
                  title: 'forgot_password',
                  rightVisibility: false,
                  leftVisibility: true,
                  bottomTextVisibility: true,
                  subTitle: 'recovery_link',
                  screen: 'forgot',
                ),
                buildEmailContainer(context, mq),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailContainer(BuildContext context, Size mq) {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              50.height,
              Text(AppLocalizations.of(context).translate('email'),
                  textAlign: TextAlign.center,
                  style: textStyle(
                    Colors.white,
                    18,
                    0.5,
                    FontWeight.w400,
                  )),
              5.height,
              CommonTextField(
                controller: _emailText,
                hintText: "",
                text: "",
                isFocused: false,
                textColor: Colors.black,
                focus: _emailFocus,
                textSize: 16,
                weight: FontWeight.w400,
                hintColor: Colors.black26,
                error: false,
                wrongError: false,
                decoration: kEditLineDecoration,
                padding: 0,
              ),
            ]));
  }
}
