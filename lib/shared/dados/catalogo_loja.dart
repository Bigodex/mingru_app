import 'package:flutter/foundation.dart';

import 'package:mingru/shared/modelos/produto.dart';

// Catálogo — compartilha os produtos e favoritos entre as telas.
class CatalogoLoja extends ChangeNotifier {
  // Produtos — mantém os dados de demonstração utilizados na home.
  final List<Produto> produtos = const [
    Produto(
      id: 'camiseta-01',
      nome: 'Camiseta Oversized Essential',
      categoria: 'Camisetas',
      precoCentavos: 12990,
      imagemAsset: 'assets/images/1.png',
    ),
    Produto(
      id: 'camiseta-02',
      nome: 'Camiseta Urban Graphic',
      categoria: 'Camisetas',
      precoCentavos: 14990,
      imagemAsset: 'assets/images/2.png',
    ),
    Produto(
      id: 'moletom-01',
      nome: 'Moletom Street com Capuz',
      categoria: 'Blusas/casacos',
      precoCentavos: 25990,
      imagemAsset: 'assets/images/3.png',
    ),
    Produto(
      id: 'calca-01',
      nome: 'Calça Cargo Utility',
      categoria: 'Calças',
      precoCentavos: 21990,
      imagemAsset: 'assets/images/4.png',
    ),
    Produto(
      id: 'tenis-01',
      nome: 'Tênis Urban Classic',
      categoria: 'Calçados',
      precoCentavos: 34990,
    ),
    Produto(
      id: 'bone-01',
      nome: 'Boné Mingru Signature',
      categoria: 'Acessórios',
      precoCentavos: 8990,
    ),
  ];

  // Favoritos — guarda os identificadores selecionados durante a sessão.
  final Set<String> _favoritos = {};

  // Consulta — informa se o produto está nos favoritos.
  bool estaFavoritado(String identificador) {
    return _favoritos.contains(identificador);
  }

  // Seleção — adiciona ou remove o favorito e avisa as telas.
  void alternarFavorito(String identificador) {
    if (!_favoritos.add(identificador)) {
      _favoritos.remove(identificador);
    }

    notifyListeners();
  }

  // Categoria — retorna os produtos do grupo escolhido.
  List<Produto> produtosDaCategoria(String categoria) {
    if (categoria == 'Todos') {
      return produtos;
    }

    return produtos.where((produto) {
      return produto.categoria == categoria;
    }).toList();
  }
}