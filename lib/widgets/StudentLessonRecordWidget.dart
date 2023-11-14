import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';

class StudentLessonRecordWidget extends StatelessWidget {
  final String lessonPlanId;
  final String classId;
  final String statusEd;
  final String statusPg;
  final String statusPi;
  final String lessonName;
  final String lessonPlaned;
  final dynamic lessonPresented;

  const StudentLessonRecordWidget({
    Key? key,
    required this.lessonPlanId,
    required this.classId,
    required this.lessonName,
    required this.statusEd,
    required this.statusPg,
    required this.statusPi,
    required this.lessonPlaned,
    required this.lessonPresented,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: kMessageItemDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      lessonName,
                      style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                      textAlign: TextAlign.left,
                    )

                  ]),
            ),

            5.width,
            Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                Text(
                  lessonPlaned,
                  style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                  textAlign: TextAlign.left,
                )

              ]),
            ),
            5.width,
            Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                Text(
                  lessonPresented,
                  style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
                  textAlign: TextAlign.left,
                )

              ]),
            ),
            5.width,
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: kEDBgDecoration,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ED:$statusEd",
                        style:
                            textStyle(Colors.black87, 12, 0, FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),),
                    5.width,
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: kPGBgDecoration,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "PG:$statusPg",
                        style:
                            textStyle(Colors.black87, 12, 0, FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),),
                    5.width,
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: kPIBgDecoration,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "PI:$statusPi",
                        style:
                            textStyle(Colors.black87, 12, 0, FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                    ),),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
