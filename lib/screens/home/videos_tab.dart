import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/database/video_categories_dao.dart';
import 'package:flutter_android_tv_box/data/models/video_categories.dart';
import 'package:flutter_android_tv_box/screens/home/video_page.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> with TickerProviderStateMixin {
  late final VideoCategoriesDAO _videoCategoriesDAO = VideoCategoriesDAO();
  late TabController _tabController;
  List<VideoCategories> _categories = [];
  bool _isContentEmpty = false;
  bool _noInternetConnection = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      VideoCategoriesDAO.fetchVideoCategories();
      _fetchCategories();
    });
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await _videoCategoriesDAO.queryVideoCategories();
      setState(() {
        _categories = categories;
        _tabController = TabController(length: _categories.length, vsync: this);
        _isContentEmpty = _categories.isEmpty;
      });
    } on SocketException {
      setState(() {
        _noInternetConnection = true;
      });
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    if (_categories.isEmpty && _isContentEmpty) {
      return const Center(child: Text('No Content Available'));
    }

    if (_categories.isNotEmpty) {
      return Column(
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

    if (_noInternetConnection) {
      return const Center(child: Text('No Internet Connection'));
    }

    return const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    timer.cancel();
  }
}
