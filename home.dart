import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OpenAI _openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: Duration(seconds: 5)),
      enableLog: true);

  String _msg = "";
  String _res = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 207, 136, 219),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                _msg = value;
              },
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                final request = CompleteText(
                    prompt: _msg, model: TextDavinci3Model(), maxTokens: 200);
                try {
                  final response = await _openAI.onCompletion(request: request);
                  setState(() {
                    if (response != null) {
                      _res = response.choices[0].text;
                    }
                  });
                } catch (e) {
                  print(e);
                }
              },
              child: const Text("Send")),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(_res),
          )
        ],
      ),
    );
  }
}
