import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Produto — cartão reutilizável da vitrine.
class CartaoProduto extends StatelessWidget {
  const CartaoProduto({
    super.key,
    required this.nome,
    required this.precoCentavos,
    required this.aoAbrir,
    required this.aoAlternarFavorito,
    this.imagemUrl,
    this.imagemAsset,
    this.favorito = false,
  }) : assert(precoCentavos >= 0);

  // Dados — informações apresentadas no cartão.
  final String nome;
  final int precoCentavos;
  final bool favorito;

  // Imagens — aceita foto da internet ou arquivo local.
  final String? imagemUrl;
  final String? imagemAsset;

  // Ações — abertura do produto e alteração do favorito.
  final VoidCallback aoAbrir;
  final VoidCallback aoAlternarFavorito;

  // Tipografia — medidas padronizadas do nome.
  static const double _tamanhoFonteNome = 14;
  static const double _alturaLinhaNome = 1.4;
  static const int _quantidadeLinhasNome = 2;

  // Moeda — apresenta o preço no padrão brasileiro.
  static final NumberFormat _formatadorMoeda = NumberFormat.currency(
    locale: 'pt_BR',
    name: 'BRL',
    symbol: r'R$',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    // Altura do nome — reserva duas linhas e respeita a escala do texto.
    final alturaNome = MediaQuery.textScalerOf(context)
            .scale(_tamanhoFonteNome) *
        _alturaLinhaNome *
        _quantidadeLinhasNome;

    // Estrutura — superfície arredondada e área clicável.
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: CoresAplicativo.superficie,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: CoresAplicativo.borda,
        ),
      ),
      child: InkWell(
        onTap: aoAbrir,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto — mantém a mesma proporção em todos os cartões.
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 5,
                  child: _construirImagem(),
                ),

                // Favorito — alterna a seleção do produto.
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    tooltip: favorito
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                    isSelected: favorito,
                    onPressed: aoAlternarFavorito,
                    icon: const Icon(Icons.favorite_border),
                    selectedIcon: const Icon(Icons.favorite),
                    style: IconButton.styleFrom(
                      backgroundColor: CoresAplicativo.fundo,
                      foregroundColor: favorito
                          ? CoresAplicativo.primaria
                          : CoresAplicativo.textoPrincipal,
                      minimumSize: const Size(48, 48),
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),

            // Informações — espaços iguais para nome e preço.
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome — mantém a altura mesmo com apenas uma linha.
                  SizedBox(
                    width: double.infinity,
                    height: alturaNome,
                    child: Text(
                      nome,
                      maxLines: _quantidadeLinhasNome,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: CoresAplicativo.textoPrincipal,
                            fontSize: _tamanhoFonteNome,
                            fontWeight: FontWeight.w500,
                            height: _alturaLinhaNome,
                          ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Preço — permanece alinhado e ocupa uma única linha.
                  Text(
                    _formatadorMoeda.format(precoCentavos / 100),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: CoresAplicativo.primaria,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Imagem — prioriza o arquivo local quando informado.
  Widget _construirImagem() {
    final caminhoLocal = imagemAsset?.trim();
    final enderecoImagem = imagemUrl?.trim();

    if (caminhoLocal != null && caminhoLocal.isNotEmpty) {
      return Image.asset(
        caminhoLocal,
        fit: BoxFit.cover,
        semanticLabel: 'Foto de $nome',
        errorBuilder: (context, erro, pilha) {
          return _construirImagemIndisponivel();
        },
      );
    }

    // Foto online — carrega a imagem pelo endereço do produto.
    if (enderecoImagem != null && enderecoImagem.isNotEmpty) {
      return Image.network(
        enderecoImagem,
        fit: BoxFit.cover,
        semanticLabel: 'Foto de $nome',
        loadingBuilder: (context, imagem, progresso) {
          if (progresso == null) return imagem;

          return _construirCarregamento();
        },
        errorBuilder: (context, erro, pilha) {
          return _construirImagemIndisponivel();
        },
      );
    }

    return _construirImagemIndisponivel();
  }

  // Carregamento — indica que a foto está sendo baixada.
  Widget _construirCarregamento() {
    return const ColoredBox(
      color: CoresAplicativo.superficieElevada,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: CoresAplicativo.primaria,
            strokeWidth: 2,
            semanticsLabel: 'Carregando foto',
          ),
        ),
      ),
    );
  }

  // Falha — preserva o espaço da imagem.
  Widget _construirImagemIndisponivel() {
    return Semantics(
      label: 'Foto indisponível',
      child: const ColoredBox(
        color: CoresAplicativo.superficieElevada,
        child: Center(
          child: Icon(
            Icons.image_outlined,
            color: CoresAplicativo.textoSecundario,
            size: 40,
          ),
        ),
      ),
    );
  }
} 