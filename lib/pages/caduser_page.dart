import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pocket_flutter/pages/home_page.dart';
import 'package:validatorless/validatorless.dart';
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadUser extends StatefulWidget {
  const CadUser({Key? key}) : super(key: key);

  @override
  _CadUserState createState() => _CadUserState();
}

class _CadUserState extends State<CadUser> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpass = TextEditingController();
  final phone = TextEditingController();

  bool tpUser = false;
  String? body;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    confirmpass.dispose();
    phone.dispose();
  }

  var phoneMask = MaskTextInputFormatter(
      mask: '(##)#####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Scrollbar(
              child: SingleChildScrollView(
                restorationId: 'cadastrousuario',
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sizedBoxSpace,
                    Container(
                      width: 330,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: TextFormField(
                        controller: name,
                        validator:
                            Validatorless.required('Campo nome é obrigatório'),
                        decoration: const InputDecoration(
                          labelText: 'Nome do Usuário',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    sizedBoxSpace,
                    Container(
                      width: 330,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: TextFormField(
                        controller: email,
                        validator: Validatorless.multiple([
                          Validatorless.required('Campo Email é obrigatório'),
                          Validatorless.email('Email inválido')
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    sizedBoxSpace,
                    Container(
                      width: 330,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: TextFormField(
                        obscureText: true,
                        controller: password,
                        validator: Validatorless.multiple([
                          Validatorless.required('Campo senha é obrigatório'),
                          Validatorless.min(
                              6, 'Senha precisa ter pelo menos 6 caracteres'),
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    sizedBoxSpace,
                    Container(
                      width: 330,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: TextFormField(
                        obscureText: true,
                        controller: confirmpass,
                        validator: Validatorless.multiple([
                          Validatorless.required('Campo senha é obrigatório'),
                          Validatorless.min(
                              5, 'Senha precisa ter pelo menos 5 caracteres'),
                          Validatorless.compare(password,
                              'Senha e Confirmar senha não são iguais'),
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'Confirmar Senha',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    sizedBoxSpace,
                    Container(
                      width: 330,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ]),
                      child: TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneMask],
                        validator: Validatorless.multiple([
                          Validatorless.required(
                              'Campo Telefone é obrigatório'),
                        ]),
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            body =
                '{"name": "${name.text}", "email": "${email.text}", "password": "${password.text}", "phone": "${phone.text}", "admin": "false"}';
            await postUsuar(body);
          }
        },
      ),
    );
  }

  Future<void> postUsuar(corpin) async {
    var url =
        Uri.parse('${dotenv.get('baseUrl', fallback: 'Não encontrado')}/users');
    var resposta = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: corpin,
    );
    if (resposta.statusCode == 200) {
      _showDialogSalvo();
    } else {
      _showDialogSalvoErro(jsonDecode(resposta.body));
    }
  }

  Future<void> _showDialogSalvo() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Usuario salvo com sucesso!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogSalvoErro(erro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Atenção, houve falha ao tentar salvar o Usuario, verifique...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$erro'),
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
