  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:shopping_app/presentation/bloc/product_bloc.dart';
  import 'package:shopping_app/presentation/bloc/product_state.dart';

  class CartScreen extends StatelessWidget {
    const CartScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          backgroundColor: Colors.pink[50], 

        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final productBloc = context.read<ProductBloc>();
            final cart = productBloc.cart;
            final cartQuantities = productBloc.cartQuantities;

            // If cart is empty, show "Cart is Empty" message
            if (cart.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Cart is Empty',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to shop screen or home screen
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Shop Now'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      final quantity = cartQuantities[product.id] ?? 0;

                      return Container(
                        decoration: BoxDecoration(
    color: Colors.white, // Background color
    borderRadius: BorderRadius.circular(12), // Optional rounded corners
    border: Border.all(color: Colors.grey.shade300), // Optional border
  ),
  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Add spacing
  padding: const EdgeInsets.all(8), 
                        child: ListTile(
                          
                          leading: Image.network(
                            product.thumbnail,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.title, style: const TextStyle(fontSize: 19)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('₹${product.discountedPrice.toStringAsFixed(2)}'),
                              Text('${product.discountPercentage.toStringAsFixed(0)}% OFF'),
                            ],
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(color: const Color.fromARGB(255, 212, 211, 211), borderRadius: BorderRadius.circular(16),),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    // Use a method that correctly updates quantity
                                    productBloc.decreaseQuantity(product);
                                  },
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    // Use a method that correctly adds to cart
                                    productBloc.addToCart(product);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bottom section with total and checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left

                    children: [
              Text(
                    " Amount Price",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${productBloc.calculateTotalPrice().toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement checkout logic
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 50),
                            ),
                            child: const Text(
                              'Check Out', 
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
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