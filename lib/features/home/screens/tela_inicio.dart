import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';
import 'package:mingru/features/home/widgets/categorias_inicio.dart';
import 'package:mingru/shared/widgets/cabecalho.dart';
import 'package:mingru/shared/widgets/campo_busca.dart';
import 'package:mingru/shared/widgets/cartao_produto.dart';
import 'package:mingru/shared/widgets/menu_navegacao_inferior.dart';

// Tela inicial — apresenta a vitrine e seus filtros.
class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  // Estado — controla a busca, a categoria e os favoritos.
  final TextEditingController _controladorBusca = TextEditingController();
  final Set<String> _favoritos = {};

  String _termoPesquisa = '';
  String _categoriaSelecionada = 'Todos';

  // Menu — inicia visível quando a tela é aberta.
  bool _menuVisivel = true;

  // Navegação — início permanece selecionado nesta tela.
  static const int _indiceMenuAtual = 0;

  // Moeda — formata os preços dos detalhes.
  static final NumberFormat _formatadorMoeda = NumberFormat.currency(
    locale: 'pt_BR',
    name: 'BRL',
    symbol: r'R$',
    decimalDigits: 2,
  );

  // Demonstração — produtos temporários para montar a vitrine.
  static const List<_ProdutoVitrine> _produtos = [
    _ProdutoVitrine(
      id: 'camiseta-01',
      nome: 'Camiseta Oversized Essential',
      categoria: 'Camisetas',
      precoCentavos: 12990,
      imagemAsset: 'assets/images/1.png',
    ),
    _ProdutoVitrine(
      id: 'camiseta-02',
      nome: 'Camiseta Urban Graphic',
      categoria: 'Camisetas',
      precoCentavos: 14990,
      imagemAsset: 'assets/images/2.png',
    ),
    _ProdutoVitrine(
      id: 'moletom-01',
      nome: 'Moletom Street com Capuz',
      categoria: 'Blusas/casacos',
      precoCentavos: 25990,
      imagemAsset: 'assets/images/3.png',
    ),
    _ProdutoVitrine(
      id: 'calca-01',
      nome: 'Calça Cargo Utility',
      categoria: 'Calças',
      precoCentavos: 21990,
      imagemAsset: 'assets/images/4.png',
    ),
    _ProdutoVitrine(
      id: 'tenis-01',
      nome: 'Tênis Urban Classic',
      categoria: 'Calçados',
      precoCentavos: 34990,
    ),
    _ProdutoVitrine(
      id: 'bone-01',
      nome: 'Boné Mingru Signature',
      categoria: 'Acessórios',
      precoCentavos: 8990,
    ),
  ];

  // Normalização — permite buscar com ou sem acentos.
  String _normalizarTexto(String texto) {
    return texto
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  // Filtros — combina a categoria com os termos pesquisados.
  List<_ProdutoVitrine> get _produtosFiltrados {
    final pesquisa = _normalizarTexto(_termoPesquisa);
    final termos = pesquisa.isEmpty ? <String>[] : pesquisa.split(' ');

    return _produtos.where((produto) {
      final correspondeCategoria = _categoriaSelecionada == 'Todos' ||
          produto.categoria == _categoriaSelecionada;

      final textoProduto = _normalizarTexto(
        '${produto.nome} ${produto.categoria}',
      );

      final correspondePesquisa = termos.every(textoProduto.contains);

      return correspondeCategoria && correspondePesquisa;
    }).toList();
  }

  // Menu — esconde ao descer e reaparece ao subir.
  bool _controlarVisibilidadeMenu(
    UserScrollNotification notificacao,
  ) {
    // Scroll para baixo — inicia a animação de saída.
    if (notificacao.direction == ScrollDirection.reverse) {
      if (_menuVisivel) {
        setState(() {
          _menuVisivel = false;
        });
      }
    }

    // Scroll para cima — inicia a animação de retorno.
    if (notificacao.direction == ScrollDirection.forward) {
      if (!_menuVisivel) {
        setState(() {
          _menuVisivel = true;
        });
      }
    }

    return false;
  }

  // Pesquisa — aplica o termo confirmado no teclado.
  void _pesquisar(String termo) {
    setState(() {
      _termoPesquisa = termo;
    });
  }

  // Categoria — aplica o filtro escolhido.
  void _selecionarCategoria(String categoria) {
    setState(() {
      _categoriaSelecionada = categoria;
    });
  }

  // Limpeza — restaura a vitrine completa.
  void _limparFiltros() {
    _controladorBusca.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _termoPesquisa = '';
      _categoriaSelecionada = 'Todos';
    });
  }

  // Favoritos — alterna a seleção durante a sessão.
  void _alternarFavorito(String identificador) {
    setState(() {
      if (!_favoritos.add(identificador)) {
        _favoritos.remove(identificador);
      }
    });
  }

  // Menu — recebe a opção selecionada.
  void _selecionarItemMenu(int indice) {
    switch (indice) {
      case 0:
        break;

      case 1:
        _mostrarTelaEmConstrucao('Categorias');
        break;

      case 2:
        _mostrarTelaEmConstrucao('Carrinho');
        break;

      case 3:
        _mostrarTelaEmConstrucao('Perfil');
        break;
    }
  }

  // Temporário — aviso enquanto as telas não existem.
  void _mostrarTelaEmConstrucao(String nomeTela) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$nomeTela será a próxima tela que vamos construir.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Detalhes — apresenta as informações do item selecionado.
  void _abrirProduto(_ProdutoVitrine produto) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CoresAplicativo.superficie,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (contextoModal) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categoria — identifica o grupo do produto.
                Text(
                  produto.categoria,
                  style: const TextStyle(
                    color: CoresAplicativo.textoSecundario,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                // Nome — apresenta o título.
                Text(
                  produto.nome,
                  style: Theme.of(contextoModal)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),

                const SizedBox(height: 16),

                // Preço — apresenta o valor.
                Text(
                  _formatadorMoeda.format(
                    produto.precoCentavos / 100,
                  ),
                  style: const TextStyle(
                    color: CoresAplicativo.primaria,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                // Informação — produto temporário.
                const Text(
                  'Produto de demonstração. Compra indisponível.',
                  style: TextStyle(
                    color: CoresAplicativo.textoSecundario,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                // Ação — fecha os detalhes.
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(contextoModal).pop();
                    },
                    child: const Text(
                      'Continuar explorando',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Limpeza — libera o controlador.
    _controladorBusca.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Produtos — aplica os filtros atuais.
    final produtosVisiveis = _produtosFiltrados;

    // Filtros — identifica se existe filtro ativo.
    final possuiFiltros =
        _termoPesquisa.isNotEmpty || _categoriaSelecionada != 'Todos';

    return Scaffold(
      backgroundColor: CoresAplicativo.fundo,
      appBar: const Cabecalho(),

      // Estrutura — conteúdo e menu ocupam a mesma área.
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Scroll — identifica a direção usada pelo usuário.
          NotificationListener<UserScrollNotification>(
            onNotification: _controlarVisibilidadeMenu,

            // Conteúdo — vitrine principal.
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  110,
                ),
                children: [
                  // Busca — pesquisa produtos.
                  CampoBusca(
                    controlador: _controladorBusca,
                    aoPesquisar: _pesquisar,
                  ),

                  const SizedBox(height: 16),

                  // Categorias — filtros rápidos.
                  CategoriasInicio(
                    categoriaSelecionada: _categoriaSelecionada,
                    aoSelecionar: _selecionarCategoria,
                  ),

                  const SizedBox(height: 24),

                  // Título — seleção atual.
                  Text(
                    _categoriaSelecionada == 'Todos'
                        ? 'Explore a loja'
                        : _categoriaSelecionada,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),

                  const SizedBox(height: 6),

                  // Descrição — apresentação da vitrine.
                  const Text(
                    'Confira nossa vitrine StreetWear!',
                    style: TextStyle(
                      color: CoresAplicativo.textoSecundario,
                      fontSize: 14,
                    ),
                  ),

                  // Pesquisa — termo atualmente aplicado.
                  if (_termoPesquisa.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Busca por “$_termoPesquisa”',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Resultado — quantidade encontrada.
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        produtosVisiveis.length == 1
                            ? '1 produto'
                            : '${produtosVisiveis.length} produtos',
                        style: const TextStyle(
                          color: CoresAplicativo.textoSecundario,
                          fontSize: 13,
                        ),
                      ),

                      if (possuiFiltros)
                        TextButton(
                          onPressed: _limparFiltros,
                          child: const Text(
                            'Limpar filtros',
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Estado vazio — nenhum produto encontrado.
                  if (produtosVisiveis.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            color: CoresAplicativo.textoSecundario,
                            size: 40,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum produto encontrado.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CoresAplicativo.textoPrincipal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Experimente outro termo ou limpe os filtros.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CoresAplicativo.textoSecundario,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // Produtos — cartões da vitrine.
                    LayoutBuilder(
                      builder: (context, restricoes) {
                        final textoAmpliado =
                            MediaQuery.textScalerOf(context).scale(14) > 20;

                        final colunaUnica =
                            restricoes.maxWidth < 300 || textoAmpliado;

                        final larguraCartao = colunaUnica
                            ? restricoes.maxWidth
                            : (restricoes.maxWidth - 12) / 2;

                        return Wrap(
                          spacing: 12,
                          runSpacing: 16,
                          children: produtosVisiveis.map((produto) {
                            return SizedBox(
                              key: ValueKey(produto.id),
                              width: larguraCartao,
                              child: CartaoProduto(
                                nome: produto.nome,
                                precoCentavos: produto.precoCentavos,
                                imagemAsset: produto.imagemAsset,
                                favorito: _favoritos.contains(
                                  produto.id,
                                ),
                                aoAbrir: () {
                                  _abrirProduto(produto);
                                },
                                aoAlternarFavorito: () {
                                  _alternarFavorito(
                                    produto.id,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // Menu — flutua diretamente sobre o conteúdo.
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Center(
                // Interação — bloqueia toques quando estiver escondido.
                child: IgnorePointer(
                  ignoring: !_menuVisivel,

                  // Movimento — desliza completamente para baixo.
                  child: AnimatedSlide(
                    offset: _menuVisivel
                        ? Offset.zero
                        : const Offset(0, 2.0),

                    // Duração — deixa o movimento claramente perceptível.
                    duration: const Duration(
                      milliseconds: 450,
                    ),

                    // Curva — começa suave e acelera durante a saída.
                    curve: _menuVisivel
                        ? Curves.easeOutCubic
                        : Curves.easeInCubic,

                    // Navegação — menu principal.
                    child: MenuNavegacaoInferior(
                      indiceSelecionado: _indiceMenuAtual,
                      aoSelecionar: _selecionarItemMenu,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Produto temporário — dados usados nesta demonstração.
class _ProdutoVitrine {
  const _ProdutoVitrine({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.precoCentavos,
    this.imagemAsset,
  });

  // Identificação — chave única.
  final String id;

  // Informações — conteúdo do produto.
  final String nome;
  final String categoria;
  final int precoCentavos;

  // Imagem — arquivo local.
  final String? imagemAsset;
}