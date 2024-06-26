import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StaffNotificationsPage extends StatefulWidget {
  @override
  _StaffNotificationsPageState createState() => _StaffNotificationsPageState();
}

class _StaffNotificationsPageState extends State<StaffNotificationsPage> {
  List<NotificationItem> notifications = [
    NotificationItem('Notification 1', 'Details 1', false, NotificationType.General),
    NotificationItem('Notification 2', 'Details 2', false, NotificationType.Alert),
    NotificationItem('Notification 3', 'Details 3', false, NotificationType.Info),
  ];

  void showNotificationPopup(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification.title),
          content: Text(notification.details),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount = notifications.where((notification) => !notification.isRead).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Handle the tap on the bell icon (you can navigate to a different screen or perform an action)
                },
                icon: Icon(
                  Icons.notifications,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (!notifications[index].isRead)
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        SizedBox(width: 10,),
                        Text(
                          notifications[index].title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle the tap on the delete icon (set as read and remove)
                        setState(() {
                          notifications[index].isRead = true;
                          notifications.removeAt(index);
                        });
                      },
                      child: Icon(
                        Icons.close, // You can change the icon as needed
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showNotificationPopup(notifications[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

enum NotificationType {
  General,
  Alert,
  Info,
}

class NotificationItem {
  String title;
  String details;
  bool isRead;
  NotificationType type;

  NotificationItem(this.title, this.details, this.isRead, this.type);
}
