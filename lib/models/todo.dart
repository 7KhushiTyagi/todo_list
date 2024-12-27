class Todo {

  int? id;
  String? title;
  String? description;
  String? category;
  String? todoDate;
  int? isFinished;

  Todo({
    this.id,
    this.title,
    this.description,
    this.category,
    this.todoDate,
    this.isFinished,
  });

  
  Map<String, dynamic> todoMap() {
    var mapping = <String, dynamic>{}; 


    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['todoDate'] = todoDate;
    mapping['isFinished'] = isFinished;

    return mapping;  
  }
}
