import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/themes/app_theme.dart';
import 'package:shopping_app/presentation/bloc/product_bloc.dart';
import 'package:shopping_app/presentation/screens/catalogue_screen.dart';


void main() {
  runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductBloc()),
      ],
      child: MaterialApp(
        title: 'Shopping Cart',
        theme: AppTheme.lightTheme,
        home: CatalogueScreen(),
      ),
    );
  }
}