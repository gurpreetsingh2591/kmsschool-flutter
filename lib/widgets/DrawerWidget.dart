import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/utils/extensions/extensions.dart';
import 'package:kmschool/utils/shared_prefs.dart';

import '../app/router.dart';
import '../utils/constant.dart';

final Uri _url = Uri.parse('https://flutter.dev');

class DrawerWidget extends StatelessWidget {
  final BuildContext contexts;

  const DrawerWidget({
    Key? key,
    required this.contexts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxImageDrawerBgDecoration(),
      child: ListView(
        padding: const EdgeInsets.only(
          top: 40,left: 10
        ),
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15,bottom: 7),
            alignment: Alignment.topLeft,
            child: Image.asset(
              'assets/icons/app_logo.png',
              scale: 4,
            ),
          ),
          SizedBox(
            height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/home.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Home',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.mainHome);
                },
              )),
          7.height,
          SizedBox(
            height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/menu_list.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Lunch Menu',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.lunchMenu);
                },
              )),
          7.height,
          SizedBox(
            height: 40,
            child: ListTile(
              leading: Image.asset(
                'assets/icons/food.png',
                scale: 12,
              ),
              title: Transform(
                transform: Matrix4.translationValues(-10, 0.0, 0.0),
                child: Text(
                  'Snacks Menu',
                  style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.snackMenu);
              },
            ),
          ),
          7.height,
          SizedBox(
            height: 40,
            child: ListTile(
              leading: Image.asset(
                'assets/icons/calender.png',
                scale: 12,
              ),
              title: Transform(
                transform: Matrix4.translationValues(-10, 0.0, 0.0),
                child: Text(
                  'School Calender',
                  style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.schoolCalender);

              },
            ),
          ),
          7.height,
          SizedBox(
            height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/message_from_school.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Message From School',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.messageFromSchool);
                },
              ),),
          7.height,
          SizedBox(
              height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/meeting_with_teacher.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Meeting With Teacher',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.meetingWithTeacher);
                },
              )),
          7.height,
          SizedBox(
              height: 40,

              child: ListTile(
                leading: Image.asset(
                  'assets/icons/meeting_with_office.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Meeting With Office',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.meetingWithOffice);
                },
              )),
          7.height,
          SizedBox(
              height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/message_to_teacher.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Message To Teacher',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.messageToTeacher);
                },
              )),
         7.height,
          SizedBox(
              height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/message_to_office.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Message To Office',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.messageToOffice);
                },
              )),
          7.height,
          SizedBox(
              height: 40,

              child: ListTile(
                leading: Image.asset(
                  'assets/icons/user.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Work in Progress',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.lessonProgress);
                },
              )),
         7.height,
          SizedBox(
              height: 40,

              child: ListTile(
                leading: Image.asset(
                  'assets/icons/user.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Photos',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.studentPhotos);
                },
              )),
         7.height,
          SizedBox(
              height: 40,

              child: ListTile(
                leading: Image.asset(
                  'assets/icons/user.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Settings',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.setReminder);
                },
              )),
          7.height,
          SizedBox(
              height: 40,

              child: ListTile(
                leading: Image.asset(
                  'assets/icons/user.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Profile',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.push(Routes.accountInfo);
                },
              )),
         7.height,
          SizedBox(
              height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/remove.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Delete Account',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  SharedPrefs().setIsLogin(false);
                  SharedPrefs().reset();
                  context.go(Routes.signIn);
                },
              )),
          7.height,
          SizedBox(
              height: 40,
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/logout.png',
                  scale: 12,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Text(
                    'Logout',
                    style: textStyle(Colors.black, 14, 0, FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  SharedPrefs().setIsLogin(false);
                  SharedPrefs().reset();

                  context.go(Routes.signIn);

                },
              )),
          7.height,
        ],
      ),
    );
  }

 /* Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }*/
}
