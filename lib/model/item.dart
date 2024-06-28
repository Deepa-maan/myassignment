class Item {
  final int? id;
  final String name;
  final String description;
  final String imageUrl;
  final String timeAdded;
  final int rating;
  final int numberOfViews;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.timeAdded,
    required this.rating,
    required this.numberOfViews,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'timeAdded': timeAdded,
      'rating': rating,
      'numberOfViews': numberOfViews,
    };
  }
}