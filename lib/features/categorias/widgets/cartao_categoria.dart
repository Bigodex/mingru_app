import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Categoria — cartão visual utilizado na tela de categorias.
class CartaoCategoria extends StatelessWidget {
  const CartaoCategoria({
    super.key,
    required this.nome,
    required this.quantidadeProdutos,
    required this.icone,
    required this.aoAbrir,
    this.imagemAsset,
  }) : assert(quantidadeProdutos >= 0);

  // Informações — identificação e quantidade de produtos.
  final String nome;
  final int quantidadeProdutos;

  // Aparência — ícone e imagem opcional da categoria.
  final IconData icone;
  final String? imagemAsset;

  // Navegação — ação executada ao tocar no cartão.
  final VoidCallback aoAbrir;

  @override
  Widget build(BuildContext context) {
    // Medidas — reserva duas linhas para manter os cartões alinhados.
    final escalaTexto = MediaQuery.textScalerOf(context);
    final alturaNome = escalaTexto.scale(16) * 1.4 * 2;
    final alturaQuantidade = escalaTexto.scale(12) * 1.4;
    final alturaCartao = 150 + alturaNome + alturaQuantidade;

    // Contagem — ajusta o texto para singular ou plural.
    final descricaoQuantidade = quantidadeProdutos == 1
        ? '1 produto'
        : '$quantidadeProdutos produtos';

    // Acessibilidade — descreve o cartão como uma única ação.
    return Semantics(
      button: true,
      label: '$nome, $descricaoQuantidade',
      onTap: aoAbrir,
      excludeSemantics: true,
      child: SizedBox(
        height: alturaCartao,

        // Estrutura — superfície arredondada com contorno discreto.
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: CoresAplicativo.superficie,
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: CoresAplicativo.borda,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Fundo — apresenta a imagem ou o ícone da categoria.
              _construirFundo(),

              // Contraste — mantém os textos legíveis sobre a imagem.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xAA1A1A1A),
                      Color(0xFF1A1A1A),
                    ],
                    stops: [0.25, 0.60, 1],
                  ),
                ),
              ),

              // Direção — indica que o cartão abre uma listagem.
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: CoresAplicativo.fundo.withAlpha(210),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: CoresAplicativo.primaria,
                    size: 18,
                  ),
                ),
              ),

              // Informações — mantém nome e contagem alinhados na base.
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: alturaNome,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          nome,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CoresAplicativo.textoPrincipal,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      descricaoQuantidade,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CoresAplicativo.textoSecundario,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Interação — desenha o efeito de toque sobre o conteúdo.
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: aoAbrir,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Imagem — carrega o arquivo informado e trata falhas.
  Widget _construirFundo() {
    final caminho = imagemAsset?.trim();

    if (caminho == null || caminho.isEmpty) {
      return _construirFundoComIcone();
    }

    return Image.asset(
      caminho,
      fit: BoxFit.cover,
      excludeFromSemantics: true,
      errorBuilder: (context, erro, pilha) {
        return _construirFundoComIcone();
      },
    );
  }

  // Alternativa — identifica a categoria quando não houver imagem.
  Widget _construirFundoComIcone() {
    return ColoredBox(
      color: CoresAplicativo.superficie,
      child: Align(
        alignment: const Alignment(0, -0.4),
        child: Icon(
          icone,
          size: 64,
          color: CoresAplicativo.primaria,
        ),
      ),
    );
  }
}