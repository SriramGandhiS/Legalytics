import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final _messagesCollection = FirebaseFirestore.instance.collection('messages');
  final _feedbackCollection = FirebaseFirestore.instance.collection('feedback');

  final String _apiKey = "AIzaSyDc2NUcfiSlJdCYH7cNoOJN0hWcr7enGqQ";

  bool _isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _sendIntroMessage();
  }

  void _sendIntroMessage() {
    _messagesCollection.add({
      'text': "👋 Welcome! Ask me anything about the **Indian Constitution** 🇮🇳",
      'createdAt': FieldValue.serverTimestamp(),
      'isUser': false,
    });
  }

  Future<void> _sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    await _messagesCollection.add({
      'text': userMessage,
      'createdAt': FieldValue.serverTimestamp(),
      'isUser': true,
    });

    _controller.clear();
    setState(() => _isBotTyping = true);

    String botReply = await _getGeminiReply(userMessage);

    await _messagesCollection.add({
      'text': botReply,
      'createdAt': FieldValue.serverTimestamp(),
      'isUser': false,
    });

    setState(() => _isBotTyping = false);
  }

  Future<String> _getGeminiReply(String prompt) async {
    const String model = 'gemini-2.5-flash';

    final Uri url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_apiKey');

    final body = {
      "contents": [
        {
          "parts": [
            {
              "text":
              "You are a friendly tutor of Indian Constitution. "
                  "Answer clearly in under 80 words. If user says 'more details', then give detailed explanation.\n\n"
                  "User: $prompt"
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ??
            "Sorry, I couldn't reply. Try again.";
      }
      return "Server error. Try again.";
    } catch (_) {
      return "Network error. Check your internet.";
    }
  }

  void _clearMessages() async {
    var docs = await _messagesCollection.get();
    for (var doc in docs.docs) {
      await _messagesCollection.doc(doc.id).delete();
    }
  }

  void _showFeedbackDialog() {
    TextEditingController feedback = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Feedback"),
        content: TextField(
          controller: feedback,
          decoration: InputDecoration(hintText: "Enter feedback"),
          maxLines: 3,
        ),
        actions: [
          TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
          TextButton(
              child: Text("Submit"),
              onPressed: () {
                if (feedback.text.isNotEmpty) {
                  _feedbackCollection.add({
                    'feedback': feedback.text,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Feedback submitted ✅")));
                }
              }),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(bool isUser, String text) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.teal : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 12, top: 4, bottom: 6),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 10),
            Text("AI is typing...", style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Indian Constitution Tutor 🇮🇳"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(icon: Icon(Icons.feedback), onPressed: _showFeedbackDialog),
          IconButton(icon: Icon(Icons.clear), onPressed: _clearMessages),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView(
                  children: [
                    ...snapshot.data!.docs.map((d) => _buildMessageBubble(
                        d['isUser'], d['text'])),
                    if (_isBotTyping) _typingIndicator(),
                  ],
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask about the Constitution...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    )),

                SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
