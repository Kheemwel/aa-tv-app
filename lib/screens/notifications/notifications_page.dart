import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/database/sqlite_notifications.dart';
import 'package:flutter_android_tv_box/data/models/notifications.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationsPage> {
  late SQLiteNotifications _sqLiteNotification;
  late List<Notifications> _notifications = [];

  @override
  void initState() {
    super.initState();
    _sqLiteNotification = SQLiteNotifications();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _sqLiteNotification.queryNotifications();
    setState(() {
      _notifications = notifications.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
                onPressed: () {
                  _showConfirmationDialog(
                      context: context,
                      message:
                          'Are you sure you want to clear all notifications?',
                      onYes: _clearNotification,
                      onNo: () {});
                },
                icon: const Icon(Icons.delete)),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: Center(
            child: _notifications.isNotEmpty
                ? ListView.separated(
                    // reverse: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 50),
                    itemCount: _notifications.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (BuildContext context, int index) =>
                        NotificationItem(
                            notification: _notifications[index],
                            onDelete: () =>
                                _deleteNotification(_notifications[index].id)))
                : const CircularProgressIndicator()));
  }

  _deleteNotification(int id) {
    _sqLiteNotification.deleteNotification(id);
    _loadNotifications();
    print(_notifications.length);
  }

  _clearNotification() {
    _sqLiteNotification.clearNotifications();
    _loadNotifications();
  }

  void _showConfirmationDialog(
      {required BuildContext context,
      required String message,
      required VoidCallback onYes,
      required VoidCallback onNo}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(message),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    onYes();
                    Navigator.pop(context);
                  }, // Implement clear logic
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                TextButton(
                  autofocus: true,
                  onPressed: () {
                    onNo();
                    Navigator.pop(context);
                  }, // Implement delete logic
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  @override
  void dispose() {
    _sqLiteNotification.dispose();
    super.dispose();
  }
}

class NotificationItem extends StatelessWidget {
  final Notifications notification;
  final VoidCallback onDelete;

  const NotificationItem(
      {super.key, required this.notification, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      focusColor: Palette.getColor('secondary'),
      tileColor: Palette.getColor('secondary-background'),
      textColor: Colors.white,
      title: Text(notification.title),
      subtitle: Text(notification.message),
      trailing: Text(notification.datetime),
      onTap: () => _showNotificationDialog(context, notification, onDelete),
    );
  }

  void _showNotificationDialog(
      BuildContext context, Notifications notification, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                color: Palette.getColor('primary-background'),
                child: Text(
                  notification.message,
                  style: const TextStyle(fontSize: 20),
                ),
              )),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Do you want delete?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                }, // Implement clear logic
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              TextButton(
                autofocus: true,
                onPressed: () {
                  Navigator.pop(context);
                }, // Implement delete logic
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ))
        ],
      )),
    );
  }
}
