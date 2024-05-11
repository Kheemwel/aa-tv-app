class VideoCategories {
  final int id;
  final String category;

  VideoCategories({
    required this.id,
    required this.category,
  });

  factory VideoCategories.fromJson(Map<String, dynamic> json) {
    return VideoCategories(
      id: json['id'] as int,
      category: json['category_name'] as String,
    );
  }
}