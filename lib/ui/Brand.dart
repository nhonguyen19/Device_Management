import 'package:devide_manager/object/BrandObject.dart';
import 'package:devide_manager/provider/api_Brand.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:devide_manager/ui/Login.dart';
import 'package:devide_manager/ui/UserDetails.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class BrandPage extends StatefulWidget {
  List<BrandObject> listBrand;
   BrandPage({Key?key,required this.listBrand});

  @override
  _BrandState createState() => _BrandState(listBrand: listBrand);
}

class _BrandState extends State<BrandPage> {
  List<BrandObject> listBrand;
  bool _isSearching = false;
  List<BrandObject> _brand = [];
  List<BrandObject> _brandDisplay = [];
  _BrandState({Key? key, required this.listBrand});
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    fetchBrand();
  }

  Future<void> fetchBrand() async {
    try {
      if(!isRefresh){
      listBrand=listBrand;
      isRefresh = true;
    }else{
      listBrand = await BrandProvide.fetchBrand(http.Client());
    }
      setState(() {
        _brand = listBrand;
        _brandDisplay = listBrand;
      });
    } catch (error) {
      print('Lỗi: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi, Vui lòng thử lại sau'),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar(),
      body:RefreshIndicator(
        onRefresh: fetchBrand,
        child:  _buildBrandList(),
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
                  _brandDisplay = _brand.where((listBrand) {
                    return listBrand.name!.toLowerCase().contains(text);
                  }).toList();
                });
              },
            )
          : const Text('Danh sách thương hiệu'),
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

  Widget _buildBrandList() {
    if (_brandDisplay.isEmpty) {
      return Center(
        child: SpinKitChasingDots(
          color: Color.fromARGB(255, 31, 60, 114),
          size: 50,
        ),
      );
    }
    return ListView.builder(
        itemCount: _brandDisplay.length,
        itemBuilder: (context, index) => _buildBrandItem(index));
  }

  Widget _buildBrandItem(int index) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
        children: [
          ListTile(  
            title: Text(_brandDisplay[index].name.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 31, 60, 114)
            ),),
            trailing:Image.asset('assets/Gif_Status/${_brandDisplay[index].status == 1?'ok.gif':'no.gif'}',
  width: 30,
  height: 30,
)
          ),
        ],
      ),
      )
    );
  }
}

