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
import 'package:devide_manager/provider/api_Brand.dart';
import 'package:devide_manager/provider/api_Configuration.dart';
import 'package:devide_manager/provider/api_Configuration_Details.dart';
import 'package:devide_manager/provider/api_Confuguration_Specification.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/provider/api_Room.dart';
import 'package:devide_manager/provider/api_Supplier.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'TypeOfDevices_In_Room.dart';
import 'package:http/http.dart' as http;

class RoomScreen extends StatefulWidget {
  List<RoomObject> listRoom;
  List<FacultyObject> listFaculty=[];
  List<DeviceObject> listDevice;
  List<BatchOfGoodObject> listBatchOfGood= [];
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<BrandObject> listBrand ;
  List<SupplierObject> listSuppliers;
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails ;
  List<ConfigurationSpecificationObject> listConfigurationSpecification ;
  RoomScreen(
      {Key? key,
    required this.listRoom,
    required this.listFaculty,
    required this.listDevice,
    required this.listBatchOfGood,
    required this.listTypeOfDivice,
    required this.listBrand,
    required this.listSuppliers,
    required this.listConfiguration,
    required this.listConfigurationDetails,
    required this.listConfigurationSpecification,});

  @override
  _RoomScreenState createState() => _RoomScreenState(
      listRoom: listRoom,
      listFaculty:listFaculty,
      listDevice: listDevice,
      listBatchOfGood: listBatchOfGood,
      listTypeOfDivice: listTypeOfDivice,
      listBrand: listBrand,
      listSuppliers: listSuppliers,
      listConfiguration:listConfiguration,
      listConfigurationDetails: listConfigurationDetails,
      listConfigurationSpecification: listConfigurationSpecification,);
}

class _RoomScreenState extends State<RoomScreen> {
  List<RoomObject> listRoom;
  List<FacultyObject> listFaculty=[];
  List<DeviceObject> listDevice;
  List<BatchOfGoodObject> listBatchOfGood=[];
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<BrandObject> listBrand ;
  List<SupplierObject> listSuppliers;
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails ;
  List<ConfigurationSpecificationObject> listConfigurationSpecification ;
  bool _isSearching = false;
  List<RoomObject> _rooms = [];
  List<RoomObject> _roomsDisplay = [];
  _RoomScreenState({
    Key? key,
    required this.listRoom,
    required this.listFaculty,
    required this.listDevice,
   required this.listBatchOfGood,
    required this.listTypeOfDivice,
    required this.listBrand,
    required this.listSuppliers,
    required this.listConfiguration,
    required this.listConfigurationDetails,
    required this.listConfigurationSpecification,
  });
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      if (!isRefresh) {
        listRoom = listRoom;
        isRefresh = true;
      } else {
        listRoom = await RoomProvider.fetchRoom(http.Client());
        listDevice = await DeviceProvider.fetchDevice(http.Client());
        listTypeOfDivice =
            await TypeOfDeviceProvider.fetchTypeOfDivice(http.Client());
        listBrand = await BrandProvide.fetchBrand(http.Client());
        listSuppliers = await SupplierProvider.fetchSupplier(http.Client());
         listConfiguration =
            await ConfigurationProvide.fetchConfiguration(
                http.Client());
        listConfigurationDetails =
            await ConfigurationDetailsProvide.fetchConfigurationDetails(
                http.Client());
        listConfigurationSpecification = await ConfigurationSpecificationProvide
            .fetchConfigurationSpecification(http.Client());
      }
      setState(() {
        _rooms = listRoom;
        _roomsDisplay = listRoom;
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
        onRefresh: fetchRooms,
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
                  _roomsDisplay = _rooms.where((listRoom) {
                    return listRoom.name!.toLowerCase().contains(text);
                  }).toList();
                });
              },
            )
          : const Text('Danh sách phòng'),
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
    if (_roomsDisplay.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
        itemCount: _roomsDisplay.length,
        itemBuilder: (context, index) => _buildRoomItem(index));
  }

  Widget _buildRoomItem(int index) {
    String displayStatus;
    Color colorStatus;
    if (_roomsDisplay[index].status == 0) {
      displayStatus = 'Không hoạt động';
      colorStatus = Colors.red;
    } else if (_roomsDisplay[index].status == 1) {
      displayStatus = 'Đang hoạt động';
      colorStatus = Colors.green.shade300;
    } else if (_roomsDisplay[index].status == 2) {
      displayStatus = 'Đang tu sửa';
      colorStatus = Colors.orange;
    } else {
      displayStatus = 'Cần tu sửa';
      colorStatus = Colors.yellow;
    }
    return Card(
      child: Column(
        children: [
          ListTile(
              title: Text(
                _roomsDisplay[index].name!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 31, 60, 114),
                ),
              ),
              subtitle: Text(
                displayStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorStatus,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
               onPressed: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Type_Of_Device_In_Room_Screen(
        listFaculty: listFaculty,
        listBatchOfGood: listBatchOfGood,
        listRoom: listRoom,
        listDevice: listDevice,
        listTypeOfDivice: listTypeOfDivice,
        room: _roomsDisplay[index],
        listBrand: listBrand,
        listConfiguration:listConfiguration,
        listConfigurationDetails: listConfigurationDetails,
        listConfigurationSpecification: listConfigurationSpecification,
        listSuppliers: listSuppliers,
      ),
    ),
  ).then((result) async {
          listRoom = await RoomProvider.fetchRoom(http.Client());
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
  });
},
              )
              ),
        ],
      ),
    );
  }
}