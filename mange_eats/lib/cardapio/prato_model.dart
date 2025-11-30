import 'dart:convert';
import 'package:http/http.dart' as http;

class CardapioService {
  static const String baseUrl = "http://192.168.0.5:8000/api/cardapio/";

  static Future<List<PratoModel>> fetchPratos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode >= 200 && response.statusCode < 400) {
      final decoded = jsonDecode(response.body);

      //
      if (decoded is List) {
        return decoded.map((e) => PratoModel.fromJson(e)).toList();
      }

      if (decoded is Map) {
        for (var value in decoded.values) {
          if (value is List) {
            return value
                .map<PratoModel>((e) => PratoModel.fromJson(e))
                .toList();
          }
        }

        throw Exception("Nenhuma lista encontrada no JSON");
      }

      throw Exception("Formato de JSON inválido");
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
      imagem: json["imagem"],
      preco: double.parse(json["preco"].toString()),
    );
  }
}
