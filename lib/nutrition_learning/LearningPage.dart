import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../pancake.dart';
import '../BottomBar.dart';

class LearningPage extends StatelessWidget {
  LearningPage({Key? key}) : super(key: key);

  final List<Map<String, String>> _videos = [
    {'title': 'Lesson 1. Nutrition 101', 'id': 'U2U5KLXg6Tk'},
    {'title': 'Lesson 2. Nutrition and Metabolism', 'id': 'fR3NxCR9z2U'},
    {'title': 'Lesson 3. How Food Affects the Brain', 'id': 'xyQY8a-ng6g'},
    {'title': 'Lesson 4. The Best Diet in the WORLD', 'id': 'dQw4w9WgXcQ'},
    {'title': 'Lesson 5. Micronutrients vs. Macronutrients', 'id': '5Wr1N1nazZ4'},
    {'title': 'Lesson 6. Intro to the Mediterranean Diet', 'id': 'SMsy_XuofMo'},
    {'title': 'Lesson 7. Intermittent Fasting', 'id': 'xrZMYVDcjZI'},
    {'title': 'Lesson 8. Guide to Meal Prepping', 'id': 'NO-EbXMB4gc'},
    {'title': 'Lesson 9. Cooking for Beginners', 'id': 'aopS3q6f1GY'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        leading: const PancakeMenuButton(),
        title: Row(
          mainAxisSize: MainAxisSize.min, // Makes Row only as wide as content
          children: [
            const Text(
              'Learning Videos',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 8),
            Icon(Icons.school, color: Colors.white),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select a topic to learn more:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_videos[index]['title']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(
                          videoId: _videos[index]['id']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const WhiteBottomBar(),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String videoId;

  const VideoPlayerPage({Key? key, required this.videoId}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(() {
      if (_controller.value.isReady) {
        print('Video is ready to play');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print('Player is ready.');
          },
        ),
      ),
    );
  }
}
