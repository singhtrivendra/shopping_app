import 'package:equatable/equatable.dart';
import 'package:shopping_app/data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool isFirstLoad;

  const ProductLoaded({required this.products, this.isFirstLoad = false});

  @override
  List<Object> get props => [products, isFirstLoad];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class CartUpdated extends ProductState {
  final List<Product> cart;
  final Map<int, int> cartQuantities;

  const CartUpdated({required this.cart, required this.cartQuantities});

  @override
  List<Object> get props => [cart, cartQuantities];
}