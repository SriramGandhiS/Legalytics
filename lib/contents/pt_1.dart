import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:login_signup/quizeasy/pt_1.dart';

const String videoUrl =
    'https://firebasestorage.googleapis.com/v0/b/myappconsi.appspot.com/o/pt_1English.mp4?alt=media&token=0fbf9a2b-1691-4514-adb4-b5c3f9654e60';

class VideoPlayerScreen1 extends StatefulWidget {
  const VideoPlayerScreen1({super.key});

  @override
  State<VideoPlayerScreen1> createState() => _VideoPlayerScreen1State();
}

class _VideoPlayerScreen1State extends State<VideoPlayerScreen1>
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isVideoLoaded = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _loadVideo() {
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() => _isVideoLoaded = true);
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            _controller.pause();
            _showQuizPromptDialog();
          }
        });
      });
  }

  void _showQuizPromptDialog() {
    showDialog(
      context: context,
      builder: (_) => _buildGlassDialog(
        title: "🎯 Quiz Time!",
        content:
            "You’ve completed the video! Would you like to take the quiz now or later?",
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => QuizScreen1()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3E7B87),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Take Quiz Now",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (_) => _buildGlassDialog(
        title: "📘 Video Description",
        content:
            '''In this video, we explore **Part I: Union and Its Territory**, which defines India’s territorial structure.

🗺️ **Key Articles:**
• Article 1: The Union of India  
• Article 2: Admission and Establishment of New States  
• Article 3: Formation & Alteration of State Areas  
• Article 4: Laws under Articles 2 & 3  

🧠 Learn how India maintains unity through its constitutional framework with real examples like Telangana & J&K.''',
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassDialog({
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 12),
                Text(content,
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: e,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isVideoLoaded) _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1B2D33);
    const Color accentColor = Color(0xFF3E7B87);
    const Color lightAccent = Color(0xFFB4D6CD);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Part I: Union and Its Territory',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showDescriptionDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🖼️ Background with blur
          Positioned.fill(
            child: Image.asset('assets/images/hbg.jpg', fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // 🎥 Video or Play Button
          Center(
            child: !_isVideoLoaded
                ? ScaleTransition(
                    scale: _pulseAnimation,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_fill, size: 30),
                      label: const Text(
                        "Play Video",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                        shadowColor: accentColor.withOpacity(0.5),
                      ),
                      onPressed: _loadVideo,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(_controller),
                              _buildVideoProgress(),
                              _buildControls(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),

      // 🎮 Floating Play/Pause Button
      floatingActionButton: _isVideoLoaded
          ? AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (_, __) => Transform.scale(
                scale: _pulseAnimation.value,
                child: FloatingActionButton(
                  backgroundColor: lightAccent,
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
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.black87,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // 🎚️ Custom Video Controls
  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _controlButton(Icons.replay_10, () {
            final newPos = _controller.value.position - const Duration(seconds: 10);
            _controller.seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
          }),
          const SizedBox(width: 10),
          _controlButton(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
          ),
          const SizedBox(width: 10),
          _controlButton(Icons.forward_10, () {
            final newPos = _controller.value.position + const Duration(seconds: 10);
            _controller.seekTo(newPos);
          }),
        ],
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildVideoProgress() {
    return VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      colors: const VideoProgressColors(
        playedColor: Color(0xFF3E7B87),
        backgroundColor: Colors.white30,
        bufferedColor: Color(0xFFB4D6CD),
      ),
    );
  }
}
