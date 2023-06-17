class SupplierObject {
  int? id;
  String? name;
  String? address;
  String? phone_Number;
  int? status;

  SupplierObject({
    this.id,
     this.name,
     this.address,
     this.phone_Number,
     this.status
     });

  SupplierObject.fromJson(Map<String, dynamic> json) {
    id = json['Supplier_ID'];
    name = json['Supplier_Name'];
    address = json['Address'];
    phone_Number = json['Phone_Number'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Supplier_ID'] = id;
    data['Supplier_Name'] = name;
    data['Address']=address;
    data['phone_Number']=phone_Number;
    data['Status']=status;
    return data;
  }
}