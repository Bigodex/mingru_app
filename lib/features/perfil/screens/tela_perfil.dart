import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Perfil — apresenta a área da conta para quem ainda não entrou.
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({
    super.key,
    required this.aoEntrar,
    required this.aoExplorar,
    required this.aoAbrirFavoritos,
    required this.aoAbrirAjuda,
    required this.aoAbrirSobre,
    this.quantidadeFavoritos = 0,
  }) : assert(quantidadeFavoritos >= 0);

  // Conta — encaminha para a entrada ou criação de uma conta.
  final VoidCallback aoEntrar;

  // Navegação — acessos disponíveis para visitantes.
  final VoidCallback aoExplorar;
  final VoidCallback aoAbrirFavoritos;
  final VoidCallback aoAbrirAjuda;
  final VoidCallback aoAbrirSobre;

  // Favoritos — apresenta a quantidade de peças selecionadas.
  final int quantidadeFavoritos;

  @override
  Widget build(BuildContext context) {
    // Estrutura — utiliza o cabeçalho e o menu da navegação principal.
    return SafeArea(
      top: false,
      child: ListView(
        key: const PageStorageKey<String>('rolagem_perfil'),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: [
          // Título — identifica a área de perfil.
          Text(
            'Seu perfil',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: CoresAplicativo.textoPrincipal,
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Seu espaço na Mingru.',
            style: TextStyle(
              color: CoresAplicativo.textoSecundario,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Apresentação — convida o visitante a acessar sua conta.
          _construirApresentacao(context),

          const SizedBox(height: 28),

          // Favoritos — permanece acessível sem exigir uma conta.
          _construirTituloSecao('Sua seleção'),

          const SizedBox(height: 12),

          _construirGrupo(
            children: [
              _construirOpcao(
                icone: Icons.favorite_border_rounded,
                titulo: 'Favoritos',
                descricao: quantidadeFavoritos == 1
                    ? '1 peça salva'
                    : '$quantidadeFavoritos peças salvas',
                aoSelecionar: aoAbrirFavoritos,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Conta — opções que precisam de identificação do cliente.
          _construirTituloSecao('Minha conta'),

          const SizedBox(height: 12),

          _construirGrupo(
            children: [
              _construirOpcao(
                icone: Icons.shopping_bag_outlined,
                titulo: 'Meus pedidos',
                descricao: 'Entre para acompanhar suas compras.',
                protegida: true,
                aoSelecionar: aoEntrar,
              ),
              _construirDivisor(),
              _construirOpcao(
                icone: Icons.person_outline_rounded,
                titulo: 'Dados pessoais',
                descricao: 'Entre para acessar suas informações.',
                protegida: true,
                aoSelecionar: aoEntrar,
              ),
              _construirDivisor(),
              _construirOpcao(
                icone: Icons.location_on_outlined,
                titulo: 'Endereços',
                descricao: 'Entre para gerenciar suas entregas.',
                protegida: true,
                aoSelecionar: aoEntrar,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Suporte — informações acessíveis também para visitantes.
          _construirTituloSecao('Precisa de uma mão?'),

          const SizedBox(height: 12),

          _construirGrupo(
            children: [
              _construirOpcao(
                icone: Icons.help_outline_rounded,
                titulo: 'Ajuda',
                descricao: 'Tire suas dúvidas sobre a loja.',
                aoSelecionar: aoAbrirAjuda,
              ),
              _construirDivisor(),
              _construirOpcao(
                icone: Icons.info_outline_rounded,
                titulo: 'Sobre a Mingru',
                descricao: 'Conheça nossa marca.',
                aoSelecionar: aoAbrirSobre,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Apresentação — destaca o acesso à conta sem bloquear a exploração.
  Widget _construirApresentacao(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CoresAplicativo.superficie,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CoresAplicativo.borda,
        ),
      ),
      child: Column(
        children: [
          // Avatar — representação genérica do visitante.
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: CoresAplicativo.primaria.withAlpha(24),
              shape: BoxShape.circle,
              border: Border.all(
                color: CoresAplicativo.primaria.withAlpha(70),
              ),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: CoresAplicativo.primaria,
              size: 42,
            ),
          ),

          const SizedBox(height: 20),

          // Boas-vindas — apresenta o convite principal.
          Text(
            'Chega mais.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: CoresAplicativo.textoPrincipal,
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Explore a loja e salve suas peças favoritas. '
            'Para finalizar uma compra, entre ou crie sua conta.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CoresAplicativo.textoSecundario,
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          // Acesso — encaminha para o fluxo de autenticação.
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: aoEntrar,
              child: const Text(
                'Entrar ou criar conta',
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Exploração — permite continuar na loja sem autenticação.
          TextButton(
            onPressed: aoExplorar,
            child: const Text(
              'Continuar explorando',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Seção — padroniza os títulos dos grupos.
  Widget _construirTituloSecao(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        color: CoresAplicativo.textoPrincipal,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Grupo — reúne as opções em uma superfície arredondada.
  Widget _construirGrupo({
    required List<Widget> children,
  }) {
    return Material(
      color: CoresAplicativo.superficie,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: CoresAplicativo.borda,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Opção — apresenta ícone, descrição e indicação de acesso.
  Widget _construirOpcao({
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback aoSelecionar,
    bool protegida = false,
  }) {
    return InkWell(
      onTap: aoSelecionar,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Identificação — ícone de contorno da funcionalidade.
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CoresAplicativo.fundo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icone,
                color: CoresAplicativo.primaria,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            // Texto — permite quebra de linha em telas menores.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: CoresAplicativo.textoPrincipal,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descricao,
                    style: const TextStyle(
                      color: CoresAplicativo.textoSecundario,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Acesso — diferencia as opções que exigem uma conta.
            Icon(
              protegida
                  ? Icons.lock_outline_rounded
                  : Icons.chevron_right_rounded,
              color: CoresAplicativo.textoSecundario,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Divisor — separa as opções dentro do mesmo grupo.
  Widget _construirDivisor() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: CoresAplicativo.borda,
    );
  }
}