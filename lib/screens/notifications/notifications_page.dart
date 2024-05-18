import 'package:flutter/material.dart';
import 'package:flutter_android_tv_box/core/theme.dart';
import 'package:flutter_android_tv_box/data/database/notifications_dao.dart';
import 'package:flutter_android_tv_box/data/models/notifications.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationsPage> {
  late final NotificationsDAO _notificationsDAO = NotificationsDAO();
  late List<Notifications> _notifications = [];
  bool _isContentEmpty = false;

  @override
  void initState() {
    super.initState();
    // List<Notifications> sample = List<Notifications>.generate(
    //     10,
    //     (index) => Notifications(
    //         id: index,
    //         title: 'Title $index',
    //         message: 'Message $index',
    //         datetime: DateTime.now().toIso8601String()));
    // for (var element in sample) {
    //   _notificationsDAO.insertNotification(element);
    // }

    // _notificationsDAO.updateNotification(Notifications(
    //     id: 8,
    //     title: "Updated",
    //     message: 'Edited',
    //     datetime: DateTime.now().toIso8601String()));
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _notificationsDAO.queryNotifications();
    setState(() {
      _notifications = notifications.reversed.toList();
      _isContentEmpty = _notifications.isEmpty;
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
          child: _buildContent(),
        ));
  }

  Widget _buildContent() {
    if (_notifications.isEmpty && _isContentEmpty) {
      return const Text('No New Notifications At The Moment');
    }
    if (_notifications.isNotEmpty) {
      return ListView.separated(
          // reverse: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
          itemCount: _notifications.length,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
                height: 10,
              ),
          itemBuilder: (BuildContext context, int index) => NotificationItem(
              notification: _notifications[index],
              onDelete: () => _deleteNotification(_notifications[index].id ?? -1)));
    }
    return const CircularProgressIndicator();
  }

  _deleteNotification(int id) {
    _notificationsDAO.deleteNotification(id);
    _loadNotifications();
  }

  _clearNotification() {
    _notificationsDAO.clearNotifications();
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
