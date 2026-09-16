import 'package:flutter/material.dart';

import 'package:mingru/core/theme/cores_aplicativo.dart';

// Cadastro — apresenta o formulário de criação de conta.
class TelaCadastro extends StatefulWidget {
  const TelaCadastro({
    super.key,
    required this.aoCadastrar,
  });

  // Conta — recebe a operação responsável pelo cadastro.
  final Future<void> Function(
    String nome,
    String email,
    String senha,
  ) aoCadastrar;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  // Formulário — controla a validação dos campos.
  final GlobalKey<FormState> _chaveFormulario = GlobalKey<FormState>();

  // Campos — armazenam os valores digitados.
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSenha = TextEditingController();
  final TextEditingController _controladorConfirmacao =
      TextEditingController();

  // Estado — controla as senhas, o envio e o feedback.
  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;
  bool _enviando = false;
  String? _erroCadastro;

  // Nome — verifica se o campo foi preenchido.
  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';

    if (nome.isEmpty) {
      return 'Informe seu nome.';
    }

    return null;
  }

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

  // Senha — exige pelo menos oito caracteres.
  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Crie uma senha.';
    }

    if (valor.runes.length < 8) {
      return 'Use pelo menos 8 caracteres.';
    }

    return null;
  }

  // Confirmação — verifica se as duas senhas são iguais.
  String? _validarConfirmacao(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme sua senha.';
    }

    if (valor != _controladorSenha.text) {
      return 'As senhas não coincidem.';
    }

    return null;
  }

  // Feedback — remove o erro anterior quando os campos forem editados.
  void _limparErroCadastro() {
    if (_erroCadastro == null) return;

    setState(() {
      _erroCadastro = null;
    });
  }

  // Cadastro — valida os campos e chama a operação recebida.
  Future<void> _cadastrar() async {
    if (_enviando) return;

    final formularioValido =
        _chaveFormulario.currentState?.validate() ?? false;

    if (!formularioValido) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _enviando = true;
      _erroCadastro = null;
    });

    try {
      await widget.aoCadastrar(
        _controladorNome.text.trim(),
        _controladorEmail.text.trim(),
        _controladorSenha.text,
      );
    } catch (_) {
      if (!mounted) return;

      // Falha — evita apresentar detalhes internos da operação.
      setState(() {
        _erroCadastro =
            'Não foi possível criar sua conta. Tente novamente.';
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
    _controladorNome.dispose();
    _controladorEmail.dispose();
    _controladorSenha.dispose();
    _controladorConfirmacao.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresAplicativo.fundo,

      // Cabeçalho — permite retornar para a tela anterior.
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),

      // Conteúdo — mantém o formulário acessível com o teclado aberto.
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
                  // Marca — reutiliza a logo existente.
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

                  // Apresentação — convida o visitante a criar sua conta.
                  Text(
                    'Faça parte da Mingru.',
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: CoresAplicativo.textoPrincipal,
                              fontWeight: FontWeight.w700,
                            ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Crie sua conta para finalizar suas compras '
                    'e acompanhar seus pedidos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CoresAplicativo.textoSecundario,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Formulário — reúne os dados necessários ao cadastro.
                  _construirFormulario(),

                  const SizedBox(height: 20),

                  // Retorno — volta para o login sem criar outra tela.
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      const Text(
                        'Já tem uma conta?',
                        style: TextStyle(
                          color: CoresAplicativo.textoSecundario,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: _enviando
                            ? null
                            : () {
                                Navigator.of(context).maybePop();
                              },
                        child: const Text('Entrar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Formulário — aplica validação e preenchimento automático.
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
          onChanged: _limparErroCadastro,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome — identifica o cliente.
              TextFormField(
                controller: _controladorNome,
                enabled: !_enviando,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                validator: _validarNome,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Como você se chama?',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 20),

              // E-mail — será utilizado para acessar a conta.
              TextFormField(
                controller: _controladorEmail,
                enabled: !_enviando,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                enableSuggestions: false,
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

              // Senha — permite criar e visualizar a senha escolhida.
              TextFormField(
                controller: _controladorSenha,
                enabled: !_enviando,
                obscureText: _ocultarSenha,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                autocorrect: false,
                enableSuggestions: false,
                validator: _validarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Pelo menos 8 caracteres',
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
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),

              const SizedBox(height: 20),

              // Confirmação — evita cadastrar uma senha digitada por engano.
              TextFormField(
                controller: _controladorConfirmacao,
                enabled: !_enviando,
                obscureText: _ocultarConfirmacao,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                autocorrect: false,
                enableSuggestions: false,
                validator: _validarConfirmacao,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  hintText: 'Digite a senha novamente',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: _ocultarConfirmacao
                        ? 'Mostrar confirmação da senha'
                        : 'Ocultar confirmação da senha',
                    onPressed: _enviando
                        ? null
                        : () {
                            setState(() {
                              _ocultarConfirmacao = !_ocultarConfirmacao;
                            });
                          },
                    icon: Icon(
                      _ocultarConfirmacao
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                onFieldSubmitted: (_) {
                  _cadastrar();
                },
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),

              // Erro — apresenta o feedback da operação de cadastro.
              if (_erroCadastro != null) ...[
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _erroCadastro!,
                    style: const TextStyle(
                      color: CoresAplicativo.erro,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Envio — impede tentativas repetidas durante a operação.
              FilledButton(
                onPressed: _enviando ? null : _cadastrar,
                child: _enviando
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: CoresAplicativo.textoPrincipal,
                          semanticsLabel: 'Criando conta',
                        ),
                      )
                    : const Text('Criar minha conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}