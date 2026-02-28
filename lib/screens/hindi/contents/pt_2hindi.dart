import 'package:flutter/material.dart';
import 'package:login_signup/quizeasy/pt_2.dart';
import 'package:video_player/video_player.dart';

const String videoUrl =
    'https://firebasestorage.googleapis.com/v0/b/myappconsi.appspot.com/o/p2.mp4?alt=media&token=a2fb4840-6af4-4672-be00-35f6cc255256';

class VideoPlayerScreen2hindi extends StatefulWidget {
  @override
  _VideoPlayerScreen2State createState() => _VideoPlayerScreen2State();
}

class _VideoPlayerScreen2State extends State<VideoPlayerScreen2hindi>
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
          title: Text('क्विज़ समय!'),
          content: Text(
              'आपने वीडियो पूरा कर लिया है। क्या आप अब क्विज़ लेना चाहेंगे या बाद में?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('बाद में'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToQuizScreen();
              },
              child: Text('अब क्विज़ लें'),
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
          title: Text('वीडियो विवरण'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '''विवरण:

भारतीय संविधान के भाग II की गहराई से खोज में आपका स्वागत है, जो नागरिकता से संबंधित है। इस वीडियो में, हम संविधान में उल्लिखित भारतीय नागरिकता के महत्वपूर्ण पहलुओं को तोड़ते हैं, ताकि आप समझ सकें कि कौन नागरिक के रूप में योग्य है और इसके साथ आने वाले अधिकार और कर्तव्य क्या हैं।

इस वीडियो में हम निम्नलिखित बातें कवर करेंगे:

धारा 5: संविधान की शुरुआत पर नागरिकता
1950 में संविधान को अपनाने के समय नागरिकता के मानदंड के बारे में जानें। समझें कि जन्म, माता-पिता और निवास के आधार पर किसे नागरिक माना गया था।

धारा 6: पाकिस्तान से प्रवासियों के लिए नागरिकता
1950 से पहले पाकिस्तान से भारत में प्रवास करने वाले व्यक्तियों के लिए प्रावधानों के बारे में जानें और उनकी नागरिकता की स्थिति कैसे निर्धारित की गई।

धारा 7: पाकिस्तान से लौटने वालों के लिए नागरिकता
उन व्यक्तियों की प्रक्रिया की खोज करें जो 1950 के बाद पाकिस्तान चले गए और फिर भारत लौटे, जिसमें नागरिकता को फिर से प्राप्त करने की आवश्यकताएँ शामिल हैं।

धारा 8: विदेश में निवास करने वाले भारतीय मूल के व्यक्तियों के लिए नागरिकता
विदेश में रहने वाले भारतीय मूल के व्यक्तियों के अधिकारों को समझें और उन शर्तों को जानें जिनके तहत वे भारतीय नागरिकता बनाए रख सकते हैं या प्राप्त कर सकते हैं।

धारा 9: स्वेच्छा से विदेशी नागरिकता प्राप्त करने पर नागरिकता की हानि
जानें कि स्वेच्छा से किसी अन्य देश की नागरिकता प्राप्त करने पर भारतीय नागरिकता स्वचालित रूप से कैसे खो जाती है।

धारा 10: नागरिकता अधिकारों की निरंतरता
जानें कि नागरिकता अधिकारों को कैसे बनाए रखा जाता है और उनके निरंतरता को सुनिश्चित करने के लिए कानूनी ढांचा क्या है।

धारा 11: नागरिकता को नियंत्रित करने में संसद की भूमिका
जानें कि संसद के पास नागरिकता के अधिग्रहण, समाप्ति और प्रबंधन के संबंध में कानून बनाने और विनियमित करने की शक्तियाँ हैं।

मुख्य बिंदु:

नागरिकता की परिभाषा: विभिन्न परिस्थितियों में कौन नागरिक के रूप में योग्य है।
नियम और प्रक्रियाएँ: नागरिकता कैसे प्राप्त की जाती है, बनाए रखी जाती है, और खोई जाती है।
विधायी शक्ति: नागरिकता कानूनों को आकार देने में संसद की भूमिका।
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
              child: Text('बंद करें'),
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
        title: Text('भाग II: नागरिकता'),
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
                              'वीडियो चलाएँ',
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

  // कस्टम वीडियो नियंत्रण
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
