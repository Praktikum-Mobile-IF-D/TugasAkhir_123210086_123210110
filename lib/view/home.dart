import 'package:flutter/material.dart';
import 'package:proyek_akhir/model/api_data_source.dart';
import 'package:proyek_akhir/view/cart.dart';
import 'package:proyek_akhir/view/category.dart';
import 'package:proyek_akhir/view/detail.dart';
import 'package:proyek_akhir/view/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> products = [];
  String? _username;
  int? accIndex;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _getUsername();
  }

  Future<void> _loadProducts() async {
    try {
      final response = await ApiDataSource.instance.loadProducts();
      setState(() {
        products = List<Map<String, dynamic>>.from(response['products']);
      });
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  Future<void> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      accIndex = prefs.getInt('accIndex');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${_username ?? ''} ${accIndex ?? ''}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.0),
            Container(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(
                      () {}); // Trigger rebuild to reflect changes in search
                },
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          _buildHomePage(),
          CartPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildCategoriesSection(),
            SizedBox(height: 20),
            _buildProductSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildCategoryItem('Beauty', 'img/beauty.png'),
        _buildCategoryItem('Fragrances', 'img/fragrance.png'),
        _buildCategoryItem('Furniture', 'img/furniture.png'),
        _buildCategoryItem('Groceries', 'img/grocery.png'),
      ],
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryPage(category: title, products: products),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    List<Map<String, dynamic>> filteredProducts = [];

    if (_searchController.text.isEmpty) {
      filteredProducts = List<Map<String, dynamic>>.from(products);
    } else {
      filteredProducts = products.where((product) {
        String title = product['title'] ?? '';
        return title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    if (filteredProducts.isEmpty) {
      return Center(
        child: Text('No products found'),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produk',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return _buildProductItem(product);
            },
          ),
        ],
      );
    }
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product['thumbnail'] ?? '',
              width: 160,
              height: 105,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] ?? 'Title not available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    product['price'] != null
                        ? '\$${product['price']}'
                        : 'Price not available',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      SizedBox(width: 4),
                      Text('${product['rating'] ?? 'Rating not available'}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(product['availabilityStatus'] ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
