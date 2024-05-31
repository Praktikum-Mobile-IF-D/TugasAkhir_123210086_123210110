import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:proyek_akhir/hive/user.dart';
import 'package:proyek_akhir/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Products>? _cartItems;
  Map<int, bool> _isCheckedMap = {};
  double _totalPrice = 0.0;
  double _totalCheckout = 0.0;

  @override
  void initState() {
    super.initState();
    _getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _cartItems == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _cartItems!.isEmpty
              ? Center(
                  child: Text('Cart kosong.'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems!.length,
                        itemBuilder: (context, index) {
                          final product = _cartItems![index];
                          return ListTile(
                            title: Text('${product.title}'),
                            subtitle: Text('\$${product.price}'),
                            leading: Image.network('${product.thumbnail}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _isCheckedMap[index] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      _isCheckedMap[index] = value!;
                                      _updateTotalPrice();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      if (_isCheckedMap[index] == true) {
                                        _totalPrice -=
                                            _cartItems![index].price ?? 0.0;
                                      }
                                      _cartItems!.removeAt(index);
                                      _isCheckedMap.remove(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _allItemsChecked(),
                              onChanged: (value) {
                                setState(() {
                                  _checkAllItems(value!);
                                  _updateTotalPrice();
                                });
                              },
                            ),
                            Text('Select All'),
                          ],
                        ),
                        Text(
                          'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Checkout Berhasil'),
                                  content: Text(
                                      'Barang sejumlah \$${_totalCheckout.toStringAsFixed(2)} telah berhasil di checkout.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            setState(() {
                              List<int> toRemove = [];
                              for (int i = 0; i < _isCheckedMap.length; i++) {
                                if (_isCheckedMap[i] == true) {
                                  toRemove.add(i);
                                  _totalPrice -= _cartItems![i].price ?? 0.0;
                                }
                              }
                              toRemove.sort((a, b) => b.compareTo(a));
                              for (int index in toRemove) {
                                _cartItems!.removeAt(index);
                                _isCheckedMap.remove(index);
                              }
                            });
                          },
                          child: Text('Checkout'),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }

  Future<void> _getCartItems() async {
    var box = await Hive.openBox<User>('usersBox');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? accIndex = prefs.getInt("accIndex");
    print(accIndex);

    if (accIndex == null) {
      setState(() {
        _cartItems = [];
      });
      return;
    }

    User? currentUser = box.get(accIndex);
    if (currentUser == null || currentUser.carts == null) {
      setState(() {
        _cartItems = [];
      });
      return;
    }

    setState(() {
      _cartItems = currentUser.carts;
      _isCheckedMap.clear();
      for (int i = 0; i < _cartItems!.length; i++) {
        _isCheckedMap[i] = false;
      }
      _totalPrice = 0.0;
    });
  }

  void _updateTotalPrice() {
    double totalPrice = 0.0;
    for (int i = 0; i < _cartItems!.length; i++) {
      if (_isCheckedMap[i] == true) {
        totalPrice += _cartItems![i].price ?? 0.0;
      }
    }
    setState(() {
      _totalPrice = totalPrice;
      _totalCheckout = totalPrice;
    });
  }

  bool _allItemsChecked() {
    for (int i = 0; i < _cartItems!.length; i++) {
      if (!_isCheckedMap.containsKey(i) || _isCheckedMap[i] == false) {
        return false;
      }
    }
    return true;
  }

  void _checkAllItems(bool value) {
    for (int i = 0; i < _cartItems!.length; i++) {
      _isCheckedMap[i] = value;
    }
  }
}
