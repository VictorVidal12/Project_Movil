
class Product {
  int? id;
  String title;
  String description;
  num price;
  int stock;
  String thumbnail;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'],
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        price: j['price'] ?? 0,
        stock: j['stock'] ?? 0,
        thumbnail: j['thumbnail'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'price': price,
        'stock': stock,
        'thumbnail': thumbnail,
      };
}
