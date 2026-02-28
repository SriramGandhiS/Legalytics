import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const String videoUrl =
    'https://firebasestorage.googleapis.com/v0/b/myappconsi.appspot.com/o/1(1).mp4?alt=media&token=1abb1bd3-c309-4546-a7f1-d434cd281097';

class VideoPlayerScreen19 extends StatefulWidget {
  @override
  _VideoPlayerScreen1State createState() => _VideoPlayerScreen1State();
}

class _VideoPlayerScreen1State extends State<VideoPlayerScreen19> {
  late VideoPlayerController _controller;
  bool _isVideoLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  void _loadVideo() {
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoLoaded = true;
        });
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            setState(() {
              _controller.pause();
            });
          }
        });
      });
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Video Description'),
          content: Text(
            'This video provides an overview of Part I: Union and its Territory. It covers the foundational aspects of the Union of India as described in the Constitution. Watch to understand the geographical and political boundaries defined by the Constitution.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (_isVideoLoaded) {
      _controller.removeListener(() {});
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part I: Union and its Territory'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showDescriptionDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: !_isVideoLoaded
                      ? ElevatedButton(
                          onPressed: _loadVideo,
                          child: Text('Play Video'),
                        )
                      : AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _isVideoLoaded
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
