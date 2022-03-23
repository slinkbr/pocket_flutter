import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { fisica, juridica }

class EditParceiro extends StatefulWidget {
  const EditParceiro({Key? key}) : super(key: key);

  @override
  _EditParceiroState createState() => _EditParceiroState();
}

class _EditParceiroState extends State<EditParceiro> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpass = TextEditingController();
  final phone = TextEditingController();
  final cnpj = TextEditingController();
  final cpf = TextEditingController();

  final address = TextEditingController();
  final complements = TextEditingController();
  final number = TextEditingController();
  final zip = TextEditingController();
  final district = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    cnpj.dispose();
    cpf.dispose();

    address.dispose();
    complements.dispose();
    number.dispose();
    zip.dispose();
    district.dispose();
    city.dispose();
    state.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  String tpPessoa = 'J';
  String tpConsu = 'C';
  SingingCharacter? _tpPessoa = SingingCharacter.juridica;

  var phoneMask = MaskTextInputFormatter(
      mask: '(##)#####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 10);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Novo Parceiro'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Cadastro'),
                icon: Icon(Icons.person),
              ),
              Tab(
                child: Text('Endereço'),
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TabBarView(
            children: [
              ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        restorationId: 'cadastro',
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio<SingingCharacter>(
                                  value: SingingCharacter.juridica,
                                  groupValue: _tpPessoa,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      _tpPessoa = value;
                                      tpPessoa = 'J';
                                    });
                                  },
                                ),
                                const Text('Pessoa Jurídica'),
                                Radio<SingingCharacter>(
                                  value: SingingCharacter.fisica,
                                  groupValue: _tpPessoa,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      _tpPessoa = value;
                                      tpPessoa = 'F';
                                    });
                                  },
                                ),
                                const Text('Pessoa Física'),
                              ],
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
                                controller: name,
                                validator: Validatorless.required(
                                    'Necessário Informar o Nome'),
                                decoration: const InputDecoration(
                                  labelText: 'Nome',
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
                                controller: (tpPessoa == 'J') ? cnpj : cpf,
                                validator: (tpPessoa == 'J')
                                    ? Validatorless.cnpj('CNPJ Inválido')
                                    : Validatorless.cpf('CPF Inválido'),
                                decoration: InputDecoration(
                                  labelText: (tpPessoa == 'J') ? 'CNPJ' : 'CPF',
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
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
                                  Validatorless.required(
                                      'Campo senha é obrigatório'),
                                  Validatorless.min(6,
                                      'Senha precisa ter pelo menos 6 caracteres'),
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
                                controller: confirmpass,
                                validator: Validatorless.multiple([
                                  Validatorless.required(
                                      'Campo senha é obrigatório'),
                                  Validatorless.min(5,
                                      'Senha precisa ter pelo menos 5 caracteres'),
                                  Validatorless.compare(password,
                                      'Senha e Confirmar senha não são iguais'),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Confirmar Senha',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
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
              ListView(
                children: [
                  Form(
                    key: _formKey2,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        restorationId: 'endereco',
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            sizedBoxSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 260,
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
                                    controller: zip,
                                    validator: Validatorless.required(
                                        'Necessário informar o CEP'),
                                    decoration: const InputDecoration(
                                      labelText: 'CEP',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final connectivityStatus =
                                        await Connectivity()
                                            .checkConnectivity();
                                    if (connectivityStatus ==
                                        ConnectivityResult.none) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Recurso disponível apenas\n com conexão de Internet ativa!'),
                                          duration:
                                              Duration(milliseconds: 2000),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      if (zip.text.isNotEmpty) {
                                        await buscaCep(zip.text);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'CEP Não Preenchido, verifique!'),
                                            duration:
                                                Duration(milliseconds: 2000),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  minWidth: 50,
                                  height: 50,
                                  color: Colors.green,
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Icon(Icons.search,
                                      color: Colors.white, size: 24),
                                ),
                              ],
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
                                controller: address,
                                validator: Validatorless.required(
                                    'Necessário informar o Logradouro'),
                                decoration: const InputDecoration(
                                  labelText: 'Logradouro',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.streetAddress,
                              ),
                            ),
                            sizedBoxSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
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
                                    controller: number,
                                    validator: (value) {
                                      if (complements.text.isEmpty) {
                                        Validatorless.required(
                                            'Necessário informar o Número');
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Nº',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                  ),
                                ),
                                Container(
                                  width: 220,
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
                                    controller: complements,
                                    validator: (value) {
                                      if (number.text.isEmpty) {
                                        Validatorless.required(
                                            'Necessário informar o Complemento');
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Complemento',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
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
                                controller: district,
                                validator: Validatorless.required(
                                    'Necessário informar o Bairro'),
                                decoration: const InputDecoration(
                                  labelText: 'Bairro',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            sizedBoxSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 250,
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
                                    controller: city,
                                    decoration: const InputDecoration(
                                      labelText: 'Cidade',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
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
                                    controller: state,
                                    decoration: const InputDecoration(
                                      labelText: 'UF',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () async {
              String body =
                  '{"name": "${name.text}", "email": "${email.text}", "password": "${password.text}", "phone": "${phone.text}", "admin": "false", "cnpj":"${cnpj.text}", "cpf": "${cpf.text}",  "zip": "${zip.text}", "address": "${address.text}", "number": "${number.text}", "complements": "${complements.text}", "district": "${district.text}", "city": "${city.text}", "state": "${state.text}", "country": "Brasil"}';
              await postUsuar(body);
            }),
      ),
    );
  }

  Future<void> buscaCep(buscacep) async {
    Response resposta =
        await Dio().get('https://viacep.com.br/ws/$buscacep/json/');
    if (resposta.statusCode == 200) {
      address.text = removeDiacritics(resposta.data['logradouro'].toString());
      district.text = removeDiacritics(resposta.data['bairro'].toString());
      city.text = removeDiacritics(resposta.data['localidade'].toString());
      state.text = resposta.data['uf'].toString();
    } else {
      address.text = '';
      district.text = '';
      city.text = '';
      state.text = '';
    }
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
                Text('Parceiro salvo com sucesso!'),
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
          title: const Text('Atenção'),
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
