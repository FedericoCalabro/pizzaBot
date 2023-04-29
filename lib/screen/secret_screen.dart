import 'package:pizzabot/pizzabot/pizza_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecretScreen extends ConsumerStatefulWidget {
  const SecretScreen({super.key});

  @override
  ConsumerState<SecretScreen> createState() => _SecretScreenState();
}

class _SecretScreenState extends ConsumerState<SecretScreen> {
  late final TextEditingController _secretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _secretController.text = await ref.read(secretManagerProvider).get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SETTINGS")),
      body: SafeArea(
        child: LayoutBuilder(builder: (layoutContext, constraint) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getTextController(),
                const SizedBox(height: 10),
                getSalvaSecretButton(),
                const SizedBox(height: 10),
                getCancellaSecretButton(),
                const SizedBox(height: 10),
                getTrovaSecretButton(),
              ],
            ),
          );
        }),
      ),
    );
  }

  TextField getTextController() {
    return TextField(
      controller: _secretController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Secret',
      ),
    );
  }

  ElevatedButton getSalvaSecretButton() {
    return ElevatedButton(
      child: const Text('Salva secret'),
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      onPressed: () async {
        final newSec = _secretController.text;
        (await SharedPreferences.getInstance()).setString('secret', newSec);
        openSnackbar(context, "Secret aggiornato");
      },
    );
  }

  ElevatedButton getCancellaSecretButton() {
    return ElevatedButton(
      child: const Text('Rimuovi secret'),
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      onPressed: () async {
        (await SharedPreferences.getInstance()).remove('secret');
        openSnackbar(context, "Secret rimosso");
      },
    );
  }

  ElevatedButton getTrovaSecretButton() {
    return ElevatedButton(
      child: const Text('Trova secret'),
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      onPressed: () async {
        final sor = await (ref.read(pizzaRepositoryProvider).getSecret());
        sor.fold(
          (l) {
            openSnackbar(context, "Secret = '${l}'");
            _secretController.text = l;
            setState(() {});
          },
          (r) => openSnackbar(context, "Errore ${r.errorMessage}"),
        );
      },
    );
  }

  void openSnackbar(BuildContext context, String snackContent) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text(snackContent))),
    );
  }
}
