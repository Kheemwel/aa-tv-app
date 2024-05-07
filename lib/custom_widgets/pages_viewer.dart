import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagesViewer extends StatefulWidget {
  const PagesViewer({super.key, required this.pages});

  final List<Widget> pages;

  @override
  State<PagesViewer> createState() => _PagesViewerState();
}

class _PagesViewerState extends State<PagesViewer>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: widget.pages.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            if (_currentPageIndex > 0) {
              _updateCurrentPageIndex(_currentPageIndex - 1);
            } else {
              _updateCurrentPageIndex(_tabController.length - 1);
            }
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            if (_currentPageIndex < (_tabController.length - 1)) {
              _updateCurrentPageIndex(_currentPageIndex + 1);
            } else {
              _updateCurrentPageIndex(0);
            }
          } else if (event.logicalKey == LogicalKeyboardKey.goBack) {
            Navigator.pop(context);
          }
          return KeyEventResult.handled;
        } else {
          return KeyEventResult.ignored;
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
              controller: _pageViewController,
              onPageChanged: _handlePageViewChanged,
              children: widget.pages),
          PageIndicator(
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          ),
        ],
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex > 0) {
                onUpdateCurrentPageIndex(currentPageIndex - 1);
              } else {
                onUpdateCurrentPageIndex(tabController.length - 1);
              }
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.background,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex < (tabController.length - 1)) {
                onUpdateCurrentPageIndex(currentPageIndex + 1);
              } else {
                onUpdateCurrentPageIndex(0);
              }
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
