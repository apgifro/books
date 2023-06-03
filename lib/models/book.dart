class Book {
  final String bookID;
  final String bookName;
  final String urlBookImage;
  final String description;
  final String authors;
  String? swapEmail;

  Book({
    required this.bookID,
    required this.bookName,
    required this.urlBookImage,
    required this.description,
    required this.authors,
    this.swapEmail,
  });
}