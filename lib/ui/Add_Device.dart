import 'dart:io';
import 'package:devide_manager/object/BatchOfGoodObject.dart';
import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/FacultyOject.dart';
import 'package:devide_manager/object/RoomObject.dart';
import 'package:devide_manager/object/SupplierObject.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/widget/GetTypeOfDevice.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDeviceScreen extends StatefulWidget {
  List<DeviceObject> listDevice;
  List<SupplierObject> listSuppliers;
  List<BatchOfGoodObject> listBatchOfGood;
  List<RoomObject> listRoom;
  List<FacultyObject> listFaculty;
  List<BrandObject> listBrand;
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails;
  AddDeviceScreen(
      {super.key,
      required this.listDevice,
      required this.listSuppliers,
      required this.listBatchOfGood,
      required this.listRoom,
      required this.listFaculty,
      required this.listBrand,
      required this.listTypeOfDivice,
      required this.listConfiguration,
      required this.listConfigurationDetails});

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState(
      listDevice: listDevice,
      listSuppliers: listSuppliers,
      listBatchOfGood: listBatchOfGood,
      listRoom: listRoom,
      listFaculty: listFaculty,
      listBrand: listBrand,
      listTypeOfDivice: listTypeOfDivice,
      listConfiguration:listConfiguration,
      listConfigurationDetails: listConfigurationDetails,
      );
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  //Danh sách được tryền vào
  List<DeviceObject> listDevice;
  List<SupplierObject> listSuppliers;
  List<BatchOfGoodObject> listBatchOfGood;
  List<RoomObject> listRoom;
  List<FacultyObject> listFaculty;
  List<BrandObject> listBrand;
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails;
  
  // DropDownMenu
  // 1. Loại thiết bị
  List<Map<String, dynamic>> typeOfDeviceOptions = [];
  int selectedTypeOfDivice = 1;
  // 2. Nhà cung cấp
  List<Map<String, dynamic>> supplierOptions = [];
  int selectedSupplier = 1;
  // 3. Lô hàng
  List<Map<String, dynamic>> batchOfGoodOptions = [];
   int selectedBatchOfGood = 1;
  // 4. Phòng
  List<Map<String, dynamic>> roomOptions = [];
   int selectedRoom = 1;
  // 5. Khoa
  List<Map<String, dynamic>> facultyOptions = [];
   int selectedFaculty = 1;
  // 5. Thương hiệu
  List<Map<String, dynamic>> brandOptions = [];
  int selectedBrand = 1;


  List<ConfigurationObject> tempListConfiguration=[];
  List<ConfigurationDetailsObject> tempListConfigurationDetails=[];
  List<ConfigurationSpecificationObject> inputListConfigurationSpecification=[];
  late String _deviceName;
  late String _deviceType;
  int? _deviceQuantity;
  late String _deviceDescription;
  File? _image;
  String? imagePath ;
  _AddDeviceScreenState(
      {required this.listDevice,
      required this.listSuppliers,
      required this.listBatchOfGood,
      required this.listRoom,
      required this.listFaculty,
      required this.listBrand,
      required this.listTypeOfDivice,
      required this.listConfiguration,
      required this.listConfigurationDetails});
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  
  void initState() {
  super.initState();
  GetTypeOfDevice();
  GetSupplier();
  GetBatchOfGoodOptions();
  GetRoom();
  GetFaculty();
  GetBrand();
}
  //Truyền danh sách nhà cung cấp còn hoạt đông vô Map
  Future<void> GetSupplier() async{ 
    for(var item in listSuppliers){
      // if(item.status == 1){
        Map<String, dynamic> addsupplier = {'value' : item.id,'label':item.name};
       supplierOptions.add(addsupplier);
      // }
    }

  }
  Future<void> GetBatchOfGoodOptions() async{ 
    for(var item in listBatchOfGood){
      if(item.status == 1){
         Map<String, dynamic> addbatchOfGood = {'value' : item.id,'label':item.id.toString()};
       batchOfGoodOptions.add(addbatchOfGood);
      }
    }

  }

  //Truyền danh sách phòng còn hoạt đông vô Map
   Future<void> GetRoom() async{ 
    for(var item in listRoom){
      if(item.status == 1){
         Map<String, dynamic> addRoom = {'value' : item.id,'label':item.name};
       roomOptions.add(addRoom);
      }
    }
  }

  //Truyền danh sách khoa còn hoạt đông vô Map
  Future<void> GetFaculty() async{  
    for(var item in listFaculty){
      if(item.status == 1){
         Map<String, dynamic> addFaculty = {'value' : item.facultyID,'label':item.facultyName};
       facultyOptions.add(addFaculty);
      }
    }
  }

  //Truyền danh sách thương hiệu còn hoạt đông vô Map
  Future<void> GetBrand() async{  
    for(var item in listBrand){
      if(item.status == 1){
         Map<String, dynamic> addBrand = {'value' : item.id,'label':item.name};
       brandOptions.add(addBrand);
      }
    }
  }

