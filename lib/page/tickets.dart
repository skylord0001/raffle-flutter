import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/main.dart';
import 'package:raffle/page/raffle.dart';
import 'package:raffle/screen/account.dart';

class MyTicket extends StatelessWidget {
  const MyTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RaffleProvider>(context),
      child: Consumer<RaffleProvider>(
        builder: (context, provider, _) {
          if (provider.user == null) {
            return const Account();
          } else if (provider.userTickets == null) {
            provider.getUserTickets();
            return const Center(child: CircularProgressIndicator());
          } else {
            final ticket = provider.userTickets;
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Tickets'),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                itemCount: ticket?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RafflePage(
                            raffle: ticket![index].raffle,
                          ),
                        ),
                      );
                    },
                    title: Text(
                      '${ticket?[index].raffle.name}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    subtitle: Text(
                      ' ₦${ticket?[index].raffle.ticketPrice}',
                      style: TextStyle(color: primaryColor.shade900),
                    ),
                    trailing: Text(
                      '${ticket?[index].createdAt.toString().substring(0, 19)}',
                      style: TextStyle(color: primaryColor.shade900),
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
