import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String senha = '';

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  onSubmitted: (value) {
                    _submit();
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    senha = value;
                  },
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  onSubmitted: (value) {
                    _submit();
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Função para processar o login
  void _submit() {
    if (email == "admin" && senha == "1234") {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro!'),
            content: Text('Usuário ou senha inválidos. Tente novamente.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

