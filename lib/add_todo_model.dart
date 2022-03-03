import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddTodoModel extends ChangeNotifier {
  String todoTitle = '';

  Future addTodotoFirebase() async{
    if (todoTitle.isEmpty) {
      throw("今日やることを入力してください");
    }

    Firestore.instance.collection('lists').add({
      'title' : todoTitle,
    }
    );
  }
}