import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/RoomObject.dart';
import 'package:devide_manager/object/SupplierObject.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Brand.dart';
import 'package:devide_manager/provider/api_Configuration_Details.dart';
import 'package:devide_manager/provider/api_Confuguration_Specification.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/provider/api_Supplier.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'Devices.dart';

class Type_Of_Device_In_Room_Screen extends StatefulWidget {
  RoomObject room;
  List<DeviceObject> listDevice;
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<BrandObject> listBrand ;
  List<SupplierObject> listSuppliers;
  List<ConfigurationDetailsObject> listConfigurationDetails ;
  List<ConfigurationSpecificationObject> listConfigurationSpecification ;
  Type_Of_Device_In_Room_Screen(
      {Key? key,
      required this.room,
      required this.listDevice,
      required this.listTypeOfDivice,
    required this.listBrand,
    required this.listSuppliers,
    required this.listConfigurationDetails,
    required this.listConfigurationSpecification
      });

  @override
  _Type_Of_Device_In_Room_Screen_State createState() =>
      _Type_Of_Device_In_Room_Screen_State(
          room: room,
          listDevice: listDevice,
          listTypeOfDivice: listTypeOfDivice,
          listBrand: listBrand,
        listSuppliers: listSuppliers,
        listConfigurationDetails: listConfigurationDetails,
        listConfigurationSpecification: listConfigurationSpecification,);
}

class _Type_Of_Device_In_Room_Screen_State
    extends State<Type_Of_Device_In_Room_Screen> {
  RoomObject room;
  List<DeviceObject> listDevice;
  List<TypeOfDiviceObject> listTypeOfDivice;
    List<BrandObject> listBrand ;
  List<SupplierObject> listSuppliers;
  List<ConfigurationDetailsObject> listConfigurationDetails ;
  List<ConfigurationSpecificationObject> listConfigurationSpecification ;
  bool _isSearching = false;
  List<TypeOfDiviceObject> _type_Of_Devices = [];
  List<TypeOfDiviceObject> _type_Of_Devices_Display = [];
  List<DeviceObject> tempListDevice = [];
  List<TypeOfDiviceObject> tempListTypeOfDevice = [];
  _Type_Of_Device_In_Room_Screen_State(
      {Key? key,
      required this.room,
      required this.listDevice,
      required this.listTypeOfDivice,
    required this.listBrand,
    required this.listSuppliers,
    required this.listConfigurationDetails,
    required this.listConfigurationSpecification});
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    fetchTypeOfDevice();
  }

  void dispose() {
    super.dispose();
  }

  Future<void> fetchTypeOfDevice() async {
    try {
      if (!isRefresh) {
        isRefresh = true;
      } else {
        listDevice = await DeviceProvider.fetchDevice(http.Client());
        listTypeOfDivice =
            await TypeOfDeviceProvider.fetchTypeOfDivice(http.Client());
        listBrand = await BrandProvide.fetchBrand(http.Client());
        listSuppliers = await SupplierProvider.fetchSupplier(http.Client());
        listConfigurationDetails =
            await ConfigurationDetailsProvide.fetchConfigurationDetails(
                http.Client());
        listConfigurationSpecification = await ConfigurationSpecificationProvide
            .fetchConfigurationSpecification(http.Client());
        tempListDevice.clear();
        tempListTypeOfDevice.clear();
      }

      //Lấy những thiết bị trong phòng
      tempListDevice = listDevice
          .where((DeviceObject) => DeviceObject.Room_ID == room.id)
          .toList();

      //Lấy những loại thiết bị trong phòng đó
      for (var item in listTypeOfDivice) {
        if (tempListDevice
                .where((tempListDevice) =>
                    tempListDevice.Type_Of_Device_ID == item.Type_Of_Device_ID)
                .length >
            0) {
          tempListTypeOfDevice.add(item);
        }
      }
      listTypeOfDivice = tempListTypeOfDevice;
      setState(() {
        _type_Of_Devices = listTypeOfDivice;
        _type_Of_Devices_Display = listTypeOfDivice;
      });
    } catch (error) {
      print('Error fetching device: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching device. Please try again later.'),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar(),
      body: RefreshIndicator(
        onRefresh: fetchTypeOfDevice,
        child: _buildRoomList(),
      ),
    );
  }

  AppBar _searchBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 31, 60, 114),
      title: _isSearching
          ? TextField(
              style: TextStyle(color: Colors.white),
              autofocus: true, // Tự động focus vào TextField khi hiển thị
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  _type_Of_Devices_Display =
                      _type_Of_Devices.where((listTypeOfDivice) {
                    return listTypeOfDivice.Type_Of_Device_Name!
                        .toLowerCase()
                        .contains(text);
                  }).toList();
                });
              },
            )
          : Text('Thiết bị phòng ${room.name.toString()}'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRoomList() {
    if (_type_Of_Devices_Display.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
        itemCount: _type_Of_Devices_Display.length,
        itemBuilder: (context, index) => _buildTypeOfDeviceItem(index));
  }

  Widget _buildTypeOfDeviceItem(int index) {
    String displayStatus;
    Color colorStatus;
    // if(_type_Of_Devices_Display[index].status == 0){
    //   displayStatus ='Không hoạt động';
    //   colorStatus = Colors.red;
    // }
    // else if(_type_Of_Devices_Display[index].status == 1){
    //   displayStatus = 'Đang hoạt động';
    //   colorStatus = Colors.green.shade300;
    // }
    //  else if(_type_Of_Devices_Display[index].status == 2){
    //   displayStatus = 'Đang tu sửa';
    //   colorStatus = Colors.orange;
    // }
    // else{
    //   displayStatus = 'Cần tu sửa';
    //   colorStatus = Colors.yellow;
    // }
    return Card(
      child: Column(
        children: [
          ListTile(
              title: Text(
                _type_Of_Devices_Display[index].Type_Of_Device_Name!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 31, 60, 114),
                ),
              ),
              subtitle: Text(
                'số lượng: ${tempListDevice.where((tempListDevice) => tempListDevice.Type_Of_Device_ID == _type_Of_Devices_Display[index].Type_Of_Device_ID).length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DevicePage(
                              typeOfDevice: _type_Of_Devices_Display[index].Type_Of_Device_ID!,
                              room: room.id!,
                              listDevice: listDevice,
                              listTypeOfDivice: listTypeOfDivice,
                              listBrand: listBrand,
                              listSuppliers: listSuppliers,
                              listConfigurationDetails:
                                  listConfigurationDetails,
                              listConfigurationSpecification:
                                  listConfigurationSpecification,
                            ),
                          ),
                        );
                },
              )),
        ],
      ),
    );
  }
}
