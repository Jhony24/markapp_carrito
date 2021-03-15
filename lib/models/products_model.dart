/*class Productos {
  final String id;
  final String name;
  final String stock;
  final String description;
  final String price;
  final String image;
  final String productImage;

  Productos(this.id, this.name, this.stock, this.description, this.price, this.image, this.productImage);

  Productos.fromMap(Map<String,dynamic> data, String id)
  : name = data['name'];

    stock = data['stock'];
    description = data['description'];
    price = data['price'];
    image = data['stock'];
    productImage = data['ProductImage'];
    id=id;
  

}*/

class Product {
  final String stock;
  final String name;
  final String description;
  final String price;
  final String price2;
  final String image;
  final String id;

  Product(this.stock, this.name, this.description, this.price, this.image,
      this.id, this.price2);

  Product.fromMap(Map<String, dynamic> data, String id)
      : stock = data['stock'],
        name = data['name'],
        description = data['description'],
        price = data['price'],
        price2 = data['price2'],
        image = data['image'],
        id = id;
}
