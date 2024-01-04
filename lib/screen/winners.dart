import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:raffle/screen/account.dart';

class WinnerList extends StatelessWidget {
  const WinnerList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RaffleProvider>(context),
      child: Consumer<RaffleProvider>(
        builder: (context, provider, _) {
          if (provider.user == null) {
            return const Account();
          } else if (provider.notificationsList == null) {
            provider.getNotifications();
            return const Center(child: CircularProgressIndicator());
          } else {
            final notifications = provider.notificationsList;
            return Scaffold(
              appBar: AppBar(
                title: const Text('List of Winners'),
                systemOverlayStyle: system,
              ),
              body: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: notifications!.length,
                itemBuilder: (context, index) {
                  //final winner = notifications[index];
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
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () async {
                            const url = 'https://www.example.com';
                            if (!await launchUrl(Uri.parse(url))) {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Lucky poor women Won a Car',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 50,
                                  child: Text(
                                    'winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message winner.message',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[200],
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
