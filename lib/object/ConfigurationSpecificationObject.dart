
class ConfigurationSpecificationObject {
  int? device_ID;
  int? configuration_Detail_ID;
  String? specification;
  int? brand_ID;
  int? status;
  String? note;

  ConfigurationSpecificationObject({
    this.device_ID,
    this.configuration_Detail_ID,
    this.specification,
    this.brand_ID,
    this.status,
    this.note
    });

  ConfigurationSpecificationObject.fromJson(Map<String, dynamic> json) {
    device_ID = json['Device_ID'];
    configuration_Detail_ID = json['Configuration_Detail_ID'];
    specification = json['Specification'];
    brand_ID = json['Brand_ID'];
    status = json['Status'];
    note = json['Note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Device_ID'] = device_ID;
    data['Configuration_Detail_ID'] = configuration_Detail_ID;
    data['Specification']=specification;
    data['Brand_ID'] = brand_ID;
    data['Status'] = status;
    data['Note']=note;
    return data;
  }
}