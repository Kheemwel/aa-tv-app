import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/home/videos.dart';
import 'package:http/http.dart' as http;

Future<List<Categories>> getCategories() async {
  final Uri url = Uri.parse('https://android-tv.loca.lt/api/get-categories');
  const String token = 'e94061b3-bc9f-489d-99ce-ef9e8c9058ce';

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((data) => Categories.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class Categories {
  final int id;
  final String category;

  Categories({
    required this.id,
    required this.category,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'] as int,
      category: json['category_name'] as String,
    );
  }
}

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> with TickerProviderStateMixin {
  late final TabController _tabController;
  late List<Categories> _categories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _categories.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                color: Colors.grey[800],
                child: TabBar.secondary(
                    controller: _tabController,
                    tabs: List.generate(
                        _categories.length,
                        (index) => Tab(
                            text: _categories[index].category))),
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: List.generate(
                        _categories.length,
                        (index) =>
                            Videos(category: _categories[index].category))),
              ),
            ],
          );
  }
}