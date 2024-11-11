import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cartpage extends StatefulWidget {
  @override
  _CartpageState createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  List _cartItems = [];
  List _Products = [];

  Future<void> _fetchCartItems() async {
    final url = 'https://fakestoreapi.com/carts';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _cartItems = jsonData;
      });
    }
  }

  Future<void> _getSortedCart(String sortBy) async {
    final url = 'https://fakestoreapi.com/carts';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body);
      setState(() {
        _Products = jsondata;
        if (sortBy == 'asc') {
          _Products.sort((a, b) => a['id'].compareTo(b['id']));
        } else if (sortBy == 'desc') {
          _Products.sort((a, b) => b['id'].compareTo(a['id']));
        }
      });
    }
  }

  /*Future<void> _Searchcart(String query) async {
    final url = 'https://fakestoreapi.com/products?limit=5&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body);
      setState(() {
        _Products = jsondata;
      });
    }
  }*/

  /*Date range filter
  Future<void> _DateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: "2019-12-10",
      lastDate: "2020-10-10",
      initialDateRange: _selectedDateRange,
    );*/


  Future<void> _fetchSingleCartDetails(int cartId) async {
    final url = 'https://fakestoreapi.com/carts/$cartId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _showDialog(jsonData);
    }
  }

  Future<void> _fetchCartsByUserId(int userId) async {
    final url = 'https://fakestoreapi.com/carts/user/$userId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _showCartsByUserId(jsonData);
        }
  }

  Future<void> _addNewCart() async {
    final url = 'https://fakestoreapi.com/carts';
    final response = await http.post(Uri.parse(url),
        headers: {
      'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': 5,
          'date': '2020-02-03',
          'products': [
            {'productId': 5, 'quantity': 1},
            {'productId': 1, 'quantity': 5}
          ]
        }));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(response.body);
    }
  }

  Future<void> _updateCart() async {
        final url = 'https://fakestoreapi.com/carts/7';
        final response = await http.put(Uri.parse(url),
            headers: {
          'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'userId': 3,
              'date': '2019-12-10',
              'products': [{'productId': 1, 'quantity': 3}]}));
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          print(response.body);
        }
      }

  Future<void> _deleteCart() async {
    final url = 'https://fakestoreapi.com/carts/6';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(response.body);
    }
  }


  void _showDialog(dynamic cartData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cart Details"),
          content: Container(
            width: 400,
            height: 300,
            child: Column(
              children: [
                Text("Cart ID: ${cartData['id']}"),
                Text("User    ID: ${cartData['userId']}"),
                Text("Date: ${cartData['date']}"),
                Divider(),
                Text("Products:"),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cartData['products'].length,
                    itemBuilder: (context, index) {
                      final product = cartData['products'][index];
                      return ListTile(
                        title: Text("Product ID: ${product['productId']}"),
                        subtitle: Text("Quantity: ${product['quantity']}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCartsByUserId(dynamic cartData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Carts by User ID"),
          content: Container(
            width: 400,
            height: 300,
            child: Column(
              children: [
                Text("User  ID: ${cartData[0]['userId']}"),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cartData.length,
                    itemBuilder: (context, index) {
                      final cart = cartData[index];
                      return ListTile(
                        title: Text("Cart ID: ${cart['id']}"),
                        subtitle: Text("Date: ${cart['date']}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Items", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.add_shopping_cart_sharp),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Add New Cart'),
                onTap: () {
                  _addNewCart();
                },
              ),
              PopupMenuItem(
                child: Text('Update Cart'),
                onTap: () {
                  _updateCart();
                },
              ),
              PopupMenuItem(
                child: Text('Delete Cart'),
                onTap: () {
                  _deleteCart();
                },
              ),
            ],
          ),
          PopupMenuButton(
            icon: Icon(Icons.sort),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Sort by ID (Desc)'),
                onTap: () {
                  _getSortedCart('desc');
                },
              ),
              PopupMenuItem(
                child: Text('Sort by ID (Asc)'),
                onTap: () {
                  _getSortedCart('asc');
                },
              ),
            ],
          ),
        ],
      ),
      body: _cartItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final cart = _cartItems[index];
          final List products = cart['products'];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cart ID: ${cart['id']}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("User    ID: ${cart['userId']}"),
                  Text("Date: ${cart['date']}"),
                  Divider(),
                  Text("Products:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 100, // You can adjust this height
                    child: SingleChildScrollView(
                      child: Column(
                        children: products.map((product) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Product ID: ${product['productId']}"),
                                Text("Quantity: ${product['quantity']}"),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _fetchSingleCartDetails(cart['id']);
                    },
                    child: Text("View Details"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _fetchCartsByUserId(cart['userId']);
                    },
                    child: Text("View User Carts"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CalendarPickupPage(
      selectedItems: selectedItems,
    ),
  ),
);


class CalendarPickupPage extends StatelessWidget {
  final List<String> selectedItems;

  CalendarPickupPage({required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    // Your existing code for CalendarPickupPage
  }
}


Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SummaryPickup(
      selectedDate: selectedDate, // Assuming you have this in CalendarPickupPage
      selectedSlot: selectedSlot, // Assuming you have this in CalendarPickupPage
      selectedItems: selectedItems,
    ),
  ),
);


for title

// In RateCardPickupPage, create a list of titles
final List<String> selectedItemTitles = selectedItems.map((item) => item.title).toList();


Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CalendarPickupPage(
      selectedItemTitles: selectedItemTitles,
    ),
  ),
);


Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SummaryPickup(
      selectedDate: selectedDate,
      selectedSlot: selectedSlot,
      selectedItemTitles: selectedItemTitles,
    ),
  ),
);
