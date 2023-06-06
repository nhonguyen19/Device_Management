
class ConfigurationObject {
  int? id;
  int? device_Type_ID;
  int? configuration_Detail_ID;
  int? status;

  ConfigurationObject({
    this.id,
    this.device_Type_ID,
    this.configuration_Detail_ID,
    this.status
    });

  ConfigurationObject.fromJson(Map<String, dynamic> json) {
    id = json['ID_Configuration'];
    device_Type_ID = json['Device_Type_ID'];
    configuration_Detail_ID = json['Configuration_Detail_ID'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID_Configuration'] = id;
    data['Device_Type_ID'] = device_Type_ID;
    data['Configuration_Detail_ID']=configuration_Detail_ID;
    data['Status']=status;
    return data;
  }
}