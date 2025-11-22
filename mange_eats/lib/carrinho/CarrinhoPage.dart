import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mange_eats/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
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

      Provider.of<BagProvider>(context, listen: false).calcularTaxa();
    } else {
      setState(() => carregandoCep = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bag = Provider.of<BagProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Carrinho", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        
      ),
      body: Column(
        children: [
          // LISTA DE ITENS
          Expanded(
            child: ListView.builder(
              itemCount: bag.itens.length,
              itemBuilder: (context, index) {
                final item = bag.itens[index];
                return ListTile(
                  leading: Image.network(item.imagem),
                  title: Text(item.nome),
                  subtitle: Text("R\$ ${item.preco.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => bag.removeItem(item),
                  ),
                );
              },
            ),
          ),

          // CAMPO DE CEP
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
                      onPressed: buscarCEP,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // EXIBE ENDEREÇO
                if (carregandoCep)
                  const CircularProgressIndicator(color: Colors.red)
                else if (rua != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rua: $rua"),
                        Text("Bairro: $bairro"),
                        Text("Cidade: $cidade - $uf"),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // RODAPÉ DE VALORES
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.red)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Itens:"),
                    Text("R\$ ${bag.total.toStringAsFixed(2)}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Taxa de Entrega:"),
                    Text(
                      "R\$ ${bag.taxaEntrega.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Geral:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "R\$ ${(bag.total + bag.taxaEntrega).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {},
                  child: const Text("Finalizar Pedido"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
