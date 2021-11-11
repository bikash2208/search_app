import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FullImage extends StatefulWidget {
  late String src;
  late int id;
  late Box box;
  late TextEditingController comment;
  FullImage(
      {Key? key,
      required this.src,
      required this.id,
      required this.box,
      required this.comment})
      : super(key: key);

  @override
  Full_ImageState createState() => Full_ImageState();
}

bool _islistening = false;
stt.SpeechToText speech = stt.SpeechToText();

class Full_ImageState extends State<FullImage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  children: [
                    Card(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 2 / 5,
                        child: Image.network(
                          widget.src,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Comments ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                    ValueListenableBuilder(
                        valueListenable: widget.box.listenable(),
                        builder: (context, Box vbox, _) {
                          if (vbox.values.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text("don't have comments."),
                              ),
                            );
                          }
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: vbox.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListTile(
                                        title: Text(widget.box.get(index)),
                                      ),
                                    ),
                                  ));
                        })
                  ],
                ),
              ),
            ),
            IconButton(
              color: Colors.white,
              alignment: Alignment.center,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 100,
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                              controller: widget.comment,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(30)),
                                filled: true,
                                hintText: "Add comment...",
                              )),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.red,
                          child: IconButton(
                            onPressed: () {
                              if (widget.comment.text.isNotEmpty) {
                                widget.box.add(widget.comment.text);
                              }
                              widget.comment.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton.icon(
                        icon: _islistening
                            ? const Icon(Icons.mic)
                            : const Icon(Icons.mic_none),
                        style: ElevatedButton.styleFrom(
                            primary: _islistening ? Colors.blue : Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () {
                          listen();
                        },
                        label: Text(
                          _islistening ? "Listening..." : "speech to text",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  void listen() async {
    if (!_islistening) {
      bool available = await speech.initialize(
        onStatus: (val) => val == "done"
            ? setState(() {
                _islistening = false;
              })
            : setState(() {
                _islistening = true;
              }),
        onError: (val) => setState(() {
          _islistening = false;
        }),
      );
      if (available) {
        setState(() => _islistening = true);
        speech.listen(
            onResult: (val) => setState(() {
                  widget.comment.text = val.recognizedWords;
                }));
      }
    } else {
      setState(() {
        _islistening = false;
        speech.stop();
      });
    }
  }
}
