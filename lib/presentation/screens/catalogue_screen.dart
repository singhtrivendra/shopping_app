// presentation/screens/catalogue_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/presentation/bloc/product_bloc.dart';
import 'package:shopping_app/presentation/bloc/product_state.dart';
import 'package:shopping_app/presentation/screens/cart_screen.dart';


class CatalogueScreen extends StatefulWidget {
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
    context.read<ProductBloc>().fetchProducts(_currentPage);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading) {
        setState(() {
          _isLoading = true;
          _currentPage++;
        });
        context.read<ProductBloc>().fetchProducts(_currentPage).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        MaterialPageRoute(builder: (context) => CartScreen()),
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
          
          if (state is ProductLoaded) {
            return GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: state.products.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the end if more products are being loaded
                if (index == state.products.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final product = state.products[index];
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
                                            color: Colors.green,
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
                                        },
                                        child: const Text('Add'),
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
              },
            );
          }
          return const Center(child: Text('No products found'));
        },
      ),
    );
  }
}
