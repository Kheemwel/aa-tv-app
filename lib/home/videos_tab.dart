import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/custom_widgets/focus_twinkling_border_button.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({super.key});

  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> with TickerProviderStateMixin {
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
              FocusableSecondTab(text: 'Live TV'),
              FocusableSecondTab(text: 'News'),
              FocusableSecondTab(text: 'Politics'),
              FocusableSecondTab(text: 'Education'),
              FocusableSecondTab(text: 'Sports'),
              FocusableSecondTab(text: 'Music & Arts'),
              FocusableSecondTab(text: 'Business'),
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

class FocusableSecondTab extends StatelessWidget {
  const FocusableSecondTab({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return FocusTwinklingBorderContainer(child: Tab(text: text,));
  }
}
