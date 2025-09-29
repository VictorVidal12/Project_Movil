
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'detail_screen.dart';
import 'form_screen.dart';
import 'dart:async';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 200) {
        Provider.of<ProductProvider>(context, listen: false).fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductFormScreen())),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search products...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => prov.search(_searchCtrl.text),
                ),
              ),
              onSubmitted: (v) => prov.search(v),
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (prov.status == Status.loading && prov.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (prov.status == Status.error && prov.products.isEmpty) {
                return Center(child: Text("Error: ${prov.errorMessage ?? 'Error desconocido'}"));
              }
              return RefreshIndicator(
                onRefresh: prov.refresh,
                child: ListView.builder(
                  controller: _scroll,
                  itemCount: prov.products.length + (prov.hasMore ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= prov.products.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final p = prov.products[i];
                    return ListTile(
                      leading: p.thumbnail.isNotEmpty ? Image.network(p.thumbnail, width: 56, height: 56, fit: BoxFit.cover) : null,
                      title: Text(p.title),
                      subtitle: Text('\$${p.price} • stock: ${p.stock}'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
