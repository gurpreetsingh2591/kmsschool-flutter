import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';


class StudentLessonRecordWidget extends StatelessWidget {
  final String subject;
  final String description;
  final String date;

  const StudentLessonRecordWidget({
    Key? key,
    required this.subject,
    required this.description,
    required this.date,
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
                subject,
                textAlign: TextAlign.left,
                style: textStyle(Colors.black, 14, 0, FontWeight.w400),
              ),
            ),
            5.height,
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            5.height,
            Text(
              description,
              style: textStyle(Colors.black87, 12, 0, FontWeight.w400),
              textAlign: TextAlign.left,
            ),
            5.height,
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                style: textStyle(Colors.black, 12, 0, FontWeight.w500),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ));
  }
}
