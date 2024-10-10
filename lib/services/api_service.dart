import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchBoards() async {
  final url = 'https://a.4cdn.org/boards.json';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<dynamic> boards = data['boards'];
    boards.removeWhere((board) => board['ws_board'] == 0);
    List<String> boardsToRemove = [
  "cm", "lgbt", "mlp", "wsg", "c", "cgl", "co", "toy", "w", "qa", "pw", 
  "tv", "vip", "vp", "wsr", "x","a","vt","vg","g","lit","adv"
];
boards.removeWhere((board) => boardsToRemove.contains(board['board']));


    List<Map<String, dynamic>> newBoards = [
      {"board":"a","title":"a"},{"board":"vt","title":"vt"},{"board":"vg","title":"vg"},
      {"board":"g","title":"g"},{"board":"lit","title":"lit"},{"board":"pol","title":"pol"}
    ];
    boards.insertAll(0, newBoards);
    return boards;
  } else {
    throw Exception('Failed to load boards');
  }
}

Future<List<dynamic>> fetchThreads(String board) async {
  final url = 'https://a.4cdn.org/$board/catalog.json';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<dynamic> threads = [];
    for (var page in data) {
      threads.addAll(page['threads']);
    }
    threads.sort((a, b) => b['replies'].compareTo(a['replies']));
    return threads;
  } else {
    throw Exception('Failed to load threads');
  }
}

Future<Map<String, dynamic>> fetchThread(String board, int threadId) async {
  final url = 'https://a.4cdn.org/$board/thread/$threadId.json';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load thread');
  }
}
