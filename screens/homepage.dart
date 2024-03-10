// ignore_for_file: no_logic_in_create_state

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final OpenAI _openAI = OpenAI.instance.build(
      token: "create ur OpenAI API key(on OpenAI playground), copy and paste it here.",
      baseOption: HttpSetup(receiveTimeout: Duration(seconds: 5)),
      enableLog: true);

  bool isSpeaking = true;
  SpeechToText stt = SpeechToText();
  String speech = "";
  List msgs = [];

  void sendMwssage(String sph) async {
    msgs.add(speech);
    final request =
        CompleteText(prompt: sph, model: TextDavinci3Model(), maxTokens: 200);
    try {
      final response = await _openAI.onCompletion(request: request);
      setState(() {
        if (response != null) {
          msgs.add(response.choices[0].text);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("What's on your mind"),
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                    height: size.height / 1.35,
                    width: size.width,
                    child: ListView.builder(
                        reverse: true,
                        itemCount: msgs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 15, top: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                index / 2 == 0
                                    ? const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                      )
                                    : const CircleAvatar(
                                        backgroundColor: Colors.red,
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  msgs[index],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          );
                        })),
                SizedBox(
                  height: size.height / 30,
                ),
                GestureDetector(
                  onTapDown: (details) async {
                    if (!isSpeaking) {
                      var available = await stt.initialize();
                      if (available) {
                        setState(() {
                          isSpeaking = true;
                          stt.listen(onResult: (result) {
                            setState(() {
                              speech = result.recognizedWords;
                            });
                          });
                        });
                      }
                    }
                  },
                  onTapUp: (details) {
                    sendMessage(speech);
                    print(speech);
                    setState(() {
                      isSpeaking = false;
                      speech = "";
                    });
                    stt.stop();
                  },
                  child: Container(
                    height: size.height / 12,
                    width: size.width / 3,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            isSpeaking
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30)),
                      height: size.height,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text('"$speech"',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white))),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }

  void sendMessage(String speech) {}
}
