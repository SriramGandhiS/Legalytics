import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_signup/screens/hindi/dashpageHindi.dart';

class MatchGameScreenHindi extends StatefulWidget {
  @override
  _MatchGameScreenState createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreenHindi> {
  List<String> laws = [];
  Map<String, String> descriptions = {};
  Map<String, String?> matched = {};
  Map<String, bool> isCorrect = {};
  List<String> availableLaws = [];
  bool showResult = false;
  DocumentSnapshot? currentMatchDocument;
  int currentMatchIndex = 0;
  List<DocumentSnapshot>? matchDocuments;

  @override
  void initState() {
    super.initState();
    fetchMatchData();
  }

  Future<void> fetchMatchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('matchDataHindi')
          .orderBy(FieldPath.documentId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        matchDocuments = snapshot.docs;
        currentMatchDocument = matchDocuments![currentMatchIndex];
        setDataFromDocument(currentMatchDocument!);
      }
    } catch (e) {
      print('डेटा प्राप्त करने में त्रुटि: $e');
    }
  }

  void setDataFromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    laws = List<String>.from(data['laws']);
    descriptions = Map<String, String>.from(data['descriptions']);
    matched = {for (var law in laws) law: null};
    isCorrect = {for (var law in laws) law: false};
    availableLaws = List.from(laws);
    setState(() {});
  }

  void checkAnswers() {
    bool allCorrect = true;
    for (var law in laws) {
      if (matched[law] == null || matched[law] != law) {
        allCorrect = false;
        isCorrect[law] = false;
      } else {
        isCorrect[law] = true;
      }
    }

    setState(() {
      showResult = true;
    });
  }

  void showCorrectAnswersDialog() {
    final incorrectAnswers = laws.where((law) => !isCorrect[law]!).toList();
    final correctAnswers = laws
        .where((law) => isCorrect[law]!)
        .map((law) => '$law: ${descriptions[law]}')
        .join('\n');

    final userAnswers =
        laws.map((law) => '${law}: ${matched[law] ?? 'मेल नहीं'}').join('\n');

    final incorrectAnswersMessage = incorrectAnswers.isEmpty
        ? "कोई गलत उत्तर नहीं है।"
        : incorrectAnswers
            .map((law) => '$law: ${descriptions[law]}')
            .join('\n');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("उत्तर"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'आपके सही उत्तर:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(correctAnswers.isEmpty
                  ? "कोई सही उत्तर नहीं है।"
                  : correctAnswers),
              SizedBox(height: 16.0),
              Text(
                'आपके उत्तर:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(userAnswers),
              SizedBox(height: 16.0),
              Text(
                'उत्तर:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(incorrectAnswersMessage),
            ],
          ),
          actions: [
            TextButton(
              child: Text("ठीक है"),
              onPressed: () {
                Navigator.of(context).pop();
                nextMatch();
              },
            ),
          ],
        );
      },
    );
  }

  void nextMatch() async {
    if (matchDocuments == null) return;

    setState(() {
      matched = {for (var law in laws) law: null};
      isCorrect = {for (var law in laws) law: false};
      showResult = false;
    });

    if (currentMatchIndex < matchDocuments!.length - 1) {
      currentMatchIndex++;
      currentMatchDocument = matchDocuments![currentMatchIndex];
      setDataFromDocument(currentMatchDocument!);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("मिलान समाप्त"),
            content: Text("आपने सभी मिलान पूरे कर लिए हैं।"),
            actions: [
              TextButton(
                child: Text("फिर से प्रयास करें"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentMatchIndex = 0;
                    matched = {for (var law in laws) law: null};
                    isCorrect = {for (var law in laws) law: false};
                    showResult = false;
                  });
                  currentMatchDocument = matchDocuments![currentMatchIndex];
                  setDataFromDocument(currentMatchDocument!);
                },
              ),
              TextButton(
                child: Text("डैशबोर्ड पर वापस जाएं"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (e) => Dashpagehindi(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  void previousMatch() async {
    if (matchDocuments == null) return;

    setState(() {
      matched = {for (var law in laws) law: null};
      isCorrect = {for (var law in laws) law: false};
      showResult = false;
    });

    if (currentMatchIndex > 0) {
      currentMatchIndex--;
      currentMatchDocument = matchDocuments![currentMatchIndex];
      setDataFromDocument(currentMatchDocument!);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("कोई पिछला मिलान नहीं"),
            content: Text("आप पहले मिलान पर हैं।"),
            actions: [
              TextButton(
                child: Text("ठीक है"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('संविधान कानून मिलान खेल'),
        backgroundColor: const Color.fromARGB(255, 230, 140, 170),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: laws.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: descriptions.keys.length,
                      itemBuilder: (context, index) {
                        String law = descriptions.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 100,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blueGrey.shade100,
                                        Colors.blueGrey.shade300
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 4),
                                        blurRadius: 8.0,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        descriptions[law]!,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              DragTarget<String>(
                                builder:
                                    (context, candidateData, rejectedData) {
                                  final isTargetHighlighted =
                                      candidateData.isNotEmpty;
                                  return Container(
                                    width: 200,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: showResult
                                          ? (isCorrect[law] == true
                                              ? Colors.green.shade300
                                              : Colors.red.shade300)
                                          : (isTargetHighlighted
                                              ? Colors.blue.shade100
                                              : Colors.grey.shade200),
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 2),
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        matched[law] ?? "यहां छोड़ें",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                                onWillAccept: (data) => true,
                                onAccept: (data) {
                                  setState(() {
                                    matched[law] = data;
                                    availableLaws.remove(data);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.deepPurple[50],
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: availableLaws.map((law) {
                        return Draggable<String>(
                          data: law,
                          child: DraggableCard(
                            law: law,
                            matched: matched.containsValue(law),
                            isCorrect: isCorrect[law] ?? false,
                            dropped: matched[law] == law,
                          ),
                          feedback: Material(
                            color: Colors.transparent,
                            child: DraggableCard(
                              law: law,
                              matched: matched.containsValue(law),
                              isCorrect: isCorrect[law] ?? false,
                              dropped: matched[law] == law,
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                law,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  if (showResult)
                    ElevatedButton(
                      onPressed: showCorrectAnswersDialog,
                      child: Text("सही उत्तर दिखाएं"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  if (!showResult)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: previousMatch,
                          color: Colors.deepPurple,
                          iconSize: 30.0,
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: checkAnswers,
                          child: Text("उत्तर जांचें"),
                        ),
                        SizedBox(width: 16.0),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: nextMatch,
                          color: Colors.deepPurple,
                          iconSize: 30.0,
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}

class DraggableCard extends StatelessWidget {
  final String law;
  final bool matched;
  final bool isCorrect;
  final bool dropped;

  DraggableCard({
    required this.law,
    required this.matched,
    required this.isCorrect,
    required this.dropped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: dropped
            ? (isCorrect ? Colors.green.shade300 : Colors.red.shade300)
            : const Color.fromARGB(255, 230, 179, 197),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          law,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
