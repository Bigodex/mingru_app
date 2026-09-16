import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';
import 'package:mingru/features/autenticacao/screens/tela_cadastro.dart';
import 'package:mingru/features/autenticacao/screens/tela_login.dart';
import 'package:mingru/features/categorias/screens/tela_categorias.dart';
import 'package:mingru/features/categorias/screens/tela_produtos_categoria.dart';
import 'package:mingru/features/home/widgets/categorias_inicio.dart';
import 'package:mingru/features/perfil/screens/tela_perfil.dart';
import 'package:mingru/shared/dados/catalogo_loja.dart';
import 'package:mingru/shared/modelos/produto.dart';
import 'package:mingru/shared/widgets/cabecalho.dart';
import 'package:mingru/shared/widgets/campo_busca.dart';
import 'package:mingru/shared/widgets/cartao_produto.dart';
import 'package:mingru/shared/widgets/menu_navegacao_inferior.dart';

// Tela inicial — organiza a home, as categorias e o perfil.
class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  // Catálogo — compartilha produtos e favoritos entre as telas.
  final CatalogoLoja _catalogo = CatalogoLoja();

  // Busca — mantém o texto e os filtros utilizados na home.
  final TextEditingController _controladorBusca = TextEditingController();

  String _termoPesquisa = '';
  String _categoriaSelecionada = 'Todos';

  // Navegação — controla a aba selecionada e a visibilidade do menu.
  int _indiceMenuAtual = 0;
  bool _menuVisivel = true;

  // Moeda — formata os valores apresentados nos detalhes.
  static final NumberFormat _formatadorMoeda = NumberFormat.currency(
    locale: 'pt_BR',
    name: 'BRL',
    symbol: r'R$',
    decimalDigits: 2,
  );

  // Normalização — permite pesquisar com ou sem acentos.
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

  // Filtros — combina a categoria e a pesquisa da home.
  List<Produto> get _produtosFiltrados {
    final pesquisa = _normalizarTexto(_termoPesquisa);
    final termos = pesquisa.isEmpty ? <String>[] : pesquisa.split(' ');

    return _catalogo.produtos.where((produto) {
      final correspondeCategoria = _categoriaSelecionada == 'Todos' ||
          produto.categoria == _categoriaSelecionada;

      final textoProduto = _normalizarTexto(
        '${produto.nome} ${produto.categoria}',
      );

      final correspondePesquisa = termos.every(textoProduto.contains);

      return correspondeCategoria && correspondePesquisa;
    }).toList();
  }

  // Favoritos — consulta as peças selecionadas no catálogo compartilhado.
  List<Produto> get _produtosFavoritos {
    return _catalogo.produtos.where((produto) {
      return _catalogo.estaFavoritado(produto.id);
    }).toList();
  }

  // Abas — associa o índice do menu às três telas disponíveis.
  int get _indiceTelaAtual {
    switch (_indiceMenuAtual) {
      case 1:
        return 1;
      case 3:
        return 2;
      default:
        return 0;
    }
  }

  // Rolagem — esconde o menu ao descer e mostra novamente ao subir.
  bool _controlarVisibilidadeMenu(
    UserScrollNotification notificacao,
  ) {
    // Direção — ignora a rolagem horizontal dos filtros.
    if (notificacao.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notificacao.direction == ScrollDirection.reverse && _menuVisivel) {
      setState(() {
        _menuVisivel = false;
      });
    }

    if (notificacao.direction == ScrollDirection.forward && !_menuVisivel) {
      setState(() {
        _menuVisivel = true;
      });
    }

    return false;
  }

  // Pesquisa — aplica o termo confirmado no campo da home.
  void _pesquisar(String termo) {
    setState(() {
      _termoPesquisa = termo;
    });
  }

  // Categoria — mantém o funcionamento dos filtros rápidos.
  void _selecionarCategoria(String categoria) {
    setState(() {
      _categoriaSelecionada = categoria;
    });
  }

  // Limpeza — restaura a vitrine completa da home.
  void _limparFiltros() {
    _controladorBusca.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _termoPesquisa = '';
      _categoriaSelecionada = 'Todos';
    });
  }

  // Menu — alterna entre as telas já disponíveis.
  void _selecionarItemMenu(int indice) {
    FocusScope.of(context).unfocus();

    switch (indice) {
      case 0:
      case 1:
      case 3:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        setState(() {
          _indiceMenuAtual = indice;
          _menuVisivel = true;
        });
        break;

      case 2:
        _mostrarAviso('O carrinho ainda não está disponível.');
        break;
    }
  }

  // Aviso — apresenta uma mensagem breve sem acumular notificações.
  void _mostrarAviso(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Login — abre a tela de acesso a partir do perfil.
  void _abrirAcessoConta() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (contextoLogin) {
          return TelaLogin(
            // Autenticação — será conectada ao serviço de contas.
            aoEntrar: (email, senha) async {
              _mostrarAviso('O login ainda não está disponível.');
            },

            // Cadastro — mantém o login abaixo da nova tela.
            aoCriarConta: _abrirCadastro,

            // Recuperação — ainda não realiza envio de e-mail.
            aoRecuperarSenha: (email) {
              _mostrarAviso(
                'A recuperação de senha ainda não está disponível.',
              );
            },
          );
        },
      ),
    );
  }

  // Cadastro — abre o formulário de criação de conta.
  void _abrirCadastro() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (contextoCadastro) {
          return TelaCadastro(
            // Conta — será conectada ao serviço de cadastro.
            aoCadastrar: (nome, email, senha) async {
              _mostrarAviso('O cadastro ainda não está disponível.');
            },
          );
        },
      ),
    );
  }

  // Categoria — abre a listagem com o catálogo compartilhado.
  void _abrirCategoria(String categoria) {
    FocusScope.of(context).unfocus();

    setState(() {
      _menuVisivel = true;
    });

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) {
          return TelaProdutosCategoria(
            categoria: categoria,
            catalogo: _catalogo,
            aoAbrirProduto: _abrirProduto,
          );
        },
      ),
    );
  }

  // Detalhes — apresenta imagem, informações e ação de compra.
  void _abrirProduto(Produto produto) {
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
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem — apresenta a foto acima das informações.
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: _construirImagemDetalhes(produto),
                  ),
                ),

                const SizedBox(height: 24),

                // Categoria — identifica o grupo do produto.
                Text(
                  produto.categoria,
                  style: const TextStyle(
                    color: CoresAplicativo.textoSecundario,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                // Nome — apresenta o título do produto.
                Text(
                  produto.nome,
                  style: Theme.of(contextoModal)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        color: CoresAplicativo.textoPrincipal,
                        fontWeight: FontWeight.w700,
                      ),
                ),

                const SizedBox(height: 16),

                // Preço — apresenta o valor em reais.
                Text(
                  _formatadorMoeda.format(
                    produto.precoCentavos / 100,
                  ),
                  style: const TextStyle(
                    color: CoresAplicativo.primaria,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 24),

                // Carrinho — substitui o antigo aviso de demonstração.
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      // Temporário — informa que a integração está pendente.
                      showDialog<void>(
                        context: contextoModal,
                        builder: (contextoAviso) {
                          return AlertDialog(
                            backgroundColor: CoresAplicativo.superficie,
                            title: const Text('Carrinho'),
                            content: const Text(
                              'O carrinho ainda não está disponível.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(contextoAviso).pop();
                                },
                                child: const Text('Entendi'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.add_shopping_cart_outlined,
                      size: 22,
                    ),
                    label: const Text(
                      'Inserir no carrinho',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Retorno — fecha o modal e mantém a navegação atual.
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(contextoModal).pop();
                    },
                    child: const Text('Continuar explorando'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Foto — carrega a mesma imagem utilizada no cartão do produto.
  Widget _construirImagemDetalhes(Produto produto) {
    final caminho = produto.imagemAsset?.trim();

    if (caminho == null || caminho.isEmpty) {
      return _construirImagemIndisponivel();
    }

    return Image.asset(
      caminho,
      fit: BoxFit.cover,
      semanticLabel: 'Foto de ${produto.nome}',
      errorBuilder: (context, erro, pilha) {
        return _construirImagemIndisponivel();
      },
    );
  }

  // Alternativa — preserva a área da foto quando não houver imagem.
  Widget _construirImagemIndisponivel() {
    return const ColoredBox(
      color: CoresAplicativo.superficieElevada,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_outlined,
                color: CoresAplicativo.textoSecundario,
                size: 48,
              ),
              SizedBox(height: 12),
              Text(
                'Imagem indisponível',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CoresAplicativo.textoSecundario,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Favoritos — abre um painel acessível também para visitantes.
  void _abrirFavoritos() {
    FocusScope.of(context).unfocus();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CoresAplicativo.fundo,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (contextoModal) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: SafeArea(
            top: false,

            // Atualização — acompanha inclusões e remoções dos favoritos.
            child: ListenableBuilder(
              listenable: _catalogo,
              builder: (context, child) {
                final favoritos = _produtosFavoritos;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho — mantém o botão de fechar acessível.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Seus favoritos',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Fechar favoritos',
                            onPressed: () {
                              Navigator.of(contextoModal).pop();
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),

                    // Conteúdo — permite rolar a seleção de produtos.
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        children: [
                          if (favoritos.isEmpty)
                            _construirFavoritosVazios(contextoModal)
                          else ...[
                            Text(
                              favoritos.length == 1
                                  ? '1 peça salva'
                                  : '${favoritos.length} peças salvas',
                              style: const TextStyle(
                                color: CoresAplicativo.textoSecundario,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _construirGradeProdutos(favoritos),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Favoritos vazios — orienta como salvar produtos e voltar à loja.
  Widget _construirFavoritosVazios(BuildContext contextoModal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            color: CoresAplicativo.primaria,
            size: 48,
          ),

          const SizedBox(height: 20),

          const Text(
            'Sua seleção começa aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CoresAplicativo.textoPrincipal,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Toque no coração dos produtos para guardar '
            'as peças que combinam com você.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CoresAplicativo.textoSecundario,
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: () {
              Navigator.of(contextoModal).pop();
              _selecionarItemMenu(0);
            },
            child: const Text('Explorar a loja'),
          ),
        ],
      ),
    );
  }

  // Informações — painel compartilhado pela ajuda e apresentação da marca.
  void _abrirInformacao({
    required String titulo,
    required String mensagem,
    required IconData icone,
  }) {
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
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icone,
                  color: CoresAplicativo.primaria,
                  size: 36,
                ),
                const SizedBox(height: 16),
                Text(
                  titulo,
                  style: Theme.of(contextoModal)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  mensagem,
                  style: const TextStyle(
                    color: CoresAplicativo.textoSecundario,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(contextoModal).pop();
                    },
                    child: const Text('Fechar'),
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
    // Recursos — libera o controlador e o catálogo desta sessão.
    _controladorBusca.dispose();
    _catalogo.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresAplicativo.fundo,
      appBar: const Cabecalho(),

      // Estrutura — mantém o menu sobre a aba selecionada.
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rolagem — acompanha o movimento na aba aberta.
          NotificationListener<UserScrollNotification>(
            onNotification: _controlarVisibilidadeMenu,

            // Catálogo — atualiza cartões e contagem de favoritos.
            child: ListenableBuilder(
              listenable: _catalogo,
              builder: (context, child) {
                return IndexedStack(
                  index: _indiceTelaAtual,
                  children: [
                    // Início — preserva a busca e os filtros existentes.
                    _construirConteudoInicio(),

                    // Categorias — apresenta os grupos de produtos.
                    TelaCategorias(
                      catalogo: _catalogo,
                      aoAbrirCategoria: _abrirCategoria,
                    ),

                    // Perfil — apresenta o estado de visitante.
                    TelaPerfil(
                      quantidadeFavoritos: _produtosFavoritos.length,
                      aoEntrar: _abrirAcessoConta,
                      aoExplorar: () {
                        _selecionarItemMenu(0);
                      },
                      aoAbrirFavoritos: _abrirFavoritos,
                      aoAbrirAjuda: () {
                        _abrirInformacao(
                          titulo: 'Explore a Mingru',
                          icone: Icons.help_outline_rounded,
                          mensagem:
                              'Use a busca da tela inicial para encontrar '
                              'produtos pelo nome ou pela categoria.\n\n'
                              'Na aba Categorias, escolha o grupo que deseja '
                              'explorar. Você pode pesquisar e ordenar '
                              'os produtos dessa listagem.\n\n'
                              'Toque no coração de uma peça para adicioná-la '
                              'aos favoritos. Sua seleção fica acessível '
                              'aqui no Perfil.',
                        );
                      },
                      aoAbrirSobre: () {
                        _abrirInformacao(
                          titulo: 'Sobre a Mingru',
                          icone: Icons.info_outline_rounded,
                          mensagem:
                              'A Mingru é uma loja de streetwear.\n\n'
                              'Explore nossas categorias, descubra suas '
                              'peças favoritas e monte uma seleção '
                              'com a sua identidade.',
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          // Menu — compartilhado entre início, categorias e perfil.
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Center(
                child: IgnorePointer(
                  ignoring: !_menuVisivel,
                  child: AnimatedSlide(
                    offset: _menuVisivel
                        ? Offset.zero
                        : const Offset(0, 2.0),
                    duration: const Duration(milliseconds: 450),
                    curve: _menuVisivel
                        ? Curves.easeOutCubic
                        : Curves.easeInCubic,
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

  // Home — mantém a busca, os filtros e a vitrine.
  Widget _construirConteudoInicio() {
    final produtosVisiveis = _produtosFiltrados;

    final possuiFiltros =
        _termoPesquisa.isNotEmpty || _categoriaSelecionada != 'Todos';

    return SafeArea(
      top: false,
      child: ListView(
        key: const PageStorageKey<String>('rolagem_inicio'),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
        children: [
          // Busca — utiliza o componente original.
          CampoBusca(
            controlador: _controladorBusca,
            aoPesquisar: _pesquisar,
          ),

          const SizedBox(height: 16),

          // Filtros — preserva todas as opções atuais.
          CategoriasInicio(
            categoriaSelecionada: _categoriaSelecionada,
            aoSelecionar: _selecionarCategoria,
          ),

          const SizedBox(height: 24),

          // Título — apresenta a seleção atual.
          Text(
            _categoriaSelecionada == 'Todos'
                ? 'Explore a loja'
                : _categoriaSelecionada,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 6),

          // Descrição — apresenta a vitrine.
          const Text(
            'Confira nossa vitrine StreetWear!',
            style: TextStyle(
              color: CoresAplicativo.textoSecundario,
              fontSize: 14,
            ),
          ),

          // Pesquisa — informa qual termo está aplicado.
          if (_termoPesquisa.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Busca por “$_termoPesquisa”',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],

          const SizedBox(height: 12),

          // Resultado — contagem e limpeza dos filtros.
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
                  child: const Text('Limpar filtros'),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Conteúdo — produtos encontrados ou mensagem de lista vazia.
          if (produtosVisiveis.isEmpty)
            _construirEstadoVazioInicio()
          else
            _construirGradeProdutos(produtosVisiveis),
        ],
      ),
    );
  }

  // Grade — reutilizada pela home e pelo painel de favoritos.
  Widget _construirGradeProdutos(List<Produto> produtos) {
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
                favorito: _catalogo.estaFavoritado(produto.id),
                aoAbrir: () {
                  _abrirProduto(produto);
                },
                aoAlternarFavorito: () {
                  _catalogo.alternarFavorito(produto.id);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Estado vazio — mantém a mensagem utilizada na home.
  Widget _construirEstadoVazioInicio() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
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
    );
  }
}