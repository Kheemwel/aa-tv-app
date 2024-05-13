import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/network/fetch_data.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_android_tv_box/data/models/videos.dart';

class VideoPage extends StatefulWidget {
  final String category;
  const VideoPage({super.key, required this.category});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late List<Videos> _videos = [];
  bool _isContentEmpty = false;

  @override
  void initState() {
    super.initState();
    _fetchVideoPage();
  }

  Future<void> _fetchVideoPage() async {
    try {
      final videos = await FetchData.getVideos();
      setState(() {
        _videos = videos
            .where((element) => element.category == widget.category)
            .toList();
        _isContentEmpty = _videos.isEmpty;
      });
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _content());
  }

  Widget _content() {
    if (_videos.isEmpty && _isContentEmpty) {
      return const Text('No Content');
    }

    if (_videos.isNotEmpty) {
      return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
          itemBuilder: (BuildContext context, int index) {
            final video = _videos[index];

            return VideoTile(
              title: video.title,
              date: video.getFormattedDate(),
              description: video.description,
              thumbnail: video.thumbnailPath,
              ontap: () => _viewVideo(context, video.videoPath),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: _videos.length);
    }

    return const CircularProgressIndicator();
  }

  void _viewVideo(BuildContext context, String videoLink) async {
    final videoController = VideoPlayerController.networkUrl(
      Uri.parse(
        videoLink,
      ),
    );

    await videoController.initialize();

    final chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: true,
      looping: true,
      materialProgressColors: ChewieProgressColors(
          playedColor: Colors.green,
          bufferedColor: Palette.getColor('secondary')),
      fullScreenByDefault: true,
    );

    final playerWidget = Chewie(
      controller: chewieController,
    );

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(child: playerWidget),
    );
  }
}

class VideoTile extends StatefulWidget {
  final String title;
  final String date;
  final String description;
  final String thumbnail;
  final VoidCallback ontap;

  const VideoTile({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.thumbnail,
    required this.ontap,
  });

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();
    backgroundColor = Palette.getColor('secondary-background');
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          backgroundColor = value ? Palette.getColor('secondary') : Palette.getColor('secondary-background');
        });
      },
      child: GestureDetector(
        onTap: widget.ontap,
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 400,
                height: 300,
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.thumbnail,
                    width: 400,
                    height: 300,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Placeholder();
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(color: Palette.getColor('text-dark')),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
