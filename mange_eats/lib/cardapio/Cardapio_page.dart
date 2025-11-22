import 'package:flutter/material.dart';
import 'package:mange_eats/cardapio/cardapio_page.dart';
import 'package:mange_eats/cardapio/prato_model.dart';
import 'package:mange_eats/carrinho/CarrinhoPage.dart';
import 'package:mange_eats/provider/bar_provider.dart';
import 'package:provider/provider.dart';





class CardapioPage extends StatefulWidget {
  const CardapioPage({super.key});

  @override
  State<CardapioPage> createState() => _CardapioPageState();
}

class _CardapioPageState extends State<CardapioPage> {


  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  late Future<List<PratoModel>> futurePratos;

  @override
  void initState() {
    super.initState();
    futurePratos = CardapioService.fetchPratos();
  }

  @override
  Widget build(BuildContext context) {
    final bag = Provider.of<BagProvider>(context);

    return Scaffold(
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
              if (bag.itens.isNotEmpty)
                Positioned(
                  right: 2,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.black,
                    child: Text(
                      bag.itens.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<PratoModel>>(
        future: futurePratos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar cardápio",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final pratos = snapshot.data!;

          return Column(
            children: [
              const SizedBox(height: 20),

              // --- CARROSSEL ---
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
                        boxShadow: ativo
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(prato.imagem, height: 140),
                          const SizedBox(height: 12),
                          Text(
                            prato.nome,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "R\$ ${prato.preco.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16, color: Colors.red),
                          ),
                          const SizedBox(height: 12),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              bag.addItem(prato);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("${prato.nome} adicionado ao carrinho!"),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Text(
                              "Adicionar ao Carrinho",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // --- INDICADORES ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pratos.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == index ? 24 : 12,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.red : Colors.red.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- LISTA COMPLETA ---
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
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.red),
                        onPressed: () {
                          bag.addItem(prato);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("${prato.nome} adicionado ao carrinho!"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
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
    );
  }
}
