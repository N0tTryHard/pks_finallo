import '../../models/chat/chat_user.dart';
import 'chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatUser> chatUsers = [];

  Future<void> getChatUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("customer_chats").get();

    chatUsers = querySnapshot.docs
        .map((doc) => ChatUser.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    forceUpdateState();
  }

  String limitWords(String text, int maxWordsCount, int maxCharactersCount) {
    String output = "";
    int wordCount = 0;
    for (final word in text.split(" ")) {
      if (wordCount >= maxWordsCount ||
          (output.length + word.length) > maxCharactersCount) {
        output += "...";
        break;
      }
      output += "$word ";
      wordCount++;
    }
    return output;
  }

  void forceUpdateState() {
    if (!mounted) return;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Список чатов"),
      ),
      body: chatUsers.isEmpty
          ? const Center(child: Text("Нет чатов с клиентами"))
          : ListView.builder(
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(chatUsers[index].uid)));
                  },
                  child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.account_circle, size: 30),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chatUsers[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  chatUsers[index].email,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryFixedDim),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Сообщение: ${limitWords(chatUsers[index].lastMessageContent, 5, 25)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
    );
  }
}
