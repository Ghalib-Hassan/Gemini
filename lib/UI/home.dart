import 'package:flutter/material.dart';
import 'package:gemini/Provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController prompt = TextEditingController();
  bool isLoading = false;

  // Helper function to parse and handle bold formatting
  List<TextSpan> _parseBoldText(String text) {
    List<TextSpan> spans = [];
    RegExp regExp = RegExp(r'\*\*(.*?)\*\*');
    Iterable<Match> matches = regExp.allMatches(text);

    int lastMatchEnd = 0;

    // Loop through the matches and build TextSpan
    for (Match match in matches) {
      // Add regular text before the bold match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: const TextStyle(
              color: Colors.black, fontSize: 16), // Regular text style
        ));
      }
      // Add bold text
      spans.add(TextSpan(
        text: match.group(1), // Extracted bold text
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
      ));
      lastMatchEnd = match.end;
    }

    // Add any remaining regular text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GeminiProvider(),
      child: Consumer<GeminiProvider>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Gemini',
              style: GoogleFonts.ubuntu(
                color: Colors.blueAccent,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.message.length,
                      itemBuilder: (context, index) {
                        if (index.isEven) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                        color: Colors.red, width: 5.0),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    'ME',
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: TextSpan(
                                      children:
                                          _parseBoldText(model.message[index]),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.blueAccent,
                                            width: 5.0),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'MY AI',
                                        style: GoogleFonts.ubuntu(
                                          fontSize: 18,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          children: _parseBoldText(
                                              model.message[index]),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.0),
                                child: Divider(
                                  color: Colors.black45,
                                  thickness: 3,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: prompt,
                            decoration: InputDecoration(
                              hintText: 'Enter Text',
                              hintStyle: const TextStyle(fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (prompt.text.trim().isEmpty) return;
                            setState(() {
                              isLoading = true; // Show loader
                            });

                            await model
                                .geminiResponse(prompt.text.trim().toString());

                            setState(() {
                              isLoading = false; // Hide loader
                            });
                            prompt.clear();
                          },
                          icon: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blueAccent,
                            ),
                            child: const Icon(
                              size: 40,
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
