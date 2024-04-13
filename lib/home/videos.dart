import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

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
  final String thumbnail;
  final String video;
  final DateTime createdAt;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.video,
    required this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnail: json['thumbnail'] as String,
      video: json['video'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String getFormattedDate() {
    return DateFormat('MMMM d, yyyy   hh:mm a').format(createdAt);
  }
}

class Videos extends StatefulWidget {
  const Videos({super.key});

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  late List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final videos = await getVideos();
      setState(() {
        _videos = videos;
      });
    } catch (error) {
      print('Error: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _videos.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
              itemBuilder: (BuildContext context, int index) {
                final video = _videos[index];
                return ListTile(
                  focusColor: Colors.green[900],
                  tileColor: Colors.grey[800],
                  textColor: Colors.white,
                  title: Text(video.title, style: const TextStyle(fontSize: 20),),
                  subtitle: SizedBox(
                    height: 250,
                    child: Row(
                      children: [
                        Image.memory(
                          base64Decode(video.thumbnail.split(',').last),
                          width: 250,
                        ),
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
                  onTap: () => _viewVideo(context, video.video),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: _videos.length)
          : const CircularProgressIndicator(),
    );
  }

  void _viewVideo(BuildContext context, String videoBase64) async {
    // Decode the base64 string to bytes
    final videoBytes = base64Decode(videoBase64.split(',').last);

    // Get the temporary directory and create a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile =
        await File('${tempDir.path}/temp_video.mp4').writeAsBytes(videoBytes);

    // Create a VideoPlayerController from the temporary file
    final videoController = VideoPlayerController.file(tempFile);

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
