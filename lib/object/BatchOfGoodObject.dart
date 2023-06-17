class BatchOfGoodObject {
  int? id;
  String? dateImport;
  int? status;

  BatchOfGoodObject({
    this.id,
    this.dateImport,
    this.status
    });

  BatchOfGoodObject.fromJson(Map<String, dynamic> json) {
    id = json['Batch_Of_Goods_ID'];
    dateImport = json['Date_Of_Import'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Batch_Of_Goods_ID'] = id;
    data['Date_Of_Import'] = dateImport;
    data['Status'] = status;
    return data;
  }
}