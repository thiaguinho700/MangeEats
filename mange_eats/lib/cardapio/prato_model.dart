import 'dart:convert';
import 'package:http/http.dart' as http;

class CardapioService {
  static const String baseUrl = "http://127.0.0.1:8000/api/cardapio/";

  static Future<List<PratoModel>> fetchPratos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => PratoModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar cardápio (${response.statusCode})");
    }
  }
}


class PratoModel {
  final int id;
  final String nome;
  final String descricao;
  final String imagem;
  final double preco;

  PratoModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.imagem,
    required this.preco,
  });

  factory PratoModel.fromJson(Map<String, dynamic> json) {
    return PratoModel(
      id: json["id"],
      nome: json["nome_prato"],
      descricao: json["descricao"],
      imagem: "http://127.0.0.1:8000${json["imagem"]}",
      preco: double.parse(json["preco"].toString()),
    );
  }
}
