import 'package:flutter/material.dart';

class AccountUpdatePage extends StatelessWidget {
  AccountUpdatePage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Редактировать профиль")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Icon(Icons.account_circle, size: 150.0),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Имя"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Эл. почта"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: "Телефон"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {},
                child: const Text(
                  "Сохранить данные",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ));
  }
}
