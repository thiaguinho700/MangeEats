import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mange_eats/cardapio/cardapio_page.dart';
import 'package:mange_eats/cardapio/prato_model.dart';

class BagProvider extends ChangeNotifier {
  final List<PratoModel> _itens = [];
  String cep = "";
  String endereco = "";
  double taxaEntrega = 0.0;

  List<PratoModel> get itens => _itens;

  void addItem(PratoModel prato) {
    _itens.add(prato);
    calcularTaxa();
    notifyListeners();
  }

  void removeItem(PratoModel prato) {
    _itens.remove(prato);
    calcularTaxa();
    notifyListeners();
  }

  void clear() {
    _itens.clear();
    calcularTaxa();
    notifyListeners();
  }

  double get total {
    double soma = 0.0;

    for (var p in _itens) {
      soma += p.preco;
    }

    return soma;
  }

  Future<void> buscarEndereco(String cepDigitado) async {
    cep = cepDigitado;

    final url = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["erro"] == true) {
        endereco = "CEP inválido";
      } else {
        endereco =
            "${data['logradouro']}, ${data['bairro']} - ${data['localidade']}";
      }
    } else {
      endereco = "Erro ao buscar CEP";
    }

    notifyListeners();
  }

  // ----------------------------
  // CALCULAR TAXA DE ENTREGA
  // ----------------------------
  void calcularTaxa() {
    if (total > 100) {
      taxaEntrega = 0;
    } else {
      taxaEntrega = 8.0; // taxa fixa — pode mudar
    }

    notifyListeners();
  }
}
