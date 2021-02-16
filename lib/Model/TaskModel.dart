
class TaskModel{

  String completedAt;
  String createdAt;
  String description;
  int id;
  String title;
  String updatedAt;
  int userId;

  TaskModel.fromJSON(Map<String, dynamic> parsedJson) {
    this.completedAt = parsedJson['completed_at'];
    this.createdAt = parsedJson['created_at'];
    this.description = parsedJson['description'];
    this.id = parsedJson['id'];
    this.title = parsedJson['title'];
    this.updatedAt = parsedJson['updated_at'];
    this.userId = parsedJson['user_id'];
  }
}