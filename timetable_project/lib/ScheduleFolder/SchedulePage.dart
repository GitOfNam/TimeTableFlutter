import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timetable_project/Color/theme_data.dart';
import 'package:timetable_project/ScheduleFolder/Schedulehelper.dart';
import 'package:timetable_project/ScheduleFolder/Scheduleinfo.dart';
import 'package:timetable_project/data.dart';
import 'package:timetable_project/dropdownitems.dart';
import 'package:timetable_project/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String _scheduleTimeString;
  DateTime _scheduleTime;
  String selectedLocation;
  DateTime selectedDate = DateTime.now();
  ScheduleHelper _scheduleHelper = ScheduleHelper();
  Future<List<ScheduleInfo>> _schedules;
  List<ScheduleInfo> _lstSchedule;
  TextEditingController _titletext = TextEditingController();
  TextEditingController _contenttext = TextEditingController();
  TextEditingController _addresstext = TextEditingController();

  @override
  void initState() {
    _scheduleTime = DateTime.now();
    _scheduleHelper.initializeDatabase().then((value) {
      print('------database schedule success');
      loadData();
    });
    super.initState();
  }

  void loadData() {
    _schedules = _scheduleHelper.getSchedule();
    if (mounted) setState(() {});
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      initialDatePickerMode: DatePickerMode.year,
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      helpText: 'Select booking date', // Can be used as title
      cancelText: 'Not now',
      confirmText: 'Book',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lập lịch biểu',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'DancingScript',
                color: CustomColors.primaryTextColor,
                fontSize: 40),
          ),
          Expanded(
            child: FutureBuilder<List<ScheduleInfo>>(
              future: _schedules,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _lstSchedule = snapshot.data;
                  return ListView(
                      children: snapshot.data.map<Widget>(
                    (item) {
                      var scheduleTime =
                          DateFormat('hh:mm aa').format(item.time);
                      var mau =
                          GradientTemplate.gradientTemplate[item.colors].colors;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: mau,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: mau.last.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: Offset(4, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.label,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  scheduleTime,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Mon-Fri',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.update,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'sdfa',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ).followedBy([
                    if (_lstSchedule.length < 5)
                      DottedBorder(
                        strokeWidth: 2,
                        color: CustomColors.clockOutline,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(24),
                        dashPattern: [5, 4],
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CustomColors.clockBG,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: FlatButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            onPressed: () {
                              _scheduleTimeString =
                                  DateFormat('HH:mm').format(DateTime.now());
                              showModalBottomSheet(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                isDismissible: true,
                                context: context,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return Container(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 80.0),
                                              child: FlatButton(
                                                onPressed: () async {
                                                  var selectedTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );
                                                  if (selectedTime != null) {
                                                    final now = DateTime.now();
                                                    var selectedDateTime =
                                                        DateTime(
                                                            now.year,
                                                            now.month,
                                                            now.day,
                                                            selectedTime.hour,
                                                            selectedTime
                                                                .minute);
                                                    _scheduleTime =
                                                        selectedDateTime;
                                                    setModalState(() {
                                                      _scheduleTimeString =
                                                          DateFormat('HH:mm')
                                                              .format(
                                                                  selectedDateTime);
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  _scheduleTimeString,
                                                  style:
                                                      TextStyle(fontSize: 32),
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: FlatButton(
                                                    child: Text(
                                                      "${selectedDate.toLocal()}"
                                                          .split(' ')[0],
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      _selectDate(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            ListTile(
                                              title: TextField(
                                                controller: _titletext,
                                                textInputAction:
                                                    TextInputAction.send,
                                                decoration: InputDecoration(
                                                    hintText: 'Tiêu đề ...'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            ListTile(
                                              title: TextField(
                                                controller: _addresstext,
                                                textInputAction:
                                                    TextInputAction.send,
                                                decoration: InputDecoration(
                                                    hintText: 'Địa chỉ ...'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            ListTile(
                                              title: TextField(
                                                controller: _contenttext,
                                                textInputAction:
                                                    TextInputAction.send,
                                                decoration: InputDecoration(
                                                    hintText: 'Nội dung ...'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            FloatingActionButton.extended(
                                              onPressed: () {
                                                onSaveSchedule();
                                              },
                                              icon: Icon(Icons.schedule),
                                              label: Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/add_alarm.png',
                                  scale: 1.5,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Add Alarm',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Image.asset('assets/images/id-loading-2.gif')
                  ]).toList());
                }
                return Center(
                  child: Text(
                    'Loading..',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// class CustomCardShapePainter extends CustomPainter {
//   final double radius;
//   final Color startColor;
//   final Color endColor;

//   CustomCardShapePainter(this.radius, this.startColor, this.endColor);

//   @override
//   void paint(Canvas canvas, Size size) {
//     var radius = 24.0;

//     var paint = Paint();
//     paint.shader = ui.Gradient.linear(
//         Offset(0, 0), Offset(size.width, size.height), [
//       HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
//       endColor
//     ]);
//     var path = Path()
//       ..moveTo(0, size.height)
//       ..lineTo(size.width - radius, size.height)
//       ..quadraticBezierTo(
//           size.width, size.height, size.width, size.height - radius)
//       ..lineTo(size.width, radius)
//       ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
//       ..lineTo(size.width - 1.5 * radius, 0)
//       ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
  void scheduleBell(
      DateTime scheduledNotificationDateTime, ScheduleInfo scheduleInfo) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Office',
        scheduleInfo.title,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  void show(
      DateTime scheduledNotificationDateTime, ScheduleInfo scheduleInfo) async {
    String tit = "Bạn đã thêm thành công lịch trình :" + scheduleInfo.title;
    String gio =
        "vào thời gian : " + scheduledNotificationDateTime.toIso8601String();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, tit, gio, platformChannelSpecifics, payload: 'codex_logo');
  }

  void zone() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void tesst() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true);
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final List<ActiveNotification> activeNotifications =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.getActiveNotifications();
  }

  void onSaveSchedule() {
    DateTime scheduleBellDateTime;
    if (_scheduleTime.isAfter(DateTime.now()))
      scheduleBellDateTime = _scheduleTime;
    else
      scheduleBellDateTime = _scheduleTime.add(Duration(days: 1));

    var scheduleInfo = ScheduleInfo(
      time: scheduleBellDateTime,
      title: _titletext.text,
      address: _addresstext.text,
      content: _contenttext.text,
      colors: _lstSchedule.length,
    );
    _scheduleHelper.insertSchedule(scheduleInfo);
    scheduleBell(scheduleBellDateTime, scheduleInfo);
    show(scheduleBellDateTime, scheduleInfo);
    Navigator.pop(context);
    loadData();
  }

  void deleteAlarm(int id) {
    _scheduleHelper.delete(id);
    //unsubscribe for notification
    loadData();
  }
}
