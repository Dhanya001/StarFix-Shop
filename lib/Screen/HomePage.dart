import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:starfix_shopping/Auth/Login.dart';
import 'package:http/http.dart' as http;
import 'package:starfix_shopping/Screen/Bottom_Navigation.dart';
import 'package:starfix_shopping/Screen/CartPage.dart';

import 'package:starfix_shopping/Screen/ProductDetail.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  List _Products = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _GetAllProducts() async{
    final url='https://fakestoreapi.com/products';
    final response=await http.get(Uri.parse(url));
    if(response.statusCode==200){
      final jsondata=jsonDecode(response.body);
      setState(() {
        _Products = jsondata;
      });

    }
  }

  Future<void> _SearchProducts(String query) async {
    final url = 'https://fakestoreapi.com/products?limit=5&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body);
      setState(() {
        _Products = jsondata;
      });
    }
  }

  Future<void> _GetCategoryProducts(String category) async {
    final url = 'https://fakestoreapi.com/products/category/$category';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body);
      setState(() {
        _Products = jsondata;
      });
    }
  }

  Future<void> _getSortedProducts(String sortBy) async {
    final url = 'https://fakestoreapi.com/products';
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

  Future<void> _addProduct() async {
    final url = 'https://fakestoreapi.com/products';
    final response = await http.post(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      'title': 'test product',
      'price': 13.5,
      'description': 'lorem ipsum set',
      'image': 'https://i.pravatar.cc',
      'category': 'electronic'
    }));
    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body);
      print(response.body);
      print('Product added successfully');
    } else {
      print('Failed to add product');
    }
  }

  Future<void> _updateProduct() async {
    final url = 'https://fakestoreapi.com/products/7';
    final response = await http.put(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      'title': 'test product',
      'price': 13.5,
      'description': 'lorem ipsum set',
      'image': 'https://i.pravatar.cc',
      'category': 'electronic'
    }));
    if (response.statusCode == 200) {
      print(response.body);
      print('Product updated successfully');
    } else {
      print('Failed to update product');
    }
  }

  Future<void> _deleteProduct() async {
    final url = 'https://fakestoreapi.com/products/6';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.body);
      print('Product deleted successfully');
    } else {
      print('Failed to delete product');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _GetAllProducts();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
        break;
      case 1:
        /*Navigator.push(
          context,
          //MaterialPageRoute(builder: (context) => ExplorePage()),
        );*/
        break;
      case 2:
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RateUsPage()),
        );*/
        break;
      case 3:
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingPage()),
        );*/
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
      backgroundColor: Color(0xFFdcb7b4),
        title: Text('StarFix Shop',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart_outlined,size: 30,color: Colors.black,),
            onPressed: () {
            Navigator.push(
              context,
            MaterialPageRoute(builder: (context)=> Cartpage()),
            );
            },),
          IconButton(icon: Icon(Icons.person_pin_outlined,size: 30,color: Colors.black,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> LoginPage()),
              );
          },),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/drawer.jpg'), fit: BoxFit.cover),
                color: Color(0xFFdcb7b4),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('StarFix Shop',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
            TextButton(
              onPressed: _updateProduct,
              child: Text('Update Product'),
            ),
            TextButton(
              onPressed: _deleteProduct,
              child: Text('Delete Product'),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Search Products',
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                    onSubmitted: (query){
                      _SearchProducts(query);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    child: PopupMenuButton(itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('All Category'),
                        onTap: () {
                          _GetAllProducts();
                        },
                      ),
                      PopupMenuItem(
                        child: Text('Mens Clothing'),
                        onTap: () {
                          _GetCategoryProducts("men's clothing");
                        },
                      ),
                      PopupMenuItem(
                        child: Text('Jewelery'),
                        onTap: () {
                          _GetCategoryProducts('jewelery');
                        },
                      ),
                      PopupMenuItem(
                        child: Text('Electronics'),
                        onTap: () {
                          _GetCategoryProducts('electronics');
                        },
                      ),
                      PopupMenuItem(
                        child: Text('Womens Clothing'),
                        onTap: () {
                          _GetCategoryProducts("women's clothing");
                        },
                      ),
                    ],),
                  ),
                ),
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: PopupMenuButton(
                    icon: Icon(Icons.sort),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Sort by ID (Desc)'),
                        onTap: () {
                          _getSortedProducts('desc');
                        },
                      ),
                      PopupMenuItem(
                        child: Text('Sort by ID (Asc)'),
                        onTap: () {
                          _getSortedProducts('asc');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12,),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _Products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Productdetail(_Products[index]['id'])),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey, width: 2.0),
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Image.network(_Products[index]['image'], fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Text(
                            _Products[index]['category'],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              _Products[index]['title'],
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${_Products[index]['price']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                            ),
                          ),
                          //Text(_Products[index]['description'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                            Opacity(
                              opacity: 0.0, // Make the ID text invisible
                              child: Text('ID: ${_Products[index]['id']}', style: TextStyle(fontSize: 12)),
                            ),
                          //Text('ID: ${_Products[index]['id']}', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex,
        onTap: _onTap,),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Dummy data for onboarding images and texts
  final List<String> _images = [
    'assets/image1.png', // Replace with your image paths
    'assets/image2.png',
    'assets/image3.png',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNext() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Navigate to the main screen or perform any other action
    }
  }

  void _onSkip() {
    // Handle skip action, like navigating to the main screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Welcome to the App!', // Customize the text for each page
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _onSkip,
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3, // Controls how much the dot expands
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onNext,
              child: Text(_currentPage == _images.length - 1 ? 'Finish' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Dummy data for onboarding images and texts
  final List<String> _images = [
    'assets/image1.png', // Replace with your image paths
    'assets/image2.png',
    'assets/image3.png',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNext() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Navigate to the main screen or perform any other action
    }
  }

  void _onSkip() {
    // Handle skip action, like navigating to the main screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Welcome to the App!', // Customize the text for each page
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _onSkip,
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3, // Controls how much the dot expands
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onNext,
              child: Text(_currentPage == _images.length - 1 ? 'Finish' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Dummy data for onboarding images and texts
  final List<String> _images = [
    'assets/image1.png', // Replace with your image paths
    'assets/image2.png',
    'assets/image3.png',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNext() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Navigate to the main screen or perform any other action
    }
  }

  void _onSkip() {
    // Handle skip action, like navigating to the main screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Welcome to the App!', // Customize the text for each page
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _onSkip,
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3, // Controls how much the dot expands
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onNext,
              child: Text(_currentPage == _images.length - 1 ? 'Finish' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Dummy data for onboarding images and texts
  final List<String> _images = [
    'assets/image1.png', // Replace with your image paths
    'assets/image2.png',
    'assets/image3.png',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNext() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Navigate to the main screen or perform any other action
    }
  }

  void _onSkip() {
    // Handle skip action, like navigating to the main screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Welcome to the App!', // Customize the text for each page
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _onSkip,
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3, // Controls how much the dot expands
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _onNext,
              child: Text(_currentPage == _images.length - 1 ? 'Finish' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Register and Login Buttons')),
        body: RegisterLoginScreen(),
      ),
    );
  }
}

class RegisterLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Center(
            child: Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  // Register button logic here
                },
                child: Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  // Login button logic here
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';

class RateCardPickup extends StatefulWidget {
  const RateCardPickup({super.key});

  @override
  State<RateCardPickup> createState() => _RateCardPickupState();
}

class _RateCardPickupState extends State<RateCardPickup> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchItems = [];

  final List<Map<String, dynamic>> rateItems = [
    {'title': 'News paper', 'price': '₹1200/kg', 'image': 'assets/Newspaper3.png', 'isChecked': false},
    {'title': 'Plastic Bottles', 'price': '₹10/kg', 'image': 'assets/Bottle.png', 'isChecked': false},
    {'title': 'Aluminum Cans', 'price': '₹28/kg', 'image': 'assets/Newspaper3.png', 'isChecked': false},
    {'title': 'E-Waste', 'price': '₹50/kg', 'image': 'assets/Bottle.png', 'isChecked': false},
    // Add more items here
  ];

  @override
  void initState() {
    super.initState();
    _searchItems = rateItems;
  }

  void _runFilter(String keyword) {
    List<Map<String, dynamic>> results = [];
    if (keyword.isEmpty) {
      results = rateItems;
    } else {
      results = rateItems.where((item) => item["title"]!.toLowerCase().contains(keyword.toLowerCase())).toList();
    }
    setState(() {
      _searchItems = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Schedule Pick Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16)),
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product",
                ),
                onChanged: (value) => _runFilter(value),
              ),
            ),
            Expanded(
              child: _searchItems.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: _searchItems.length,
                      itemBuilder: (context, index) {
                        final item = _searchItems[index];
                        return _buildRateCardPickUp(
                          index: index,
                          title: item['title']!,
                          price: item['price']!,
                          image: item['image']!,
                          isChecked: item['isChecked']!,
                        );
                      },
                    )
                  : const Center(child: Text("No result Found")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCardPickUp({
    required int index,
    required String title,
    required String price,
    required String image,
    required bool isChecked,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _searchItems[index]['isChecked'] = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}


ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Schedulersummary(rateItems: rateItems),
      ),
    );
  },
  child: Text("Proceed"),
),


