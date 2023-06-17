class TeacherInformationObject {
  int? id;
  int? faculty_ID;
  String? image;
  String? userName;
  String? password;
  String? teacher_Name;
  String? phone_Number;
  String? address;
  String? gender;
  String? date_Of_Birth;
  int? status;

  TeacherInformationObject({
    this.id,
    this.faculty_ID,
    this.image,
    this.userName,
    this.password,
    this.teacher_Name,
    this.phone_Number,
    this.gender,
    this.date_Of_Birth,
    this.address,
    this.status
    });

  TeacherInformationObject.fromJson(Map<String, dynamic> json) {
    id = json['ID_Teacher'];
    faculty_ID = json['Faculty_ID'];
    image = json['Image'];
    userName = json['Username'];
    password = json['Password'];
    teacher_Name = json['Teacher_Name'];
    phone_Number = json['Phone_Number'];
    gender = json['Gender'];
    date_Of_Birth = json['Date_Of_Birth'];
    address = json['Address'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID_Teacher '] = id;
    data['Faculty_ID'] = faculty_ID;
    data['Image'] = image;
    data['Username']=userName;
    data['Password']=password;
    data['Teacher_Name']=teacher_Name;
    data['Phone_Number']=phone_Number;
    data['Gender']=gender;
    data['Date_Of_Birth']=date_Of_Birth;
    data['Status ']=status;
    return data;
  }
}