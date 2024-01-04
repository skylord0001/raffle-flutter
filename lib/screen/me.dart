import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/main.dart';
import 'package:raffle/screen/account.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RaffleProvider>(context),
      child: Consumer<RaffleProvider>(
        builder: (context, provider, _) {
          if (provider.user == null) {
            return const Account();
          } else if (provider.user == null ||
              provider.userTickets == null ||
              provider.userNotifications == null) {
            provider.getUserNotifications();
            provider.getUserTickets();
            return const Center(child: CircularProgressIndicator());
          } else {
            final user = provider.user;
            final ticket = provider.userTickets;
            final notifications = provider.userNotifications;
            return Scaffold(
              appBar: AppBar(
                title: const Text("My Account"),
                systemOverlayStyle: system,
                actions: [
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.logout),
                    onPressed: () {},
                  ),
                ],
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/myticket',
                              );
                            },
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
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        'My Tickets',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        ticket!.length.toString(),
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
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
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 10,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          AssetImage('images/2.webp'),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      user!.username,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      user.email,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 400,
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
                                  notification.createdAt
                                      .toString()
                                      .substring(0, 19),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  notification.message,
                                  style:
                                      TextStyle(color: primaryColor.shade900),
                                ),
                                trailing:
                                    const Icon(Icons.notifications_active),
                                onTap: () {
                                  // Handle notification tap here
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  if (!await launchUrl(
                      Uri.parse('http://127.0.0.1:8880/contact'))) {
                    throw 'Could not launch http://127.0.0.1:8880/contact';
                  }
                },
                child: const Icon(
                  Icons.chat_sharp,
                  color: Colors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
