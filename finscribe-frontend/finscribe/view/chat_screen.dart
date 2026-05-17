import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:fyp/Utils/components/colors.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> fullData;

  const ChatScreen({
    Key? key,
    required this.fullData,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const apiKey = 'AIzaSyAba4R_F3LyYOajY2hF8_qBFy3ucAsanmk';

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late final ChatSession _chat;
  bool _isLoading = false;
  bool _showInitialGreeting = true;

  @override
  void initState() {
    super.initState();
    final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
    _chat = model.startChat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialPrompt();
    });
  }


  void _sendInitialPrompt() async {
    if (_showInitialGreeting) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Hello! I'm your business analytics assistant. I'll analyze your data and provide insights.",
          isUser: false,
          time: DateTime.now(),
        ));
        _showInitialGreeting = false;
      });
      await Future.delayed(Duration(seconds: 1));
    }

    // // Extract pieces from fullData
    // final dailySpending = (widget.fullData['dailySpending'] ?? {}) as Map<String, double>;
    // final vendorFrequency = (widget.fullData['vendorFrequency'] ?? {}) as Map<String, int>;
    // final productData = (widget.fullData['productData'] ?? {}) as Map<String, dynamic>;
    //
    // final spendingData = dailySpending.entries
    //     .map((e) => "• ${e.key}: \$${e.value.toStringAsFixed(2)}")
    //     .join("\n");
    //
    // final vendorData = vendorFrequency.entries
    //     .map((e) => "• ${e.key}: ${e.value} transactions")
    //     .join("\n");
    //
    // final productSummary = productData.entries
    //     .map((e) => "• ${e.key}: ${e.value}")
    //     .join("\n");

    // final prompt = """
    //       I'm sharing my business data for analysis:
    //
    //       📅 **Daily Spending**
    //       $spendingData
    //
    //       🏢 **Vendor Frequency**
    //       $vendorData
    //
    //       📦 **Product Data**
    //       $productData
    //
    //       Please analyze this data and provide insights about:
    //       - Spending patterns and trends
    //       - Vendor relationships
    //       - Product performance
    //       - Cost optimization opportunities
    //
    //       Don't Include any asterisk and don't bold any words and don't provide any recommendations until asked
    //       """;

    final rawJson = jsonEncode(widget.fullData);

    final prompt = """
          Here is my full business data in raw JSON format:
          
          $rawJson
          
          Please analyze this data and provide insights about:
          - Spending patterns and trends
          - Vendor relationships
          - Product performance
          - Cost optimization opportunities
          
          Don't include any asterisks, don't bold anything, and don't provide recommendations unless asked.
          """;

    print("raw data:   $rawJson");
    setState(() {
      _messages.add(ChatMessage(
        text: "Give a generalized overview of my data",
        isUser: true,
        time: DateTime.now(),
      ));
      _isLoading = true;
    });

    try {
      final response = await _chat.sendMessage(Content.text(prompt));
      setState(() {
        _messages.add(ChatMessage(
          text: response.text ?? 'No response',
          isUser: false,
          time: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Error: ${e.toString()}',
          isUser: false,
          time: DateTime.now(),
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }



  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        time: DateTime.now(),
      ));
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _chat.sendMessage(Content.text(message));
      setState(() {
        _messages.add(ChatMessage(
          text: response.text ?? 'No response',
          isUser: false,
          time: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: '⚠️ Error: ${e.toString()}',
          isUser: false,
          time: DateTime.now(),
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Insights',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.appbarColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return AnimatedMessageBubble(
                    message: _messages[index],
                    isFirst: index == 0,
                    isLast: index == _messages.length - 1,
                  );
                },
              ),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appbarColor),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about your data...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        // suffixIcon: IconButton(
                        //   icon: Icon(Icons.attach_file, color: Colors.grey),
                        //   onPressed: () {},
                        // ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.appbarColor,
                        AppColors.appbarColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isFirst;
  final bool isLast;

  const AnimatedMessageBubble({
    Key? key,
    required this.message,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bubbleColor = isUser
        ? AppColors.appbarColor
        : Colors.grey[200];
    final textColor = isUser
        ? Colors.white
        : Colors.black87;

    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 0 : 4,
        bottom: isLast ? 8 : 4,
      ),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Card(
              elevation: 2,
              color: bubbleColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 16 : 4),
                  topRight: Radius.circular(isUser ? 4 : 16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      DateFormat('h:mm a').format(message.time),
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}



