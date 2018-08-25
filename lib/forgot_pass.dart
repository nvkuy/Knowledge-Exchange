import 'package:flutter/material.dart';

class forgot_pass extends StatefulWidget {
  forgot_pass(this.title);

  final String title;

  @override
  _forgot_passState createState() => _forgot_passState();
}

class _forgot_passState extends State<forgot_pass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: Text('Forgot password'),
      ),
    );
  }
}