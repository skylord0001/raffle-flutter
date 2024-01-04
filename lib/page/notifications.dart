import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/main.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RaffleProvider>(context),
      child: Consumer<RaffleProvider>(
        builder: (context, provider, _) {
          if (provider.notificationsList == null) {
            provider.getNotifications();
            return const Center(child: CircularProgressIndicator());
          } else {
            final notifications = provider.notificationsList;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Notifications'),
                systemOverlayStyle: system,
              ),
              body: ListView.builder(
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
