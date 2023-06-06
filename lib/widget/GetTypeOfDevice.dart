import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/provider/api_Configuration_Details.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/provider/api_Confuguration_Specification.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:devide_manager/object/SupplierObject.dart';
import 'package:devide_manager/provider/api_Supplier.dart';
import 'package:devide_manager/object/RoomObject.dart';
import 'package:devide_manager/provider/api_Room.dart';
import 'package:devide_manager/object/FacultyOject.dart';
import 'package:devide_manager/provider/api_Faculties.dart';
import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/provider/api_Brand.dart';
import 'package:devide_manager/ui/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

//Tìm Loại sản phẩm
TypeOfDiviceObject? findTypeOfDeviceById(
    List<TypeOfDiviceObject> listTOD, int id) {
  for (var TOD in listTOD) {
    if (TOD.Type_Of_Device_ID == id) {
      return TOD;
    }
  }
  return null;
}

class GetTypeOfDevice extends StatelessWidget {
  int id;
  List<TypeOfDiviceObject> listTypeOfDivice;
  String displayString;
  Color displayColor;
  TypeOfDiviceObject? findTODevice;
  GetTypeOfDevice({Key? key, required this.id,required this.listTypeOfDivice, required this.displayString,required this.displayColor});
  @override
  Widget build(BuildContext context) {
    findTODevice = findTypeOfDeviceById(listTypeOfDivice, id);
   return Text(
                '${displayString}${findTODevice!.Type_Of_Device_Name.toString()}',
                style: TextStyle(
                  fontSize: 14,
                   color: displayColor
                   ),
              );
  }
}

class GetImageTypeOfDevice extends StatelessWidget {
  int id;
  List<TypeOfDiviceObject>? TODevice;
  GetImageTypeOfDevice({Key? key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<TypeOfDiviceObject>>(
          future: TypeOfDeviceProvider.fetchTypeOfDivice(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TODevice = snapshot.data!;
              TypeOfDiviceObject? findTOD = findTypeOfDeviceById(TODevice!, id);
              return Image.network(findTOD!.icon!);
            } else {
              Image.network(
                  'https://img.icons8.com/?size=512&id=HhJuxQZj1lk5&format=png');
            }
            return const SpinKitChasingDots(
              color: Color.fromARGB(255, 31, 60, 114),
              size: 20,
            );
          }),
    );
  }
}

//Tìm kiếm nhà sản xuất theo id
SupplierObject? findSupplierById(List<SupplierObject> listSuppliers, int id) {
  for (var supp in listSuppliers) {
    if (supp.id == id) {
      return supp;
    }
  }
  return null;
}

class GetSupplier extends StatelessWidget {
  int id;
  List<SupplierObject> listSupplier;
  Color displayColor;
  SupplierObject? supplier;
  GetSupplier({Key? key, required this.id,required this.listSupplier,required this.displayColor});
  @override
  Widget build(BuildContext context) {
    supplier = findSupplierById(listSupplier, id);
  return Text(
                '${supplier!.name.toString()}',
                style: TextStyle(
                  fontSize: 14,
                  color: displayColor
                ),
              );
  }
}

//Tìm kiếm phòng
RoomObject? findRoomById(List<RoomObject> listRooms, int id) {
  for (var room in listRooms) {
    if (room.id == id) {
      return room;
    }
  }
  return null;
}

class GetRoom extends StatelessWidget {
  int id;
  Color displayColor;
  List<RoomObject>? rooms;
  GetRoom({Key? key, required this.id,required this.displayColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<RoomObject>>(
          future: RoomProvider.fetchRoom(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              rooms = snapshot.data!;
              RoomObject? findSupp = findRoomById(rooms!, id);
              return Text(
                '${findSupp!.name.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                color:displayColor),
              );
            } else {
              const Text('Hệ thống đang có sự cố!!');
            }
            return const SpinKitChasingDots(
              color: Color.fromARGB(255, 31, 60, 114),
              size: 20,
            );
          }),
    );
  }
}

//Tìm kiếm phòng
FacultyObject? findGetFacultyById(List<FacultyObject> listFaculties, int id) {
  for (var faculty in listFaculties) {
    if (faculty.facultyID == id) {
      return faculty;
    }
  }
  return null;
}

//Tìm kiếm khoa
class GetFaculty extends StatelessWidget {
  int id;
  Color displayColor;
  List<FacultyObject>? faculties;
  GetFaculty({Key? key, required this.id,required this.displayColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<FacultyObject>>(
          future: FacultyProvider.fetchFaculty(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              faculties = snapshot.data!;
              FacultyObject? findfaculty = findGetFacultyById(faculties!, id);
              return Text(
                '${findfaculty!.facultyName.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold,
                color: displayColor),
              );
            } else {
              const Text('Hệ thống đang có sự cố!!');
            }
            return const SpinKitChasingDots(
              color: Color.fromARGB(255, 31, 60, 114),
              size: 20,
            );
          }),
    );
  }
}

