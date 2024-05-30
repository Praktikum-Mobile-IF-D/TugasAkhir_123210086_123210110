import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:proyek_akhir/hive/user.dart';
import 'package:proyek_akhir/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: FutureBuilder(
        future: _getCartItems(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Products>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Products>? cartItems = snapshot.data;
            if (cartItems == null || cartItems.isEmpty) {
              return Center(
                child: Text('Cart is empty'),
              );
            } else {
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return ListTile(
                    title: Text('${product.title}'),
                    subtitle: Text('\$${product.price}'),
                    leading: Image.network('${product.thumbnail}'),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Products>> _getCartItems() async {
    var box = await Hive.openBox<User>('usersBox');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? accIndex = prefs.getInt("accIndex");
    print(accIndex);

    if (accIndex == null) {
      // Handle the case where accIndex is null
      return [];
    }

    User? currentUser = box.get(accIndex);
    if (currentUser == null) {
      // Handle the case where user is null
      return [];
    }

    // Return the user's cart or an empty list if the cart is null
    return currentUser.carts ?? [];
  }
}
