/// All queries for table creation are defined here
library;

const List<String> tables = [
  videoCategoriesTable,
  videosTable,
  announementsTable,
  eventsTable,
  notificationsTable,
];

const String videoCategoriesTable = 'CREATE TABLE video_categories('
    'id INTEGER PRIMARY KEY, '
    'category_name TEXT)';

const String videosTable = 'CREATE TABLE videos('
    'id INTEGER PRIMARY KEY, '
    'title TEXT, '
    'description TEXT, '
    'category TEXT, '
    'thumbnail_path TEXT, '
    'video_path TEXT,'
    'created_at TEXT)';

const String announementsTable = 'CREATE TABLE announcements('
    'id INTEGER PRIMARY KEY, '
    'title TEXT, '
    'message TEXT, '
    'created_at TEXT)';

const String eventsTable = 'CREATE TABLE events('
    'id INTEGER PRIMARY KEY, '
    'title TEXT, '
    'description TEXT, '
    'event_start TEXT, '
    'event_end TEXT)';

const String notificationsTable = 'CREATE TABLE notifications('
    'id INTEGER PRIMARY KEY, '
    'title TEXT, '
    'message TEXT, '
    'datetime TEXT)';