import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'package:scrapapp/screens/HomePage.dart';
import 'package:gap/gap.dart';

class Schedulersummary extends StatefulWidget {
  final DateTime selectedDate;
  final String estimatedWeight;

  const Schedulersummary({super.key, required this.selectedDate, required this.estimatedWeight});

  @override
  State<Schedulersummary> createState() => _SchedulersummaryState();
}

class _SchedulersummaryState extends State<Schedulersummary> {
  final TextEditingController _notescontroller = TextEditingController();

  String _monthName(int month) {
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, "Schedule Pick Up", "Pick Up Summary"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
              child: Text(
                "${widget.selectedDate.day} ${_monthName(widget.selectedDate.month)} ${widget.selectedDate.year}",
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 160,
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey, width: 2)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  MyMediumText(title: "Estimate Weight:", isBold: true, color: Colors.black),
                  Gap(20),
                  Text(widget.estimatedWeight), // Displaying the estimated weight
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyMediumText(title: "Notes", isBold: true, color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 2, color: Colors.grey)),
              child: TextFormField(
                controller: _notescontroller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Enter Product Notes",
                ),
                maxLines: 4,
              ),
            ),
            MyBottomButton(title: "Schedule Pick Up Now", destination: HomePage())
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'SchedulerSummary.dart';
import 'package:table_calendar/table_calendar.dart';

