import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';
import 'package:mingru/features/home/screens/tela_inicio.dart';

// Tela de abertura — apresenta a marca antes de acessar a loja.
class TelaAbertura extends StatefulWidget {
  const TelaAbertura({super.key});

  @override
  State<TelaAbertura> createState() => _TelaAberturaState();
}

class _TelaAberturaState extends State<TelaAbertura> {
  // Temporizador — controla o tempo de apresentação da marca.
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();

    // Inicialização — agenda a entrada na loja após dois segundos.
    _temporizador = Timer(
      const Duration(seconds: 2),
      _abrirTelaInicio,
    );
  }

  // Navegação — substitui a abertura pela tela inicial.
  void _abrirTelaInicio() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (context) => const TelaInicio(),
      ),
    );
  }

  @override
  void dispose() {
    // Limpeza — cancela o temporizador quando a tela é removida.
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Estrutura — mantém o conteúdo dentro da área segura do dispositivo.
    return Scaffold(
      backgroundColor: CoresAplicativo.fundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Marca — ajusta o nome ao espaço disponível na tela.
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'MINGRU',
                    style: TextStyle(
                      color: CoresAplicativo.primaria,
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      height: 1.1,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Segmento — complementa a apresentação da marca.
                const Text(
                  'STREETWEAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CoresAplicativo.textoSecundario,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 48),

                // Indicador — acompanha o período de apresentação.
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: CoresAplicativo.primaria,
                    backgroundColor: CoresAplicativo.borda,
                    strokeWidth: 2.5,
                    semanticsLabel: 'Abrindo a Mingru',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}