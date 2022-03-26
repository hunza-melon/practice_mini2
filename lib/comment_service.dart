import 'package:flutter/material.dart';

import 'main.dart';

class CommentService extends ChangeNotifier {
  List<Comment> commentList = [];

  void createComment(String commentId, String commentContent) {
    commentList.add(Comment(commentId, commentContent));
    notifyListeners();
  }
}
