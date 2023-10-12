import 'dart:convert';

class Todo{
  final String title;
  final String description;
  final bool isDone  ;

  Todo({
    required this.title,
    required this.description,
    required this.isDone,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? isDone,

  }){
    return Todo(
      title: title?? this.title,
      description: description?? this.description,
      isDone: isDone?? this.isDone,
    );
  }
  Map <String,dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'isDone': isDone
    };
  }

   String toJson() {
    return jsonEncode(toMap());
  }

  factory Todo.fromJson(String jsonStr) {
    Map<String, dynamic> map = jsonDecode(jsonStr);
    return Todo(
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
    );
  }
}
