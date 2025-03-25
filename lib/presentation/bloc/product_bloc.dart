import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/data/models/product_model.dart';
import 'package:shopping_app/data/repositories/api_service.dart';
import 'package:shopping_app/presentation/bloc/product_state.dart';

class ProductBloc extends Cubit<ProductState> {
  final ApiService _apiService = ApiService();
  final List<Product> _cart = [];
  final Map<int, int> _cartQuantities = {}; // Track product quantities
  bool _hasReachedMax = false;

  ProductBloc() : super(ProductInitial());

  List<Product> get cart => _cart;
  Map<int, int> get cartQuantities => _cartQuantities;

  Future<void> fetchProducts(int page) async {
    try {
      // If we've already reached the max, don't fetch more
      if (_hasReachedMax && page > 1) return;

      // Show loading state for first page
      if (page == 1) {
        emit(ProductLoading());
      }

      final products = await _apiService.fetchProducts(page);
      
      // Check if we've reached the end of products
      _hasReachedMax = products.isEmpty;

      // Handle state based on current state and page
      final currentState = state;
      
      if (page == 1) {
        // First page load - replace existing products
        emit(ProductLoaded(
          products: products, 
          isFirstLoad: true,
          hasReachedMax: _hasReachedMax,
          cartQuantities: _cartQuantities
        ));
      } else if (currentState is ProductLoaded) {
        // Subsequent pages - append to existing products
        final updatedProducts = [...currentState.products, ...products];
        emit(ProductLoaded(
          products: updatedProducts, 
          isFirstLoad: false,
          hasReachedMax: _hasReachedMax,
          cartQuantities: _cartQuantities
        ));
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

    // Update state based on current state
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(ProductLoaded(
        products: currentState.products,
        isFirstLoad: currentState.isFirstLoad,
        hasReachedMax: _hasReachedMax,
        cartQuantities: Map.from(_cartQuantities)
      ));
    } else {
      emit(CartUpdated(cart: _cart, cartQuantities: _cartQuantities));
    }
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

    // Update state based on current state
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(ProductLoaded(
        products: currentState.products,
        isFirstLoad: currentState.isFirstLoad,
        hasReachedMax: _hasReachedMax,
        cartQuantities: Map.from(_cartQuantities)
      ));
    } else {
      emit(CartUpdated(cart: _cart, cartQuantities: _cartQuantities));
    }
  }

  void decreaseQuantity(Product product) {
    // If product is in cart
    if (_cartQuantities.containsKey(product.id)) {
      // Decrease quantity
      _cartQuantities[product.id] = (_cartQuantities[product.id] ?? 0) - 1;

      // If quantity becomes 0, remove from cart
      if ((_cartQuantities[product.id] ?? 0) <= 0) {
        _cartQuantities.remove(product.id);
        _cart.removeWhere((p) => p.id == product.id);
      }

      // Update state based on current state
      final currentState = state;
      if (currentState is ProductLoaded) {
        emit(ProductLoaded(
          products: currentState.products,
          isFirstLoad: currentState.isFirstLoad,
          hasReachedMax: _hasReachedMax,
          cartQuantities: Map.from(_cartQuantities)
        ));
      } else {
        emit(CartUpdated(cart: _cart, cartQuantities: _cartQuantities));
      }
    }
  }

  double calculateTotalPrice() {
    return _cart.fold(0.0, (total, product) {
      final quantity = _cartQuantities[product.id] ?? 0;
      return total + (product.discountedPrice * quantity);
    });
  }

  // Optional: Method to reset products (useful for pull-to-refresh)
  void resetProducts() {
    _hasReachedMax = false;
    fetchProducts(1);
  }
}