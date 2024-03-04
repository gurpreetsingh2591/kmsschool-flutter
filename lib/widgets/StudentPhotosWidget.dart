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
        child: Container(
            constraints: const BoxConstraints.expand(),
            margin: const EdgeInsets.only(bottom: 15,left: 5,right: 5),
            decoration: kInnerDecoration,
            child: Center(
                child: Image.network(
                    "http://$image",
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame,
                        wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.orange,strokeWidth: 2,),
                        );
                      }
                      /*ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "http://$image",
                      //client.read(Uri.parse(image)),
                      fit: BoxFit.cover,
                    ),
                  ),*/

                      // you can replace


                    })
            )
        ));
  }
}