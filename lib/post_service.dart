//import 'dart:html';

import 'package:flutter/material.dart';

import 'main.dart';

class PostService extends ChangeNotifier {
  List<Post> postList = [
    //Post('제목예시', '내용예시', [Comment('User', '댓글을 남기세요.')])
  ];

  void createPost(String postTitle, String postContent) {
    postList.add(Post(postTitle, postContent, []));
    notifyListeners();
  }

  void createComment(String postTitle, String commentContent) {
    postList
        .where((element) => element.postTitle == postTitle)
        .toList()
        .first
        .comments
        .add(Comment('commentIdSample', commentContent));
    notifyListeners();
  }
}
