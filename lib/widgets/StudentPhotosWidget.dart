import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';

class StudentPhotosWidget extends StatelessWidget {
  final String driveLink;
  final String image;
  final VoidCallback click;

  const StudentPhotosWidget({
    Key? key,
    required this.driveLink,
    required this.image,
    required this.click,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        click();
      },
      child: Expanded(child: Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 15, right: 15),
        decoration: kInnerDecoration,
        child: Image.network(
          "http://$image",
          //client.read(Uri.parse(image)),
          fit: BoxFit.contain,
        ),
      ),
      )
    );
  }
}
