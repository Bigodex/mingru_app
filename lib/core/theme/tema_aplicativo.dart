import 'package:flutter/material.dart';

import 'cores_aplicativo.dart';

// Tema — identidade visual da Mingru.
abstract final class TemaAplicativo {
  // Fonte — família registrada no pubspec.yaml.
  static const String _familiaFonte = 'Poppins';

  // Paleta — cores dos componentes Material.
  static final ColorScheme _esquemaCores = ColorScheme.fromSeed(
    seedColor: CoresAplicativo.primaria,
    brightness: Brightness.dark,
  ).copyWith(
    primary: CoresAplicativo.primaria,
    onPrimary: CoresAplicativo.sobrePrimaria,
    secondary: CoresAplicativo.primaria,
    onSecondary: CoresAplicativo.sobrePrimaria,
    surface: CoresAplicativo.superficie,
    onSurface: CoresAplicativo.textoPrincipal,
    onSurfaceVariant: CoresAplicativo.textoSecundario,
    outline: CoresAplicativo.borda,
    error: CoresAplicativo.erro,
    onError: CoresAplicativo.fundo,
  );

  // Tema escuro — configuração global.
  static final ThemeData escuro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _esquemaCores,
    fontFamily: _familiaFonte,
    scaffoldBackgroundColor: CoresAplicativo.fundo,
    disabledColor: CoresAplicativo.textoDesabilitado,

    // Textos — aplica Poppins aos estilos do tema.
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: _familiaFonte,
      bodyColor: CoresAplicativo.textoPrincipal,
      displayColor: CoresAplicativo.textoPrincipal,
    ),

    // Ícones — tamanho e cor padrão.
    iconTheme: const IconThemeData(
      color: CoresAplicativo.textoPrincipal,
      size: 24,
    ),

    // Cabeçalho — título e fundo da barra superior.
    appBarTheme: const AppBarThemeData(
      backgroundColor: CoresAplicativo.fundo,
      foregroundColor: CoresAplicativo.textoPrincipal,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: _familiaFonte,
        color: CoresAplicativo.textoPrincipal,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    // Botão principal — ações em destaque.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: CoresAplicativo.primaria,
        foregroundColor: CoresAplicativo.sobrePrimaria,
        disabledBackgroundColor: CoresAplicativo.superficieElevada,
        disabledForegroundColor: CoresAplicativo.textoDesabilitado,
        minimumSize: const Size(64, 52),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        textStyle: const TextStyle(
          fontFamily: _familiaFonte,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Botão de texto — ações complementares.
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: CoresAplicativo.primaria,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(
          fontFamily: _familiaFonte,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Campos — preenchimento, rótulos e validação.
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: CoresAplicativo.superficie,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      labelStyle: const TextStyle(
        fontFamily: _familiaFonte,
        color: CoresAplicativo.textoSecundario,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: const TextStyle(
        fontFamily: _familiaFonte,
        color: CoresAplicativo.textoSecundario,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: const TextStyle(
        fontFamily: _familiaFonte,
        color: CoresAplicativo.primaria,
        fontWeight: FontWeight.w500,
      ),
      errorStyle: const TextStyle(
        fontFamily: _familiaFonte,
        color: CoresAplicativo.erro,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: CoresAplicativo.textoSecundario,
      suffixIconColor: CoresAplicativo.textoSecundario,
      errorMaxLines: 3,
      border: _borda(CoresAplicativo.borda),
      enabledBorder: _borda(CoresAplicativo.borda),
      focusedBorder: _borda(
        CoresAplicativo.primaria,
        espessura: 2,
      ),
      errorBorder: _borda(CoresAplicativo.erro),
      focusedErrorBorder: _borda(
        CoresAplicativo.erro,
        espessura: 2,
      ),
      disabledBorder: _borda(CoresAplicativo.superficieElevada),
    ),

    // Divisores — separação entre conteúdos.
    dividerTheme: const DividerThemeData(
      color: CoresAplicativo.borda,
      thickness: 1,
      space: 24,
    ),

    // Carregamento — cor dos indicadores.
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: CoresAplicativo.primaria,
    ),

    // Seleção — cursor e marcação de texto.
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: CoresAplicativo.primaria,
      selectionColor: CoresAplicativo.primaria.withValues(alpha: 0.25),
      selectionHandleColor: CoresAplicativo.primaria,
    ),
  );

  // Bordas — formato compartilhado pelos campos.
  static OutlineInputBorder _borda(
    Color cor, {
    double espessura = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: cor,
        width: espessura,
      ),
    );
  }
}