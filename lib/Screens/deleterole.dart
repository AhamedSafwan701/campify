import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeleteroleScreen extends StatefulWidget {
  const DeleteroleScreen({super.key});

  @override
  State<DeleteroleScreen> createState() => _DeleteroleScreenState();
}

class _DeleteroleScreenState extends State<DeleteroleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Role',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 182, 182, 128),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
