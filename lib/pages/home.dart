import 'package:carrito_oferta/pages/add_products.dart';
import 'package:carrito_oferta/pages/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selecteditem = 0;

  var _pages = [AddProducts(), ProductsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        ),
      ),

      body: _pages[_selecteditem],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selecteditem,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_business_sharp,
                size: 35,
              ),
              label: 'Agregar Producto'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 35),
              label: 'Carrito de Compras'),
        ],
        onTap: (index) {
          setState(() {
            _selecteditem = index;
          });
        },
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
