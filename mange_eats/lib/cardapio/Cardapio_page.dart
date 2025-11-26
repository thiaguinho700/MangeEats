import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mange_eats/cardapio/prato_model.dart';
import 'package:mange_eats/carrinho/CarrinhoPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CardapioPage extends StatefulWidget {
  const CardapioPage({super.key});

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  int? carrinhoId;
  List<dynamic> itens = [];

  late Future<List<PratoModel>> futurePratos;

  @override
  void initState() {
    super.initState();
    futurePratos = CardapioService.fetchPratos();
    carregarCarrinho();
  }

  // ---------------------------------------------------------
  // BUSCAR CARRINHO DO USUÁRIO
  // ---------------------------------------------------------
  Future<void> carregarCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print(token);
    final url = Uri.parse('http://10.109.83.25:8000/api/carrinho/');

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final lista = jsonDecode(response.body);
      if (lista.isNotEmpty) {
        setState(() {
          carrinhoId = lista[0]["id"];
          itens = lista[0]["itens"];
        });
      }
    } else {
      print("Erro ao carregar carrinho: ${response.body}");
    }
  }

  // ---------------------------------------------------------
  // ADICIONAR ITEM AO CARRINHO
  // ---------------------------------------------------------
  Future<void> adicionarItemAoCarrinho(int pratoId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    // primeiro garante carrinho carregado
    if (carrinhoId == null) {
      await carregarCarrinho();
      if (carrinhoId == null) return;
    }

    final url = Uri.parse(
        'http://10.109.83.25:8000/api/carrinho/$carrinhoId/adicionar/');

    final body = jsonEncode({
      "prato_id": pratoId,
      "quantidade": 1,
    });

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: body,
    );

    print("Resposta Add Item: ${response.body}");

    if (response.statusCode == 201) {
      await carregarCarrinho();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item adicionado ao carrinho!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print("Erro ao adicionar item: ${response.body}");
    }
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        futurePratos = CardapioService.fetchPratos();
        await carregarCarrinho();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Cardápio", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CarrinhoPage()),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.white),

                if (itens.isNotEmpty)
                  Positioned(
                    right: 2,
                    top: 8,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.black,
                      child: Text(
                        itens.length.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ---------------------
        body: FutureBuilder<List<PratoModel>>(
          future: futurePratos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.red));
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao carregar cardápio: ${snapshot.error}"),
              );
            }

            final pratos = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 20),

                SizedBox(
                  height: 350,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pratos.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final prato = pratos[index];
                      bool ativo = _currentPage == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(
                          horizontal: ativo ? 8 : 16,
                          vertical: ativo ? 0 : 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(prato.imagem, height: 140),
                            const SizedBox(height: 12),
                            Text(prato.nome,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("R\$ ${prato.preco.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.red)),
                            const SizedBox(height: 12),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () async {
                                await adicionarItemAoCarrinho(prato.id);
                              },
                              child: const Text("Adicionar ao Carrinho",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: pratos.length,
                    itemBuilder: (context, index) {
                      final prato = pratos[index];

                      return ListTile(
                        leading: Image.network(prato.imagem),
                        title: Text(prato.nome),
                        subtitle: Text(
                          "R\$ ${prato.preco.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.red),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart,
                              color: Colors.red),
                          onPressed: () async {
                            await adicionarItemAoCarrinho(prato.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
