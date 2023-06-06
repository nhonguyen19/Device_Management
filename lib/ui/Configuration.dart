import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/provider/api_Configuration.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/provider/api_Configuration_Details.dart';
import 'package:devide_manager/ui/DeviceDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devide_manager/widget/GetTypeOfDevice.dart';
import 'package:devide_manager/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ConfigurationPage extends StatefulWidget {
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails;
  List<TypeOfDiviceObject> listTypeOfDivice;
   ConfigurationPage({Key?key,required this.listConfiguration,required this.listConfigurationDetails,required this.listTypeOfDivice});

  @override
  _ConfigurationState createState() => _ConfigurationState(listConfiguration:listConfiguration,listConfigurationDetails: listConfigurationDetails,listTypeOfDivice: listTypeOfDivice);
}

class _ConfigurationState extends State<ConfigurationPage> {

  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails;
  List<TypeOfDiviceObject> listTypeOfDivice;
  bool _isSearching = false;
  List<ConfigurationObject> _configuration = [];
  List<ConfigurationObject> _configurationDisplay = [];
   _ConfigurationState({Key?key,required this.listConfiguration,required this.listConfigurationDetails,required this.listTypeOfDivice});

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }


  Future<void> fetchDevices() async {
    try {
      listConfiguration = listConfiguration;
      setState(() {
        _configuration = listConfiguration;
        _configurationDisplay = listConfiguration;
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
      body: _buildDeviceList(),
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
                  // _configurationDisplay = _configuration.where((listConfiguration) {
                  //   return listConfiguration..toLowerCase().contains(text) ||
                  //       listConfiguration.Image!.toLowerCase().contains(text) ||
                  //       listConfiguration.Price!.toLowerCase().contains(text) ||
                  //       listConfiguration.Warranty_Period!.toLowerCase().contains(text) ||
                  //       listConfiguration.Note!.toLowerCase().contains(text) ||
                  //       listConfiguration.Description!.toLowerCase().contains(text);
                  // }).toList();
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
    if (_configurationDisplay.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
        itemCount: _configurationDisplay.length,
        itemBuilder: (context, index) => _buildDeviceItem(index));
  }

  Widget _buildDeviceItem(int index) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: GetTypeOfDevice(id: _configurationDisplay[index].device_Type_ID!,listTypeOfDivice: listTypeOfDivice,displayString: '',displayColor: Colors.black,),
            subtitle:GetConfigurationDetails(
              id: _configurationDisplay[index].configuration_Detail_ID!,
              listConfigurationDetails: listConfigurationDetails,
              displayString: '',
              displaycolor:Color.fromARGB(220, 243, 95, 95)),
            trailing: Image.asset(
              _configurationDisplay[index].status == 1
                  ? 'assets/Gif_Status/connect_ic_2.gif'
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

