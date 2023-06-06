import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/SupplierObject.dart';
import 'package:devide_manager/provider/api_Brand.dart';
import 'package:devide_manager/object/FacultyOject.dart';
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Configuration_Details.dart';
import 'package:devide_manager/provider/api_Confuguration_Specification.dart';
import 'package:devide_manager/provider/api_Device.dart';
import 'package:devide_manager/provider/api_Faculties.dart';
import 'package:devide_manager/provider/api_Supplier.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:devide_manager/ui/Brand.dart';
import 'package:devide_manager/ui/Configuration.dart';
import 'package:devide_manager/ui/DeviceDetails.dart';
import 'package:devide_manager/ui/Devices.dart';
import 'package:devide_manager/ui/Login.dart';
import 'package:devide_manager/ui/Faculties.dart';
import 'package:devide_manager/ui/QR_Code_Scanner.dart';
import 'package:devide_manager/ui/User.dart';
import 'package:devide_manager/widget/GetTypeOfDevice.dart';
import 'package:devide_manager/widget/widget.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:devide_manager/provider/api_Type_Of_Device.dart';
import 'package:devide_manager/object/ConfigurationObject.dart';
import 'package:devide_manager/provider/api_Configuration.dart';
import 'package:devide_manager/ui/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class QRScannerScreen extends StatefulWidget {
  List<DeviceObject> listDevice = [];
  List<TypeOfDiviceObject> listTypeOfDivice = [];
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];
  @override
  QRScannerScreen(
      {Key? key,
      required this.listDevice,
      required this.listTypeOfDivice,
      required this.listBrand,
      required this.listSuppliers,
      required this.listConfigurationDetails,
      required this.listConfigurationSpecification});
  _QRScannerScreenState createState() => _QRScannerScreenState(
      listDevice: listDevice,
      listTypeOfDivice: listTypeOfDivice,
      listBrand: listBrand,
      listSuppliers: listSuppliers,
      listConfigurationDetails: listConfigurationDetails,
      listConfigurationSpecification: listConfigurationSpecification);
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool Sreach = false;
  List<DeviceObject> listDevice = [];
  List<TypeOfDiviceObject> listTypeOfDivice = [];
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];
  _QRScannerScreenState(
      {Key? key,
      required this.listDevice,
      required this.listTypeOfDivice,
      required this.listBrand,
      required this.listSuppliers,
      required this.listConfigurationDetails,
      required this.listConfigurationSpecification});
  late DeviceObject device;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String QRCode = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QRCode = '';
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Vui lòng nhập QR Code trong khu vực',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center),
                Text('Quá trình quét sẽ được bắt đầu tự động'),
              ],
            ),
          )),
          Container(
            width: screenWidth /
                1.5, // Kích thước lớn hơn cutOutSize để tạo viền bên ngoài
            height: screenWidth / 1.5,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue.shade300,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: QRCode == ''
                ? QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      cutOutSize: 300,
                    ),
                  )
                : Center(
                    child: SpinKitChasingDots(
                      color: Color.fromARGB(255, 31, 60, 114),
                      size: 50,
                    ),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scanned QR: $QRCode'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        QRCode = scanData.code!;
      });

      // Xử lý logic sau khi quét QR Code thành công
      if (!Sreach) {
        Sreach = true;
        _handleQRCodeScan();
      }
    });
  }

  void _handleQRCodeScan() async {
    for (var item in listDevice) {
      if (item.QRCode == QRCode) device = item;
    }
    if (device != null) {
      if (await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Device_Details(
                  device: device,
                  listTypeOfDivice: listTypeOfDivice,
                  listBrand: listBrand,
                  listSuppliers: listSuppliers,
                  listConfigurationDetails: listConfigurationDetails,
                  listConfigurationSpecification:
                      listConfigurationSpecification),
            ),
          ) ==
          false) {
        Sreach = false;
      }
    }
  }
}
