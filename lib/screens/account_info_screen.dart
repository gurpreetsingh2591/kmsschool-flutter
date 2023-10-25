import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/data/api/ApiService.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import 'package:kmschool/utils/toast.dart';
import 'package:kmschool/widgets/ButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../app/router.dart';
import '../utils/constant.dart';
import '../utils/shared_prefs.dart';
import '../utils/themes/colors.dart';
import '../widgets/ColoredSafeArea.dart';
import '../widgets/TopBarWidget.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  AccountInfoPageState createState() => AccountInfoPageState();
}

class AccountInfoPageState extends State<AccountInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();

    initializePreference().whenComplete(() {
      isLogin = SharedPrefs().isLogin();
      setState(() {});
    });
  }

  Future<void> initializePreference() async {
    SharedPrefs.init(await SharedPreferences.getInstance());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: ColoredSafeArea(
        child: buildHomeContainer(context, mq),
      ),
    );
  }

  Widget buildHomeContainer(BuildContext context, Size mq) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundDark, backgroundDark],
          stops: [0.5, 1.5],
        ),
      ),
      child: Container(
          margin:
              const EdgeInsets.only(bottom: 20, top: 22, left: 32, right: 32),
          child: Stack(
            children: [
              TopBarWidget(
                onTapLeft: () {
                  Navigator.pop(context);
                },
                onTapRight: () {
                  Navigator.pop(context);
                },
                leftIcon: 'assets/images/left_back_icon.png',
                rightIcon: '',
                title: "Account Info",
                rightVisibility: false,
                leftVisibility: true,
                bottomTextVisibility: false,
                subTitle: '',
                screen: 'account',
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, top: 80),
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    buildLogoutContainer(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget buildLogoutContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          SharedPrefs().getUserFullName().toString() ?? "User Name",
          style: textStyle(Colors.white, 24, 0.5, FontWeight.w500),
        ),
        5.height,
        Text(
          SharedPrefs().getUserEmail().toString() ?? "User email",
          style: textStyle(Colors.white60, 16, 0.5, FontWeight.w500),
        ),
        50.height,
        ButtonWidget(
            margin: 0,
            name: "Logout",
            icon: "",
            visibility: false,
            padding: 10,
            onTap: () {
              showAlertDialog(
                  context, "Logout!", "Are you sure to logout?", true);
            },
            size: 16,
            scale: 2,
            height: 50,
            decoration: kButtonBoxDecoration,
            textColors: Colors.black,
            rightVisibility: false,
            weight: FontWeight.w400,
            iconColor: Colors.white),
        20.height,
        ButtonWidget(
          name: "Delete Account",
          icon: "",
          visibility: false,
          padding: 10,
          onTap: () {
            showAlertDialog(context, "Delete Account!",
                "Are you sure to delete account permanently?", false);
          },
          size: 16,
          scale: 2,
          height: 50,
          decoration: kButtonBoxDecorationEmpty,
          textColors: kYellow,
          rightVisibility: false,
          weight: FontWeight.w400,
          iconColor: Colors.white,
          margin: 0,
        ),
      ],
    );
  }

  showAlertDialog(
      BuildContext context, String title, String msg, bool isLogout) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          if (isLogout) {
            dynamic logout = ApiService().logout();
            if (kDebugMode) {
              print("logout user--$logout");
            }

            SharedPrefs().setUserEmail("");
            SharedPrefs().setUserFullName("");
            SharedPrefs().setIsLogin(false);
            SharedPrefs().reset();

            context.go(Routes.signIn);
          } else {
            dynamic deleteUser = ApiService().deleteUser();
            if (kDebugMode) {
              print("delete user---$deleteUser");
            }
            SharedPrefs().setUserEmail("");
            SharedPrefs().setUserFullName("");
            SharedPrefs().setIsLogin(false);
            SharedPrefs().reset();

            context.go(Routes.messageFromSchool);
            toast("Account Deleted Successfully", false);
          }
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
      content: Text(msg),
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
}
