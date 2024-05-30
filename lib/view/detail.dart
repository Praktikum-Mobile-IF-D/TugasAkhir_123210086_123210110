import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:proyek_akhir/hive/user.dart';
import 'package:proyek_akhir/model/product_model.dart';
import 'package:proyek_akhir/view/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  DetailPage({required this.product});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _selectedCurrency = 'USD';

  Future<void> _addtocart(Map<String, dynamic> product) async {
    var box = Hive.box<User>('usersBox');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? accIndex = prefs.getInt("accIndex") ?? 0;

    Products newCart = Products(
      thumbnail: product['thumbnail'],
      title: product['title'],
      price: product['price'],
    );

    if (box.getAt(accIndex!)?.carts != null) {
      box.getAt(accIndex)!.carts?.add(newCart);
    } else {
      var user = box.getAt(accIndex);
      user?.carts = [newCart];
      await box.putAt(accIndex, user!);
    }
    //error klo dipake
    print(accIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        widget.product['thumbnail'] ?? '',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.product['title'] ?? 'Title not available',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: _selectedCurrency,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCurrency = newValue!;
                            });
                          },
                          items: <String>['USD', 'IDR', 'EUR']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _convertCurrency(
                              widget.product['price'], _selectedCurrency),
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Stock: ${widget.product['stock'] ?? 'Not available'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          widget.product['rating'] != null
                              ? '${widget.product['rating']}'
                              : 'Rating not available',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Detail Produk',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kategori: ${widget.product['category'] ?? 'Category not available'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tags: ${widget.product['tags']?.join(', ') ?? 'Tags not available'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Deskripsi Produk',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.product['description'] ??
                          'Description not available',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _addtocart(widget.product);
              },
              child: Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }

  String _convertCurrency(dynamic price, String currency) {
    double convertedPrice = price;
    String symbol = '';
    if (currency == 'IDR') {
      convertedPrice *= 16225;
      symbol = 'Rp. ';
    } else if (currency == 'EUR') {
      convertedPrice *= 0.92;
      symbol = '€ ';
      convertedPrice = double.parse(convertedPrice.toStringAsFixed(2));
    } else {
      symbol = '\$ ';
    }
    return '$symbol$convertedPrice';
  }
}
