import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Login — apresenta o formulário de acesso à conta.
class TelaLogin extends StatefulWidget {
  const TelaLogin({
    super.key,
    required this.aoEntrar,
    required this.aoCriarConta,
    required this.aoRecuperarSenha,
  });

  // Autenticação — recebe a operação que realizará o login.
  final Future<void> Function(String email, String senha) aoEntrar;

  // Navegação — encaminha para cadastro e recuperação de senha.
  final VoidCallback aoCriarConta;
  final ValueChanged<String> aoRecuperarSenha;

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  // Formulário — controla a validação dos campos.
  final GlobalKey<FormState> _chaveFormulario = GlobalKey<FormState>();

  // Campos — armazenam os valores digitados.
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();

  // Estado — controla a visibilidade da senha e o envio.
  bool _ocultarSenha = true;
  bool _enviando = false;
  String? _erroAcesso;

  // E-mail — verifica o preenchimento e o formato básico.
  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';

    if (email.isEmpty) {
      return 'Informe seu e-mail.';
    }

    final formatoValido = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
    ).hasMatch(email);

    if (!formatoValido) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  // Senha — exige preenchimento sem alterar o conteúdo digitado.
  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe sua senha.';
    }

    return null;
  }

  // Feedback — remove o erro anterior quando o usuário edita os campos.
  void _limparErroAcesso() {
    if (_erroAcesso == null) return;

    setState(() {
      _erroAcesso = null;
    });
  }

  // Envio — valida os campos e chama a operação de autenticação.
  Future<void> _entrar() async {
    if (_enviando) return;

    final formularioValido =
        _chaveFormulario.currentState?.validate() ?? false;

    if (!formularioValido) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _enviando = true;
      _erroAcesso = null;
    });

    try {
      await widget.aoEntrar(
        _controladorEmail.text.trim(),
        _controladorSenha.text,
      );
    } catch (_) {
      if (!mounted) return;

      // Falha — apresenta uma mensagem sem expor detalhes internos.
      setState(() {
        _erroAcesso =
            'Não foi possível entrar. Confira seus dados e tente novamente.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Recursos — libera os controladores ao sair da tela.
    _controladorEmail.dispose();
    _controladorSenha.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresAplicativo.fundo,

      // Cabeçalho — permite retornar à navegação anterior.
      appBar: AppBar(
        title: const Text('Entrar'),
      ),

      // Conteúdo — permite rolagem quando o teclado estiver aberto.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Marca — utiliza a logo já existente no projeto.
                  Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo-oficial.png',
                          fit: BoxFit.contain,
                          semanticLabel: 'Mingru',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Apresentação — recebe o cliente.
                  Text(
                    'Bom te ver por aqui.',
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: CoresAplicativo.textoPrincipal,
                              fontWeight: FontWeight.w700,
                            ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Entre na sua conta para continuar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CoresAplicativo.textoSecundario,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Formulário — agrupa os campos e as ações de acesso.
                  _construirFormulario(),

                  const SizedBox(height: 20),

                  // Cadastro — oferece acesso à criação de conta.
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      const Text(
                        'Ainda não tem uma conta?',
                        style: TextStyle(
                          color: CoresAplicativo.textoSecundario,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: _enviando ? null : widget.aoCriarConta,
                        child: const Text('Criar conta'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Visitante — permite retornar sem realizar login.
                  TextButton(
                    onPressed: _enviando
                        ? null
                        : () {
                            Navigator.of(context).maybePop();
                          },
                    child: const Text('Continuar como visitante'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Campos — constrói o formulário com preenchimento automático.
  Widget _construirFormulario() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CoresAplicativo.superficie,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CoresAplicativo.borda,
        ),
      ),
      child: AutofillGroup(
        child: Form(
          key: _chaveFormulario,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: _limparErroAcesso,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // E-mail — identifica a conta do cliente.
              TextFormField(
                controller: _controladorEmail,
                enabled: !_enviando,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                autocorrect: false,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                validator: _validarEmail,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'voce@exemplo.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 20),

              // Senha — permite alternar entre conteúdo oculto e visível.
              TextFormField(
                controller: _controladorSenha,
                enabled: !_enviando,
                obscureText: _ocultarSenha,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                autocorrect: false,
                enableSuggestions: false,
                validator: _validarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: _ocultarSenha
                        ? 'Mostrar senha'
                        : 'Ocultar senha',
                    onPressed: _enviando
                        ? null
                        : () {
                            setState(() {
                              _ocultarSenha = !_ocultarSenha;
                            });
                          },
                    icon: Icon(
                      _ocultarSenha
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                onFieldSubmitted: (_) {
                  _entrar();
                },
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 8),

              // Recuperação — encaminha o e-mail já digitado.
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _enviando
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();

                          widget.aoRecuperarSenha(
                            _controladorEmail.text.trim(),
                          );
                        },
                  child: const Text('Esqueci minha senha'),
                ),
              ),

              // Erro — informa quando a tentativa de acesso falhar.
              if (_erroAcesso != null) ...[
                const SizedBox(height: 8),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _erroAcesso!,
                    style: const TextStyle(
                      color: CoresAplicativo.erro,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Acesso — bloqueia envios repetidos durante a operação.
              FilledButton(
                onPressed: _enviando ? null : _entrar,
                child: _enviando
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: CoresAplicativo.textoPrincipal,
                          semanticsLabel: 'Entrando',
                        ),
                      )
                    : const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}