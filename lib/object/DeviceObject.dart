class DeviceObject {
  int? id ;
  int? Type_Of_Device_ID;
  int? Supplier_ID;
  int? Batch_Of_Goods_ID;
  int? Room_ID;
  int? Faculty_ID;
  int? Brand_ID;
  String? Device_Name;
  String? Image;
  String? QRCode;
  String? Price;
  String? Warranty_Period;
  int? Status;
  String? Note;
  String? Description;


  DeviceObject({
    this.id,
    this.Type_Of_Device_ID,
    this.Supplier_ID,
    this.Batch_Of_Goods_ID,
    this.Room_ID,
    this.Faculty_ID,
    this.Brand_ID,
    this.Device_Name,
    this.Image,
    this.QRCode,
    this.Price,
    this.Warranty_Period,
    this.Status,
    this.Note,
    this.Description});

  DeviceObject.fromJson(Map<String, dynamic> json) {
    id = json['Device_ID'];
    Type_Of_Device_ID = json['Type_Of_Device_ID'];
    Supplier_ID = json['Supplier_ID'];
    Batch_Of_Goods_ID = json['Batch_Of_Goods_ID'];
    Room_ID = json['Room_ID'];
    Faculty_ID = json['Faculty_ID'];
    Brand_ID = json['Brand_ID'];
    Device_Name = json['Device_Name'];
    Image = json['Image'];
    QRCode = json['QRCode'];
    Price = json['Price'];
    Warranty_Period = json['Warranty_Period'];
    Status = json['Status'];
    Note = json['Note'];
    Description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Device_ID'] = id;
    data['Type_Of_Device_ID'] = Type_Of_Device_ID;
    data['Supplier_ID'] = Supplier_ID;
    data['Batch_Of_Goods_ID'] = Batch_Of_Goods_ID;
    data['Room_ID'] = Room_ID;
    data['Brand_ID'] = Brand_ID;
    data['Faculty_ID'] = Faculty_ID;
    data['Device_Name'] = Device_Name;
    data['Image'] = Image;
    data['QRCode'] = QRCode;
    data['Price'] = Price;
    data['Warranty_Period'] = Warranty_Period;
    data['Status'] = Status;
    data['Note'] = Note;
    data['Description'] = Description; 
    return data;
  }
}