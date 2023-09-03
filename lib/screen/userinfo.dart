import 'package:flutter/material.dart';

import '../components/form.dart';
import '../model/database.dart';
import '../model/model.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  User _user = const User(username: "", balance: 0.0);

  @override
  void initState() {
    super.initState();
    _readUser();
  }

  void _readUser() async {
    var temp = await DBProvider().readUser();
    setState(() {
      _user = temp;
    });
  }

  _updateName(value) {
    setState(() {
      _user = User(
        username: value,
        balance: _user.balance,
      );
    });
  }

  _updateBalance(value) {
    setState(() {
      _user = User(
        username: _user.username,
        balance: double.parse(value),
      );
    });
  }

  _submitUser() async {
    await DBProvider().submitUser(_user);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/');
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text("User info"),
          ),
          body: Column(
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              const Text('Username'),
              FormInputUser(
                callback: _updateName,
                textInputType: TextInputType.text,
              ),
              const Text('Balance Amount'),
              FormInputUser(
                callback: _updateBalance,
                textInputType: TextInputType.number,
              ),
              SubmitButton(callback: _submitUser),
              Container(
                margin: const EdgeInsets.all(20),
                child: RichText(
                  text: const TextSpan(
                    text:
                        "Do this when set up new account, on submit, every old data will be deleted. ",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: RichText(
                  text: const TextSpan(
                    text:
                        "We do not own any data of users, data sources for news are from https://vnexpress.net/ and for Book shopping page are from https://www.fahasa.com/. Data analystics are done locally for user and is not shared with anyone.",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: RichText(
                  text: const TextSpan(
                    text:
                        "Our app aims to better manage their money using reports, news and books. We believe that these sources will help people in making better financial decision in the future.",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: RichText(
                  text: const TextSpan(
                    text: "Thanks for using this app and enjoy <3",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
