import 'package:flutter/material.dart';

class FormInputUser extends StatelessWidget {
  final ValueSetter? callback;
  final TextInputType? textInputType;
  const FormInputUser({super.key, this.callback, this.textInputType});

  @override
  Widget build(Object context) {
    return Card(
      child: Form(
        child: TextFormField(
          keyboardType: textInputType,
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

class SubmitButton extends StatelessWidget {
  final VoidCallback? callback;
  const SubmitButton({super.key, this.callback});

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
