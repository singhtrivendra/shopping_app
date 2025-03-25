class Product {
  final int id;
  final String title;
  final double price;
  final String brand;
  final String thumbnail;
  final double discountPercentage;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.brand,
    required this.thumbnail,
    required this.discountPercentage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      brand: json['brand'],
      thumbnail: json['thumbnail'],
      discountPercentage: json['discountPercentage'].toDouble(),
    );
  }

  double get discountedPrice => price * (1 - discountPercentage / 100);
}