import 'package:flutter/material.dart';
import 'package:proyek_akhir/view/detail.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> products;

  CategoryPage({required this.category, required this.products});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, dynamic>> getProductsByCategory() {
    return widget.products
        .where(
            (product) => product['category'] == widget.category.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categoryProducts = getProductsByCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kategori ${widget.category}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductSection(categoryProducts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection(List<Map<String, dynamic>> categoryProducts) {
    if (categoryProducts.isEmpty) {
      return Center(
        child: Text(widget.category),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              final product = categoryProducts[index];
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
          color: Color.fromARGB(255, 240, 243, 247),
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
