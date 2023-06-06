import 'dart:ffi';

class RoomObject {
  int? id;
  String? name;
  String? note;
  int? status;

  RoomObject({this.id, this.name});

  RoomObject.fromJson(Map<String, dynamic> json) {
    id = json['Room_ID'];
    name = json['Room_Name'];
    note = json['Note'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Room_Name'] = id;
    data['Room_ID'] = name;
    data['Note']=note;
    data['Status']=status;
    return data;
  }
}