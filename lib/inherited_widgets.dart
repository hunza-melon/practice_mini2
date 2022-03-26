import 'package:flutter/cupertino.dart';

import 'main.dart';

class InheritedPost extends InheritedWidget {
  final Post? post;

  final Widget child;

  InheritedPost({Key? key, @required this.post, required this.child})
      : super(key: key, child: child);

  static InheritedPost? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPost>();
  }

  @override
  bool updateShouldNotify(InheritedPost oldWidget) {
    return true;
  }
}

//예시에서 PostCard class는 HomePage
//PostPage는 PostDetailPage와 같음
//PostModel은 Post