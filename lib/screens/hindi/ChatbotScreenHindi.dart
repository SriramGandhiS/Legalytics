import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreenHindi extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenHindi> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  @override
  void initState() {
    super.initState();
    _sendIntroMessage();
  }

  void _sendIntroMessage() {
    _messagesCollection.add({
      'text':
          'चैटबॉट में आपका स्वागत है! यह बॉट संविधान के बारे में आपके सवालों का जवाब देने और तकनीकी सहायता प्रदान करने के लिए यहां है।',
      'createdAt': FieldValue.serverTimestamp(),
      'isUser': false,
    });
  }

  void _sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isNotEmpty) {
      _messagesCollection.add({
        'text': userMessage,
        'createdAt': FieldValue.serverTimestamp(),
        'isUser': true,
      });

      String replyMessage = _getReplyMessage(userMessage);
      if (replyMessage.isNotEmpty) {
        _messagesCollection.add({
          'text': replyMessage,
          'createdAt': FieldValue.serverTimestamp(),
          'isUser': false,
        });
      }

      _controller.clear();
    }
  }

  String _getReplyMessage(String userMessage) {
    switch (userMessage.toLowerCase()) {
      case "hello":
        return "नमस्ते! आज मैं आपकी किस प्रकार मदद कर सकता हूँ?";
      case "what is your name?":
        return "मैं आपका वर्चुअल सहायक हूँ!";
      case "how are you?":
        return "मैं एक प्रोग्राम हूँ, और मैं अच्छा हूँ!";
      case "what is the constitution of india?":
        return "भारत का संविधान भारत का सर्वोच्च कानून है, जो सरकारी संस्थानों की राजनीतिक सिद्धांतों, प्रक्रियाओं और शक्तियों के ढांचे को निर्धारित करता है, साथ ही नागरिकों के मौलिक अधिकार और कर्तव्यों को भी।";
      default:
        return "मुझे खेद है, मैंने इसे समझा नहीं।";
    }
  }

  void _clearMessages() async {
    final snapshot = await _messagesCollection.get();
    for (var doc in snapshot.docs) {
      await _messagesCollection.doc(doc.id).delete();
    }
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('प्रतिक्रिया'),
          content: TextField(
            controller: feedbackController,
            decoration:
                InputDecoration(hintText: "अपनी प्रतिक्रिया यहाँ दर्ज करें..."),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('रद्द करें'),
            ),
            TextButton(
              onPressed: () {
                _sendFeedback(feedbackController.text);
                Navigator.of(context).pop();
              },
              child: Text('जमा करें'),
            ),
          ],
        );
      },
    );
  }

  void _sendFeedback(String feedback) {
    if (feedback.isNotEmpty) {
      _feedbackCollection.add({
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('प्रतिक्रिया जमा की गई!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('चैटबॉट'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.feedback, color: Colors.white),
            onPressed: _showFeedbackDialog,
          ),
          IconButton(
            icon: Icon(Icons.clear, color: Colors.white),
            onPressed: _clearMessages,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView(
                  padding: EdgeInsets.all(8.0),
                  children: snapshot.data!.docs.map((doc) {
                    bool isUserMessage = doc['isUser'] ?? false;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          elevation: 5.0,
                          color: isUserMessage
                              ? Colors.teal[300]
                              : Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              doc['text'],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'संदेश टाइप करें...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
