import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';

class EventTypeColorWidget extends StatelessWidget {
  const EventTypeColorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.red,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.lightBlue[600],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.red,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.orange,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.yellow,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Text(
                            "School Holiday",
                            textAlign: TextAlign.center,
                            style: textStyle(
                                Colors.black87, 8, 0, FontWeight.normal),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                          child: Text("Parent Teacher Meeting day",
                              textAlign: TextAlign.center,
                              style: textStyle(
                                  Colors.black87, 8, 0, FontWeight.normal)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Text(
                            "Staff professional activity day",
                            textAlign: TextAlign.center,
                            style: textStyle(
                                Colors.black87, 8, 0, FontWeight.normal),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Text(
                            "Graduation",
                            textAlign: TextAlign.center,
                            style: textStyle(
                                Colors.black87, 8, 0, FontWeight.normal),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Text(
                            "Seminar for grandparents",
                            textAlign: TextAlign.center,
                            style: textStyle(
                                Colors.black87, 8, 0, FontWeight.normal),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Text(
                            "Winter concert",
                            textAlign: TextAlign.center,
                            style: textStyle(
                                Colors.black87, 8, 0, FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
