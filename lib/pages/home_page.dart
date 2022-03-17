import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocket_flutter/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'caduser_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.env['text'] ?? 'Não encontrado'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  child: Image.asset('assets/imagens/logo4.png'),
                  color: Colors.white,
                ),
              ),
              decoration: const BoxDecoration(color: Colors.green),
              accountName: const Text('Usuario'),
              accountEmail: const Text('email@dominio.com.br'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadUser(),
                  ),
                );
              },
              leading: const Icon(Icons.person),
              title: const Text('Cadastro de Parceiro'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.people),
              title: const Text('Teste 1'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.request_quote),
              title: const Text('Teste 2'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.notes),
              title: const Text('Teste 3'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.sell),
              title: const Text('Teste 4'),
            ),
            ListTile(
              onTap: () {
                _showDialogLogout();
              },
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
            ),
          ],
        ),
      ),
      body: Center(child: Text(dotenv.env['text'] ?? 'Não encontrado')),
    );
  }

  Future<void> _showDialogLogout() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseja realmente sair do sistema?'),
          // content: SingleChildScrollView(
          //   child: ListBody(
          //     children: const <Widget>[
          //       Text('Atenção, todos os dados não enviados serão perdidos!'),
          //     ],
          //   ),
          // ),
          actions: <Widget>[
            TextButton(
              child: const Text('Sair'),
              onPressed: () {
                limparShared();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

void limparShared() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.remove('token');
}
