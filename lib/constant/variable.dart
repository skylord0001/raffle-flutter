import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

SystemUiOverlayStyle system = const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
);

BoxDecoration background = const BoxDecoration(
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
);
Future<void> signout() async {}

class Notification {
  final int id;
  final String message;
  final DateTime createdAt;
  final int user;

  Notification({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.user,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'],
    );
  }
}

class UserTickets {
  final int id;
  final Raffle raffle;
  final String key;
  final DateTime createdAt;
  final bool paid;
  final String reference;

  UserTickets({
    required this.id,
    required this.raffle,
    required this.key,
    required this.createdAt,
    required this.paid,
    required this.reference,
  });

  factory UserTickets.fromJson(Map<String, dynamic> json) {
    return UserTickets(
      id: json['id'],
      raffle: Raffle.fromJson(json['raffle']),
      key: json['key'],
      paid: json['paid'],
      reference: json['paystack_reference'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Raffle {
  final int id;
  final String name;
  final String description;
  final double ticketPrice;
  final DateTime startDate;
  final DateTime endDate;
  final String image;
  final int ticketsAvailable;
  final int ticketsSold;
  final DateTime createdAt;
  int? winner;

  Raffle({
    required this.id,
    required this.name,
    required this.description,
    required this.ticketPrice,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.ticketsAvailable,
    required this.ticketsSold,
    required this.createdAt,
    this.winner,
  });

  factory Raffle.fromJson(Map<String, dynamic> json) {
    return Raffle(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ticketPrice: json['ticket_price'].toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      image: json['image'],
      ticketsAvailable: json['tickets_available'],
      ticketsSold: json['tickets_sold'],
      createdAt: DateTime.parse(json['created_at']),
      winner: json['winner'] != null ? int.parse(json['winner']) : null,
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}

class RaffleProvider with ChangeNotifier {
  User? _user;
  Raffle? _raffle;
  List<Raffle> _raffles = [];
  List<UserTickets>? _userTickets;
  List<Notification>? _userNotifications;
  List<Notification>? _notificationsList;

  User? get user => _user;
  Raffle? get raffle => _raffle;
  List<Raffle> get raffles => _raffles;
  List<UserTickets>? get userTickets => _userTickets;
  List<Notification>? get userNotifications => _userNotifications;
  List<Notification>? get notificationsList => _notificationsList;

  Future<void> fetchRaffles() async {
    try {
      final headers = {
        'Authorization': 'Token 1e9b9be80157b3ef736e6ddf975e4ca72f66b25b',
      };

      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8880/api/raffles/?format=json&_=${DateTime.now().millisecondsSinceEpoch}'),
        headers: headers,
      );
      final data = jsonDecode(response.body) as List<dynamic>;
      _raffles = data.map((item) => Raffle.fromJson(item)).toList();
    } catch (e) {
      //
    }
    notifyListeners();
  }

  Future<void> fetchRaffle() async {
    try {
      final headers = {
        'Authorization': 'Token 1e9b9be80157b3ef736e6ddf975e4ca72f66b25b',
      };

      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8880/api/raffles/hot/?format=json&_=${DateTime.now().millisecondsSinceEpoch}'),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      _raffle = Raffle.fromJson(data);
      notifyListeners();
    } catch (e) {
      //
    }
    notifyListeners();
  }

  Future<Object?> getUserProfile({String? username, String? password}) async {
    try {
      final currentUser = user;

      String? usern = username ?? currentUser?.username;
      String? paswd = password ?? currentUser?.password;

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8880/api/user/profile/'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$usern:$paswd'))}'
        },
      );

      final data = jsonDecode(response.body);
      data['password'] = paswd;
      _user = User.fromJson(data);
      notifyListeners();
      return _user;
    } on HttpException {
      return 'Failed to retrieve data from the server';
    } on SocketException {
      return 'Unable to Connect to the Internet';
    } catch (e) {
      return 'Invalid username or password';
    }
  }

  Future<void> getUserTickets({String? username, String? password}) async {
    try {
      final currentUser = user;

      String? usern = username ?? currentUser?.username;
      String? paswd = password ?? currentUser?.password;

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8880/api/user/profile/tickets/'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$usern:$paswd'))}'
        },
      );
      final data = jsonDecode(response.body) as List<dynamic>;
      _userTickets = data.map((item) => UserTickets.fromJson(item)).toList();
    } catch (e) {
      //
    }
    notifyListeners();
  }

  Future<void> getUserNotifications(
      {String? username, String? password}) async {
    try {
      final currentUser = user;

      String? usern = username ?? currentUser?.username;
      String? paswd = password ?? currentUser?.password;

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8880/api/user/notifications/'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$usern:$paswd'))}'
        },
      );
      final data = jsonDecode(response.body) as List<dynamic>;
      _userNotifications =
          data.map((item) => Notification.fromJson(item)).toList();
    } catch (e) {
      //
    }
    notifyListeners();
  }

  Future<void> getNotifications({String? username, String? password}) async {
    try {
      final currentUser = user;

      String? usern = username ?? currentUser?.username;
      String? paswd = password ?? currentUser?.password;

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8880/api/notifications/'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('$usern:$paswd'))}'
        },
      );
      final data = jsonDecode(response.body) as List<dynamic>;
      _notificationsList =
          data.map((item) => Notification.fromJson(item)).toList();
    } catch (e) {
      //
    }
    notifyListeners();
  }
}
