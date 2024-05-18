import 'package:flutter_android_tv_box/data/models/model.dart';

/// Model class for categoried of videos from back-end
class VideoCategories extends Model {
  final int? id;
  final String category;

  VideoCategories({
    this.id,
    required this.category,
  });

  factory VideoCategories.fromMap(Map<String, dynamic> map) {
    return VideoCategories(
      id: map['id'] as int,
      category: map['category_name'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_name': category
    };
  }
}