class Ngrok {
  String ngrok = 'https://3c0e-42-117-101-9.ngrok-free.app';
  late String api_Faculties;
  late String api_Batch_Of_Goods;
  late String api_Brands;
  late String api_Devices;
  late String api_Rooms;
  late String api_Suppliers;
  late String api_Type_Of_Devices;
  late String api_Teacher_Information;
  late String api_Configuration;
  late String api_Configuration_Details;
  late String api_Configuration_Specification;

  Ngrok() {
    api_Faculties = ngrok + '/api/faculties';
    api_Batch_Of_Goods = ngrok + '/api/batches';
    api_Brands = ngrok + '/api/brands';
    api_Devices = ngrok + '/api/devices';
    api_Rooms = ngrok + '/api/rooms';
    api_Suppliers = ngrok + '/api/suppliers';
    api_Type_Of_Devices = ngrok + '/api/type-of-devices';
    api_Teacher_Information = ngrok + '/api/teacher-informations';
    api_Configuration = ngrok + '/api/configurations';
    api_Configuration_Details = ngrok + '/api/configuration-details';
    api_Configuration_Specification = ngrok + '/api/configuration-specifications';
  }
}