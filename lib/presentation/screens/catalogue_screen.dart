import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/data/models/product_model.dart';
import 'package:shopping_app/presentation/bloc/product_bloc.dart';
import 'package:shopping_app/presentation/bloc/product_state.dart';
import 'package:shopping_app/presentation/screens/cart_screen.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({Key? key}) : super(key: key);

  @override
  _CatalogueScreenState createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch initial products
    context.read<ProductBloc>().fetchProducts(_currentPage);
    
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final state = context.read<ProductBloc>().state;
      
      if (state is ProductLoaded && 
          !state.hasReachedMax && 
          !_isLoading) {
        setState(() {
          _isLoading = true;
          _currentPage++;
        });
        
        context.read<ProductBloc>().fetchProducts(_currentPage).then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((_) {
          setState(() {
            _isLoading = false;
            _currentPage--;
          });
        });
      }
    }
  }

  void _showAddToCartSnackBar(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                backgroundColor: Colors.pink[50], 

      appBar: AppBar(
        title: const Text('Catalogue'),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              final productBloc = context.read<ProductBloc>();
              final cartItemCount = productBloc.cartQuantities.values.fold(
                0, 
                (previousValue, element) => previousValue + element
              );
              
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  CartScreen()),
                      );
                    },
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 10,
                        child: Text(
                          cartItemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading && state is! ProductLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () => context.read<ProductBloc>().fetchProducts(1),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is ProductLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductBloc>().resetProducts();
              },
              child: state.products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : GridView.builder(
                      controller: _scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: state.hasReachedMax 
                        ? state.products.length 
                        : state.products.length + 1,
                      itemBuilder: (context, index) {
                        // Show loading indicator at the end if more products can be loaded
                        if (index >= state.products.length) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final product = state.products[index];
                        return _buildProductCard(context, product);
                      },
                    ),
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final productBloc = context.read<ProductBloc>();
        final cartQuantity = productBloc.cartQuantities[product.id] ?? 0;

        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.thumbnail,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.brand,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${product.discountedPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                        if (cartQuantity > 0)
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  productBloc.removeFromCart(product);
                                },
                              ),
                              Text(cartQuantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  productBloc.addToCart(product);
                                },
                              ),
                            ],
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              productBloc.addToCart(product);
                              _showAddToCartSnackBar(context, product.title);
                            },
                            child: const Text('Add',style: TextStyle(color: Colors.white),),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}