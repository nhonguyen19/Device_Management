import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:devide_manager/ui/Add_Device.dart';
import 'package:devide_manager/ui/DeviceDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devide_manager/provider/api_Configuration_Details.dart';
import 'package:devide_manager/provider/api_Confuguration_Specification.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/object/SupplierObject.dart';
import 'package:devide_manager/provider/api_Brand.dart';
import 'package:devide_manager/provider/api_Supplier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class DevicePage extends StatefulWidget {
  int typeOfDevice;
  int room; 
  int bath;
  List<DeviceObject> listDevice =[];
  List<TypeOfDiviceObject> listTypeOfDivice=[];
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<ConfigurationObject> listConfiguration=[];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];

  DevicePage(
      {Key? key,
      required this.bath,
      required this.typeOfDevice,
      required this.room,
      required this.listDevice,
      required this.listTypeOfDivice,
      required this.listBrand,
      required this.listSuppliers,
      required this.listConfiguration,
      required this.listConfigurationDetails,
      required this.listConfigurationSpecification});

  @override
  _DeviceState createState() => _DeviceState(bath:bath,typeOfDevice:typeOfDevice,room:room,listDevice:listDevice,listTypeOfDivice: listTypeOfDivice,listBrand:listBrand,listSuppliers:listSuppliers,listConfigurationDetails:listConfigurationDetails,listConfigurationSpecification:listConfigurationSpecification,listConfiguration:listConfiguration);
}

class _DeviceState extends State<DevicePage> {
  int bath;
  int typeOfDevice;
  int room; 
  List<DeviceObject> listDevice =[];
  List<TypeOfDiviceObject> listTypeOfDivice=[];
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<ConfigurationObject> listConfiguration=[];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];
  bool _isSearching = false;
  bool isRefresh = false;
  List<DeviceObject> _device = [];
  List<DeviceObject> _deviceDisplay = [];
  _DeviceState(
      {Key? key,
      required this.bath,
      required this.typeOfDevice,
      required this.room,
      required this.listDevice,
      required this.listTypeOfDivice,
      required this.listBrand,
      required this.listSuppliers,
      required this.listConfiguration,
      required this.listConfigurationDetails,
      required this.listConfigurationSpecification});
  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    try {
      if(!isRefresh){
      listDevice=listDevice;
      isRefresh = true;
    }else{
      listDevice = await DeviceProvider.fetchDevice(http.Client());
    }
      setState(() {
        _device = listDevice.where((listDevice){
          return (typeOfDevice == 0
                            ? listDevice.Type_Of_Device_ID != typeOfDevice
                            : listDevice.Type_Of_Device_ID == typeOfDevice)&&
                  (room == 0
                            ? listDevice.Room_ID != room
                            : listDevice.Room_ID == room)&&
                   (bath == 0
                            ? listDevice.Batch_Of_Goods_ID != bath
                            : listDevice.Batch_Of_Goods_ID == bath);
        }).toList();
        _deviceDisplay = listDevice.where((listDevice){
          return (typeOfDevice == 0
                            ? listDevice.Type_Of_Device_ID != typeOfDevice
                            : listDevice.Type_Of_Device_ID == typeOfDevice)&&
                  (room == 0
                            ? listDevice.Room_ID != room
                            : listDevice.Room_ID == room)&&
                   (bath == 0
                            ? listDevice.Batch_Of_Goods_ID != bath
                            : listDevice.Batch_Of_Goods_ID == bath);
        }).toList();
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
  Future<bool?> _navigateToDeviceAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDeviceScreen(listDevice:listDevice,
        listConfiguration: listConfiguration,
        listConfigurationDetails: listConfigurationDetails,
        listTypeOfDivice: listTypeOfDivice,),
      ),
    );

    if (result == true) {
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar(),
      body:RefreshIndicator(
        onRefresh: fetchDevices,
        child:  _buildDeviceList(),
      ),
       floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 31, 60, 114),
            child: Icon(Icons.add),
            onPressed: () {
              _navigateToDeviceAddScreen().then((shouldReload) {
                if (shouldReload == true) {
                  fetchDevices();
                }
              });
            }));
    
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
                  _deviceDisplay = _device.where((listDevice) {
                    return (listDevice.Device_Name!.toLowerCase().contains(text) ||
                        listDevice.Image!.toLowerCase().contains(text) ||
                        listDevice.Price!.toLowerCase().contains(text) ||
                        listDevice.Warranty_Period!.toLowerCase().contains(text) ||
                        listDevice.Note!.toLowerCase().contains(text) ||
                        listDevice.Description!.toLowerCase().contains(text)) && 
                        (typeOfDevice == 0
                            ? listDevice.Type_Of_Device_ID != typeOfDevice
                            : listDevice.Type_Of_Device_ID == typeOfDevice)&&
                  (room == 0
                            ? listDevice.Room_ID != room
                            : listDevice.Room_ID == room)&&
                   (bath == 0
                            ? listDevice.Batch_Of_Goods_ID != bath
                            : listDevice.Batch_Of_Goods_ID == bath);
                  }).toList();
                });
              },
            )
          : const Text('Danh sách thiết bị'),
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

  Widget _buildDeviceList() {
    if (_deviceDisplay.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
        itemCount: _deviceDisplay.length,
        itemBuilder: (context, index) => _buildDeviceItem(index));
  }

  Widget _buildDeviceItem(int index) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 80, 
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // Bo góc của khung ảnh
                child: Image.network(
                  _deviceDisplay[index].Image.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(_deviceDisplay[index].Device_Name.toString()),
            subtitle: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Device_Details(device: _deviceDisplay[index],listTypeOfDivice: listTypeOfDivice,listBrand: listBrand,listSuppliers:listSuppliers,listConfigurationDetails: listConfigurationDetails,listConfigurationSpecification: listConfigurationSpecification,),
                  ),
                );
              },
              child: const Text(
                'Xem chi tiết',
                style: TextStyle(
                  color: Color.fromARGB(255, 31, 60, 114),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Image.asset(
              _deviceDisplay[index].Status == 1
                  ? 'assets/Gif_Status/automation.gif'
                  : 'assets/Gif_Status/repair.gif',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}

