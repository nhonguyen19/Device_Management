class SupplierObject {
  int? id;
  String? name;
  String? address;
  int? phone_Number;

  SupplierObject({
    this.id,
     this.name,
     this.address,
     this.phone_Number});

  SupplierObject.fromJson(Map<String, dynamic> json) {
    id = json['Supplier_ID'];
    name = json['Supplier_Name'];
    address = json['Address'];
    phone_Number = json['Phone_Number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Supplier_ID'] = id;
    data['Supplier_Name'] = name;
    data['Address']=address;
    data['phone_Number']=phone_Number;
    return data;
  }
}