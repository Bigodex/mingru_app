import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Categorias — filtros representados por ícones.
class CategoriasInicio extends StatelessWidget {
  const CategoriasInicio({
    super.key,
    required this.categoriaSelecionada,
    required this.aoSelecionar,
  });

  // Seleção — categoria ativa e ação de mudança.
  final String categoriaSelecionada;
  final ValueChanged<String> aoSelecionar;

  // Ícones — mantém os nomes utilizados pelo filtro da home.
  static const Map<String, IconData> _categorias = {
    'Todos': PhosphorIconsRegular.squaresFour,
    'Camisetas': PhosphorIconsRegular.tShirt,
    'Calças': PhosphorIconsRegular.pants,
    'Calçados': PhosphorIconsRegular.sneaker,
    'Meias': PhosphorIconsRegular.sock,
    'Acessórios': PhosphorIconsRegular.baseballCap,
  };

  @override
  Widget build(BuildContext context) {
    // Rolagem — acomoda as categorias em telas menores.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categorias.entries.map((categoria) {
          final nome = categoria.key;
          final icone = categoria.value;
          final selecionada = nome == categoriaSelecionada;

          // Botão — destaca a categoria selecionada em amarelo.
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: nome,
              isSelected: selecionada,
              icon: Icon(
                icone,
                size: 30,
              ),
              style: IconButton.styleFrom(
                minimumSize: const Size(56, 56),
                padding: const EdgeInsets.all(12),
                foregroundColor: selecionada
                    ? CoresAplicativo.sobrePrimaria
                    : CoresAplicativo.textoPrincipal,
                backgroundColor: selecionada
                    ? CoresAplicativo.primaria
                    : CoresAplicativo.superficie,
                side: BorderSide(
                  color: selecionada
                      ? CoresAplicativo.primaria
                      : CoresAplicativo.borda,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              // Filtro — informa a categoria escolhida para a home.
              onPressed: () {
                if (selecionada) return;

                aoSelecionar(nome);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}