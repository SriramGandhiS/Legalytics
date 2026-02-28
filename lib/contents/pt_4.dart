import 'package:flutter/material.dart';
import 'package:login_signup/quizeasy/pt_2.dart';
import 'package:video_player/video_player.dart';

const String videoUrl =
    'https://firebasestorage.googleapis.com/v0/b/myappconsi.appspot.com/o/p4.mp4?alt=media&token=56f9e72a-cb2c-45a6-8383-a5071e1bb19e';

class VideoPlayerScreen4 extends StatefulWidget {
  @override
  _VideoPlayerScreen2State createState() => _VideoPlayerScreen2State();
}

class _VideoPlayerScreen2State extends State<VideoPlayerScreen4>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isVideoLoaded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
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
            _showQuizPromptDialog();
          }
        });
      });
  }

  void _showQuizPromptDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Time!'),
          content: Text(
              'You have completed the video. Would you like to take the quiz now or later?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Later'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToQuizScreen();
              },
              child: Text('Take Quiz Now'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToQuizScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizScreen2()),
    );
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Video Description'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '''Video Description:

Welcome back to our series on the Constitution of India! In this video, we delve into Part IV: Directive Principles of State Policy, which outlines the guidelines for the governance of India and sets the ideals that the state should strive towards to achieve social and economic democracy.

Key Highlights:

Introduction to Directive Principles: Understand the purpose and significance of the Directive Principles, which act as guiding principles for the central and state governments in India.

Distinction from Fundamental Rights: Learn about the difference between Directive Principles and Fundamental Rights, emphasizing that while Directive Principles are non-justiciable (not enforceable by any court), they are essential for governance.

Categories of Directive Principles:

  Social and Economic Welfare: Principles focusing on securing a social order to promote welfare, such as providing adequate means of livelihood, equal pay for equal work, and protection against economic exploitation.

  Gandhian Principles: Emphasizes ideals inspired by Mahatma Gandhi, including the promotion of cottage industries, organization of village panchayats, and prevention of alcohol consumption.

  Liberal Principles: Covers broader social objectives, such as the separation of the judiciary from the executive, protection of monuments, and international peace and security.

Key Articles Explained:

Article 39: Explores the duty of the state to provide adequate means of livelihood and equitable distribution of wealth.

Article 41: Right to work, education, and public assistance in certain cases.

Article 44: Promotion of a Uniform Civil Code for all citizens.

Article 45 & 46: Provisions for early childhood care and education and promotion of the educational and economic interests of Scheduled Castes, Scheduled Tribes, and other weaker sections.

Implementation and Challenges: Analysis of how these principles have influenced policies in India, such as the right to education and rural employment schemes, and the challenges faced in implementing them effectively.

Relevance in Contemporary India: Discussion on the current relevance of Directive Principles in shaping welfare policies and their role in bridging socio-economic inequalities.

Interactive Elements: The video includes infographics, case studies, and quizzes to make the learning experience engaging and memorable. We will explore landmark cases and debates that highlight the interplay between Directive Principles and Fundamental Rights.

Conclusion: Recap of the importance of Directive Principles as the moral compass for governance, driving India towards a more equitable and just society.

Call to Action: If you found this video helpful, please like, share, and subscribe to our channel. Hit the notification bell to keep learning about the Constitution of India in our ongoing series!

''',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part IV: Directive Principles of State Policy'),
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE0F7FA), Color(0xFFE1BEE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: !_isVideoLoaded
                      ? ScaleTransition(
                          scale: _animation,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blueAccent,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 8.0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                            ),
                            onPressed: _loadVideo,
                            child: Text(
                              'Play Video',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(_controller),
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.all(8.0),
                                colors: VideoProgressColors(
                                  playedColor: Colors.blue,
                                  backgroundColor: Colors.grey,
                                  bufferedColor: Colors.lightBlue,
                                ),
                              ),
                              _buildControls(),
                            ],
                          ),
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

  // Custom video controls
  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.replay_10),
          onPressed: () {
            final currentPosition = _controller.value.position;
            final rewindPosition =
                Duration(seconds: currentPosition.inSeconds - 10);
            _controller.seekTo(rewindPosition);
          },
        ),
        IconButton(
          icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.forward_10),
          onPressed: () {
            final currentPosition = _controller.value.position;
            final forwardPosition =
                Duration(seconds: currentPosition.inSeconds + 10);
            _controller.seekTo(forwardPosition);
          },
        ),
      ],
    );
  }
}
