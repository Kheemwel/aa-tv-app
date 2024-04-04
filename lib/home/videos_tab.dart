import 'package:flutter/material.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ColoredBox(
          color: Color(Colors.grey[800]!.value),
          child: TabBar.secondary(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Live TV'),
              Tab(text: 'News'),
              Tab(text: 'Politics'),
              Tab(text: 'Education'),
              Tab(text: 'Sports'),
              Tab(text: 'Music & Arts'),
              Tab(text: 'Business'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              Center(child: Text('Live TV tab')),
              Center(child: Text('News tab')),
              Center(child: Text('Politics tab')),
              Center(child: Text('Education tab')),
              Center(child: Text('Sports tab')),
              Center(child: Text('Music & Arts tab')),
              Center(child: Text('Business tab')),
            ],
          ),
        ),
      ],
    );
  }
}
