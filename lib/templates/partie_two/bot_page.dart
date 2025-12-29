import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isMe;
  final String? time;
  final String? senderName;

  ChatMessage({
    required this.text,
    required this.isMe,
    this.time,
    this.senderName,
  });
}

class BotPage extends StatefulWidget {
  const BotPage({super.key});

  @override
  State<BotPage> createState() => _BotPageState();
}

class _BotPageState extends State<BotPage> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  static const String _apiUrl = "http://10.0.2.2:8000/grosly_api_office/chatbot";

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: "Welcome to GroSly\n\nI'm your Moroccan cooking assistant! Tell me what you'd like to cook and I'll suggest a recipe based on available ingredients.",
            isMe: false,
            time: _getCurrentTime(),
            senderName: "GroSly Chef",
          ),
        );
      });
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute ${now.hour < 12 ? 'AM' : 'PM'}";
  }

  Future<String> fetchBotResponse(String userMessage) async {
    try {
      print("Request sent to chatbot");
      print("User message: $userMessage");

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_message": userMessage
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Raw response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded response: $data");
        return data["chatbot_response"] ?? "No response from bot.";
      } else {
        print("Server error: ${response.statusCode}");
        print("Body: ${response.body}");
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Complete exception: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: const Color(0xFF61AD4E),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset("assets/icons/symbole.png"),
            ),
            const SizedBox(width: 12),
            const Text(
              "GroSly Chef",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFF61AD4E),
              ),
            ),
          ),
        ],
      ),

      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return chatBubble(_messages[index]);
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Color(0xFF97999D),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Ask for a recipe...",
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    color: Color(0xFF61AD4E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBubble(ChatMessage message) {
    return Column(
      crossAxisAlignment:
      message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!message.isMe && message.senderName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEBF3E9),
                  child: Image.asset("assets/icons/symbole.png"),
                ),
                const SizedBox(width: 8),
                Text(
                  message.senderName!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        Container(
          margin: EdgeInsets.only(
            left: message.isMe ? 60 : 0,
            right: message.isMe ? 0 : 60,
            bottom: 12,
          ),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: message.isMe
                ? const Color(0xFF61AD4E)
                : const Color(0xFFEFF7ED),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isMe ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void sendMessage() async {
    if (_textController.text.trim().isEmpty) return;

    final userText = _textController.text;
    _textController.clear();

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: userText,
          isMe: true,
          time: _getCurrentTime(),
        ),
      );
    });

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: "Typing...",
          isMe: false,
          senderName: "GroSly Chef",
        ),
      );
    });

    try {
      final botReply = await fetchBotResponse(userText);

      setState(() {
        _messages.removeAt(0);
      });

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: botReply,
            isMe: false,
            time: _getCurrentTime(),
            senderName: "GroSly Chef",
          ),
        );
      });
    } catch (e) {
      print("Complete error: $e");

      setState(() {
        _messages.removeAt(0);
      });

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: "Server unavailable. Please try again later.",
            isMe: false,
            senderName: "GroSly Chef",
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}