import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kmschool/utils/constant.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';

class CommonDialogs{

  showClearAlertDialog(BuildContext context, String deviceId, VoidCallback onTapYes,VoidCallback onTapCancel) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        onTapYes();

      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        onTapCancel();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Clear Alerts!"),
      content: const Text("Are you sure to clear all Alerts?"),
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
  showAlreadyExistDialog(BuildContext context, VoidCallback onTapYes) {
    // set up the button
    Widget okButton = TextButton(
      child:  Text("Ok".allInCaps,style: textStyle(Colors.white, 18, 0.5, FontWeight.w600)),
      onPressed: () {
        //onTapYes();
        Navigator.of(context, rootNavigator: true)
            .pop();
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  Text("Device Name Already Exist!",style: textStyle(Colors.white, 18, 0.5, FontWeight.w600),),
      content:  Text("Please Change device name, this name is already exist in database",style: textStyle(Colors.white, 14, 0.5, FontWeight.w400)),
      actions: [

        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showVerifyEmailLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: kDialogBgDecorationSecondary,
                  child: const SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
            ),
          );
        });

  }

}