import 'package:timetable_project/enum.dart';
import 'package:flutter/foundation.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String title;
  String image;

  MenuInfo(this.menuType, {this.title, this.image});
  updateMenu(MenuInfo menuInfo) {
    this.menuType = menuInfo.menuType;
    this.title = menuInfo.title;
    this.image = menuInfo.image;

    notifyListeners();
  }
}
