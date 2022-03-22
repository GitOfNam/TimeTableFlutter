import 'dart:async';
import 'dart:ui';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final CustomTimerController _controller = new CustomTimerController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTimer(
              controller: _controller,
              from: Duration(hours: 12),
              to: Duration(hours: 0),
              builder: (CustomTimerRemainingTime remaining) {
                return Text(
                  "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                  style: TextStyle(fontSize: 36.0, color: Colors.white),
                );
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Text("Start"),
                  onPressed: () => _controller.start(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.green,
                ),
                FlatButton(
                  child: Text("Pause"),
                  onPressed: () => _controller.pause(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.blue,
                ),
                FlatButton(
                    child: Text("Reset"),
                    onPressed: () => _controller.reset(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }
}
