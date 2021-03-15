import 'package:carrito_oferta/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductInformation extends StatefulWidget {
  final Product product;
  ProductInformation(this.product);
  @override
  _ProductInformationState createState() => _ProductInformationState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductInformationState extends State<ProductInformation> {
  List<Product> items;

  String productImage; //nuevo

  @override
  void initState() {
    super.initState();
    print(productImage); //nuevo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Information y Foto'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Container(
        height: 800.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text(
                  "Name : ${widget.product.name}",
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                Divider(),
                Container(
                  height: 300.0,
                  width: 300.0,
                  child: Center(
                    child: productImage == ''
                        ? Text('No Image')
                        : Image.network(productImage +
                            '?alt=media'), //nuevo para traer la imagen de firestore
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
