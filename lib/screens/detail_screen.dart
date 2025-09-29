import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'form_screen.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context); 

    final fresh = prov.products.firstWhere(
      (p) => p.id == product.id,
      orElse: () => product,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(fresh.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => ProductFormScreen(product: fresh))),

            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text('Delete'),
                          content: const Text(
                              'Are you sure you want to delete this product?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete')),
                          ],
                        ));
                if (ok == true && fresh.id != null) {
                  await prov.deleteProduct(fresh.id!);
                  if (prov.status == Status.success) Navigator.pop(context);
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Error: ${prov.errorMessage ?? 'Error desconocido'}")));
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fresh.thumbnail.isNotEmpty)
              Center(
                  child:
                      Image.network(fresh.thumbnail, height: 180, fit: BoxFit.cover)),
            const SizedBox(height: 12),
            Text(fresh.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(fresh.description),
            const SizedBox(height: 12),
            Text('Price: \$${fresh.price}'),
            Text('Stock: ${fresh.stock}'),
          ],
        ),
      ),
    );
  }
}
