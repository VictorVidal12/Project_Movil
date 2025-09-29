import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const _base = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts({int limit = 20, int skip = 0}) async {
    final url = Uri.parse('$_base/products?limit=$limit&skip=$skip');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List products = data['products'] ?? [];
      return products.map((p) => Product.fromJson(p)).toList();
    }
    throw Exception('Failed to load products (status ${res.statusCode}): ${res.body}');
  }

  Future<Product> getProductById(int id) async {
    final res = await http.get(Uri.parse('$_base/products/$id'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return Product.fromJson(data);
    }
    throw Exception('Failed to fetch product with id $id (status ${res.statusCode})');
  }

  Future<List<Product>> searchProducts(String q, {int limit = 1000}) async {
    final query = q.trim();
    if (query.isEmpty) return [];

    final url = Uri.parse('$_base/products?limit=$limit');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List products = data['products'] ?? [];

      final lower = query.toLowerCase();
      final filtered = products
          .map((p) => Product.fromJson(p))
          .where((p) => p.title.toLowerCase().contains(lower))
          .toList();

      return filtered;
    }
    throw Exception('Search failed (status ${res.statusCode}): ${res.body}');
  }


  Future<Product> createProduct(Product p) async {
    final res = await http.post(
      Uri.parse('$_base/products/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': p.title,
        'description': p.description,
        'price': p.price,
        'stock': p.stock,
        'thumbnail': p.thumbnail
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Product.fromJson(json.decode(res.body));
    }
    throw Exception('Create failed (status ${res.statusCode}): ${res.body}');
  }

  Future<Product> updateProduct(Product p) async {
    final id = p.id;
    if (id == null) throw Exception('Product id required for update');

    final body = {
      'title': p.title,
      'description': p.description,
      'price': p.price,
      'stock': p.stock,
      'thumbnail': p.thumbnail,
    };

    final res = await http.put(
      Uri.parse('$_base/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (res.statusCode == 200) {
      return Product.fromJson(json.decode(res.body));
    }
    throw Exception('Update failed (status ${res.statusCode}): ${res.body}');
  }


  Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$_base/products/$id'));
    if (res.statusCode == 200) return;
    throw Exception('Delete failed (status ${res.statusCode}): ${res.body}');
  }
}
