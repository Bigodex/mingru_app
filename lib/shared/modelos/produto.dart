// Produto — estrutura compartilhada pelos produtos da loja.
class Produto {
  const Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.precoCentavos,
    this.imagemAsset,
  });

  // Identificação — chave única utilizada nos favoritos e na listagem.
  final String id;

  // Informações — nome e categoria apresentados na loja.
  final String nome;
  final String categoria;

  // Preço — valor em centavos para evitar imprecisões decimais.
  final int precoCentavos;

  // Imagem — caminho opcional do arquivo dentro dos assets.
  final String? imagemAsset;
}