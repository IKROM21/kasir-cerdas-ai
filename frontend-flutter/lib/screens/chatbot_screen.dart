import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Halo! Saya asisten AI Smart Cashier. Ada yang bisa saya bantu?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Bantuan Kasir'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatMessageWidget(message: message);
              },
            ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _textController.clear();

    // Simulate AI response after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _generateAIResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  String _generateAIResponse(String userMessage) {
    // Simple response generation based on keywords
    if (userMessage.toLowerCase().contains('stok')) {
      return 'Produk dengan stok rendah saat ini: Kopi Latte (5 pcs), Croissant (2 pcs). Saya sarankan untuk segera melakukan restock.';
    } else if (userMessage.toLowerCase().contains('penjualan') ||
        userMessage.toLowerCase().contains('jual')) {
      return 'Hari ini penjualan meningkat 15% dibanding kemarin. Produk terlaris: Kopi Latte (25 pcs), Croissant (18 pcs).';
    } else if (userMessage.toLowerCase().contains('promo') ||
        userMessage.toLowerCase().contains('diskon')) {
      return 'Saat ini ada promo 10% untuk semua minuman panas. Promo berlaku hingga akhir bulan.';
    } else if (userMessage.toLowerCase().contains('terima kasih') ||
        userMessage.toLowerCase().contains('thank')) {
      return 'Sama-sama! Ada lagi yang bisa saya bantu?';
    } else {
      return 'Saya adalah asisten AI Smart Cashier. Saya bisa membantu dengan informasi stok, penjualan, promo, dan pertanyaan lainnya. Apa yang ingin Anda ketahui?';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(message.text),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Center(
                child: Text(
                  'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}