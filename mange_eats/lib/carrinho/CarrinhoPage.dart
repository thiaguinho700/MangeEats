import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  int? carrinhoId;
  int? usuarioId;
  List<dynamic> itens = [];

  @override
  void initState() {
    super.initState();
    getCarrinho();
  }

  Future<void> getCarrinho() async {
    final urlLogin = Uri.parse('http://10.109.83.25:8000/api/carrinho/');
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');

    try {
      final response = await http.get(
        urlLogin,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 400) {
        final data = jsonDecode(response.body);

        // O carrinho está em data["results"][0]
        final carrinho = data["results"][0];

        setState(() {
          carrinhoId = carrinho["id"];
          usuarioId = carrinho["usuario"];
          itens = carrinho["itens"]; // lista de itens
        });

        print("Carrinho ID: $carrinhoId");
        print("Usuário ID: $usuarioId");
        print("Itens: $itens");
      } else {
        print("Erro: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  final TextEditingController cepController = TextEditingController();

  String? rua;
  String? bairro;
  String? cidade;
  String? uf;

  bool carregandoCep = false;

  Future<void> buscarCEP() async {
    String cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length != 8) return;

    setState(() => carregandoCep = true);

    final url = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      setState(() {
        rua = dados['logradouro'];
        bairro = dados['bairro'];
        cidade = dados['localidade'];
        uf = dados['uf'];
        carregandoCep = false;
      });
    } else {
      setState(() => carregandoCep = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Carrinho", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // LISTA DE ITENS ------------------------------
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final item = itens[index];

                return ListTile(
                  title: Text(item["nome"] ?? "Produto"),
                  subtitle: Text("R\$ ${item["preco"] ?? "0.00"}"),
                );
              },
            ),
          ),

          // ↓ daqui pra baixo deixei igual ao seu --------------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: cepController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Digite seu CEP",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
