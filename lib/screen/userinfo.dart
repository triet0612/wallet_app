import 'package:flutter/material.dart';

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

  updateName(value) {
    setState(() {
      _user = User(
        username: value,
        balance: _user.balance,
      );
    });
  }

  updateBalance(value) {
    setState(() {
      _user = User(
        username: _user.username,
        balance: double.parse(value),
      );
    });
  }

  submitUser() async {
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
                icon: const Icon(Icons.arrow_back)),
            title: const Text("User info"),
          ),
          body: Column(
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              const Text('Username'),
              _FormInputUser(callback: updateName),
              const Text('Balance Amount'),
              _FormInputUser(callback: updateBalance),
              _SubmitButton(callback: submitUser),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormInputUser extends StatelessWidget {
  final ValueSetter? callback;
  const _FormInputUser({this.callback});

  @override
  Widget build(Object context) {
    return Card(
      child: Form(
        child: TextFormField(
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.always,
          onChanged: (value) {
            try {
              callback!(value);
            } catch (_) {}
          },
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback? callback;
  const _SubmitButton({this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent.shade700,
        fixedSize: const Size(200, 50),
      ),
      onPressed: () async {
        callback!();
      },
      child: const Text(
        "Submit",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
