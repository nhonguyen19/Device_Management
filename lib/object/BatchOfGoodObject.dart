class BatchOfGoodObject {
  int? id;
  String? dateImport;

  BatchOfGoodObject({
    this.id,
    this.dateImport
    });

  BatchOfGoodObject.fromJson(Map<String, dynamic> json) {
    id = json['Batch_Of_Goods_ID'];
    dateImport = json['Date_Of_Import'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Batch_Of_Goods_ID'] = id;
    data['Date_Of_Import'] = dateImport;
    return data;
  }
}