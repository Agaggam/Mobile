class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    bool isSupabase = json.containsKey('image_url');

    if (isSupabase) {
      final categoryData = json['categories'];
      String categoryName = (categoryData != null && categoryData is Map)
          ? categoryData['name']
          : 'Uncategorized';

      return Product(
        id: json['id'],
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        description: json['description'] ?? '',
        category: categoryName,
        image: json['image_url'],
      );
    } else {
      return Product(
        id: json['id'],
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        description: json['description'],
        category: json['category'],
        image: json['image'],
      );
    }
  }
}
