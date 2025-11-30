import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mange_eats/login/login_page.dart';

class Cadastro_page extends StatefulWidget {
  const Cadastro_page({super.key});

  @override
  State<Cadastro_page> createState() => _Cadastro_pageState();
}

class _Cadastro_pageState extends State<Cadastro_page> {
  bool checkBox = false;
  bool hidePassword = true;

  Icon eyeOpenPassword = Icon(Icons.visibility, color: Colors.black);
  Icon eyeClosePassword = Icon(Icons.visibility_off, color: Colors.black);

  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordNovamenteController = TextEditingController();

  Future<void> criarCarrinho() async {
    final urlCarrinho = Uri.parse('http://192.168.0.5:8000/api/carrinho/');

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
    final user = prefs.getString('user_data');
    final userData = json.decode(user!);

    try {
      final carrinhoResponse = await http.post(
        urlCarrinho,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"usuario": userData!['username']}),
      );

      if (carrinhoResponse.statusCode >= 200 &&
          carrinhoResponse.statusCode < 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Carrinho criado com sucesso!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Falha ao criar o carrinho!")),
        );
      }
    } catch (e) {}
  }

  Future<void> registerUsuario() async {
    final urlCadastro = Uri.parse('http://192.168.0.5:8000/api/auth/users/');
    final urlLogin = Uri.parse('http://192.168.0.5:8000/api/auth/jwt/create/');
    final urlMe = Uri.parse('http://192.168.0.5:8000/api/auth/users/me/');

    try {
      final registerResponse = await http.post(
        urlCadastro,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _nomeController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      if (!(registerResponse.statusCode >= 200 &&
          registerResponse.statusCode < 400)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao cadastrar: ${registerResponse.body}"),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final loginResponse = await http.post(
        urlLogin,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _nomeController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final loginData = json.decode(loginResponse.body);
      final accessToken = loginData['access'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);

      final meResponse = await http.get(
        urlMe,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      final userData = json.decode(meResponse.body);

      await prefs.setString('user_data', json.encode(userData));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuário cadastrado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
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
                        "Cadastrar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Bem-Vindo",
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    label: Text("Email"),
                    icon: Icon(Icons.person),
                  ),
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
                obscureText: hidePassword,
                controller: _passwordController,
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

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: _passwordNovamenteController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    label: Text("Senha novamente"),
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
                    child: Text("Aceite nossos termos e contratos"),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () => registerUsuario(),
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
                  "Sign in",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Já possui uma conta? "),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        decorationStyle: TextDecorationStyle.solid,
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