BrandObject? findGetBrandById(List<BrandObject> listBrands, int id) {
  for (var brand in listBrands) {
    if (brand.id == id) {
      return brand;
    }
  }
  return null;
}

//Tìm kiếm Thương hiệu
class GetBrand extends StatelessWidget {
  int id;
  List<BrandObject> listBrand;
  String displayString;
  Color displayColor;
  BrandObject? findBrand;
  GetBrand({Key? key, required this.id,required this.listBrand, required this.displayString, required this.displayColor});
  @override
  Widget build(BuildContext context) {
    findBrand = findGetBrandById(listBrand, id);
    return Text(
                '${findBrand!.name.toString()}',
                style: TextStyle(fontSize: 14,
                color: displayColor ),
              );
  }
}

ConfigurationDetailsObject? findGetConfigurationDetailsId(
    List<ConfigurationDetailsObject> listConfigurationDetails, int id) {
  for (var configurationDetail in listConfigurationDetails) {
    if (configurationDetail.id == id) {
      return configurationDetail;
    }
  }
  return null;
}

//Tìm kiếm Thương hiệu
class GetConfigurationDetails extends StatelessWidget {
  int id;
  Color displaycolor;
  String displayString;
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  ConfigurationDetailsObject? findConfigurationDetails ;
  GetConfigurationDetails(
      {Key? key,
      required this.id,
      required this.listConfigurationDetails,
      required this.displaycolor,
      required this.displayString});
  @override
  Widget build(BuildContext context) {
    findConfigurationDetails = findGetConfigurationDetailsId(listConfigurationDetails,id);
      return Text(
                '${findConfigurationDetails!.name.toString()}${displayString}',
                style: TextStyle(fontSize: 16, color: displaycolor),
              );
  }
}

List<ConfigurationSpecificationObject?> findGetConfigurationSpecificationId(
    List<ConfigurationSpecificationObject> listConfigurationSpecifications,
    int id) {
  List<ConfigurationSpecificationObject> ConfigurationSpec = [];
  for (var configurationSpecification in listConfigurationSpecifications) {
    if (configurationSpecification.device_ID == id) {
      ConfigurationSpec.add(configurationSpecification);
    }
  }
  return ConfigurationSpec;
}

//Thông số
class GetConfigurationSpecification extends StatelessWidget {
  int id;
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];
  List<ConfigurationDetailsObject?> findConfigurationDetails = [];
  List<ConfigurationSpecificationObject?> findConfigurationSpecification = [];
  GetConfigurationSpecification(
      {Key? key, required this.id, required this.listConfigurationDetails,required this.listConfigurationSpecification});
  @override
  Widget build(BuildContext context) {
    findConfigurationSpecification = findGetConfigurationSpecificationId(listConfigurationSpecification,id);
    return Container(
      child:  Column(      
                      children: [
                        for (int i = 0;
                            i < findConfigurationSpecification.length;
                            i++)
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: 
                              SingleChildScrollView(
                                scrollDirection:Axis.horizontal,
                                child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Container(
                                      child: (GetConfigurationDetails(
                                        id: findConfigurationSpecification[i]!
                                            .configuration_Detail_ID!,
                                            displayString:': ',
                                        listConfigurationDetails: listConfigurationDetails,
                                        displaycolor: Colors.white,
                                      )
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '${findConfigurationSpecification[i]!.specification.toString()}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70),
                                      ),
                                    ),
                                ],
                              ))
            )],
            ),
    );
  }
}
int? findNumberDeviceId(List<DeviceObject> listDevice, int id) {
 return listDevice.where((device) => device.Type_Of_Device_ID == id).length;
}

//Tìm kiếm khoa
class GetNumberDeviceId extends StatelessWidget {
  int id;
  GetNumberDeviceId({Key? key, required this.id});
  int? NumberDevice;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<DeviceObject>>(
          future: DeviceProvider.fetchDevice(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DeviceObject> listDevice = snapshot.data!;
               NumberDevice = findNumberDeviceId(listDevice!, id);
              return Text(
                'số lượng: ${NumberDevice}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
              );
            } else {
              const Text('Hệ thống đang có sự cố!!');
            }
            return const SpinKitChasingDots(
              color: Color.fromARGB(255, 31, 60, 114),
              size: 20,
            );
          }),
    );
  }
}