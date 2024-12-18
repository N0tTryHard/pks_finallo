import '../chat/chat_list.dart';
import '../chat/chat_page.dart';
import 'package:flutter/material.dart';
import '../../models/user/auth_service.dart';
import '../orders_page.dart';
import '/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    appData.accountPageState = this;
  }

  void forceUpdateState() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Icon(Icons.account_circle, size: 200.0),
            const SizedBox(
              height: 10,
            ),
            Text(
              appData.account!.displayName as String,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(appData.account!.email!),
            const SizedBox(
              height: 20,
            ),
            AuthService.isAdmin()
                ? const Center()
                : TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrdersPage()));
                    },
                    child: const Text(
                      "Мои заказы",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
            AuthService.isAdmin()
                ? const Center()
                : TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(null)));
                    },
                    child: const Text(
                      "Чат с продавцом",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
            AuthService.isAdmin()
                ? TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatList()));
                    },
                    child: const Text(
                      "Чат с клиентами",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : const Center()
          ],
        ),
      ),
      persistentFooterButtons: [
        SizedBox.expand(
            child: TextButton(
          onPressed: () async {
            final authService = AuthService();
            await authService.logout();
          },
          child: const Text(
            "Выйти",
            style: TextStyle(fontSize: 18),
          ),
        ))
      ],
    );
  }
}
