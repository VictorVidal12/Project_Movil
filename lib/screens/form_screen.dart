import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _title, _desc, _price, _stock, _thumbnail;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = TextEditingController(text: p?.title ?? '');
    _desc = TextEditingController(text: p?.description ?? '');
    _price = TextEditingController(text: p?.price.toString() ?? '0');
    _stock = TextEditingController(text: p?.stock.toString() ?? '0');
    _thumbnail = TextEditingController(text: p?.thumbnail ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _price.dispose();
    _stock.dispose();
    _thumbnail.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final prov = Provider.of<ProductProvider>(context, listen: false);
    final prod = Product(
      id: widget.product?.id,
      title: _title.text.trim(),
      description: _desc.text.trim(),
      price: num.tryParse(_price.text) ?? 0,
      stock: int.tryParse(_stock.text) ?? 0,
      thumbnail: _thumbnail.text.trim(),
    );

    try {
      if (widget.product == null) {
        await prov.addProduct(prod);
      } else {
        await prov.updateProduct(prod);
      }
      if (prov.status == Status.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.product == null ? 'Producto creado' : 'Producto actualizado')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${prov.errorMessage ?? 'Error desconocido'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(text, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        if (required) ...[
          const SizedBox(width: 6),
          Text('*', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Crear producto' : 'Editar producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Campos con * son obligatorios', style: theme.textTheme.bodySmall),
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel('Título', required: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _title,
                        decoration: InputDecoration(
                          hintText: 'Nombre del producto',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'El título es obligatorio';
                          if (v.trim().length < 2) return 'El título es muy corto';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel('Descripción'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _desc,
                        decoration: InputDecoration(hintText: 'Descripción breve del producto'),
                        minLines: 3,
                        maxLines: 5,
                        validator: (v) {
                          if (v != null && v.trim().isNotEmpty && v.trim().length < 5) {
                            return 'Descripción demasiado breve';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel('Precio', required: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: '0'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'El precio es obligatorio';
                          final n = num.tryParse(v);
                          if (n == null) return 'Precio inválido';
                          if (n < 0) return 'Precio no puede ser negativo';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel('Stock', required: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _stock,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: '0'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'El stock es obligatorio';
                          final n = int.tryParse(v);
                          if (n == null) return 'Stock inválido';
                          if (n < 0) return 'Stock no puede ser negativo';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      _fieldLabel('Thumbnail URL'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _thumbnail,
                        decoration: InputDecoration(hintText: 'https://...'),
                        validator: (v) {
                          if (v != null && v.trim().isNotEmpty) {
                            final uri = Uri.tryParse(v);
                            if (uri == null || (!uri.isAbsolute)) return 'URL inválida';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isSubmitting
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary)),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('Guardando...', style: TextStyle(color: theme.colorScheme.onPrimary)),
                                  ],
                                )
                              : Text(widget.product == null ? 'Crear' : 'Guardar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
