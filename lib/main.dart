import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(const FormApp());

class FormApp extends StatelessWidget {
  const FormApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final FocusNode _emailNode = new FocusNode();
  final FocusNode _phoneNode = new FocusNode();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _echo() async {
    final Uri uri = Uri.parse('https://postman-echo.com/get').replace(queryParameters: {
      'name': _name.text,
      'email': _email.text,
      'phone': _phone.text,
      'age': _age.text,
    });

    final Response response = await get(uri);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PresentationPage(body: response.body);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Form'),
        trailing: GestureDetector(
          child: Text(
            'Validate',
            style: TextStyle(
              color: CupertinoColors.activeBlue,
              fontSize: 17.0,
            ),
          ),
          onTap: () {
            if (_formKey.currentState.validate()) {
              _echo();
            }
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
                keyboardType: TextInputType.text,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your name text.';
                  }

                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailNode);
                },
              ),
              TextFormField(
                controller: _email,
                focusNode: _emailNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (!value.contains('@') && !value.contains('.')) {
                    return 'Please enter a valid email.';
                  }

                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_phoneNode);
                },
              ),
              TextFormField(
                controller: _phone,
                focusNode: _phoneNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Phone',
                ),
                keyboardType: TextInputType.phone,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your phone number.';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _age,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Age',
                ),
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter your age text.';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PresentationPage extends StatelessWidget {
  const PresentationPage({Key key, this.body}) : super(key: key);

  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Response'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Text(
          JsonEncoder.withIndent('   ').convert(
            jsonDecode(body),
          ),
        ),
      ),
    );
  }
}
