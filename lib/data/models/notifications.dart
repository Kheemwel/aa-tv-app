/// Model class for notifications in database
class Notifications {
  final int id;
  final String title;
  final String message;
  final String datetime;

  Notifications({
    required this.id,
    required this.title,
    required this.message,
    required this.datetime,
  });
}
