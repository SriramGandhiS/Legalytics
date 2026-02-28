import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class FinesAndDutiesScreen extends StatefulWidget {
  const FinesAndDutiesScreen({super.key});

  @override
  State<FinesAndDutiesScreen> createState() => _FinesAndDutiesScreenState();
}

class _FinesAndDutiesScreenState extends State<FinesAndDutiesScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _showPlayer = false;
  late AnimationController _animationController;

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
    final url = "https://firebasestorage.googleapis.com/v0/b/myappconsi.appspot.com/o/invideo-ai-1080%20India's%20Lifesaving%20Helplines_%20Know%20Your%20%202025-04-05.mp4?alt=media&token=4445261e-4f77-41d8-9ad1-6f7dc7a3e7cc";

    _videoPlayerController = VideoPlayerController.network(url);
    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
    );

    setState(() {
      _showPlayer = true;
    });
  }

  TableRow buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildSection(String title, List<TableRow> rows) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade700,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(2),
            },
            children: rows,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trafficRows = [
      buildTableRow(["Violation", "Old Fine", "New Fine", "Additional Penalties"], isHeader: true),
      buildTableRow(["Drunk Driving", "₹1,000 - ₹1,500", "₹10,000", "Up to 6 months jail; repeat: ₹15,000 + 2 yrs"]),
      buildTableRow(["Riding Without Helmet", "₹100", "₹1,000", "License suspension 3 months"]),
      buildTableRow(["No Seatbelt", "₹100", "₹1,000", "—"]),
      buildTableRow(["Using Mobile While Driving", "₹500", "₹5,000", "—"]),
      buildTableRow(["No Valid License", "₹500", "₹5,000", "Up to 3 months jail + community service"]),
      buildTableRow(["No Insurance", "₹1,000", "₹2,000", "Repeat: ₹4,000 fine"]),
      buildTableRow(["Overloading Vehicles", "₹2,000", "₹20,000", "—"]),
      buildTableRow(["Blocking Emergency Vehicles", "₹100", "₹10,000", "—"]),
      buildTableRow(["Juvenile Offenses", "₹2,500", "₹25,000", "3 yrs jail; vehicle registration cancelled"]),
    ];

    final gstRows = [
      buildTableRow(["Offense", "Penalty"], isHeader: true),
      buildTableRow(["Late GSTR Filing", "₹200/day (₹100 CGST + ₹100 SGST); none for IGST"]),
      buildTableRow(["Non-Filing GSTR", "10% of tax due or ₹10,000 (higher)"]),
      buildTableRow(["Fraud", "100% of tax due or ₹10,000; may include jail"]),
      buildTableRow(["Helping in Fraud", "Up to ₹25,000"]),
      buildTableRow(["Wrong GST Rate", "100% of due tax or ₹10,000"]),
      buildTableRow(["Not Issuing Invoice", "100% of due tax or ₹10,000"]),
      buildTableRow(["Incorrect Invoicing", "₹25,000"]),
    ];

    final otherLegalRows = [
      buildTableRow(["Violation", "Previous", "Updated", "Remarks"], isHeader: true),
      buildTableRow(["Unauthorized Vehicle Use", "₹1,000", "₹5,000", "—"]),
      buildTableRow(["Over-Speeding", "₹400", "₹1,000", "—"]),
      buildTableRow(["Unqualified Driving", "₹500", "₹10,000", "—"]),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("📜 Updated Fines & Duties"),
        centerTitle: true,
        backgroundColor: Colors.teal,
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
      body: _showPlayer
          ? Chewie(controller: _chewieController!)
          : ListView(
              children: [
                buildSection("🚦 Traffic Violations", trafficRows),
                buildSection("🏛️ GST Offenses", gstRows),
                buildSection("⚖️ Other Legal Penalties", otherLegalRows),
                Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "📅 As of April 2025, these changes aim to promote safety, transparency, and legal accountability.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
