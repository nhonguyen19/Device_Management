class BrandObject {
  int? id;
  String? name;
  int? quantity;
  int? status;

  BrandObject({
    this.id,
    this.name,
    this.quantity,
    this.status});

  BrandObject.fromJson(Map<String, dynamic> json) {
    id = json['Brand_ID'];
    name = json['Brand_Name'];
    quantity = json['Quantity'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Room_Name'] = id;
    data['Room_ID'] = name;
    data['Quantity']=quantity;
    data['Status']=status;
    return data;
  }
}