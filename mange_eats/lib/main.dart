import 'package:flutter/material.dart';
import 'package:mange_eats/cadastro/Cadastro_page.dart';
import 'package:mange_eats/cardapio/Cardapio_page.dart';
import 'package:mange_eats/carrinho/CarrinhoPage.dart';
import 'package:mange_eats/login/login_page.dart';
import 'package:mange_eats/utils/navigator.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mange Eats",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
