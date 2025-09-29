import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum Status { initial, loading, success, error }

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> products = [];
  bool hasMore = true;
  int _skip = 0;
  final int _limit = 20;

  Status status = Status.initial;
  String? errorMessage;

  ProductProvider() {
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    status = Status.loading;
    notifyListeners();
    _skip = 0;
    try {
      final data = await _api.fetchProducts(limit: _limit, skip: _skip);
      products = data;
      _skip += data.length;
      hasMore = data.length == _limit;
      status = Status.success;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchMore() async {
    if (!hasMore || status == Status.loading) return;
    try {
      final data = await _api.fetchProducts(limit: _limit, skip: _skip);
      products.addAll(data);
      _skip += data.length;
      hasMore = data.length == _limit;
      notifyListeners();
    } catch (_) {
    }
  }

  Future<void> refresh() async {
    await fetchInitial();
  }

  Future<void> search(String q) async {
    if (q.trim().isEmpty) {
      await fetchInitial();
      return;
    }
    status = Status.loading;
    notifyListeners();
    try {
      final data = await _api.searchProducts(q, limit: 1000);
      products = data;
      hasMore = data.length == 1000;
      status = Status.success;
      notifyListeners();
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

//Create:
  Future<Product?> addProduct(Product p) async {
    status = Status.loading;
    notifyListeners();
    try {
      final created = await _api.createProduct(p);
      products.insert(0, created);
      status = Status.success;
      notifyListeners();
      return created;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

//Update:
  Future<Product?> updateProduct(Product p) async {
    status = Status.loading;
    notifyListeners();
    try {
      final updated = await _api.updateProduct(p);

      final idx = products.indexWhere((e) => e.id == updated.id);
      if (idx != -1) {
        products[idx] = updated;
      } else {
        products.insert(0, updated);
      }

      status = Status.success;
      notifyListeners();
      return updated;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

//Delete:
  Future<bool> deleteProduct(int id) async {
    status = Status.loading;
    notifyListeners();
    try {
      await _api.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      status = Status.success;
      notifyListeners();
      return true;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<Product?> fetchProductById(int id) async {
    try {
      final fresh = await _api.getProductById(id);
      final idx = products.indexWhere((p) => p.id == fresh.id);
      if (idx != -1) {
        products[idx] = fresh;
      } else {
        products.insert(0, fresh);
      }
      notifyListeners();
      return fresh;
    } catch (e) {
      //Ignore
      return null;
    }
  }
}
