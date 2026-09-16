import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Cabeçalho — componente compartilhado da Mingru.
class Cabecalho extends StatelessWidget implements PreferredSizeWidget {
  const Cabecalho({super.key});

  // Altura — espaço ocupado no Scaffold.
  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    // Estrutura — fundo amarelo e identificação da marca.
    return AppBar(
      backgroundColor: CoresAplicativo.sobrePrimaria,
      foregroundColor: CoresAplicativo.sobrePrimaria,
      automaticallyImplyLeading: false,
      centerTitle: false,
      toolbarHeight: preferredSize.height,
      titleSpacing: 20,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo — imagem sobre um círculo escuro.
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: CoresAplicativo.fundo,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo-oficial.png',
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ),
          ),

          // Nome — texto ao lado direito da logo.
          const Flexible(
            child: Text(
              'Mingru',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CoresAplicativo.textoPrincipal,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),

      // Menu — ícone à direita do cabeçalho.
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.menu,
            color: CoresAplicativo.textoPrincipal,
            size: 28,
            semanticLabel: 'Menu',
          ),
        ),
      ],
    );
  }
}