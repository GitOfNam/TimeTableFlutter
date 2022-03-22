class ScheduleInfo {
  int id;
  DateTime time;
  String title;
  String address;
  String content;
  int colors;

  ScheduleInfo(
      {this.id,
      this.time,
      this.title,
      this.address,
      this.content,
      this.colors});
  factory ScheduleInfo.fromMap(Map<String, dynamic> json) => ScheduleInfo(
        id: json["id"],
        time: DateTime.parse(json["time"]),
        title: json["title"],
        address: json["address"] == null ? "Tại..." : json["address"],
        content: json["content"] == null ? "Nhắc nhở..." : json["content"],
        colors: json["colors"],
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "time": time.toIso8601String(),
        "title": title,
        "address": address,
        "content": content,
        "colors": colors,
      };
}
