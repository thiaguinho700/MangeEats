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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final user_data = prefs.getString('user_data');
    final userData = json.decode(user_data!);

    final userId = userData['id']; // já é int
    print(userId);
    final urlCarrinho = Uri.parse(
      'http://192.168.0.5:8000/api/carrinho/?usuario=$userId',
    );

    try {
      final response = await http.get(
        urlCarrinho,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 400) {
        final data = jsonDecode(response.body);

        // ✔️ O retorno é uma lista, então precisamos acessar [0]
        if (data is List && data.isNotEmpty) {
          final carrinho = data[0];
          final carrinhoId = carrinho['id'];

          print("Carrinho encontrado: $carrinhoId");

          // salvar no prefs
          await prefs.setInt('carrinho_id', carrinhoId);
        } else {
          print(carrinhoId);
          print("Nenhum carrinho encontrado para o usuário");
        }
      } else {
        print("Erro carrinho: ${response.body}");
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
        leading: IconButton(
          onPressed: () => getCarrinho(),
          icon: Icon(Icons.refresh),
        ),
        title: const Text("Carrinho", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Column(
        children: [
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
