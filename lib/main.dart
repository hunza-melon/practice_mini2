//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice_mini2/post_service.dart';
import 'package:provider/provider.dart';

import 'comment_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostService()),
        //ChangeNotifierProvider(create: (context) => CommentService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class Post {
  String postTitle;
  String postContent;
  List<Comment> comments;
  Post(this.postTitle, this.postContent, this.comments);
}

class Comment {
  late String commentId;
  late String commentContent;
  Comment(this.commentId, this.commentContent);
}

class HomePage extends StatelessWidget {
  final Post? post;
  const HomePage({Key? key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostService>(builder: (context, postService, child) {
      List<Post> postList = postService.postList;
      return Scaffold(
        appBar: AppBar(
          title: Text('게시판'),
        ),
        body: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (BuildContext context, int index) {
            var _post = postList[index];
            return Column(
              children: [
                ListTile(
                  title: Text(_post.postTitle),
                  leading: CircleAvatar(
                      child: Text(
                    '작성자',
                    style: TextStyle(fontSize: 12),
                  )),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return PostDetailPage(
                        post: _post,
                      );
                    }));
                  },
                ),
                Divider(thickness: 1),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PostPage()));
            },
            child: Icon(Icons.post_add)),
      );
    });
  }
}

//게시글 상세조회 페이지
class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostService>(builder: (context, postService, child) {
      //List<Comment> commentList = commentService.commentList;
      return Scaffold(
        appBar: AppBar(
          title: Text('게시글 상세'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          child: CircleAvatar(child: Text('작성자')),
                        ),
                        SizedBox(width: 16),
                        Text(post.postTitle, style: TextStyle(fontSize: 24)),
                        Spacer(),
                        Text(
                          'YYYY/MM/DD \n HH:MM',
                          textAlign: TextAlign.end,
                        )
                      ],
                    ),
                    Divider(thickness: 2),
                    Container(height: 100, child: Text(post.postContent)),
                    Divider(thickness: 2),
                    Text(
                      '댓글 ${post.comments.length}개',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    post.comments.isEmpty
                        ? Text('아직 댓글이 없습니다.')
                        : Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: post.comments.length,
                                //itemCount: commentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var _comment = post.comments[index];
                                  return ListTile(
                                    title: Text(_comment.commentContent),
                                    leading: CircleAvatar(
                                        child: Text(_comment.commentId)),
                                  );
                                }),
                          ),

                    //Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () =>
                postService.createComment(post.postTitle, 'practicecomment')),
      );
    });
  }
}

//게시글 작성 페이지
class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '작성하기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 36,
            child: TextField(
              controller: titleController,
              decoration: InputDecoration.collapsed(hintText: '제목을 입력하세요.'),
            ),
          ),
          Divider(thickness: 1),
          Container(
            height: 180,
            child: TextField(
              controller: textController,
              decoration: InputDecoration.collapsed(hintText: '내용을 입력하세요.'),
            ),
          ),
          Divider(thickness: 1),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  String postTitle = titleController.text;
                  String postContent = textController.text;
                  PostService postService = context.read<PostService>();
                  postService.createPost(postTitle, postContent);
                  Navigator.pop(context);
                },
                child: Text('작성완료')),
          )
        ]),
      )),
    );
  }
}
