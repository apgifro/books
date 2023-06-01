import 'dart:convert';
import 'package:http/http.dart' as http;

// busca geral
// https://www.googleapis.com/books/v1/volumes?q=infantojuvenil&key=AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8
// https://www.googleapis.com/books/v1/volumes?q=flutter&maxResults=20&key=AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8
// https://www.googleapis.com/books/v1/volumes?q=biologia&key=AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8

// busca por id
// https://www.googleapis.com/books/v1/volumes/zyTCAlFPjgYC?key=AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8

// busca por autor
// https://www.googleapis.com/books/v1/volumes?q=inauthor:"Richard+Moreno"&key=AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8
// https://www.googleapis.com/books/v1/volumes?q=inauthor:"JK+Rowling"&key=AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8

// mais novos
// https://www.googleapis.com/books/v1/volumes?q=biologia+orderBy=newest&key=AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8

const String api = 'https://www.googleapis.com/books/v1';
const String apiKey = 'AIzaSyC6AcwYUhVcBjI3K5uDsO6H_xY8qSVL2D8';


Future <Map<String, dynamic>> fetchBooks (String content) async {
  final String url = '$api/volumes?q=$content&maxResults=30&key=$apiKey';
  final http.Response response = await http.get(Uri.parse(url));
  return json.decode(response.body);
}
