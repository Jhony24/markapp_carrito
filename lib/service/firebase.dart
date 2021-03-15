import 'package:carrito_oferta/models/products_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  static FirestoreService _firestoreService = FirestoreService._internal();
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService(){
    return _firestoreService;
  }

  Stream<List<Product>>getPracticas(){
    return _db.collection('products').snapshots().map(
      (snapshot) => snapshot.documents.map(
        (doc)=> Product.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
   
  }

  
}