// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toodo_app/add_todo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'add_todo_model.dart';


void main() {
  runApp(MaterialApp(
      home: MyApp()));
}


//class MyApp extends StatelessWidget {
class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final itemController = TextEditingController();




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade400,
        title: Text('やることリスト', ),
      ),
      body: Container(
        height: 680,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('lists').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    decoration:  BoxDecoration(
                      border: Border(
                        bottom:  BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(document['title'],
                        style: TextStyle(
                          fontSize: 17,
                        ),
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Archive',
                      color: Colors.blue,
                      icon: Icons.archive,
                      onTap: () => _showSnackBar('Archive'),
                    ),
                    IconSlideAction(
                      caption: 'share',
                      color: Colors.indigo,
                      icon: Icons.share,
                      onTap: () => _showSnackBar('Share'),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: '編集する',
                      color: Colors.black45,
                      icon: Icons.edit,
                      onTap: () {
                        //メモが編集できるような処理を書くーーーーーーーーーーーーー
                        Navigator.push(     
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTodo(
                              //addtodo で定義したリストとここを組み合わせたいんだけれどもうまくいかない
                              // list: list,
                          ),
                          ),
                        );
                      },
                    ),
                    IconSlideAction(
                      caption: '削除する',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async{
                        //値を削除するーーーーーーーーーーーーーーーーーー
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('”${document['title']}”  を削除しますか？'),
                            actions: [
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () async{
                                  Navigator.of(context).pop();

                                  //削除する処理を書く
                                  //await deleteLists(context);

                                },
                              ),
                            ],
                          );
                        },
                        );
                      },
                    ),
                  ]
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 75.0,
        height: 75.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodo(),
                  fullscreenDialog: true,
                ),
            );
          },
          child:  Icon(Icons.add,size: 52.0,),
          backgroundColor: Colors.orange.shade400,

        ),
      ),
    );
  }

  _showSnackBar(String s) {}

  Future deleteLists(BuildContext context,
  AddTodoModel model,
      ) async{

    try {
      // await model.deleteLists();
      await _showDialog(context, "削除しました");
      Navigator.of(context).pop();
      //ここから例外処理
    } catch (e) {
      await _showDialog(context, e.toString());
    }
  }
  //SHOWDIALOGを作ってますはい
  Future _showDialog(
      BuildContext context, String title
      ){
    showDialog(
    context: context,
    builder: (BuildContext context, ) {
      return AlertDialog(
        title: Text(title),
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
  ); }
}






