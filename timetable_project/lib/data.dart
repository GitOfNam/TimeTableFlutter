import 'package:timetable_project/AlarmFolder/Alarminfo.dart';
import 'package:timetable_project/Color/theme_data.dart';
import 'package:timetable_project/enum.dart';
import 'package:timetable_project/menuinfo.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock,
      title: 'Clock', image: 'assets/images/clock_icon.png'),
  MenuInfo(MenuType.schedule,
      title: 'Schedule', image: 'assets/images/schedule_icon.png'),
  MenuInfo(MenuType.alarm,
      title: 'Alarm', image: 'assets/images/alarm_icon.png'),
  MenuInfo(MenuType.timer,
      title: 'Timer', image: 'assets/images/timer_icon.png'),
  MenuInfo(MenuType.stopwatch,
      title: 'Stopwatch', image: 'assets/images/stopwatch_icon.png'),
];

// List<AlarmInfo> alarms = [
//   AlarmInfo(
//       time: DateTime.now().add(Duration(hours: 1)),
//       title: 'Office',
//       isAlarm: true,
//       repeat: '',
//       colors: 0),
//   AlarmInfo(
//       time: DateTime.now().add(Duration(hours: 2)),
//       title: 'Sport',
//       isAlarm: true,
//       colors: 0),
// ];
