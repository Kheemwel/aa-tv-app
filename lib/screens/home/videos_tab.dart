import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/models/video_categories.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';
import 'package:flutter_android_tv_box/screens/home/video_page.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> with TickerProviderStateMixin {
  late final TabController _tabController;
  late List<VideoCategories> _categories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await FetchData.getVideoCategories();
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      rethrow;
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
                color: Palette.getColor('secondary-background').withOpacity(0.5),
                child: TabBar.secondary(
                    controller: _tabController,
                    indicatorWeight: 0.01,
                    tabs: List.generate(
                      _categories.length,
                      (index) => Tab(text: _categories[index].category),
                    )),
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: List.generate(
                        _categories.length,
                        (index) =>
                            VideoPage(category: _categories[index].category))),
              ),
            ],
          );
  }
}
