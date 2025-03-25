import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/presentation/bloc/product_bloc.dart';
import 'package:shopping_app/presentation/bloc/product_state.dart';


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final productBloc = context.read<ProductBloc>();
          final cart = productBloc.cart;
          final cartQuantities = productBloc.cartQuantities;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final product = cart[index];
                    final quantity = cartQuantities[product.id] ?? 0;

                    return ListTile(
                      leading: Image.network(
                        product.thumbnail,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹${product.discountedPrice.toStringAsFixed(2)}'),
                          Text('${product.discountPercentage.toStringAsFixed(0)}% OFF'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              productBloc.removeFromCart(product);
                            },
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              productBloc.addToCart(product);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: ₹${productBloc.calculateTotalPrice().toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Implement checkout logic
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Check Out'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}