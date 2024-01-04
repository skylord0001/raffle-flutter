import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/main.dart';

class NotificationStreameWidget extends StatefulWidget {
  const NotificationStreameWidget({Key? key}) : super(key: key);

  @override
  NotificationStreameWidgetState createState() =>
      NotificationStreameWidgetState();
}

class NotificationStreameWidgetState extends State<NotificationStreameWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: Consumer<RaffleProvider>(
        builder: (context, provider, _) {
          if (provider.notificationsList == null) {
            provider.getNotifications();
            return const Center(child: CircularProgressIndicator());
          } else {
            final notifications = provider.notificationsList;
            return RefreshIndicator(
              onRefresh: provider.getNotifications,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: notifications!.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          notification.createdAt.toString().substring(0, 19),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          notification.message.replaceFirst("You", "Someone"),
                          style: TextStyle(color: primaryColor.shade900),
                        ),
                        trailing: const Icon(Icons.notifications),
                        onTap: () {
                          // Handle notification tap here
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
