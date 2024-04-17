import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

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
            .where((element) => element.category != widget.category)
            .toList();
        _isContentEmpty = _videos.isEmpty;
      });
    } catch (error) {
      print('Error: $error');
      // Handle error
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
            print(video.thumbnailPath);
            return ListTile(
              focusColor: Colors.green[900],
              tileColor: Colors.grey[800],
              textColor: Colors.white,
              title: Text(
                video.title,
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: SizedBox(
                height: 250,
                child: Row(
                  children: [
                    Image.network(video.thumbnailPath),
                    const SizedBox(
                      width: 100,
                    ),
                    Expanded(
                        child: Text(
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            video.description)),
                  ],
                ),
              ),
              trailing: Text(video.getFormattedDate()),
              onTap: () => _viewVideo(context, video.videoPath),
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

    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: VideoPlayer(videoController),
            ),
            Expanded(
                child: Center(
              child: TextButton(
                autofocus: true,
                onPressed: () {
                  Navigator.pop(context);
                }, // Implement clear logic
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ))
          ],
        ),
      ),
    );

    // Start playing the video when the dialog is shown
    videoController.initialize().then((_) {
      videoController.play();
    });
  }
}
