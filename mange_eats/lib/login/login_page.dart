import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mange_eats/cadastro/Cadastro_page.dart';
import 'package:mange_eats/cardapio/Cardapio_page.dart';
import 'package:mange_eats/utils/navigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBox = false;
  bool hidePassword = true;

  Icon eyeOpenPassword = Icon(Icons.visibility, color: Colors.black);
  Icon eyeClosePassword = Icon(Icons.visibility_off, color: Colors.black);

  final _nomeController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> logInUsuario() async {
    final urlLogin = Uri.parse('http://10.109.83.25:8000/api/auth/jwt/create/');

    try {
      final loginResponse = await http.post(
        urlLogin,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _nomeController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      if (loginResponse.statusCode >= 200 && loginResponse.statusCode < 400) {
        print(loginResponse.body);
        print(loginResponse.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bem-Vindo!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigatorApp()),
        );
      } else {
        print(loginResponse.body);
        print(loginResponse.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Falha ao tentar entrar!")),
        );
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      body: Center(
        child: Container(
          width: 380,
          height: 800,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Bem-Vindo de volta!",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    label: Text("Nome"),
                    icon: Icon(Icons.person),
                  ),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  label: Text("Senha"),
                  icon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    isSelected: checkBox,
                    onPressed: () => setState(() {
                      hidePassword = !hidePassword;
                    }),
                    icon: hidePassword ? eyeClosePassword : eyeOpenPassword,
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: checkBox,
                    onChanged: (bool? value) => {
                      setState(() {
                        checkBox = value!;
                      }),
                    },
                    activeColor: Colors.red[400],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text("Lembrar da senha?"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => logInUsuario(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: EdgeInsets.only(
                    right: 100,
                    left: 100,
                    bottom: 13,
                    top: 13,
                  ),
                ),
                child: Text(
                  "Log in",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Não possui uma conta? "),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro_page())),
                    child: Text(
                      "Registrar",
                      style: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
