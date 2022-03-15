import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
              title: const Text('Cad Usuario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadUser(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Lista Usuarios'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Lista Produtos'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Lista Ofertas'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(child: Text(dotenv.env['text'] ?? 'Não encontrado')),
    );
  }
}
