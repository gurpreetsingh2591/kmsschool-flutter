import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';

class StudentLessonRecordWidget extends StatelessWidget {
  final String lessonPlanId;
  final String classId;
  final String lessonStatus;
  final String statusNew;
  final String lessonName;

  const StudentLessonRecordWidget({
    Key? key,
    required this.lessonPlanId,
    required this.classId,
    required this.lessonStatus,
    required this.statusNew,
    required this.lessonName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: kMessageItemDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                "Lesson Name: $lessonName",
                textAlign: TextAlign.left,
                style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
              ),
            ),
            5.height,

            Text(
              "Lesson New Status: $statusNew",
              style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
              textAlign: TextAlign.left,
            ),
            5.height,
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lesson Old Status: $lessonStatus",
                style: textStyle(Colors.black87, 14, 0, FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ));
  }
}
