import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/constants.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/database/videos_dao.dart';
import 'package:flutter_android_tv_box/widgets/remote_controller.dart';

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_android_tv_box/data/models/videos.dart';

// Package for caching image network
import 'package:cached_network_image/cached_network_image.dart';

class VideoPage extends StatefulWidget {
  final String category;
  const VideoPage({super.key, required this.category});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final VideosDAO _videosDAO = VideosDAO();
  static List<Videos> _videos = [];
  bool _isContentEmpty = false;
  bool _noInternetConnection = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      VideosDAO.fetchVideos();
      _fetchVideos();
    });
  }

  Future<void> _fetchVideos() async {
    try {
      final videos = await _videosDAO.queryVideos(widget.category);
      setState(() {
        _videos = videos
            .where((element) => element.category == widget.category)
            .toList();
        _isContentEmpty = _videos.isEmpty;
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
    return Center(child: _content());
  }

  Widget _content() {
    if (_videos.isEmpty && _isContentEmpty) {
      return const Text('No Content Available');
    }

    if (_videos.isNotEmpty) {
      return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
          itemBuilder: (BuildContext context, int index) {
            final video = _videos[index];
            
            return VideoTile(
              title: video.title,
              date: video.createdAt,
              description: video.description,
              thumbnail: "$urlAPI/${video.thumbnailPath}/$imageToken",
              onTap: () => _viewVideo(context, "$urlAPI/${video.videoPath}/$videoToken"),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: _videos.length);
    }

    if (_noInternetConnection) {
      return const Text('No Internet Connection');
    }

    return const CircularProgressIndicator();
  }

  void _viewVideo(BuildContext context, String videoLink) async {
    late VideoPlayerController videoController;
    try {
      // Show a loading dialog while the video initializes
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Dialog.fullscreen(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

      videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoLink),
      );

      await videoController.initialize();

      // Close the loading dialog after the video is initialized
      Navigator.of(context).pop();

      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.green,
          bufferedColor: Palette.getColor('secondary'),
        ),
        allowFullScreen: true,
        fullScreenByDefault: true,
      );

      final playerWidget = Chewie(
        controller: chewieController,
      );

      showDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(child: playerWidget),
      );
    } catch (e) {
      // Close the loading dialog if it's open
      Navigator.of(context).pop();

      // Show a dialog indicating that the video cannot be played
      showDialog(
        context: context,
        builder: (context) => const Dialog.fullscreen(
          child: Center(
            child: Text("The Video Cannot Be Played"),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }
}

class VideoTile extends StatefulWidget {
  final String title;
  final String date;
  final String description;
  final String thumbnail;
  final VoidCallback onTap;

  const VideoTile({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.thumbnail,
    required this.onTap,
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
    return buildRemoteController(
      onFocusChange: (value) {
        setState(() {
          backgroundColor = value
              ? Palette.getColor('secondary')
              : Palette.getColor('secondary-background');
        });
      },
      onClick: widget.onTap,
      child: GestureDetector(
        onTap: widget.onTap,
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
                width: 512,
                height: 288,
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: 512,
                      height: 288,
                      fit: BoxFit.cover,
                      imageUrl: widget.thumbnail,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Padding(
                        padding: EdgeInsets.all(2.5),
                        child: Placeholder(),
                      ),
                    )),
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
