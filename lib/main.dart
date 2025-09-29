import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'screens/list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        title: 'Products CRUD',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,

          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 0,
            centerTitle: false,
          ),

          scaffoldBackgroundColor: colorScheme.background,

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: colorScheme.surfaceVariant.withOpacity(0.04),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.9)),
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 2,
            ),
          ),

          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: BorderSide(color: colorScheme.primary.withOpacity(0.16)),
            ),
          ),

          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: colorScheme.onBackground,
                displayColor: colorScheme.onBackground,
              ),

          cardColor: colorScheme.surface,
          shadowColor: Colors.black.withOpacity(0.12),
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}
