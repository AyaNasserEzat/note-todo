class Note{
 final int ?id;
  final String content;
  final String title;
  Note({required this.content, this.id,required this.title});
  factory Note.fromJson(jsonData){
    return Note(content: jsonData['content'], title: jsonData['title']);
  }
  Map<String,dynamic> tomap(){
    return {
      "id":id,
      "title":title,
      "content":content
    };
   }
}
class ToDo{
  final int? id;
  final int? value;
  final String title;
  ToDo({ this.value=0,  this.id,required this.title});
  factory ToDo.fromJson(jsonData){
    return ToDo(title: jsonData['title']);
  }
  Map<String,dynamic> tomap(){
    return {
      "id":id,
      "title":title,
      "value":value
    };
   }
}