
class ConfigurationDetailsObject {
  int? id;
  String? name;

  ConfigurationDetailsObject({
    this.id,
    this.name,
    });

  ConfigurationDetailsObject.fromJson(Map<String, dynamic> json) {
    id = json['Configuration_Detail_ID'];
    name = json['Configuration_Name'];
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Configuration_Detail_ID'] = id;
    data['Configuration_Name'] = name;
    return data;
  }
}