//Truyền danh sách loại thiết bị còn hoạt đông vô Map
  Future<void> GetTypeOfDevice() async{
    for(var item in listTypeOfDivice){
      if(item.status == 1){
         Map<String, dynamic> addTypeOfDevice = {'value' : item.Type_Of_Device_ID,'label':item.Type_Of_Device_Name};
       typeOfDeviceOptions.add(addTypeOfDevice);
      }
    }
  }

  // Lấy các cấu hình tương ứng với loại thiết bị
  Widget InputTypeOfDevice(int id){
    tempListConfiguration =listConfiguration.where((listConfiguration) => listConfiguration.device_Type_ID == id).toList();
    for(var item in tempListConfiguration){
      for(var itemDetail in listConfigurationDetails){
        if(item.configuration_Detail_ID == itemDetail.id){
          tempListConfigurationDetails.add(itemDetail);
        }
      }
    }

    return tempListConfigurationDetails.isNotEmpty
    ? ListView.builder(
        shrinkWrap: true,
        itemCount: tempListConfigurationDetails.length,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              child: TextFormField(
                  decoration: InputDecoration(labelText: '${tempListConfigurationDetails[index].name}'),
                  onSaved: (value) {
                    if (value != null) {
                      setState(() {
                        inputListConfigurationSpecification[index].configuration_Detail_ID = tempListConfigurationDetails[index].id;
                        inputListConfigurationSpecification[index].specification = value;
                      });
                    }
                  },
                ),
            ),
          );
        },
      )
    : Container();
  }

  

  Widget _buildImagePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh',
          style: TextStyle(
            color: Color.fromARGB(255, 31, 60, 114),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color.fromARGB(255, 31, 60, 114),
              image: _image != null
                  ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _image == null
                ? Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 48,
                  )
                : null,
          ),
        ),
      ],
    );
  }
   Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 60, 114),
        title: const Text('Thêm thiết bị mới'),
      ),
      body: Container(
        child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                 _buildImagePreview(),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tên thiết bị'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên thiết bị';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      setState(() => _deviceName = value);
                    }
                  },
                ),

                //Hiển thị loại thiết bị
                  DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Loại thiết bị',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
                value: selectedTypeOfDivice,
                onChanged: (int? value) {
                     tempListConfiguration.clear();
                     tempListConfigurationDetails.clear();
                  setState(() {
                    selectedTypeOfDivice = value?? 1;
                  });
                },
                items: typeOfDeviceOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
              ),

              // //Hiển thị nhà cung cấp
                 DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Nhà cung cấp',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
                value: selectedSupplier,
                onChanged: (int? value) {
                  setState(() {
                    selectedSupplier = value?? 1;
                  });
                },
                items: supplierOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
              ),

              //Hiển thị lô hàng
               DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Lô hàng',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
                value: selectedBatchOfGood,
                onChanged: (int? value) {
                  setState(() {
                    selectedBatchOfGood = value?? 1;
                  });
                },
                items: batchOfGoodOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
              ),

               //Hiển thị phòng
               DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Phòng',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
                value: selectedRoom,
                onChanged: (int? value) {
                  setState(() {
                    selectedRoom = value?? 1;
                  });
                },
                items: roomOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
              ),

                //Hiển thị phòng
               DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Khoa phụ trách',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
                value: selectedFaculty,
                onChanged: (int? value) {
                  setState(() {
                    selectedFaculty = value?? 1;
                  });
                },
                items: facultyOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
              ),

               //Hiển thị thương hiệu
               DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Thương hiệu',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 31, 60, 114),
                  ),
                ),
                value: selectedBrand,
                onChanged: (int? value) {
                  setState(() {
                    selectedBrand = value?? 1;
                  });
                },
                items: brandOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: option['value'],
                    child: Text(option['label']),
                  );
                }).toList(),
              ),


                TextFormField(
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      setState(() => _deviceDescription = value);
                    }
                  },
                ),

                 TextFormField(
                  decoration: const InputDecoration(labelText: 'Số lượng'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số lượng';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      setState(() => _deviceQuantity = int.tryParse(value));
                    }
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('Cấu hình',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),
                ),
                SizedBox(height: 16.0),
                Container(
                child: InputTypeOfDevice(selectedTypeOfDivice),
              ),
              
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Thêm mới'),
                ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }

  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery, // hoặc ImageSource.camera
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
