import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_todo_model.dart';

class AddTodo extends StatelessWidget {
  // 値を更新するための処理を書く　mainのページとくっつけるためにlistを定義する
  AddTodo( { required this.list} );
  final List  list;
  
  @override
  Widget build(BuildContext context) {
    //追加と編集とで処理を変えるためにisUpdateを定義して条件分岐を書いてあげる
    final bool isUpdate = list != null;
    //--------------------------------------------------------
    return ChangeNotifierProvider<AddTodoModel>(
      create: (_) => AddTodoModel(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange.shade400,
            title: Text(isUpdate ? "todoリストを編集する" : "todoリストを追加する"),
          ),
          body: Consumer<AddTodoModel>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                        child: TextFormField(
                          onChanged: (text) {
                            model.todoTitle = text;
                          },
                          decoration: InputDecoration(
                            //ヒントテキストの色を黒にして、入力画面では色をオレンジに変わるようにしたい
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange.shade400, width: 2.0,
                              ),
                            ),
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(
                                color: Colors.orange.shade400,
                                fontWeight: FontWeight.w400,
                              ),
                                //focusColor: Colors.red,
                              labelText: '今日やるべきことを入力してください',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.orange.shade400,
                                ),
                              ),
                          ),
                        ),
                    ),
                        RaisedButton(
                          child:  Text(isUpdate ? 'やることリストを変更する' : "やることリストに追加する"),
                          onPressed: () async {
                        //firestoreにやること（値）を追加する

                              try {
                                await model.addTodotoFirebase();
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('保存しました'),
                                      actions: [
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                Navigator.of(context).pop();
                                //ここから例外処理
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(e.toString()),
                                      actions: [
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            highlightColor: Colors.orange.shade400,
                            onHighlightChanged: (value) {},
                        ),
                  ],
                ),
              );
            },
          ),
        ),
    );
  }
}


