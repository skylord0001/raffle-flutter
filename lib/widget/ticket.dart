import 'package:flutter/material.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/page/raffle.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TicketWidget extends StatelessWidget {
  final Raffle raffle;
  final bool show;

  const TicketWidget({Key? key, required this.raffle, required this.show})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return show
        ? InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RafflePage(
                    raffle: raffle,
                  ),
                ),
              );
            },
            child: ticket(context),
          )
        : ticket(context);
  }

  Widget ticket(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 250,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(raffle.image),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          if (show)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: LinearProgressIndicator(
                      value: raffle.ticketsSold /
                          (raffle.ticketsAvailable + raffle.ticketsSold),
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 0, 255, 8),
                      ),
                      semanticsLabel:
                          "${(raffle.ticketsSold / raffle.ticketsAvailable) * 100}%",
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
