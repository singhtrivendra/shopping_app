import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/data/models/product_model.dart';
import 'package:shopping_app/data/repositories/api_service.dart';
import 'package:shopping_app/presentation/bloc/product_state.dart';


class ProductBloc extends Cubit<ProductState> {
  final ApiService _apiService = ApiService();
  final List<Product> _cart = [];
  final Map<int, int> _cartQuantities = {}; // Track product quantities

  ProductBloc() : super(ProductInitial());

  List<Product> get cart => _cart;
  Map<int, int> get cartQuantities => _cartQuantities;

  Future<void> fetchProducts(int page) async {
    try {
      emit(ProductLoading());
      final products = await _apiService.fetchProducts(page);
      
      // If it's the first page, reset the products list
      if (page == 1) {
        emit(ProductLoaded(products: products, isFirstLoad: true));
      } else {
        // For subsequent pages, append to existing products
        final currentState = state;
        if (currentState is ProductLoaded) {
          final updatedProducts = [...currentState.products, ...products];
          emit(ProductLoaded(products: updatedProducts, isFirstLoad: false));
        }
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void addToCart(Product product) {
    // Increment quantity if product already in cart
    if (_cartQuantities.containsKey(product.id)) {
      _cartQuantities[product.id] = (_cartQuantities[product.id] ?? 0) + 1;
    } else {
      _cartQuantities[product.id] = 1;
    }

    // Add product to cart if not already present
    if (!_cart.any((p) => p.id == product.id)) {
      _cart.add(product);
    }

    emit(CartUpdated(cart: _cart, cartQuantities: _cartQuantities));
  }

  void removeFromCart(Product product) {
    // Decrease quantity or remove completely
    if (_cartQuantities.containsKey(product.id)) {
      _cartQuantities[product.id] = (_cartQuantities[product.id] ?? 0) - 1;

      if ((_cartQuantities[product.id] ?? 0) <= 0) {
        _cartQuantities.remove(product.id);
        _cart.removeWhere((p) => p.id == product.id);
      }
    }

    emit(CartUpdated(cart: _cart, cartQuantities: _cartQuantities));
  }

  double calculateTotalPrice() {
    return _cart.fold(0.0, (total, product) {
      final quantity = _cartQuantities[product.id] ?? 0;
      return total + (product.discountedPrice * quantity);
    });
  }
}