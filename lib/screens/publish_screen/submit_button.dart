import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final Function()? onPressed;

  const MySubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.all(8),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
