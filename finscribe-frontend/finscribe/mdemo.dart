// import 'package:flutter/material.dart';
// import 'package:fyp/Utils/components/colors.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:intl/intl.dart';
//
// class ChatScreen extends StatefulWidget {
//   final Map<dynamic, dynamic> chartData;
//   final Map<String, double> dailySpending;
//   final Map<String, int> vendorFrequency;
//   final Map<String, dynamic> productData;
//
//   const ChatScreen({Key? key,
//     required this.chartData,
//     required this.dailySpending,
//     required this.vendorFrequency,
//     required this.productData}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
//
// class _ChatScreenState extends State<ChatScreen> {
//   static const apiKey = 'AIzaSyAteBjWbHDyjGz1uOoy5632IdX_MjFNDjE';
//
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<ChatMessage> _messages = [];
//   late final ChatSession _chat;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
//     _chat = model.startChat();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _sendInitialPrompt();
//     });
//   }
//
//   void _sendInitialPrompt() async {
//     // Format daily spending data
//     final spendingData = widget.dailySpending.entries
//         .map((e) => "Date: ${e.key}, Amount: \$${e.value.toStringAsFixed(2)}")
//         .join("\n");
//
//     // Format vendor frequency data
//     final vendorData = widget.vendorFrequency.entries
//         .map((e) => "Vendor: ${e.key}, Transactions: ${e.value}")
//         .join("\n");
//
//     // Format product data (if available)
//     final productData = widget.productData.entries
//         .map((e) => "Product: ${e.key}, Data: ${e.value}")
//         .join("\n");
//
//     final prompt = """
//           Here's my complete data:
//
//           === DAILY SPENDING ===
//           $spendingData
//
//           === VENDOR TRANSACTION FREQUENCY ===
//           $vendorData
//
//           === PRODUCT DATA ===
//           $productData
//
//           Analyze this data and give me insights about my spending patterns, frequent vendors, and any recommendations for cost optimization.
//           """;
//
//     setState(() {
//       _messages.add(ChatMessage(
//         text: "I've shared my data for analysis",
//         isUser: true,
//         time: DateTime.now(),
//       ));
//       _isLoading = true;
//     });
//
//     try {
//       final response = await _chat.sendMessage(Content.text(prompt));
//       setState(() {
//         _messages.add(ChatMessage(
//           text: response.text ?? 'No response',
//           isUser: false,
//           time: DateTime.now(),
//         ));
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add(ChatMessage(
//           text: 'Error: ${e.toString()}',
//           isUser: false,
//           time: DateTime.now(),
//         ));
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//       _scrollToBottom();
//     }
//   }
//
//
//   Future<void> _handleInitialPrompt(String prompt) async {
//     setState(() {
//       _messages.add(ChatMessage(
//         text: prompt,
//         isUser: true,
//         time: DateTime.now(),
//       ));
//       _isLoading = true;
//     });
//
//     try {
//       final response = await _chat.sendMessage(Content.text(prompt));
//       setState(() {
//         _messages.add(ChatMessage(
//           text: response.text ?? 'No response',
//           isUser: false,
//           time: DateTime.now(),
//         ));
//       });
//     } catch (e) {
//       _messages.add(ChatMessage(
//         text: 'Error: ${e.toString()}',
//         isUser: false,
//         time: DateTime.now(),
//       ));
//     } finally {
//       _isLoading = false;
//       _scrollToBottom();
//     }
//   }
//
//   Future<void> _sendMessage() async {
//     final message = _messageController.text.trim();
//     if (message.isEmpty) return;
//
//     setState(() {
//       _messages.add(ChatMessage(
//         text: message,
//         isUser: true,
//         time: DateTime.now(),
//       ));
//       _isLoading = true;
//     });
//     _messageController.clear();
//     _scrollToBottom();
//
//     try {
//       final response = await _chat.sendMessage(Content.text(message));
//       setState(() {
//         _messages.add(ChatMessage(
//           text: response.text ?? 'No response',
//           isUser: false,
//           time: DateTime.now(),
//         ));
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add(ChatMessage(
//           text: 'Error: ${e.toString()}',
//           isUser: false,
//           time: DateTime.now(),
//         ));
//         _isLoading = false;
//       });
//     }
//
//     _scrollToBottom();
//   }
//
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent + 100,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.blueAccent,
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(8),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 return MessageBubble(message: message);
//               },
//             ),
//           ),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.only(bottom: 8.0),
//               child: CircularProgressIndicator(),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type your message...',
//                       border: OutlineInputBorder(),
//                     ),
//                     onSubmitted: (_) => _sendMessage(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _isLoading ? null : _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class ChatMessage {
//   final String text;
//   final bool isUser;
//   final DateTime time;
//
//   ChatMessage({
//     required this.text,
//     required this.isUser,
//     required this.time,
//   });
// }
//
// class MessageBubble extends StatelessWidget {
//   final ChatMessage message;
//
//   const MessageBubble({super.key, required this.message});
//
//   @override
//   Widget build(BuildContext context) {
//     final isUser = message.isUser;
//     final bubbleColor = isUser
//         ? Theme.of(context).colorScheme.primary
//         : Theme.of(context).colorScheme.surfaceVariant;
//     final textColor = isUser
//         ? Theme.of(context).colorScheme.onPrimary
//         : Theme.of(context).colorScheme.onSurfaceVariant;
//
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.all(12),
//         constraints: const BoxConstraints(maxWidth: 300),
//         decoration: BoxDecoration(
//           color: bubbleColor,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment:
//           isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(message.text, style: TextStyle(color: textColor)),
//             const SizedBox(height: 4),
//             Text(
//               DateFormat('HH:mm').format(message.time),
//               style: TextStyle(
//                 fontSize: 10,
//                 color: textColor.withOpacity(0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








// void _sendInitialPrompt() async {
//   if (_showInitialGreeting) {
//     setState(() {
//       _messages.add(ChatMessage(
//         text: "Hello! I'm your business analytics assistant. I'll analyze your data and provide insights.",
//         isUser: false,
//         time: DateTime.now(),
//       ));
//       _showInitialGreeting = false;
//     });
//     await Future.delayed(Duration(seconds: 1));
//   }
//
//   final spendingData = widget.dailySpending.entries
//       .map((e) => "• ${e.key}: \$${e.value.toStringAsFixed(2)}")
//       .join("\n");
//
//   final vendorData = widget.vendorFrequency.entries
//       .map((e) => "• ${e.key}: ${e.value} transactions")
//       .join("\n");
//
//   final productData = widget.productData.entries
//       .map((e) => "• ${e.key}: ${e.value}")
//       .join("\n");
//
//   final prompt = """
//         I'm sharing my business data for analysis:
//
//         📅 **Daily Spending**
//         $spendingData
//
//         🏢 **Vendor Frequency**
//         $vendorData
//
//         📦 **Product Data**
//         $productData
//
//         Please analyze this data and provide insights about:
//         - Spending patterns and trends
//         - Vendor relationships
//         - Product performance
//         - Cost optimization opportunities
//
//         Don't Include any asterisk and don't bold any words and don't provide any recommendations until asked
//         """;
//
//   setState(() {
//     _messages.add(ChatMessage(
//       text: "Give a generalized overview of my data",
//       isUser: true,
//       time: DateTime.now(),
//     ));
//     _isLoading = true;
//   });
//
//   try {
//     final response = await _chat.sendMessage(Content.text(prompt));
//     setState(() {
//       _messages.add(ChatMessage(
//         text: response.text ?? 'No response',
//         isUser: false,
//         time: DateTime.now(),
//       ));
//     });
//   } catch (e) {
//     setState(() {
//       _messages.add(ChatMessage(
//         text: 'Error: ${e.toString()}',
//         isUser: false,
//         time: DateTime.now(),
//       ));
//     });
//   } finally {
//     setState(() => _isLoading = false);
//     _scrollToBottom();
//   }
// }