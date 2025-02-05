class Capung {
  final String latinName;
  final String indonesianName;
  final String description;
  final String descriptionParagraph;  // Mengizinkan null
  final String imagePath;

  Capung({
    required this.latinName,
    required this.indonesianName,
    required this.description,
    required this.descriptionParagraph,  // Bisa null
    required this.imagePath,
  });
}
