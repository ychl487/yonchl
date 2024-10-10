import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'threads_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<dynamic>> boardsData;

  @override
  void initState() {
    super.initState();
    boardsData = fetchBoards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('yonchl v24.10.10'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: boardsData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final board = snapshot.data![index];
                return ListTile(
                  title: Text(board['title']),
                  subtitle: Text('/${board['board']}/'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThreadsView(board: board['board']),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading boards"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
