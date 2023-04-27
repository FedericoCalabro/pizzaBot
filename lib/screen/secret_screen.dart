import 'package:chatbot/pizzabot/pizza_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecretScreen extends ConsumerStatefulWidget {
  final TextEditingController _secretController = TextEditingController();

  SecretScreen({super.key});

  @override
  ConsumerState<SecretScreen> createState() => _SecretScreenState();
}

class _SecretScreenState extends ConsumerState<SecretScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (layoutContext, constraint) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: widget._secretController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Secret',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final newSecret = widget._secretController.text;
                    (await SharedPreferences.getInstance())
                        .setString('secret', newSecret);
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  child: const Text('Salva secret'),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
