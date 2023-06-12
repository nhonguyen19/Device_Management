import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/provider/api_Batch_Of_Goods.dart';
import 'package:devide_manager/provider/api_Configuration.dart';
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
import 'package:devide_manager/ui/Devices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import '../object/BatchOfGoodObject.dart';

class Batch_Of_GoodsScreen extends StatefulWidget {
  List<DeviceObject> listDevice =[];
  List<BatchOfGoodObject> listBatchOfGood ;
  List<TypeOfDiviceObject> listTypeOfDivice=[];
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<ConfigurationObject> listConfiguration=[];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];

  Batch_Of_GoodsScreen(
      {Key? key,
      required this.listBatchOfGood,
      required this.listDevice,
      required this.listTypeOfDivice,
      required this.listBrand,
      required this.listSuppliers,
      required this.listConfiguration,
      required this.listConfigurationDetails,
      required this.listConfigurationSpecification});

  @override
  _Batch_Of_GoodsState createState() => _Batch_Of_GoodsState(listDevice:listDevice,listBatchOfGood: listBatchOfGood,listTypeOfDivice: listTypeOfDivice,listBrand:listBrand,listSuppliers:listSuppliers,listConfigurationDetails:listConfigurationDetails,listConfigurationSpecification:listConfigurationSpecification,listConfiguration:listConfiguration);
}

class _Batch_Of_GoodsState extends State<Batch_Of_GoodsScreen> {
  List<DeviceObject> listDevice ;
  List<BatchOfGoodObject> listBatchOfGood ;
  List<TypeOfDiviceObject> listTypeOfDivice;
  List<BrandObject> listBrand ;
  List<SupplierObject> listSuppliers ;
  List<ConfigurationObject> listConfiguration;
  List<ConfigurationDetailsObject> listConfigurationDetails ;
  List<ConfigurationSpecificationObject> listConfigurationSpecification;
  bool _isSearching = false;
  bool isRefresh = false;
  List<BatchOfGoodObject> _batchOfGood = [];
  List<BatchOfGoodObject> _batchOfGoodDisplay = [];
  _Batch_Of_GoodsState(
      {Key? key,
      required this.listBatchOfGood,
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
    fetchBatchOfGood();
  }

Future<void> fetchBatchOfGood() async {
    try {
      if (!isRefresh) {
        listBatchOfGood = listBatchOfGood;
        isRefresh = true;
      } else {
        listBatchOfGood = await BatchOfGoodProvide.fetchBatchOfGood(http.Client());
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
        _batchOfGood = listBatchOfGood;
        _batchOfGoodDisplay = listBatchOfGood;
      });
    } catch (error) {
      print('Lỗi tìm kiếm lô hàng: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi không thể tìm thấy lô hàng, vui lòng thử lại'),
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
        onRefresh: fetchBatchOfGood,
        child:  _buildBatchOfGoodList(),
      ),
       floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 31, 60, 114),
            child: Icon(Icons.add),
            onPressed: () {
              _navigateToDeviceAddScreen().then((shouldReload) {
                if (shouldReload == true) {
                  fetchBatchOfGood();
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
                  _batchOfGoodDisplay = _batchOfGood.where((listBatchOfGood) =>
                  listBatchOfGood.dateImport!.toLowerCase().contains(text) ).toList();
                });
              },
            )
          : const Text('Danh sách lô hàng'),
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
  Widget _buildGetPrice(int id) {
    List<DeviceObject> deviceInBatch = listDevice.where((listDevice) => listDevice.Batch_Of_Goods_ID == id).toList();
    double Price = 0;
    for(var item in deviceInBatch){
      Price+=double.parse(item.Price!);
    }
    return Container(child:
      Text('Giá: ${Price} VNĐ'),
    );
  }

  Widget _buildBatchOfGoodList() {
    if (_batchOfGoodDisplay.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
        itemCount: _batchOfGoodDisplay.length,
        itemBuilder: (context, index) => _buildBatchOfGooodItem(index));
  }

  Widget _buildBatchOfGooodItem(int index) {
    int leng = _batchOfGoodDisplay[index].dateImport!.length;
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              alignment: Alignment.center,
              width: 80, 
              height: 80,
              child: Text('Lô hàng: ${_batchOfGoodDisplay[index].id}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),)
            ),
            title: Text('Ngày nhập hàng: ${_batchOfGoodDisplay[index].dateImport.toString().substring(0,leng-8)}'),
            subtitle:_buildGetPrice(_batchOfGoodDisplay[index].id!),
            trailing:IconButton(
                icon: Icon(Icons.arrow_right),
               onPressed: () async {
  await  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DevicePage(
                              bath:_batchOfGoodDisplay[index].id!,
                              typeOfDevice: 0,
                              room: 0,
                              listDevice: listDevice,
                              listTypeOfDivice: listTypeOfDivice,
                              listBrand: listBrand,
                              listSuppliers: listSuppliers,
                              listConfiguration:listConfiguration,
                              listConfigurationDetails:
                                  listConfigurationDetails,
                              listConfigurationSpecification:
                                  listConfigurationSpecification,
                            ),
                          ),
                        ).then((result) async {
         listBatchOfGood = await BatchOfGoodProvide.fetchBatchOfGood(http.Client());
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
  });
},
              )
          ),
        ],
      ),
    );
  }
}

