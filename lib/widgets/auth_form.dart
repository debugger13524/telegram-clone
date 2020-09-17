import 'dart:io';

import 'package:flutter/material.dart';
import 'package:telegramclone/pickers/user_image_picker.dart';
import 'package:telegramclone/widgets/divider.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitForm, this.isLoading);
  bool isLoading;

  final void Function(String userName, String userEmail, String userPassword,File image,
      bool isLogin, BuildContext ctx) submitForm;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String _userName = "";
  String _userEmail = "";
  String _userPassword = "";
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState.validate();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      print(_userEmail);
      widget.submitForm(_userName.trim(), _userEmail.trim(),
          _userPassword.trim(),_userImageFile, _isLogin, context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100.0,
          ),
          Text(
            'Let\'s talk',
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.w100,
              letterSpacing: 8.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Theme(
              data: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.teal,
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(
                    color: Colors.teal,
                    fontSize: 20.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: <Widget>[
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      controller: emailController,
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                            ? null
                            : "Enter valid email address";
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('userName'),
                        validator: (val) {
                          return val.length > 3
                              ? null
                              : "Username must be atleast 4 characters long";
                        },
                        onSaved: (value) {
                          _userName = value;
                        },
                        controller: userNameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: "Username",
                        ),
                        keyboardType: TextInputType.text,

                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (val) {
                        return val.length > 6
                            ? null
                            : "Password must be 6 characters long";
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      controller: passwordController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if (_isLogin)
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    SizedBox(
                      height: 30.0,
                    ),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: Text(
                          _isLogin ? "SignIn" : "SignUp",
                        ),
                        splashColor: Colors.lightGreenAccent,
                        onPressed: _trySubmit,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLogin && !widget.isLoading) DividerLine(),
          if (_isLogin && !widget.isLoading)
            MaterialButton(
              onPressed: () => {},
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage('images/google_icon.png'),
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Signin with google',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          if (_isLogin)
            SizedBox(
              height: 40,
            ),
          if (!widget.isLoading)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text(
                  _isLogin
                      ? 'Don\'t have an account? SignUp '
                      : 'I already have an account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
