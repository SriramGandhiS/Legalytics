import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HelplineInfoScreen extends StatefulWidget {
  @override
  _HelplineInfoScreenState createState() => _HelplineInfoScreenState();
}

class _HelplineInfoScreenState extends State<HelplineInfoScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _showPlayer = false;
  late AnimationController _animationController;

  final List<Map<String, String>> cyberCrimeHelplines = [
    {'number': '1930', 'purpose': 'Cyber Crime Helpline – Report financial frauds (24x7)'},
    {'number': '155260', 'purpose': 'National Cyber Crime Reporting Portal – Connects to local police'},
    {'number': 'www.cybercrime.gov.in', 'purpose': 'File cybercrime complaints online'},
    {'number': '011-23438207', 'purpose': 'Central helpline for cyber bullying or abuse'},
  ];

  final List<Map<String, String>> legalRightsHelplines = [
    {'number': '15100', 'purpose': 'Legal Aid Helpline – Free legal advice by NALSA'},
    {'number': '1091', 'purpose': 'Women Helpline – Legal help for harassment or domestic abuse'},
    {'number': '1098', 'purpose': 'Childline – For children in distress'},
    {'number': '100', 'purpose': 'Police – For legal emergencies'},
    {'number': '112', 'purpose': 'All-in-one emergency number'},
  ];

  final List<Map<String, String>> otherHelplines = [
    {'number': '14444', 'purpose': 'Digital Payment Support – UPI, wallets'},
    {'number': '14546', 'purpose': 'Aadhaar complaints & consent revocation'},
    {'number': '011-24300666', 'purpose': 'Report corruption – Central Vigilance Commission'},
    {'number': '1090', 'purpose': 'Women Power Line – UP-specific support'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _loadVideoAndPlay() async {
    final url =
        "https://firebasestorage.googleapis.com/v0/b/myappconsi.appspot.com/o/invideo-ai-1080%20India's%20Lifesaving%20Helplines_%20Know%20Your%20%202025-04-05.mp4?alt=media&token=4445261e-4f77-41d8-9ad1-6f7dc7a3e7cc";

    _videoPlayerController = VideoPlayerController.network(url);
    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
    );

    setState(() {
      _showPlayer = true;
    });
  }

  Widget buildTable(String title, List<Map<String, String>> data, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            ...data.map((item) => ListTile(
              title: Text(item['number']!, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['purpose']!),
              leading: Icon(Icons.phone, color: color),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade200, Colors.blue.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text("📞 Digital & Legal Safety"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.3).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              )),
              child: IconButton(
                icon: Icon(Icons.play_circle_fill, color: Colors.amberAccent, size: 30),
                tooltip: "Watch Video Guide",
                onPressed: _loadVideoAndPlay,
              ),
            ),
          ],
        ),
      ),
      body: _showPlayer
          ? Chewie(controller: _chewieController!)
          : ListView(
              children: [
                buildTable("🔐 Cybercrime & Online Safety", cyberCrimeHelplines, Colors.redAccent),
                buildTable("⚖️ Legal & Constitutional Rights", legalRightsHelplines, Colors.blue),
                buildTable("📱 Other Important Helplines", otherHelplines, Colors.deepPurple),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "🇮🇳 These helplines reflect Constitutional Rights:\n\n"
                    "- Article 21: Right to Life & Personal Liberty\n"
                    "- Article 14: Right to Equality\n"
                    "- Article 15(3), 39(e)(f): Child Protection\n"
                    "- Article 32: Right to Constitutional Remedies\n"
                    "- Article 23, 24: Freedom from Exploitation",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
    );
  }
}
