import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';
import 'package:mingru/features/categorias/widgets/cartao_categoria.dart';
import 'package:mingru/shared/dados/catalogo_loja.dart';

// Categorias — apresenta os grupos de produtos disponíveis na loja.
class TelaCategorias extends StatelessWidget {
  const TelaCategorias({
    super.key,
    required this.catalogo,
    required this.aoAbrirCategoria,
  });

  // Dados — utiliza o mesmo catálogo compartilhado com a home.
  final CatalogoLoja catalogo;

  // Navegação — informa qual categoria deverá ser aberta.
  final ValueChanged<String> aoAbrirCategoria;

  // Categorias — mantém visíveis os grupos mesmo quando estiverem vazios.
  static const Map<String, IconData> _categorias = {
    'Camisetas': PhosphorIconsRegular.tShirt,
    'Blusas/casacos': Icons.checkroom_outlined,
    'Calças': PhosphorIconsRegular.pants,
    'Calçados': PhosphorIconsRegular.sneaker,
    'Meias': PhosphorIconsRegular.sock,
    'Acessórios': PhosphorIconsRegular.baseballCap,
  };

  // Capas — utiliza as imagens existentes adequadas a cada categoria.
  static const Map<String, String> _imagensCategorias = {
    'Camisetas': 'assets/images/1.png',
    'Blusas/casacos': 'assets/images/4.png',
  };

  @override
  Widget build(BuildContext context) {
    // Área segura — o cabeçalho será fornecido pela navegação principal.
    return SafeArea(
      top: false,
      child: ListView(
        key: const PageStorageKey<String>('rolagem_categorias'),

        // Espaçamento — reserva espaço para o menu inferior flutuante.
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          110,
        ),
        children: [
          // Apresentação — título da tela.
          Text(
            'Categorias',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: CoresAplicativo.textoPrincipal,
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 8),

          // Descrição — orienta a exploração do catálogo.
          const Text(
            'Encontre sua próxima peça.',
            style: TextStyle(
              color: CoresAplicativo.textoSecundario,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Grade — organiza os cartões conforme o espaço disponível.
          LayoutBuilder(
            builder: (context, restricoes) {
              // Acessibilidade — usa uma coluna em telas estreitas
              // ou quando o usuário ampliar bastante os textos.
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
                children: _categorias.entries.map((categoria) {
                  final nome = categoria.key;
                  final icone = categoria.value;

                  // Contagem — considera os produtos do catálogo.
                  final quantidade =
                      catalogo.produtosDaCategoria(nome).length;

                  return SizedBox(
                    key: ValueKey<String>(nome),
                    width: larguraCartao,
                    child: CartaoCategoria(
                      nome: nome,
                      quantidadeProdutos: quantidade,
                      icone: icone,
                      imagemAsset: _imagensCategorias[nome],
                      aoAbrir: () {
                        aoAbrirCategoria(nome);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 24),

          // Catálogo completo — permite explorar todos os produtos.
          OutlinedButton.icon(
            onPressed: () {
              aoAbrirCategoria('Todos');
            },
            icon: const Icon(
              PhosphorIconsRegular.squaresFour,
              size: 22,
            ),
            label: const Text(
              'Ver todos os produtos',
              textAlign: TextAlign.center,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: CoresAplicativo.primaria,
              minimumSize: const Size.fromHeight(52),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              side: const BorderSide(
                color: CoresAplicativo.borda,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}