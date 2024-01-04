import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/widget/ticket.dart';

class RaffleScreen extends StatelessWidget {
  const RaffleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    bool isDesktop;
    try {
      isDesktop = (!Platform.isIOS && !Platform.isAndroid);
    } catch (e) {
      isDesktop = false;
    }
    return ChangeNotifierProvider.value(
      value: Provider.of<RaffleProvider>(context),
      child: Consumer<RaffleProvider>(
        builder: (context, provider, _) {
          if (provider.raffles.isEmpty) {
            provider.fetchRaffles();
            return const Center(child: CircularProgressIndicator());
          } else {
            final data = provider.raffles.reversed.toList();
            return isDesktop
                ? Scaffold(
                    appBar: AppBar(
                      title: Text('${data.length} Raffle Available'),
                    ),
                    body: RefreshIndicator(
                      key: refreshIndicatorKey,
                      onRefresh: provider.fetchRaffles,
                      child: rafflesw(provider),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        refreshIndicatorKey.currentState?.show();
                      },
                      tooltip: 'Refresh',
                      child: const Icon(Icons.refresh),
                    ),
                  )
                : RefreshIndicator(
                    key: refreshIndicatorKey,
                    onRefresh: provider.fetchRaffles,
                    child: rafflesw(provider),
                  );
          }
        },
      ),
    );
  }

  Widget rafflesw(provider) {
    final data = provider.raffles.reversed.toList();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          for (final raffle in data)
            TicketWidget(
              show: true,
              raffle: raffle,
            ),
        ],
      ),
    );
  }
}
