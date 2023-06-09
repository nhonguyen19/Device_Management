import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/RoomObject.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/provider/api_Room.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'TypeOfDevices_In_Room.dart';
import 'package:http/http.dart' as http;

class RoomScreen extends StatefulWidget {
  List<RoomObject> listRoom;
  List<DeviceObject> listDevice;
  List<TypeOfDiviceObject> listTypeOfDivice;
  RoomScreen(
      {Key? key,
      required this.listRoom,
      required this.listDevice,
      required this.listTypeOfDivice});

  @override
  _RoomScreenState createState() => _RoomScreenState(
      listRoom: listRoom,
      listDevice: listDevice,
      listTypeOfDivice: listTypeOfDivice);
}

class _RoomScreenState extends State<RoomScreen> {
  List<RoomObject> listRoom;
  List<DeviceObject> listDevice;
  List<TypeOfDiviceObject> listTypeOfDivice;
  bool _isSearching = false;
  List<RoomObject> _rooms = [];
  List<RoomObject> _roomsDisplay = [];
  _RoomScreenState(
      {Key? key,
      required this.listRoom,
      required this.listDevice,
      required this.listTypeOfDivice});
  bool isRefresh = false;
  List<DeviceObject> tempListDevice = [];
  List<TypeOfDiviceObject> tempListTypeOfDivice = [];
  @override
  void initState() {
    super.initState();
    fetchRooms();
    tempListTypeOfDivice.clear();
  }

  Future<void> fetchRooms() async {
    try {
      if (!isRefresh) {
        listRoom = listRoom;
        isRefresh = true;
        tempListTypeOfDivice.clear();
      } else {
        listRoom = await RoomProvider.fetchRoom(http.Client());
        listDevice = await DeviceProvider.fetchDevice(http.Client());
        listTypeOfDivice =
            await TypeOfDeviceProvider.fetchTypeOfDivice(http.Client());
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Type_Of_Device_In_Room_Screen(
                          listDevice: listDevice,
                          listTypeOfDivice: listTypeOfDivice,
                          room: _roomsDisplay[index]),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
