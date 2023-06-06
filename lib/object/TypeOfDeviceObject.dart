class TypeOfDiviceObject {
  int? Type_Of_Device_ID ;
  String? Type_Of_Device_Name;
  String? Image;
  String? icon;

  TypeOfDiviceObject({this.Type_Of_Device_ID, this.Type_Of_Device_Name,this.Image});

  TypeOfDiviceObject.fromJson(Map<String, dynamic> json) {
    Type_Of_Device_ID = json['Type_Of_Device_ID'];
    Type_Of_Device_Name = json['Type_Of_Device_Name'];
    Image = json['Image'];
    icon = json['Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type_Of_Device_ID'] = Type_Of_Device_ID;
    data['Type_Of_Device_ID'] = Type_Of_Device_Name;
    data['Image'] = Image;
    data['Icon'] = icon;
    return data;
  }
}