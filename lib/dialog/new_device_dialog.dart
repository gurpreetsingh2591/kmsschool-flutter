import 'package:flutter/material.dart';
import 'package:kmschool/utils/constant.dart';

import '../utils/themes/colors.dart';

class CustomUpgradeDialog extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onTap;

  const CustomUpgradeDialog(
      {Key? key, required this.onTap, required this.context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildUpgradeMobileSubscriptionDialogContainer(context, onTap);
  }

  buildUpgradeMobileSubscriptionDialogContainer(
      BuildContext contexts, VoidCallback onTap) {
    return showDialog(
        context: contexts,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              backgroundColor: kDialogBgColor,
              insetPadding: const EdgeInsets.all(15),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        alignment: Alignment.center,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'New Device',
                              style: textStyle(
                                  Colors.white, 32, 0, FontWeight.w500),
                            )),
                      ),
                    ],
                  )));
        });
  }
}
