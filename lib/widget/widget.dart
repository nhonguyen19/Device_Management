import 'package:devide_manager/object/DeviceObject.dart';
import 'package:devide_manager/object/TypeOfDeviceObject.dart';
import 'package:flutter/material.dart';
import 'package:devide_manager/widget/GetTypeOfDevice.dart';
import 'package:devide_manager/object/ConfigurationDetailsObject.dart';
import 'package:devide_manager/object/ConfigurationSpecificationObject.dart';
import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/object/SupplierObject.dart';
import 'package:devide_manager/ui/Devices.dart';

//thiết bị

Widget buildDepartmentItem(BuildContext context, String image, String name,
    String total, int available, Color color) {
       Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
  return Container(
    margin: const EdgeInsets.only(left: 24),
    width: 350,
    height: 200,
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
    child: Row(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.show_chart_rounded,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tổng số: $total',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_sharp,
                      size: 16,
                      color: Colors.blueAccent                   ),
                    const SizedBox(width: 4),
                    Text(
                      'Đang hoạt động: $available',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: available / int.parse(total),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(color),
                        overlayColor: MaterialStateProperty.all<Color>(
                            color.withOpacity(0.1)),
                      ),
                      child: const Text('Chi tiết'),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline),
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class ItemAppBar extends StatelessWidget {
  DeviceObject deviceDetails;
  List<TypeOfDiviceObject> listTypeOfDivice = [];
  List<BrandObject> listBrand = [];
  List<SupplierObject> listSuppliers = [];
  List<ConfigurationDetailsObject> listConfigurationDetails = [];
  List<ConfigurationSpecificationObject> listConfigurationSpecification = [];
  ItemAppBar({Key? key, required this.deviceDetails,required this.listTypeOfDivice,required this.listBrand,required this.listSuppliers,required this.listConfigurationDetails,required this.listConfigurationSpecification});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 31, 60, 114),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Chi tiết thiết bị",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Spacer(),
          Container(
              child: IconButton(
                  icon: GetImageTypeOfDevice(
                      id: deviceDetails.Type_Of_Device_ID!),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color.fromARGB(255, 31, 60, 114),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Column(
                                    children: [
                                      //Hiển thị Loại thiết bị
                                      Padding(
                                        padding:
EdgeInsets.symmetric(vertical:10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Loại thiết bị:',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Container(
                                              child: GetTypeOfDevice(
                                                id: deviceDetails
                                                    .Type_Of_Device_ID!,
                                                listTypeOfDivice: listTypeOfDivice,
                                                displayString: '',
                                                displayColor: Colors.white70,
                                              ),
                                            )
                                          ],
                                        ),
                                  ),    
                                      //Hiển thị Thương hiệu
                                       Padding(
                                        padding:
EdgeInsets.symmetric(vertical:10),child:
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                         Container(
                                          child:  Text(
                                            'Thương hiệu:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                         ),
                                         Container(
                                          child:  GetBrand(
                                            id: deviceDetails.Brand_ID!,
                                            listBrand: listBrand,
                                            displayString: '',
                                            displayColor: Colors.white70,
                                          ),
                                         )
                                        ],
                                      ),
                                       ),
                                      //Nhà cung cấp
                                       Padding(
                                        padding:
EdgeInsets.symmetric(vertical:10),child:
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                         Container(child:  Text(
                                            'Nhà cung cấp:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),),
                                         Container(
                                          child:  GetSupplier(
                                            id: deviceDetails.Supplier_ID!,
                                            listSupplier: listSuppliers,
                                            displayColor: Colors.white70,
                                          ),
                                         )
                                        ],
                                      ),
                                       ),
                                        Padding(
                                        padding:
EdgeInsets.symmetric(vertical:10),child:
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                         Container(
                                          child:  Text(
                                            'Mã lô hàng:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                         ),
                                       Container(
                                        child: Text(deviceDetails.Batch_Of_Goods_ID.toString(),style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70
                                        ),),
                                       )
                                        ],
                                      ),
                                        ),
                                      GetConfigurationSpecification(
                                          id: deviceDetails.id!,
                                          listConfigurationDetails: listConfigurationDetails,
                                          listConfigurationSpecification: listConfigurationSpecification,),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
