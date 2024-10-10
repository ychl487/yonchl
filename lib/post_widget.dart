import 'package:flutter/material.dart';

class Post {
  final int postId;
  final String content;
  final List<Post> replies;

  Post({required this.postId, required this.content, this.replies = const []});
}

class ThreadTreeView extends StatelessWidget {
  final Post rootPost;

  ThreadTreeView({required this.rootPost});

  @override
  Widget build(BuildContext context) {
    return _buildPostTree(rootPost);
  }

  Widget _buildPostTree(Post post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostWidget(post: post),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: post.replies.map((reply) => _buildPostTree(reply)).toList(),
          ),
        ),
      ],
    );
  }
}

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({required this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
         child: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust the value as needed
  child: SelectableText(
    widget.post.content,
    style: TextStyle(
      color: Colors.white,
      decoration: isHidden ? TextDecoration.none : TextDecoration.none,
    ),
  ),
),
        ),
        if (!isHidden)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.post.replies.map((reply) => PostWidget(post: reply)).toList(),
            ),
          ),
      ],
    );
  }
}
