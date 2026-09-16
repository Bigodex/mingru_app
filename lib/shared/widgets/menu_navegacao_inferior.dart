import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Menu inferior — navegação principal flutuante da aplicação.
class MenuNavegacaoInferior extends StatelessWidget {
  const MenuNavegacaoInferior({
    super.key,
    required this.indiceSelecionado,
    required this.aoSelecionar,
  });

  // Estado — informa qual item está atualmente selecionado.
  final int indiceSelecionado;

  // Navegação — devolve o índice selecionado para a tela.
  final ValueChanged<int> aoSelecionar;

  @override
  Widget build(BuildContext context) {
    // Estrutura — apenas o próprio menu flutuante.
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 276,
        height: 64,

        // Aparência — card compacto, arredondado e elevado.
        decoration: BoxDecoration(
          color: CoresAplicativo.superficie,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: CoresAplicativo.borda,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              spreadRadius: 1,
              offset: Offset(0, 8),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              // Início — tela principal.
              _ItemMenu(
                indice: 0,
                indiceSelecionado: indiceSelecionado,
                icone: Icons.home_rounded,
                iconeInativo: Icons.home_outlined,
                descricao: 'Início',
                aoSelecionar: aoSelecionar,
              ),

              // Categorias — catálogo da loja.
              _ItemMenu(
                indice: 1,
                indiceSelecionado: indiceSelecionado,
                icone: Icons.widgets_rounded,
                iconeInativo: Icons.widgets_outlined,
                descricao: 'Categorias',
                aoSelecionar: aoSelecionar,
              ),

              // Carrinho — itens selecionados.
              _ItemMenu(
                indice: 2,
                indiceSelecionado: indiceSelecionado,
                icone: Icons.shopping_cart_rounded,
                iconeInativo: Icons.shopping_cart_outlined,
                descricao: 'Carrinho',
                aoSelecionar: aoSelecionar,
              ),

              // Perfil — conta do usuário.
              _ItemMenu(
                indice: 3,
                indiceSelecionado: indiceSelecionado,
                icone: Icons.person_rounded,
                iconeInativo: Icons.person_outline_rounded,
                descricao: 'Perfil',
                aoSelecionar: aoSelecionar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Item — botão individual do menu inferior.
class _ItemMenu extends StatelessWidget {
  const _ItemMenu({
    required this.indice,
    required this.indiceSelecionado,
    required this.icone,
    required this.iconeInativo,
    required this.descricao,
    required this.aoSelecionar,
  });

  final int indice;
  final int indiceSelecionado;

  final IconData icone;
  final IconData iconeInativo;

  final String descricao;

  final ValueChanged<int> aoSelecionar;

  @override
  Widget build(BuildContext context) {
    // Seleção — identifica qual item está ativo.
    final selecionado = indice == indiceSelecionado;

    return Expanded(
      child: Tooltip(
        message: descricao,
        child: InkWell(
          onTap: () {
            aoSelecionar(indice);
          },
          child: Center(
            // Destaque — fundo discreto no ícone selecionado.
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: selecionado
                    ? CoresAplicativo.primaria.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                selecionado ? icone : iconeInativo,
                size: 29,
                color: selecionado
                    ? CoresAplicativo.primaria
                    : CoresAplicativo.textoSecundario,
              ),
            ),
          ),
        ),
      ),
    );
  }
}