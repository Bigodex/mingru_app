import 'package:flutter/material.dart';

import 'core/theme/tema_aplicativo.dart';
import 'features/splash/screens/tela_abertura.dart';

// Aplicativo — centraliza o tema e a tela inicial da Mingru.
class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuração principal — aplica a identidade visual da loja.
    return MaterialApp(
      title: 'Mingru',
      debugShowCheckedModeBanner: false,
      theme: TemaAplicativo.escuro,

      // Tela inicial — apresenta a marca ao abrir o aplicativo.
      home: const TelaAbertura(),
    );
  }
}