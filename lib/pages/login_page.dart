import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pocket_flutter/pages/caduser_page.dart';
import 'package:pocket_flutter/pages/home_page.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool escondeSenha = true;
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late FocusNode _senha;

  @override
  void initState() {
    super.initState();
    _senha = FocusNode();
  }

  @override
  void dispose() {
    _senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade300,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset("assets/imagens/logo4.png"),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.shade300,
                                  blurRadius: 15,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Parceiro",
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.grey.shade500,
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade500),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    onEditingComplete: () =>
                                        _senha.requestFocus(),
                                    controller: _emailController,
                                    validator: (email) {
                                      if (email == null || email.isEmpty) {
                                        return 'Insira um parceiro!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: TextFormField(
                                    focusNode: _senha,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Senha",
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.grey.shade500,
                                      ),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade500),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade500)),
                                      suffixIcon: InkWell(
                                        onTap: _togglePasswordView,
                                        child: Icon(
                                          escondeSenha
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                    obscureText: escondeSenha,
                                    controller: _passwordController,
                                    validator: (senha) {
                                      if (senha == null || senha.isEmpty) {
                                        return 'Insira sua senha';
                                      } else if (senha.length < 6) {
                                        return 'Insira uma senha v??lida';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (_formkey.currentState!.validate()) {
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    final connectivityStatus =
                                        await Connectivity()
                                            .checkConnectivity();
                                    if (connectivityStatus ==
                                        ConnectivityResult.none) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Imposs??vel fazer Login sem conex??o com a Internet!'),
                                          duration:
                                              Duration(milliseconds: 2000),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      bool deuCerto = await login();
                                      if (deuCerto == true) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        );
                                      } else {
                                        _loginError();
                                      }
                                    }
                                  }
                                },
                                child: const Text('Logar'),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CadUser(),
                                    ),
                                  );
                                },
                                child: const Text(
                                    'Ainda n??o tem conta? Cadastre-se agora.'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      escondeSenha = !escondeSenha;
    });
  }

  Future<bool> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse(
        '${dotenv.get('baseUrl', fallback: 'N??o encontrado')}/sessions');
    var resposta = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": _emailController.text.toLowerCase(),
        "password": _passwordController.text
      }),
    );
    if (resposta.statusCode == 200) {
      var json = jsonDecode(resposta.body);
      String _token = json['token'];
      debugPrint('token = $_token');
      sharedPreferences.setString('token', 'Bearer $_token');
      return true;
    } else {
      return false;
    }
  }

  Future<void> _loginError() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aten????o'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Usu??rio ou senha est??o inv??lidos!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
