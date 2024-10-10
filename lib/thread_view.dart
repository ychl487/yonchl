import 'package:flutter/material.dart';
import 'post_widget.dart';
import 'services/api_service.dart';





class ThreadView extends StatefulWidget {
  final String board;
  final int threadId;

  ThreadView({required this.board, required this.threadId});

  @override
  _ThreadViewState createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  late Future<Map<String, dynamic>> threadData;

  @override
  void initState() {
    super.initState();
    threadData = fetchThread(widget.board, widget.threadId);
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("#${widget.threadId}"),
    ),
    body: FutureBuilder<Map<String, dynamic>>(
      future: threadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading thread: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!['posts'] == null) {
          return Center(child: Text("No data available."));
        }

        // Parse the posts into a tree structure
        final rootPost = parseThread(snapshot.data!);

        /*
        // Use ListView to ensure scrolling when posts are long
        return ListView(
          children: [
            ThreadTreeView(rootPost: rootPost),
          ],
        );
        */

        return Scrollbar(
  interactive: true,
  child: ListView(
    children: [
      ThreadTreeView(rootPost: rootPost),
    ],
  ),
);






      },
    ),
  );
}


String formatThread(Map<String, dynamic> thread) {
  List posts = thread['posts'];
  
  // Build a map for quick lookup
  Map<int, Map> postLookup = {};
  for (var post in posts) {
    postLookup[post['no']] = post;
  }

  // Recursively format the posts
  StringBuffer buffer = StringBuffer();
  for (var post in posts) {
    // The OP post has no parent, so it is directly printed
    if (!post.containsKey('parent')) {
      buffer.writeln(formatPost(post, postLookup, 0));
    }
  }
  
  return buffer.toString();
}

String formatPost(Map post, Map<int, Map> postLookup, int level) {
  StringBuffer buffer = StringBuffer();

  // Indentation based on the level of reply
  String indent = '  ' * level;

  // Add the current post's content
  buffer.writeln('${indent}Post #${post['no']}: ${post['com']}');

  // If there are replies, format them recursively
  if (post.containsKey('replies')) {
    for (var replyNo in post['replies']) {
      Map? replyPost = postLookup[replyNo];
      if (replyPost != null) {
        replyPost['parent'] = post['no'];  // Assign a parent to help structuring
        buffer.write(formatPost(replyPost, postLookup, level + 1));
      }
    }
  }

  return buffer.toString();
}


Post parseThread(Map<String, dynamic> threadJson) {
  // Check if the posts key exists and is a List

final Map<String, dynamic> threadData = threadJson;
// Check if the JSON contains "posts" key (this is where thread data is stored)
  if (!threadData.containsKey('posts')) {
     return Post(postId: 0, content:"no");
  }

  // Get the list of posts
  final List<dynamic> posts = threadData['posts'];

  // Initialize the output string
  StringBuffer threadText = StringBuffer();

  // Iterate through the posts to build the thread's textual representation
  for (var post in posts) {
    final int postNumber = post['no'];
    //String postComment = post['com']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? ''; // Remove HTML tags
    //String postComment = post['com'];
    String postComment = post['com']?.replaceAll(RegExp(r'<br\s*\/?>'), '\n') // Replace <br> with newline
                          .replaceAll(RegExp(r'<[^>]*>'), '') // Remove other HTML tags
                          ?? ''; // Handle null case
    final String postSubject = post['sub'] ?? '';
    postComment = postComment.replaceAll('&gt;', '>'); 
    postComment = postComment.replaceAll('&lt;', '<');
    postComment = postComment.replaceAll('&#039;', "'");
    postComment = postComment.replaceAll('&quot;', "--");
    postComment = postComment.replaceAll('&amp;', "&"); 
    postComment = postComment.replaceAll(RegExp(r'>>\d+'), '');

    // Add the post to the output string
    //threadText.writeln('#$postNumber');
    if (postSubject.isNotEmpty) {
      threadText.writeln('Subject: $postSubject');
    }
    threadText.write(postComment);
    threadText.write(" '\n\n"); // Separate posts with a line
  }



 return Post(postId: 0, content: threadText.toString());



  
}


}