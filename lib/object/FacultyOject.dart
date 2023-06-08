class FacultyObject {
  int? facultyID;
  String? facultyName;
  String? image;
  int? status;

  FacultyObject(
      {this.facultyID,
      this.facultyName,
      this.image,
      this.status,
     });

  FacultyObject.fromJson(Map<String, dynamic> json) {
    facultyID = json['Faculty_ID'];
    facultyName = json['Faculty_Name'];
    image = json['Image'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Faculty_ID'] = this.facultyID;
    data['Faculty_Name'] = this.facultyName;
    data['Image'] = this.image;
    data['Status'] = this.status;
    return data;
  }

  where(bool Function(dynamic faculty) param0) {}
}