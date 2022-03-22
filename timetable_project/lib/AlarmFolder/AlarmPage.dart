import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timetable_project/AlarmFolder/Alarminfo.dart';
import 'package:timetable_project/Color/theme_data.dart';
import 'package:timetable_project/AlarmFolder/alarmhelper.dart';
import 'package:timetable_project/data.dart';
import 'package:timetable_project/dropdownitems.dart';
import 'package:timetable_project/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  String selectedLocation;
  TextEditingController tit = TextEditingController();
  DateTime _alarmTime;
  String _alarmTimeString;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms;
  List<AlarmInfo> _currentAlarms;

  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Alarm',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: CustomColors.primaryTextColor,
                fontFamily: 'DancingScript',
                fontSize: 24),
          ),
          Expanded(
            child: FutureBuilder<List<AlarmInfo>>(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _currentAlarms = snapshot.data;
                  return ListView(
                    children: snapshot.data.map<Widget>(
                      (alarm) {
                        var alarmTime =
                            DateFormat('hh:mm aa').format(alarm.time);
                        var gradientColor = GradientTemplate
                            .gradientTemplate[alarm.colors].colors;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColor,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColor.last.withOpacity(0.4),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        alarm.title,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: true,
                                    onChanged: (bool value) {},
                                    activeColor: Colors.white,
                                  ),
                                ],
                              ),
                              Text(
                                alarm.repeat,
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    alarmTime,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                      onPressed: () {
                                        deleteAlarm(alarm.id);
                                      }),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ).followedBy([
                      if (_currentAlarms.length < 5)
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              onPressed: () {
                                _alarmTimeString =
                                    DateFormat('HH:mm').format(DateTime.now());
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  isScrollControlled: false,
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
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: FlatButton(
                                                  onPressed: () async {
                                                    var selectedTime =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );
                                                    if (selectedTime != null) {
                                                      final now =
                                                          DateTime.now();
                                                      var selectedDateTime =
                                                          DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              selectedTime.hour,
                                                              selectedTime
                                                                  .minute);
                                                      _alarmTime =
                                                          selectedDateTime;
                                                      setModalState(() {
                                                        _alarmTimeString =
                                                            DateFormat('HH:mm')
                                                                .format(
                                                                    selectedDateTime);
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    _alarmTimeString,
                                                    style:
                                                        TextStyle(fontSize: 32),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                title: TextField(
                                                  controller: tit,
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
                                                title: DropdownButton<String>(
                                                  items: locations
                                                      .map((String val) {
                                                    return new DropdownMenuItem<
                                                        String>(
                                                      value: val,
                                                      child: new Text(val),
                                                    );
                                                  }).toList(),
                                                  hint: Text("Lặp lại"),
                                                  onChanged: (newVal) {
                                                    selectedLocation = newVal;
                                                    this.setState(() {});
                                                  },
                                                  value: selectedLocation,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              FloatingActionButton.extended(
                                                onPressed: () {
                                                  onSaveAlarm();
                                                },
                                                icon: Icon(Icons.alarm),
                                                label: Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                                // scheduleAla
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
                        Center(
                            child: Text(
                          'Only 5 alarms allowed!',
                          style: TextStyle(color: Colors.white),
                        )),
                    ]).toList(),
                  );
                }
                return Center(
                    child: Image.asset('assets/images/id-loading-2.gif'));
              },
            ),
          )
        ],
      ),
    );
  }

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo) async {
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

    await flutterLocalNotificationsPlugin.schedule(0, 'Office', alarmInfo.title,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  void show() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
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

  void onSaveAlarm() {
    DateTime scheduleAlarmDateTime;
    if (_alarmTime.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime.add(Duration(days: 1));

    var alarmInfo = AlarmInfo(
      time: scheduleAlarmDateTime,
      title: tit.text,
      isAlarm: null,
      repeat: selectedLocation,
      colors: _currentAlarms.length,
    );
    _alarmHelper.insertAlarm(alarmInfo);
    scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
    Navigator.pop(context);
    loadAlarms();
  }

  void deleteAlarm(int id) {
    _alarmHelper.delete(id);
    //unsubscribe for notification
    loadAlarms();
  }
}
