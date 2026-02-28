import 'package:flutter/material.dart';
import 'package:login_signup/screens/hindi/quizeasyhindi/pt_1ehindi.dart';
import 'package:video_player/video_player.dart';

const String videoUrl =
    'https://firebasestorage.googleapis.com/v0/b/myappconsi.appspot.com/o/pt_1Hindi.mp4?alt=media&token=4d862001-82f5-415a-8274-0a7600ab674f';

class VideoPlayerScreen1hindi extends StatefulWidget {
  @override
  _VideoPlayerScreen1State createState() => _VideoPlayerScreen1State();
}

class _VideoPlayerScreen1State extends State<VideoPlayerScreen1hindi>
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
      MaterialPageRoute(builder: (context) => QuizScreen1hindi()),
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
                  '''वीडियो विवरण:

भारत के संविधान पर हमारी श्रृंखला में आपका स्वागत है! इस वीडियो में, हम भाग I: संघ और इसका क्षेत्र की जांच करेंगे, जो देश की भौगोलिक सीमाओं और राज्यों और संघ शासित क्षेत्रों की स्थापना के लिए मौलिक ढांचा प्रदान करता है।

मुख्य बिंदु:

भाग I का अवलोकन: संघ और इसके क्षेत्र का परिचय, जो भारत की भौगोलिक सीमाओं को परिभाषित करने में इसके महत्व को उजागर करता है।

धारा 1: भारत संघ: बताता है कि भारत राज्यों का संघ है, और "भारत का क्षेत्र" जैसे शब्दों का मतलब, जिसमें राज्य, संघ शासित क्षेत्र और भारत द्वारा अधिग्रहित अन्य क्षेत्र शामिल हैं।

धारा 2: नए राज्यों का प्रवेश और स्थापना: चर्चा करता है कि संसद नए राज्यों को संघ में कैसे शामिल कर सकती है या नए राज्यों की स्थापना कर सकती है।

धारा 3: नए राज्यों का गठन और क्षेत्रों का परिवर्तन: नए राज्यों के गठन, सीमाओं को बदलने, राज्यों के नामकरण और इन प्रक्रियाओं में संसद की भूमिका की जांच करता है।

धारा 4: धाराओं 2 और 3 के तहत बनाए गए कानून: विवरण करता है कि राज्यों के प्रवेश या परिवर्तन के लिए बनाए गए कानूनों को संविधान संशोधन नहीं माना जाता है और इन्हें साधारण बहुमत से पारित किया जा सकता है।

इंटरएक्टिव लर्निंग: पूरे वीडियो में, हम आकर्षक दृश्य और आसानी से समझने वाली भाषा का उपयोग करेंगे ताकि आप भाग I की जटिल अवधारणाओं को समझ सकें। इस दौरान क्विज़ और इंटरएक्टिव तत्व भी होंगे।

प्रासंगिकता और वर्तमान प्रभाव: हम वास्तविक जीवन के उदाहरणों को भी देखेंगे, जैसे कि तेलंगाना, जम्मू-कश्मीर आदि जैसे राज्यों की पुनर्गठन को, यह दिखाने के लिए कि ये संविधान प्रावधान आधुनिक भारत में कैसे लागू किए गए हैं।

निष्कर्ष: भारत को एक राष्ट्र के रूप में बनाए रखने में भाग I के महत्व को संक्षेप में प्रस्तुत करना।
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
        title: Text('भाग I: संघ और इसका क्षेत्र'),
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
          // हल्के रंग का ग्रेडियंट बैकग्राउंड
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE0F7FA),
                    Color(0xFFE1BEE7)
                  ], // कस्टम हल्के रंग
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
                              backgroundColor: Colors.white, // हल्के बैकग्राउंड
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
