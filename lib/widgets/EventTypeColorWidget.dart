import 'package:flutter/material.dart';
import 'package:kmschool/utils/extensions/lib_extensions.dart';
import '../utils/constant.dart';

class EventTypeColorWidget extends StatelessWidget {
  const EventTypeColorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Align(
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
                      Flexible(
                        flex: 1,
                        child: Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.red,
                      ),),
                  Flexible(
                    flex: 1,
                    child:  Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.lightBlue[600],
                    )),
                  Flexible(
                    flex: 1,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.red,
                    )),
                  Flexible(
                    flex: 1,
                    child:  Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.orange,
                    )),
                  Flexible(
                    flex: 1,
                    child:  Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.yellow,
                    ) ),
                  Flexible(
                    flex: 1,
                    child:   Container(
                        width: MediaQuery.of(context).size.width / 6,
                        color: Colors.orange,
                    ) ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                    Flexible(
                    flex: 1,
                    child: Container(
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
                    ) ),
                  Flexible(
                    flex: 1,
                    child:  SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                          child: Text("Parent Teacher Meeting day",
                              textAlign: TextAlign.center,
                              style: textStyle(
                                  Colors.black87, 8, 0, FontWeight.normal)),
                        ),
                    )),
                  Flexible(
                    flex: 1,
                    child: Container(
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
                    ) ),
                  Flexible(
                    flex: 1,
                    child: Container(
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
                    ) ),
                  Flexible(
                    flex: 1,
                    child:  Container(
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
                    )),
                  Flexible(
                    flex: 1,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 6,
                        padding: const EdgeInsets.all(2),
                        child: Center(
                          child: Text(
                            "Winter concert",
                            textAlign: TextAlign.center,
                            style: textStyle(
                                Colors.black87, 8, 0, FontWeight.normal),
                          ),
                        )   ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
