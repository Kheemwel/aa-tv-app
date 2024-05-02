import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

Future<List<Video>> getVideos() async {
  final Uri url = Uri.parse('https://android-tv.loca.lt/api/get-videos');
  const String token = 'e94061b3-bc9f-489d-99ce-ef9e8c9058ce';

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((data) => Video.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class Video {
  final int id;
  final String title;
  final String description;
  final String category;
  final String thumbnailPath;
  final String videoPath;
  final DateTime createdAt;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnailPath,
    required this.videoPath,
    required this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      thumbnailPath: json['thumbnail_path'] as String,
      videoPath: json['video_path'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String getFormattedDate() {
    return DateFormat('MMMM d, yyyy   hh:mm a').format(createdAt);
  }
}

class Videos extends StatefulWidget {
  final String category;
  const Videos({super.key, required this.category});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  late List<Video> _videos = [];
  bool _isContentEmpty = false;

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final videos = await getVideos();
      setState(() {
        _videos = videos
            .where((element) => element.category == widget.category)
            .toList();
        _isContentEmpty = _videos.isEmpty;
      });
    } catch (error) {
      print('Error: $error');
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
          bufferedColor: Color(Colors.green[900]!.value)),
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
    backgroundColor = Colors.grey[800];
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          backgroundColor = value ? Colors.green[900] : Colors.grey[800];
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
                      style: TextStyle(color: Colors.grey[300]),
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
