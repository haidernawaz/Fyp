import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:legalassistance/Screens/RecommendedLawyers/lawyer_recommend.dart';
import 'dart:convert';
import 'package:legalassistance/Screens/RecommendedLawyers/recommended_lawyers.dart';
import 'package:legalassistance/Packages/packages.dart';
import 'package:translator/translator.dart';

class NewQueryScreen extends StatefulWidget {
  NewQueryScreen({Key? key, required this.guestEntry}) : super(key: key);
  bool guestEntry;

  @override
  State<NewQueryScreen> createState() => _NewQueryScreenState();
}

class _NewQueryScreenState extends State<NewQueryScreen> {
  ChatUser mySelf = ChatUser(id: '1', firstName: 'Abdul');
  ChatUser bot = ChatUser(id: '2', firstName: 'Bot');
  String _response = '';
  List<ChatMessage> chatMessages = <ChatMessage>[];
  final List<ChatUser> _typing = <ChatUser>[];
  String userQuery = '';
  String? _predictedCategory;

  String capitalizeFirstLetter(String text) {
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  getMessage(ChatMessage m) async {
    _typing.add(bot);
    chatMessages.insert(0, m);
    setState(() {});
    debugPrint('user input is ${m.text}');
    await _fetchResponse(m.text);
    ChatMessage data =
        ChatMessage(text: _response, user: bot, createdAt: DateTime.now());
    chatMessages.insert(0, data);
    _typing.remove(bot);
    setState(() {});
  }

  _fetchResponse(String userQuery) async {
    final Uri qaApiUrl = Uri.parse('http://192.168.18.66:8001/qa');
    final Uri classificationApiUrl =
        Uri.parse('http://192.168.18.66:8002/classify');

    if (_isUrdu(userQuery)) {
      debugPrint('Query is in Urdu');
      String translatedText = await _translateText(userQuery, 'en');
      debugPrint(translatedText);

      try {
        final classificationResponse = await http.post(
          classificationApiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'question': translatedText,
          }),
        );

        if (classificationResponse.statusCode == 200) {
          final classificationJson = jsonDecode(classificationResponse.body);
          String predictedCategory = classificationJson['predicted_category'];
          predictedCategory = capitalizeFirstLetter(predictedCategory);
          setState(() {
            _predictedCategory = predictedCategory;
          });

          final qaResponse = await http.post(
            qaApiUrl,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'question': translatedText,
            }),
          );

          if (qaResponse.statusCode == 200) {
            final qaJson = jsonDecode(qaResponse.body);
            String translatedResponse =
                await _translateText(qaJson.toString(), 'ur');
            debugPrint(translatedResponse);
            setState(() {
              _response = translatedResponse;
            });
          } else {
            setState(() {
              _response = 'Failed to get response from QA API';
            });
          }
        } else {
          setState(() {
            _response = 'Failed to get response from classification API';
          });
        }
      } catch (error) {
        setState(() {
          _response = 'Error: $error';
        });
      }
    } else {
      debugPrint('Query is in English');
      try {
        final classificationResponse = await http.post(
          classificationApiUrl,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'question': userQuery,
          }),
        );

        if (classificationResponse.statusCode == 200) {
          final classificationJson = jsonDecode(classificationResponse.body);
          String predictedCategory = classificationJson['predicted_category'];
          predictedCategory = capitalizeFirstLetter(predictedCategory);
          setState(() {
            _predictedCategory = predictedCategory;
            debugPrint(predictedCategory);
          });

          final qaResponse = await http.post(
            qaApiUrl,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'question': userQuery,
            }),
          );

          if (qaResponse.statusCode == 200) {
            final qaJson = jsonDecode(qaResponse.body);
            setState(() {
              _response = qaJson.toString();
            });
          } else {
            setState(() {
              _response = 'Failed to get response from QA API';
            });
          }
        } else {
          setState(() {
            _response = 'Failed to get response from classification API';
          });
        }
      } catch (error) {
        setState(() {
          _response = 'Error: $error';
        });
      }
    }
  }

  bool _isUrdu(String text) {
    RegExp urduCharacters = RegExp(r'[\u0600-\u06FF]');
    return urduCharacters.hasMatch(text);
  }

  Future<String> _translateText(String text, String toLanguage) async {
    final translator = GoogleTranslator();
    Translation translation = await translator.translate(text, to: toLanguage);
    return translation.text;
  }

  void _onButtonClicked() {
    if (_predictedCategory != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LawyerRecommend(
            category: _predictedCategory!,
          ),
        ),
      );
      debugPrint('Done');
    } else {
      // Handle case when no category is predicted
      debugPrint('Nothing');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LawyerRecommend(
            category: "Question is not availabe in my database",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppBar(context, LocalesData.appbar.getString(context)),
        body: widget.guestEntry
            ? SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: DashChat(
                        typingUsers: _typing,
                        currentUser: mySelf,
                        onSend: (ChatMessage m) {
                          getMessage(m);
                          debugPrint(m.toString());
                        },
                        messages: chatMessages,
                        inputOptions: InputOptions(
                          alwaysShowSend: false,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : StreamBuilder(
                stream: streamFunction.getUserDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final userData = snapshot.data;

                    if (userData!['block']) {
                      return Scaffold(
                        body: Center(
                          child: Text(
                              LocalesData.blockStatement.getString(context)),
                        ),
                      );
                    } else {
                      return SafeArea(
                        child: Column(
                          children: [
                            userData['role'] == 'layman'
                                ? ElevatedButton(
                                    onPressed: _onButtonClicked,
                                    child:
                                        const Text('Get Recommended Lawyers'),
                                  )
                                : const SizedBox(),
                            Expanded(
                              child: DashChat(
                                typingUsers: _typing,
                                currentUser: mySelf,
                                onSend: (ChatMessage m) {
                                  getMessage(m);
                                  debugPrint(m.toString());
                                },
                                messages: chatMessages,
                                inputOptions: InputOptions(
                                  alwaysShowSend: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }));
  }
}
