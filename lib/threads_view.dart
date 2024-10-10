import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'thread_view.dart';
//import 'package:intl/intl.dart';

String timeSince(int unixTimestamp) {
  DateTime inputDate = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
  DateTime now = DateTime.now();
  
  Duration difference = now.difference(inputDate);

  if (difference.inDays > 0) {
    return '${difference.inDays} day(s) ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour(s) ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute(s) ago';
  } else if (difference.inSeconds > 0) {
    return '${difference.inSeconds} second(s) ago';
  } else {
    return 'just now';
  }
}

class ThreadsView extends StatefulWidget {
  final String board;

  ThreadsView({required this.board});

  @override
  _ThreadsViewState createState() => _ThreadsViewState();
}

class _ThreadsViewState extends State<ThreadsView> {
  late Future<List<dynamic>> threadsData;

  @override
  void initState() {
    super.initState();
    threadsData = fetchThreads(widget.board);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('/${widget.board}/'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: threadsData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final thread = snapshot.data![index];
                String threadTitle = thread['sub'] ?? 'No title';
                threadTitle = threadTitle.replaceAll('&#039;', "'");
                threadTitle = threadTitle.replaceAll('&amp;', "&"); 
                return ListTile(
                  title: Text(threadTitle),
                  subtitle: Text('${thread['replies']} replies - ${timeSince(thread['time'])}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThreadView(
                          board: widget.board,
                          threadId: thread['no'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading threads"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
