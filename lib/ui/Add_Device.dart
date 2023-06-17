import 'dart:io';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddDeviceScreen extends StatefulWidget {
  List<DeviceObject> listDevice;
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails;
  AddDeviceScreen(
      {super.key,
      required this.listDevice,
      required this.listTypeOfDivice,
      required this.listConfiguration,
      required this.listConfigurationDetails});

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState(
        listDevice: listDevice,
        listTypeOfDivice: listTypeOfDivice,
        listConfiguration: listConfiguration,
        listConfigurationDetails: listConfigurationDetails,
      );
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  List<DeviceObject> listDevice;
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails;
  List<ConfigurationObject> tempListConfiguration = [];
  List<ConfigurationDetailsObject> tempListConfigurationDetails = [];
  List<ConfigurationSpecificationObject> inputListConfigurationSpecification =
      [];
  late String _deviceName;
  late String _deviceType;
  int? _deviceQuantity;
  late String _deviceDescription;
  File? _image;
  String? imagePath;
  _AddDeviceScreenState(
      {required this.listDevice,
      required this.listTypeOfDivice,
      required this.listConfiguration,
      required this.listConfigurationDetails});
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  List<Map<String, dynamic>> typeOfDeviceOptions = [];
  int selectedTypeOfDivice = 1;
  void initState() {
    super.initState();
    GetTypeOfDevice();
  }

  Future<void> GetTypeOfDevice() async {
    for (var item in listTypeOfDivice) {
      Map<String, dynamic> addTypeOfDevice = {
        'value': item.Type_Of_Device_ID,
        'label': item.Type_Of_Device_Name
      };
      typeOfDeviceOptions.add(addTypeOfDevice);
    }
  }

  Widget InputTypeOfDevice(int id) {
    tempListConfiguration = listConfiguration
        .where((listConfiguration) => listConfiguration.device_Type_ID == id)
        .toList();
    for (var item in tempListConfiguration) {
      for (var itemDetail in listConfigurationDetails) {
        if (item.configuration_Detail_ID == itemDetail.id) {
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
                    decoration: InputDecoration(
                        labelText:
                            '${tempListConfigurationDetails[index].name}'),
                    onSaved: (value) {
                      if (value != null) {
                        setState(() {
                          inputListConfigurationSpecification[index]
                                  .configuration_Detail_ID =
                              tempListConfigurationDetails[index].id;
                          inputListConfigurationSpecification[index]
                              .specification = value;
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
                      decoration:
                          const InputDecoration(labelText: 'Tên thiết bị'),
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
                          selectedTypeOfDivice = value!;
                        });
                      },
                      items: typeOfDeviceOptions.map((option) {
                        return DropdownMenuItem<int>(
                          value: option['value'],
                          child: Text(option['label']),
                        );
                      }).toList(),
                    ),
                    Container(
                      child: InputTypeOfDevice(selectedTypeOfDivice),
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
        ));
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
