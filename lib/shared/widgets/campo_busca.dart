import 'package:flutter/material.dart';

// Busca — campo reutilizável para pesquisar produtos.
class CampoBusca extends StatelessWidget {
  const CampoBusca({
    super.key,
    required this.aoPesquisar,
    this.controlador,
  });

  // Pesquisa — entrega o termo confirmado para a tela.
  final ValueChanged<String> aoPesquisar;

  // Controlador — permite consultar ou alterar o texto externamente.
  final TextEditingController? controlador;

  @override
  Widget build(BuildContext context) {
    // Campo — utiliza as cores e fontes do tema.
    return TextField(
      controller: controlador,
      textInputAction: TextInputAction.search,
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: const InputDecoration(
        hintText: 'O que você procura?',
        prefixIcon: Icon(
          Icons.search,
          semanticLabel: 'Buscar produtos',
        ),
      ),

      // Envio — remove espaços extras e ignora buscas vazias.
      onSubmitted: (valor) {
        final termo = valor.trim();

        if (termo.isEmpty) return;

        FocusScope.of(context).unfocus();
        aoPesquisar(termo);
      },

      // Teclado — fecha ao tocar fora do campo.
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}