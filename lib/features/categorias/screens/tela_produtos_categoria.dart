import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';
import 'package:mingru/shared/dados/catalogo_loja.dart';
import 'package:mingru/shared/modelos/produto.dart';
import 'package:mingru/shared/widgets/cartao_produto.dart';

// Ordenação — opções disponíveis na listagem.
enum _OrdenacaoProdutos {
  padrao('Padrão'),
  menorPreco('Menor preço'),
  maiorPreco('Maior preço'),
  nome('Nome: A–Z');

  const _OrdenacaoProdutos(this.rotulo);

  final String rotulo;
}

// Listagem — apresenta os produtos da categoria selecionada.
class TelaProdutosCategoria extends StatefulWidget {
  const TelaProdutosCategoria({
    super.key,
    required this.categoria,
    required this.catalogo,
    required this.aoAbrirProduto,
  });

  // Conteúdo — categoria escolhida e catálogo compartilhado.
  final String categoria;
  final CatalogoLoja catalogo;

  // Navegação — encaminha o produto para a abertura dos detalhes.
  final ValueChanged<Produto> aoAbrirProduto;

  @override
  State<TelaProdutosCategoria> createState() =>
      _TelaProdutosCategoriaState();
}

class _TelaProdutosCategoriaState extends State<TelaProdutosCategoria> {
  // Busca — controla o texto digitado nesta listagem.
  final TextEditingController _controladorBusca = TextEditingController();
  String _termoPesquisa = '';

  // Ordenação — começa respeitando a ordem original do catálogo.
  _OrdenacaoProdutos _ordenacao = _OrdenacaoProdutos.padrao;

  // Normalização — permite pesquisar sem diferenciar acentos e maiúsculas.
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

  // Resultado — combina categoria, pesquisa e ordenação.
  List<Produto> get _produtosFiltrados {
    final pesquisa = _normalizarTexto(_termoPesquisa);
    final termos = pesquisa.isEmpty ? <String>[] : pesquisa.split(' ');

    // Cópia — permite ordenar sem modificar o catálogo compartilhado.
    final produtos = widget.catalogo
        .produtosDaCategoria(widget.categoria)
        .where((produto) {
      final textoProduto = _normalizarTexto(
        '${produto.nome} ${produto.categoria}',
      );

      return termos.every(textoProduto.contains);
    }).toList();

    switch (_ordenacao) {
      case _OrdenacaoProdutos.padrao:
        break;

      case _OrdenacaoProdutos.menorPreco:
        produtos.sort(
          (primeiro, segundo) =>
              primeiro.precoCentavos.compareTo(segundo.precoCentavos),
        );
        break;

      case _OrdenacaoProdutos.maiorPreco:
        produtos.sort(
          (primeiro, segundo) =>
              segundo.precoCentavos.compareTo(primeiro.precoCentavos),
        );
        break;

      case _OrdenacaoProdutos.nome:
        produtos.sort(
          (primeiro, segundo) => _normalizarTexto(primeiro.nome).compareTo(
            _normalizarTexto(segundo.nome),
          ),
        );
        break;
    }

    return produtos;
  }

  // Limpeza — restaura todos os produtos da categoria atual.
  void _limparBusca() {
    _controladorBusca.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _termoPesquisa = '';
    });
  }

  @override
  void dispose() {
    // Recursos — libera o controlador ao fechar a tela.
    _controladorBusca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Estrutura — apresenta título e botão de voltar.
    return Scaffold(
      backgroundColor: CoresAplicativo.fundo,
      appBar: AppBar(
        title: Text(
          widget.categoria == 'Todos'
              ? 'Todos os produtos'
              : widget.categoria,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      // Atualização — acompanha as alterações dos favoritos.
      body: ListenableBuilder(
        listenable: widget.catalogo,
        builder: (context, child) {
          final produtos = _produtosFiltrados;
          final categoriaVazia = widget.catalogo
              .produtosDaCategoria(widget.categoria)
              .isEmpty;

          return SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                // Pesquisa — filtra os produtos enquanto o usuário digita.
                TextField(
                  controller: _controladorBusca,
                  textInputAction: TextInputAction.search,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Buscar nesta listagem',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _termoPesquisa.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar busca',
                            onPressed: _limparBusca,
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                  onChanged: (valor) {
                    setState(() {
                      _termoPesquisa = valor;
                    });
                  },
                  onSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),

                const SizedBox(height: 16),

                // Controles — apresenta a contagem e as opções de ordenação.
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Text(
                      produtos.length == 1
                          ? '1 produto'
                          : '${produtos.length} produtos',
                      style: const TextStyle(
                        color: CoresAplicativo.textoSecundario,
                        fontSize: 13,
                      ),
                    ),
                    PopupMenuButton<_OrdenacaoProdutos>(
                      tooltip: 'Ordenar produtos',
                      initialValue: _ordenacao,
                      color: CoresAplicativo.superficie,
                      onSelected: (ordenacao) {
                        setState(() {
                          _ordenacao = ordenacao;
                        });
                      },
                      itemBuilder: (context) {
                        return _OrdenacaoProdutos.values.map((opcao) {
                          return CheckedPopupMenuItem<_OrdenacaoProdutos>(
                            value: opcao,
                            checked: opcao == _ordenacao,
                            child: Text(opcao.rotulo),
                          );
                        }).toList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sort_rounded,
                              color: CoresAplicativo.primaria,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _ordenacao.rotulo,
                              style: const TextStyle(
                                color: CoresAplicativo.textoPrincipal,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: CoresAplicativo.textoSecundario,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Conteúdo — alterna entre os produtos e o estado vazio.
                if (produtos.isEmpty)
                  _construirEstadoVazio(categoriaVazia)
                else
                  _construirGrade(produtos),
              ],
            ),
          );
        },
      ),
    );
  }

  // Grade — reutiliza os cartões da home com dimensões padronizadas.
  Widget _construirGrade(List<Produto> produtos) {
    return LayoutBuilder(
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
          children: produtos.map((produto) {
            return SizedBox(
              key: ValueKey<String>(produto.id),
              width: larguraCartao,
              child: CartaoProduto(
                nome: produto.nome,
                precoCentavos: produto.precoCentavos,
                imagemAsset: produto.imagemAsset,
                favorito: widget.catalogo.estaFavoritado(produto.id),
                aoAbrir: () {
                  FocusScope.of(context).unfocus();
                  widget.aoAbrirProduto(produto);
                },
                aoAlternarFavorito: () {
                  widget.catalogo.alternarFavorito(produto.id);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Estado vazio — diferencia categoria sem produtos de busca sem resultado.
  Widget _construirEstadoVazio(bool categoriaVazia) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            categoriaVazia
                ? Icons.checkroom_outlined
                : Icons.search_off_rounded,
            size: 48,
            color: CoresAplicativo.textoSecundario,
          ),
          const SizedBox(height: 16),
          Text(
            categoriaVazia
                ? 'Ainda não há produtos por aqui.'
                : 'Nenhum produto encontrado.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoresAplicativo.textoPrincipal,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            categoriaVazia
                ? 'Enquanto isso, explore as outras categorias.'
                : 'Experimente outro termo ou limpe a busca.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CoresAplicativo.textoSecundario,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (_termoPesquisa.isNotEmpty) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _limparBusca,
              icon: const Icon(Icons.close_rounded),
              label: const Text('Limpar busca'),
            ),
          ],
        ],
      ),
    );
  }
}