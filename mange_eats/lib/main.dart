import 'package:flutter/material.dart';
import 'package:mange_eats/cardapio/Cardapio_page.dart';
import 'package:mange_eats/carrinho/CarrinhoPage.dart';
import 'package:mange_eats/provider/bar_provider.dart';
import 'package:mange_eats/utils/navigator.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BagProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mange Eats",
      debugShowCheckedModeBanner: false,
      home: NavigatorApp(),
    );
  }
}
