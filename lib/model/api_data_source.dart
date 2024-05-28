import 'package:proyek_akhir/model/base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadProducts() {
    return BaseNetwork.get("products");
  }
}
