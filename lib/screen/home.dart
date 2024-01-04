import 'dart:async';
import 'package:raffle/screen/account.dart';
import 'package:raffle/screen/me.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/widget/ticket.dart';
import 'package:raffle/screen/winners.dart';
import 'package:raffle/screen/raffles.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/widget/notifications.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<RaffleProvider>(builder: (context, provider, _) {
      if (provider.user == null) {
        return const Account();
      } else {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF188F52),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: IndexedStack(
                        index: _selectedIndex,
                        children: const [
                          HomePage(),
                          RaffleScreen(),
                          WinnerList(),
                          AccountScreen(),
                        ],
                      ),
                    ),
                    BottomNavigationBar(
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: const Color(0xFF188F52),
                      currentIndex: _selectedIndex,
                      showUnselectedLabels: true,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.filter_list),
                          label: 'Raffles',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.emoji_events),
                          label: 'Winners',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle_outlined),
                          label: 'Me',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    if (_selectedIndex != 0) {
      // User is on a page other than the home page, so navigate to home page
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              title: const Text('Are you sure?'),
              content: const Text('Do you really wanna exit'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          )) ??
          false;
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Provider.of<RaffleProvider>(context),
      child: Consumer<RaffleProvider>(
        builder: (context, provider, _) {
          if (provider.user == null) {
            return const Account();
          } else if (provider.raffle == null ||
              provider.raffles.isEmpty ||
              provider.userTickets == null ||
              provider.notificationsList!.isEmpty) {
            provider.fetchRaffle();
            provider.fetchRaffles();
            provider.getNotifications(
                username: provider.user!.username,
                password: provider.user!.password);
            provider.getUserTickets(
                username: provider.user!.username,
                password: provider.user!.password);
            return const Center(child: CircularProgressIndicator());
          } else {
            final raffle = provider.raffle!;
            final raffles = provider.raffles;
            final usertickets = provider.userTickets!;
            final notifications = provider.notificationsList;
            int notPaidCount = 0;
            for (UserTickets ticket in usertickets) {
              if (!ticket.paid) {
                notPaidCount++;
              }
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/notifications',
                                arguments: 'hot',
                              );
                            },
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                notifications!.length.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Open Raffle'),
                          const SizedBox(height: 12),
                          Text(
                            raffles.length.toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('My Tickets'),
                          const SizedBox(height: 12),
                          Text(
                            usertickets.length.toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              // Navigate to shopping cart screen
                            },
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Text(
                                notPaidCount.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TicketWidget(
                    raffle: raffle,
                    show: true,
                  ),
                  const NotificationStreameWidget(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
