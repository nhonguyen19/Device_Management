import 'dart:async';
import 'package:devide_manager/object/BatchOfGoodObject.dart';
import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/RoomObject.dart';
import 'package:devide_manager/object/SupplierObject.dart';
import 'package:devide_manager/provider/api_Batch_Of_Goods.dart';
import 'package:devide_manager/provider/api_Brand.dart';
import 'package:devide_manager/object/FacultyOject.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Configuration_Details.dart';
import 'package:devide_manager/provider/api_Confuguration_Specification.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/provider/api_Faculties.dart';
import 'package:devide_manager/provider/api_Room.dart';
import 'package:devide_manager/provider/api_Supplier.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:devide_manager/provider/share_preferences.dart';
import 'package:devide_manager/ui/Brand.dart';
import 'package:devide_manager/ui/Configuration.dart';
import 'package:devide_manager/ui/Devices.dart';
import 'package:devide_manager/ui/Login.dart';
import 'package:devide_manager/ui/Faculties.dart';
import 'package:devide_manager/ui/User.dart';
import 'package:devide_manager/widget/GetTypeOfDevice.dart';
import 'package:devide_manager/widget/widget.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/provider/api_Configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'QR_Code_Scanner.dart';
import 'Home.dart';
class LoadingScreen extends StatefulWidget {
  
  TeacherInformationObject user;
   LoadingScreen({Key? key,required this.user});

  @override
  _LoadingScreenState createState() => _LoadingScreenState(user: user);
}

class _LoadingScreenState extends State<LoadingScreen> {
  TeacherInformationObject user;
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<FacultyObject> listFaculty =[];
  List<RoomObject> listRoom=[];
  List<TeacherInformationObject> listUser = [];
  List<DeviceObject> listDevice = [];
  List<BatchOfGoodObject> listBatchOfGood =[];
  List<TypeOfDiviceObject> listTypeOfDivice = [];
  List<ConfigurationObject> listConfiguration = [];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];
  double load = 0.0;
  Timer? timer;

  _LoadingScreenState({required this.user});

    //Lấy danh sách nhà cung cấp
  Future<List<SupplierObject>> GetListSuppliers() async {
    listSuppliers = await SupplierProvider.fetchSupplier(http.Client());
    return listSuppliers;
  }

  //Lấy danh sách Thương hiệu
  Future<List<BrandObject>> GetListBrand() async {
    listBrand = await BrandProvide.fetchBrand(http.Client());
    return listBrand;
  }
//Lấy danh sách khoa
  Future<List<FacultyObject>> GetListFaculty() async {
    listFaculty =
        await FacultyProvider.fetchFaculty(http.Client());
    return listFaculty;
  }
  //Lấy danh sách phòng
    Future<List<RoomObject>> GetListRoom() async {
    listRoom =
        await RoomProvider.fetchRoom(http.Client());
    return listRoom;
  }
  //Lấy danh sách giáo viên
  Future<List<TeacherInformationObject>> GetListUser() async {
    listUser =
        await TeacherInformationProvider.fetchTeacherInformation(http.Client());
    return listUser;
  }
  Future<List<BatchOfGoodObject>> GetListBatchOfGood() async {
    listBatchOfGood = await BatchOfGoodProvide.fetchBatchOfGood(http.Client());
    return listBatchOfGood;
  }
  Future<List<DeviceObject>> GetListDivice() async {
    listDevice = await DeviceProvider.fetchDevice(http.Client());
    return listDevice;
  }

  Future<List<TypeOfDiviceObject>> GetListTypeOfDivice() async {
    listTypeOfDivice =
        await TypeOfDeviceProvider.fetchTypeOfDivice(http.Client());
    return listTypeOfDivice;
  }

  Future<List<ConfigurationObject>> GetListConfiguration() async {
    listConfiguration =
        await ConfigurationProvide.fetchConfiguration(http.Client());
    return listConfiguration;
  }

  Future<List<ConfigurationDetailsObject>> GetListConfigurationDetails() async {
    listConfigurationDetails =
        await ConfigurationDetailsProvide.fetchConfigurationDetails(
            http.Client());
    return listConfigurationDetails;
  }

  Future<List<ConfigurationSpecificationObject>>
      GetListConfigurationSpecification() async {
    listConfigurationSpecification =
        await ConfigurationSpecificationProvide.fetchConfigurationSpecification(
            http.Client());
    return listConfigurationSpecification;
  }

  @override
  void initState() {
    super.initState();

    // Bắt đầu tăng tiến độ theo thời gian
    timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
      setState(() {
        // Tăng giá trị tiến độ
        load += 0.001;
        if (load >= 1.0) {
          // Khi đạt giá trị tối đa, dừng timer
          navigateToNextScreen();
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Hủy bỏ timer khi widget bị hủy
    super.dispose();
  }
  void navigateToNextScreen() async{ 
   listFaculty = await GetListFaculty();
   listRoom = await GetListRoom();
   listUser = await GetListUser();
    listDevice = await GetListDivice();
    listBatchOfGood = await GetListBatchOfGood();
    listTypeOfDivice = await GetListTypeOfDivice();
    listBrand = await GetListBrand();
    listSuppliers = await GetListSuppliers();
    listConfiguration=await GetListConfiguration();
    listConfigurationDetails = await GetListConfigurationDetails();
    listConfigurationSpecification = await GetListConfigurationSpecification();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(teacherInformation: user,listBrand: listBrand,
      listConfiguration: listConfiguration,
      listConfigurationDetails: listConfigurationDetails,
      listConfigurationSpecification: listConfigurationSpecification,
      listDevice: listDevice,
      listBatchOfGood:listBatchOfGood,
      listSuppliers: listSuppliers,
      listTypeOfDivice: listTypeOfDivice,
      listUser: listUser,
      listFaculty: listFaculty,
      listRoom: listRoom,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
          ),
          Container(
            child: Image.asset('assets/logo.jpg'),
          ),
          Container(
            width: screenWidth,
            height: 5,
            child: LinearProgressIndicator(
              value: load,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 5,
              semanticsLabel: 'Loading',
            ),
          ),
        ],
      ),
    );
  }
}