import 'dart:async';
import 'dart:ui';

import 'package:carrito_oferta/models/products_model.dart';
import 'package:carrito_oferta/pages/update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carrito_oferta/service/firebase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

final productReference = FirebaseDatabase.instance.reference();

class _ProductsPageState extends State<ProductsPage> {
  Firestore _db = Firestore.instance;
  int valor1 = 0;
  int valoroferta = 0;

  List<Product> items;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    valor1 = 0;
    valoroferta = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  Future deletePost(String documentId) async {
    await _db.collection("products").document(documentId).delete();
    //await _db.document('documentId').delete();
  }

  Future enviar(String idpedido, String total, String oferta) async {
    Firestore.instance
        .collection('pedidos')
        .add({'idproducto': idpedido, "total": total, "totaloferta": oferta});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          SizedBox(height: 10),
                          Icon(Icons.shopping_cart_outlined),
                          SizedBox(width: 10),
                          Text(
                            "Carrito de Compras",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    StreamBuilder(
                      stream: FirestoreService().getPracticas(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Product>> snapshot) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Center(child: Text('Cargando...'));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data.length > 0) {
                              Product product = snapshot.data[index];
                              return InkWell(
                                onTap: () {
                                  if (int.parse(product.stock) > 0) {
                                    int stock = int.parse(product.stock) - 1;

                                    _db
                                        .collection("products")
                                        .document(product.id)
                                        .updateData(
                                            {"stock": stock.toString()});
                                    setState(() {
                                      valor1 =
                                          valor1 + int.parse(product.price);
                                      valoroferta = valoroferta +
                                          int.parse(product.price2);
                                    });
                                  } else {
                                    // ignore: unnecessary_statements
                                    null;
                                  }
                                },
                                child: Card(
                                  elevation: 4,
                                  child: ListTile(
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.delete_outline),
                                            onPressed: () {
                                              deletePost(product.id);
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdatePage(
                                                      product: product,
                                                    ),
                                                  ));
                                            })
                                      ],
                                    ),
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, bottom: 10),
                                          child: Image(
                                            width: 100,
                                            height: 145,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(product.image ??
                                                "https://jumboargentina.vteximg.com.br/arquivos/ids/586707-750-750/Snack-De-Arroz-Tosti-Sabor-Queso-70gr-Sin-Tac-1-849829.jpg?v=637268670157430000"),
                                          ),
                                        ),
                                        SizedBox(width: 20.0),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(product.name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20)),
                                              Text(product.description,
                                                  style: TextStyle(
                                                      color: Colors.black26,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                              SizedBox(height: 8.0),
                                              Text(
                                                  "Cantidad    " +
                                                      product.stock,
                                                  style: TextStyle(
                                                      color: Colors.black26,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                              SizedBox(height: 8.0),
                                              Text(
                                                  "Ahora    " +
                                                      "S/" +
                                                      product.price,
                                                  style: TextStyle(
                                                      color: Colors.black26,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15)),
                                              SizedBox(height: 5.0),
                                              Row(
                                                children: [
                                                  Container(
                                                    color: Colors.red,
                                                    child: Text(" oh! ",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ),
                                                  SizedBox(width: 20.0),
                                                  Text("S/" + product.price2,
                                                      style: TextStyle(
                                                          color: Colors.black26,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15)),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Text("nada");
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TOTAL A  PAGAR: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Ahora",
                                        style: TextStyle(
                                            color: Colors.black26,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    SizedBox(width: 10),
                                    Text("S/" + valor1.toString(),
                                        style: TextStyle(
                                            color: Colors.black26,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      color: Colors.red,
                                      child: Text(" oh! ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    SizedBox(width: 10),
                                    Text("S/" + valoroferta.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 60),
                            color: Colors.red,
                            onPressed: () {
                              enviar("1", valor1.toString(),
                                  valoroferta.toString());
                              setState(() {
                                valor1 = 0;
                                valoroferta = 0;
                              });
                              Fluttertoast.showToast(
                                msg: "Pedido enviado a Firebase",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Text("Siguiente",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro

}
