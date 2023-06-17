import 'package:devide_manager/object/BatchOfGoodObject.dart';
import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
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
import 'package:devide_manager/ui/Batch_Of_Good.dart';
import 'package:devide_manager/ui/Brand.dart';
import 'package:devide_manager/ui/Configuration.dart';
import 'package:devide_manager/ui/Devices.dart';
import 'package:devide_manager/ui/Login.dart';
import 'package:devide_manager/ui/Faculties.dart';
import 'package:devide_manager/ui/Room.dart';
import 'package:devide_manager/ui/User.dart';
import 'package:devide_manager/widget/widget.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/provider/api_Configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../object/RoomObject.dart';
import 'QR_Code_Scanner.dart';
import 'package:devide_manager/widget/GetTypeOfDevice.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  TeacherInformationObject teacherInformation;
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<FacultyObject> listFaculty = [];
  List<RoomObject> listRoom = [];
  List<TeacherInformationObject> listUser = [];
  List<DeviceObject> listDevice = [];
  List<BatchOfGoodObject> listBatchOfGood = [];
  List<TypeOfDiviceObject> listTypeOfDivice = [];
  List<ConfigurationObject> listConfiguration = [];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];

  HomePage({
    Key? key,
    required this.teacherInformation,
    required this.listBrand,
    required this.listSuppliers,
    required this.listUser,
    required this.listFaculty,
    required this.listRoom,
    required this.listDevice,
    required this.listBatchOfGood,
    required this.listTypeOfDivice,
    required this.listConfiguration,
    required this.listConfigurationDetails,
    required this.listConfigurationSpecification,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(
      teacherInformation: teacherInformation,
      listBrand: listBrand,
      listConfiguration: listConfiguration,
      listConfigurationDetails: listConfigurationDetails,
      listConfigurationSpecification: listConfigurationSpecification,
      listDevice: listDevice,
      listBatchOfGood: listBatchOfGood,
      listSuppliers: listSuppliers,
      listTypeOfDivice: listTypeOfDivice,
      listUser: listUser,
      listFaculty: listFaculty,
      listRoom: listRoom);
}

class _HomePageState extends State<HomePage> {
  TeacherInformationObject teacherInformation;
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<FacultyObject> listFaculty = [];
  List<RoomObject> listRoom = [];
  List<TeacherInformationObject> listUser = [];
  List<DeviceObject> listDevice = [];
  List<BatchOfGoodObject> listBatchOfGood = [];
  List<TypeOfDiviceObject> listTypeOfDivice = [];
  List<ConfigurationObject> listConfiguration = [];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];
  late final FacultyObject faculty;

  _HomePageState(
      {Key? key,
      required this.teacherInformation,
      required this.listBrand,
      required this.listSuppliers,
      required this.listFaculty,
      required this.listRoom,
      required this.listUser,
      required this.listDevice,
      required this.listBatchOfGood,
      required this.listTypeOfDivice,
      required this.listConfiguration,
      required this.listConfigurationDetails,
      required this.listConfigurationSpecification});
  late List<int> device_Number;
  bool isRefresh = false;
  @override

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
    listFaculty = await FacultyProvider.fetchFaculty(http.Client());
    return listFaculty;
  }

  //Lấy danh sách giáo viên
  Future<List<TeacherInformationObject>> GetListUser() async {
    listUser =
        await TeacherInformationProvider.fetchTeacherInformation(http.Client());
    return listUser;
  }

  //Lấy danh sách lô hàng
  Future<List<BatchOfGoodObject>> GetListBatchOfGood() async {
    listBatchOfGood = await BatchOfGoodProvide.fetchBatchOfGood(http.Client());
    return listBatchOfGood;
  }

  //Lấy danh sách thiết bị
  Future<List<DeviceObject>> GetListDivice() async {
    listDevice = await DeviceProvider.fetchDevice(http.Client());
    return listDevice;
  }

  //Lấy danh sách phòng
  Future<List<RoomObject>> GetListRoom() async {
    listRoom = await RoomProvider.fetchRoom(http.Client());
    return listRoom;
  }

  //Lấy danh sách loại
  Future<List<TypeOfDiviceObject>> GetListTypeOfDivice() async {
    listTypeOfDivice =
        await TypeOfDeviceProvider.fetchTypeOfDivice(http.Client());
    return listTypeOfDivice;
  }

  //Lấy danh sách cấu hình
  Future<List<ConfigurationObject>> GetListConfiguration() async {
    listConfiguration =
        await ConfigurationProvide.fetchConfiguration(http.Client());
    return listConfiguration;
  }

  //Lấy danh sách loại cấu hình
  Future<List<ConfigurationDetailsObject>> GetListConfigurationDetails() async {
    listConfigurationDetails =
        await ConfigurationDetailsProvide.fetchConfigurationDetails(
            http.Client());
    return listConfigurationDetails;
  }

  //Lấy danh sách thông số cấu hình
  Future<List<ConfigurationSpecificationObject>>
      GetListConfigurationSpecification() async {
    listConfigurationSpecification =
        await ConfigurationSpecificationProvide.fetchConfigurationSpecification(
            http.Client());
    return listConfigurationSpecification;
  }

  Future<void> fetchHome() async {
    try {
      if (!isRefresh) {
        listUser = listUser;
        isRefresh = true;
      } else {
        listFaculty = await GetListFaculty();
        listRoom = await GetListRoom();
        listUser = await GetListUser();
        listDevice = await GetListDivice();
        listBatchOfGood = await GetListBatchOfGood();
        listTypeOfDivice = await GetListTypeOfDivice();
        listBrand = await GetListBrand();
        listSuppliers = await GetListSuppliers();
        listConfiguration = await GetListConfiguration();
        listConfigurationDetails = await GetListConfigurationDetails();
        listConfigurationSpecification =
            await GetListConfigurationSpecification();
      }
      setState(() {});
    } catch (error) {
      print('Lỗi: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi, Vui lòng thử lại sau'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    var text = const Text(
      'Danh sách đơn vị',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
    return Scaffold(
        backgroundColor: const Color(0xffF4F7FC),
        drawer: Drawer(
          backgroundColor: const Color(0xffF4F7FC),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 3,
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CircleAvatar(
                      maxRadius: 50,
                      minRadius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          NetworkImage(teacherInformation.image.toString()),
                    ),
                  ),
                ),
                accountName: Text(
                  teacherInformation.teacher_Name.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                accountEmail: Text(teacherInformation.userName.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage("assets/Gif_Status/backgroung_taskbar.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/Icon/logout_x64.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                title: const Text('Đăng xuất'),
                onTap: () async {
                  await Preferences.saveLoggedInStatus(false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
              ),

              //Chức năng xem cấu hình
              ListTile(
                  leading: Image.asset(
                    'assets/Icon/Configuration.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  title: const Text('Cấu hình'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfigurationPage(
                          listConfiguration: listConfiguration,
                          listConfigurationDetails: listConfigurationDetails,
                          listTypeOfDivice: listTypeOfDivice,
                        ),
                      ),
                    );
                  }),

              ListTile(
                  leading: Image.asset(
                    'assets/Icon/user.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  title: const Text('Thông tin giáo viên'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => User(
                          listUser: listUser,
                        ),
                      ),
                    ).then((shouldReload) async {
                      if (shouldReload == true)
                        listFaculty = await GetListFaculty();
                      listRoom = await GetListRoom();
                      listUser = await GetListUser();
                      listDevice = await GetListDivice();
                      listBatchOfGood = await GetListBatchOfGood();
                      listTypeOfDivice = await GetListTypeOfDivice();
                      listBrand = await GetListBrand();
                      listSuppliers = await GetListSuppliers();
                      listConfiguration = await GetListConfiguration();
                      listConfigurationDetails =
                          await GetListConfigurationDetails();
                      listConfigurationSpecification =
                          await GetListConfigurationSpecification();
                    });
                  }),
              ListTile(
                  leading: Image.asset(
                    'assets/Icon/brand.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  title: const Text('Thương hiệu'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BrandPage(
                          listBrand: listBrand,
                        ),
                      ),
                    );
                  }),
              ListTile(
                  leading: Image.asset(
                    'assets/Icon/room_black.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  title: const Text('Phòng'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomScreen(
                          listRoom: listRoom,
                          listDevice: listDevice,
                          listTypeOfDivice: listTypeOfDivice,
                          listBrand: listBrand,
                          listConfiguration: listConfiguration,
                          listConfigurationDetails: listConfigurationDetails,
                          listConfigurationSpecification:
                              listConfigurationSpecification,
                          listSuppliers: listSuppliers,
                        ),
                      ),
                    );
                  }),
              ListTile(
                  leading: Image.asset(
                    'assets/Icon/batch.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  title: const Text('Lô hàng'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Batch_Of_GoodsScreen(
                          listBatchOfGood: listBatchOfGood,
                          listDevice: listDevice,
                          listTypeOfDivice: listTypeOfDivice,
                          listBrand: listBrand,
                          listConfiguration: listConfiguration,
                          listConfigurationDetails: listConfigurationDetails,
                          listConfigurationSpecification:
                              listConfigurationSpecification,
                          listSuppliers: listSuppliers,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 31, 60, 114),
          title: const Text(
            'Quản lý thiết bị nhà trường',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRScannerScreen(
                        listDevice: listDevice,
                        listTypeOfDivice: listTypeOfDivice,
                        listBrand: listBrand,
                        listSuppliers: listSuppliers,
                        listConfigurationDetails: listConfigurationDetails,
                        listConfigurationSpecification:
                            listConfigurationSpecification,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () async {},
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                )),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: fetchHome,
          child: _buildHomeList(),
        ));
  }

  Widget _buildHomeList() {
    return ListView(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Gif_Status/background.gif'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return FractionallySizedBox(
                          widthFactor:
                              0.8, // Tùy chỉnh độ rộng của FractionallySizedBox theo nhu cầu
                          child: Text(
                            'Chào mừng đến với Thiết bị CĐKT Cao Thắng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5.0,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Danh sách thiết bị',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DevicePage(
                              bath: 0,
                              typeOfDevice: 0,
                              room: 0,
                              listDevice: listDevice,
                              listTypeOfDivice: listTypeOfDivice,
                              listBrand: listBrand,
                              listSuppliers: listSuppliers,
                              listConfiguration: listConfiguration,
                              listConfigurationDetails:
                                  listConfigurationDetails,
                              listConfigurationSpecification:
                                  listConfigurationSpecification,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(
                          color: Color.fromARGB(255, 31, 60, 114),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 200,
                        child: FutureBuilder<List<TypeOfDiviceObject>>(
                          future: TypeOfDeviceProvider.fetchTypeOfDivice(
                              http.Client()),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              List<TypeOfDiviceObject> lsTypeOfDevice =
                                  snapshot.data!;
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: lsTypeOfDevice.length,
                                  itemBuilder: (((context, index) =>
                                      buildDeviceItem(
                                        context,
                                        lsTypeOfDevice[index].Image.toString(),
                                        lsTypeOfDevice[index]
                                            .Type_Of_Device_Name
                                            .toString(),
                                        lsTypeOfDevice[index]
                                            .Type_Of_Device_ID!,
                                        Color.fromARGB(255, 19, 200, 19),
                                      ))));
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Hệ thống đang có sự cố!!'),
                              );
                            }
                            return Center(
                              child: SpinKitChasingDots(
                                color: Color.fromARGB(255, 31, 60, 114),
                                size: 50,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Danh sách đơn vị',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FacultyScreen(
                                        listFaculty: listFaculty,
                                      )));
                        },
                        child: const Text(
                          'Xem tất cả',
                          style: TextStyle(
                            color: Color.fromARGB(255, 31, 60, 114),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 190,
                        child: FutureBuilder<List<FacultyObject>>(
                          future: FacultyProvider.fetchFaculty(http.Client()),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              List<FacultyObject> lsDonVi = snapshot.data!;
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: lsDonVi.length,
                                  itemBuilder: (((context, index) =>
                                      lsDonVi[index].status == 1
                                          ? buildDepartmentItem(
                                              context,
                                              lsDonVi[index].image.toString(),
                                              lsDonVi[index]
                                                  .facultyName
                                                  .toString(),
                                              lsDonVi.length.toString(),
                                              FacultyProvider
                                                  .countActiveFaculties(
                                                      listFaculty),
                                              Colors.green,
                                            )
                                          : Container())));
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Hệ thống đang có sự cố!!'),
                              );
                            }
                            return Center(
                              child: SpinKitChasingDots(
                                color: Color.fromARGB(255, 31, 60, 114),
                                size: 50,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDeviceItem(
      BuildContext context, String image, String name, int id, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      width: 140,
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          GetNumberDeviceId(id: id),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DevicePage(
                      bath: 0,
                      typeOfDevice: id,
                      room: 0,
                      listDevice: listDevice,
                      listTypeOfDivice: listTypeOfDivice,
                      listBrand: listBrand,
                      listSuppliers: listSuppliers,
                      listConfiguration: listConfiguration,
                      listConfigurationDetails: listConfigurationDetails,
                      listConfigurationSpecification:
                          listConfigurationSpecification,
                    ),
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
          ),
        ],
      ),
    );
  }
}
