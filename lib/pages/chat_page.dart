import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  List<ChatMessage> _messages = [
    /*
    const ChatMessage(texto: "Hola mundo", uid: "123"),
    const ChatMessage(
        texto:
            "Hola mundo 2 Hola mundo 2Hola mundo 2 Hola mundo 2 Hola mundo 2 Hola mundo 2 Hola mundo 2 Hola mundo 2 ",
        uid: "123"),
    const ChatMessage(texto: "Hola mundo 3", uid: "1234"),
    const ChatMessage(texto: "Hola mundo 3", uid: "123"),
    const ChatMessage(texto: "Hola mundo 3", uid: "1235"),
    const ChatMessage(texto: "Hola mundo 3", uid: "123"),
    */
  ];

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _escribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                "TE",
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 16,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "Nombre",
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
              ),
            ),
            const Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        //padding: EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _escribiendo = true;
                    } else {
                      _escribiendo = false;
                    }
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar mensaje"),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _escribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: const Text("Enviar"))
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: _escribiendo
                                ? () =>
                                    _handleSubmit(_textController.text.trim())
                                : null,
                            icon: const Icon(
                              Icons.send,
                            )),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: text,
      uid: "123",
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1000)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _escribiendo = false;
    });
  }

  @override
  void dispose() {
    // TODO: Off del socket
    
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
