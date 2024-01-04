import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raffle/constant/variable.dart';
import 'package:raffle/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  AccountState createState() => AccountState();
}

class AccountState extends State<Account> {
  final signinkey = GlobalKey<FormState>();
  final signupkey = GlobalKey<FormState>();
  final signinusernameController = TextEditingController();
  final signinpasswordController = TextEditingController();

  final signupnamesController = TextEditingController();
  final signupusernameController = TextEditingController();
  final signuppasswordController = TextEditingController();
  late Widget account;

  String? signinusernameError;
  String? signinpasswordError;

  String? signupusernameError;
  String? signuppasswordError;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    account = signinWidget();
    signinusernameController.addListener(signinvalidateUsername);
    signupusernameController.addListener(signupvalidateUsername);
    signinpasswordController.addListener(signinvalidatePassword);
    signuppasswordController.addListener(signupvalidatePassword);
  }

  void signupvalidateUsername() {
    if (signupusernameController.text.isEmpty) {
      setState(
        () {
          signupusernameError = 'Please enter your username';
        },
      );
    } else if (signupusernameController.text.length <= 4) {
      setState(
        () {
          signupusernameError = 'username must not be less than 5';
        },
      );
    } else {
      setState(
        () {
          signupusernameError = null;
        },
      );
    }
  }

  void signinvalidateUsername() {
    if (signinusernameController.text.isEmpty) {
      setState(
        () {
          signinusernameError = 'Please enter your username';
        },
      );
    } else if (signinusernameController.text.length <= 4) {
      setState(
        () {
          signinusernameError = 'username must not be less than 5';
        },
      );
    } else {
      setState(
        () {
          signinusernameError = null;
        },
      );
    }
  }

  void signinvalidatePassword() {
    RegExp number = RegExp(r'[0-9]');
    if (signinpasswordController.text.isEmpty) {
      setState(() {
        signinpasswordError = 'Please enter your password';
      });
    }
    if (!number.hasMatch(signinpasswordController.text)) {
      setState(() {
        signinpasswordError = 'at least one number (0123456789)';
      });
    } else {
      setState(() {
        signinpasswordError = null;
      });
    }
  }

  void signupvalidatePassword() {
    RegExp number = RegExp(r'[0-9]');
    RegExp symbol = RegExp(r'[!@#\$%^&*]');
    if (signuppasswordController.text.isEmpty) {
      setState(() {
        signuppasswordError = 'Please enter your password';
      });
    } else if (signuppasswordController.text.length <= 8) {
      setState(() {
        signuppasswordError = 'must not less than 8';
      });
    } else if (!number.hasMatch(signuppasswordController.text)) {
      setState(() {
        signuppasswordError = 'at least one number (0123456789)';
      });
    } else if (!symbol.hasMatch(signuppasswordController.text)) {
      return setState(() {
        signuppasswordError = 'at least one symbols (!@#\$%^&*)';
      });
    } else {
      setState(() {
        signuppasswordError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/123.webp'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    padding: const EdgeInsets.all(30),
                    decoration: background,
                    child: Center(child: account),
                  ),
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: website(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget website() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Lucky Tree Raffle Draw",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(
                          Uri.parse('http://127.0.0.1:8880/policy'))) {
                        throw 'Could not launch http://127.0.0.1:8880/policy';
                      }
                    },
                    child: const Text("Privacy Policy"),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(
                          Uri.parse('http://127.0.0.1:8880/terms'))) {
                        throw 'Could not launch http://127.0.0.1:8880/terms';
                      }
                    },
                    child: const Text("Terms and Conditions"),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(Uri.parse(
                          'http://127.0.0.1:8880/frequently-asked-questions'))) {
                        throw 'Could not launch http://127.0.0.1:8880/frequently-asked-questions';
                      }
                    },
                    child: const Text("FAQ"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(
                          Uri.parse('http://127.0.0.1:8880/#about'))) {
                        throw 'Could not launch http://127.0.0.1:8880/#about';
                      }
                    },
                    child: const Text("About Us"),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(
                          Uri.parse('http://127.0.0.1:8880/#contact'))) {
                        throw 'Could not launch http://127.0.0.1:8880/#contact';
                      }
                    },
                    child: const Text("Support"),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(
                          Uri.parse('http://127.0.0.1:8880/#howto'))) {
                        throw 'Could not launch http://127.0.0.1:8880/#howto';
                      }
                    },
                    child: const Text("How To"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget signinWidget() {
    return Consumer<RaffleProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          child: Form(
            key: signinkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 130,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  controller: signinusernameController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username or email";
                    }
                    return signinusernameError;
                  },
                  onChanged: (String value) {
                    signinkey.currentState!.validate();
                  },
                  decoration: textinput('Username or Email'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  obscureText: true,
                  controller: signinpasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return signinpasswordError;
                  },
                  onChanged: (String value) {
                    signinkey.currentState!.validate();
                  },
                  decoration: textinput('Password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                  ),
                  onPressed: () {
                    if (signinkey.currentState!.validate()) {
                      provider
                          .getUserProfile(
                        username: signinusernameController.text,
                        password: signinpasswordController.text,
                      )
                          .then((value) {
                        if (value is! User) {
                          setState(() {
                            signinusernameError = value as String?;
                            signinpasswordError = value;
                          });
                        }
                      });
                    }
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "By signing in, you agree to our Terms, Data Policy and Cookies Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Don't have an account? ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      account = signupWidget();
                    });
                  },
                  child: const Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget signupWidget() {
    return SingleChildScrollView(
      child: Form(
        key: signupkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 130,
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              decoration: textinput('Email Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email address";
                }
                return signupusernameError;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: signupusernameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
              onChanged: (String value) {
                signupkey.currentState!.validate();
              },
              decoration: textinput('Full Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              obscureText: true,
              controller: signuppasswordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
              onChanged: (String value) {
                signupkey.currentState!.validate();
              },
              decoration: textinput('Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 40),
              ),
              onPressed: () {
                if (signupkey.currentState!.validate()) {
                  print(signupusernameController.text);
                  print(signuppasswordController.text);
                }
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "By signing up, you agree to our Terms, Data Policy and Cookies Policy.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Have an account? ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  account = signinWidget();
                });
              },
              child: const Text(
                "Sign in",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration textinput(label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[200],
      border: const OutlineInputBorder(),
      labelStyle: TextStyle(
        color: Colors.grey.shade800,
      ),
    );
  }
}
