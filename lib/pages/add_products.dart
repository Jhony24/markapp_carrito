import 'dart:io';

import 'package:carrito_oferta/models/products_model.dart';
import 'package:carrito_oferta/pages/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  AddProducts({Key key}) : super(key: key);

  @override
  _AddProductsState createState() => _AddProductsState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');
enum SelectSource { camara, galeria }

class _AddProductsState extends State<AddProducts> {
  final Firestore _db = Firestore.instance;

  List<Product> items;
  File _foto;
  String urlFoto;
  // ignore: unused_field
  bool _isInAsyncCall = false;
  int price;
  final _nameController = TextEditingController();
  final _price1Controller = TextEditingController();
  final _descriptionController = TextEditingController();
  final _price2Controller = TextEditingController();
  final _stockController = TextEditingController();

  //nuevo imagen
  String productImage;
  File image;
  final ImagePicker _picker = ImagePicker();

  _openGallery(BuildContext context) async {
    PickedFile _pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      image = File(_pickedFile.path);
    });
    //Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    PickedFile _pickedFile = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      image = File(_pickedFile.path);
    });
    //Navigator.of(context).pop();
  }

  Future _delay() {
    return Future.delayed(Duration(seconds: 5));
  }

  Future getImage() async {
    AlertDialog alerta = new AlertDialog(
      content: Text('Seleccione de donde desea capturar la imagen'),
      title: Text('Seleccione Imagen'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _openCamera(context);
            Navigator.of(context).pop();
          },
          child: Row(
            children: <Widget>[Text('Camara'), Icon(Icons.camera)],
          ),
        ),
        FlatButton(
          onPressed: () {
            _openGallery(context);
            Navigator.of(context).pop();
          },
          child: Row(
            children: <Widget>[Text('Galeria'), Icon(Icons.image)],
          ),
        )
      ],
    );
    showDialog(context: context, child: alerta);
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }
  //fin nuevo imagen

  @override
  void initState() {
    super.initState();
  }

  restablecer() {
    setState(() {
      _foto = null;
      _nameController.clear();
      _descriptionController.clear();
      _price1Controller.clear();
      _price2Controller.clear();
      _stockController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: getImage,
                      ),
                      margin: EdgeInsets.only(top: 20),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: image == null
                                  ? NetworkImage(
                                      "https://jumboargentina.vteximg.com.br/arquivos/ids/586707-750-750/Snack-De-Arroz-Tosti-Sabor-Queso-70gr-Sin-Tac-1-849829.jpg?v=637268670157430000")
                                  : FileImage(image))),
                    )
                  ],
                ),
                Text('click para cambiar foto'),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  controller: _nameController,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Nombre del Producto'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  controller: _descriptionController,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.list), labelText: 'Descripcion'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  controller: _price1Controller,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.monetization_on),
                      labelText: 'Precio Normal'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                TextField(
                  controller: _price2Controller,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.monetization_on),
                      labelText: 'Precio Oferta'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                TextField(
                  controller: _stockController,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.format_list_numbered),
                      labelText: 'Stock'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    color: Colors.red,
                    onPressed: () async {
                      final StorageReference fireStoreRef = FirebaseStorage
                          .instance
                          .ref()
                          .child('productos')
                          .child('${_nameController.text}.jpg');
                      final StorageUploadTask task = fireStoreRef.putFile(
                          image, StorageMetadata(contentType: 'image/jpeg'));
                      await task.onComplete.then((onValue) {
                        onValue.ref.getDownloadURL().then((onValue) async {
                          urlFoto = onValue.toString();
                          await _db.collection("products").add({
                            'name': _nameController.text,
                            "description": _descriptionController.text,
                            "price2": _price2Controller.text,
                            'image': urlFoto,
                            'price': _price1Controller.text,
                            "stock": _stockController.text
                          });

                          _isInAsyncCall = false;
                        });
                      });

                      Fluttertoast.showToast(
                        msg: "Agregando Producto Espere...",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                      );
                      await _delay();
                      Fluttertoast.showToast(
                        msg: "Producto Agregado",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                      );
                      restablecer();
                    },
                    child: Text('Agregar Producto',
                        style: TextStyle(color: Colors.white))),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