class Calenderpickup extends StatefulWidget {
  final String estimatedWeight;

  const Calenderpickup({super.key, required this.estimatedWeight});

  @override
  State<Calenderpickup> createState() => _CalenderpickupState();
}

class _CalenderpickupState extends State<Calenderpickup> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  int? _selectedslot;

  final List<String> _timeslot = [
    "09:00 AM - 12:00 PM",
    "01:00 PM - 04:00 PM",
    "05:00 PM - 08:00 PM",
  ];

  @override
  void initState() {
    _selectedDate = _focusedDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, "Schedule Pick Up", "Pick Up Date & Time-slots"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(1999),
                  lastDay: DateTime(2030),
                  selectedDayPredicate: (day) {
                    return isSameDay(_focusedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = selectedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: MyMediumText(title: "Pick a slot", isBold: true, color: Colors.black),
              ),
              SizedBox(height: 10),
              Column(
                children: List.generate(_timeslot.length, (index) {
                  return Container(
                    color: Colors.white,
                    child: RadioListTile<int>(
                      dense: true,
                      value: index,
                      groupValue: _selectedslot,
                      onChanged: (value) {
                        setState(() {
                          _selectedslot = value;
                        });
                      },
                      title: Text(_timeslot[index], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                      activeColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }),
              ),
              MyBottomButton(
                title: "Next",
                destination: Schedulersummary(
                  selectedDate: _focusedDay,
                  estimatedWeight: widget.estimatedWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrapapp/Utility/Widget_Helper.dart';
import 'CalenderPickUp.dart';

class CapturePickup extends StatefulWidget {
  const CapturePickup({super.key});

  @override
  State<CapturePickup> createState() => _CapturePickupState();
}

class _CapturePickupState extends State<CapturePickup> {
  final TextEditingController _weightcontroller = TextEditingController();
  final picker = ImagePicker();
  File? _image;

  Future getImageGallery() async {
    final pickedfile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedfile != null ? File(pickedfile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appbar(context, "Schedule Pick Up", "Upload a Photo"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: _image != null
                        ? Image.file(_image!.absolute, fit: BoxFit.cover)
                        : Center(child: Icon(Icons.add_photo_alternate_outlined, size: 30)),
                  ),
                ),
              ],
            ),
          ),
          MySmallText(
            title: "Capture a clear image of the selected products.",
            isBold: true,
            color: Colors.black,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: MyMediumText(title: "Estimate Weight", isBold: true, color: Colors.black),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 2, color: Colors.grey)),
            child: TextFormField(
              controller: _weightcontroller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: InputBorder.none,
                hintText: "Enter Product Estimate Weight",
              ),
            ),
          ),
          Spacer(),
          MyBottomButton(
            title: "Next",
            destination: Calenderpickup(estimatedWeight: _weightcontroller.text),
          ),
        ],
      ),
    );
  }
}


class Schedulersummary extends StatelessWidget {
  final List<Map<String, dynamic>> rateItems;

  const Schedulersummary({Key? key, required this.rateItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter the list to include only selected items
    final selectedItems = rateItems.where((item) => item['isChecked'] == true).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Schedule Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selected Items:", style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 10),
            ...selectedItems.map((item) => Text(item['title'])).toList(),
          ],
        ),
      ),
    );
  }
}

