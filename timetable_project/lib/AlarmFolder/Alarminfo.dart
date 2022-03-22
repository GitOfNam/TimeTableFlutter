class AlarmInfo {
  int id;
  DateTime time;
  String title;
  bool isAlarm;
  String repeat;
  int colors;

  AlarmInfo(
      {this.id, this.time, this.title, this.isAlarm, this.repeat, this.colors});
  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        time: DateTime.parse(json["time"]),
        title: json["title"] == null ? 'Alarm' : json["title"],
        isAlarm: json["isAlarm"] == null ? true : false,
        repeat: json["repeat"] == null ? 'Daily' : json["repeat"],
        colors: json["colors"],
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "time": time.toIso8601String(),
        "title": title,
        "isAlarm": isAlarm,
        "repeat": repeat,
        "colors": colors,
      };
}
