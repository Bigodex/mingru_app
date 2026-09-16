import 'package:flutter/material.dart';

// Cores do aplicativo — identidade visual da Mingru.
abstract final class CoresAplicativo {
  // Superfícies — fundos das telas, cartões e campos.
  static const Color fundo = Color(0xFF1A1A1A);
  static const Color superficie = Color(0xFF333333);
  static const Color superficieElevada = Color(0xFF404040);

  // Destaques — amarelo da marca com textos e ícones escuros.
  static const Color primaria = Color(0xFFFFBD09);
  static const Color sobrePrimaria = Color(0xFF1A1A1A);

  // Superfície clara — botões e detalhes em creme da referência.
  static const Color superficieClara = Color(0xFFFFF2CE);
  static const Color sobreSuperficieClara = Color(0xFF1A1A1A);

  // Textos — níveis de importância sobre fundos escuros.
  static const Color textoPrincipal = Color(0xFFF5F5F5);
  static const Color textoSecundario = Color(0xFFB3B3B3);
  static const Color textoDesabilitado = Color(0xFF808080);

  // Contornos — separadores e bordas dos componentes.
  static const Color borda = Color(0xFF4A4A4A);

  // Feedback — mensagens e estados das operações.
  static const Color sucesso = Color(0xFF69DB9C);
  static const Color aviso = Color(0xFFFFD166);
  static const Color erro = Color(0xFFFF8080);
  static const Color informacao = Color(0xFF82B1FF);
}