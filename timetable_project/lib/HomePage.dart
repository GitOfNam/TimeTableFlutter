import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_project/ScheduleFolder/SchedulePage.dart';
import 'package:timetable_project/StopWatch.dart';
import 'package:timetable_project/TimerPage.dart';
import 'package:timetable_project/clock_view.dart';
import 'package:timetable_project/enum.dart';
import 'package:timetable_project/menuinfo.dart';
import 'package:timetable_project/AlarmFolder/AlarmPage.dart';
import 'package:timetable_project/ClockPage.dart';
import 'package:timetable_project/data.dart';
import 'package:timetable_project/Color/theme_data.dart';
import 'package:timetable_project/ScheduleFolder/SchedulePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // var now = DateTime.now();
    // var formartTime = DateFormat('HH:mm').format(now);
    // var formartHour = DateFormat('EEE, d MMM').format(now);
    // var timezone = now.timeZoneOffset.toString().split('.').first;
    // var offset = '';
    // if (!timezone.startsWith('-')) offset = '+';
    // print(timezone);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.pageBackgroundColor,
      body: Row(
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: menuItems
                  .map((currentMenuInfo) => buildMenuButton(currentMenuInfo))
                  .toList()),
          VerticalDivider(
            color: CustomColors.dividerColor,
            width: 1,
          ),
          Expanded(
            child: Consumer<MenuInfo>(
              builder: (BuildContext context, MenuInfo value, Widget child) {
                if (value.menuType == MenuType.clock)
                  return ClockPage();
                else if (value.menuType == MenuType.alarm)
                  return AlarmPage();
                else if (value.menuType == MenuType.schedule)
                  return SchedulePage();
                else if (value.menuType == MenuType.timer)
                  return TimerPage();
                else if (value.menuType == MenuType.stopwatch)
                  return StopWatchPage();
                else
                  return Container(
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(fontSize: 20),
                            children: <TextSpan>[
                          TextSpan(text: 'Form mới \n'),
                          TextSpan(
                              text: value.title, style: TextStyle(fontSize: 48))
                        ])),
                  );
                //return Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Flexible(
                //         flex: 1,
                //         fit: FlexFit.tight,
                //         child: Text('Clock',
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w700,
                //                 fontSize: 24)),
                //       ),
                //       Flexible(
                //         flex: 2,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             Text(formartTime,
                //                 style: TextStyle(
                //                     color: Colors.white, fontSize: 64)),
                //             Text(formartHour,
                //                 style: TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w300,
                //                     fontSize: 20)),
                //           ],
                //         ),
                //       ),
                //       Flexible(
                //           flex: 4,
                //           fit: FlexFit.tight,
                //           child: Align(
                //               alignment: Alignment.center,
                //               child: ClockView(
                //                 size: MediaQuery.of(context).size.height / 4,
                //               ))),
                //       Flexible(
                //         flex: 2,
                //         fit: FlexFit.tight,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             Text('Timezone',
                //                 style: TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w500,
                //                     fontSize: 20)),
                //             SizedBox(height: 16),
                //             Row(
                //               children: <Widget>[
                //                 Icon(
                //                   Icons.language,
                //                   color: Colors.white,
                //                 ),
                //                 SizedBox(width: 16),
                //                 Text('UTC' + offset + timezone,
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 24,
                //                     ))
                //               ],
                //             )
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
            color: currentMenuInfo.menuType == value.menuType
                ? CustomColors.menuBackgroundColor
                : Colors.transparent,
            onPressed: () {
              var menuInfo = Provider.of<MenuInfo>(context, listen: false);
              menuInfo.updateMenu(currentMenuInfo);
            },
            child: Column(
              children: <Widget>[
                Image.asset(currentMenuInfo.image, scale: 1.5),
                SizedBox(height: 16),
                Text(
                  currentMenuInfo.title ?? '',
                  style: TextStyle(
                    color: CustomColors.primaryTextColor,
                    fontSize: 14,
                    fontFamily: 'avenir',
                  ),
                )
              ],
            ));
      },
    );
  }
}
