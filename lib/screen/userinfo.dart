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
            ],
          ),
        ),
      ),
    );
  }
}
