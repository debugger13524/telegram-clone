import 'package:flutter/material.dart';
import 'package:telegramclone/screens/chatRoomScreen.dart';
import 'package:telegramclone/services/auth.dart';
import 'package:telegramclone/services/database.dart';



class Signup extends StatefulWidget {

  final Function toggle;

  Signup(this.toggle);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods=AuthMethods();
  DatabaseMethods databaseMethods=DatabaseMethods();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String,String> userInfoMap={
        "name":usernameController.text,
        "email":emailController.text,

      };
      setState(() {
        isLoading = true;
      });

      databaseMethods.uploadUserInfo(userInfoMap);
      authMethods.signUpWithEmailAndPassword(emailController.text, passwordController.text).then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoomScreen()));
      });
    }
  }
  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("images/background_image.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Container(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
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
                        Text(
                          'SignUp with email',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        Form(
                          key: formKey,
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
                                  TextFormField(

                                    validator: (val) {
                                      return val.isEmpty
                                          ? "Please enter valid user name"
                                          : null;
                                    },
                                    controller: usernameController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(

                                      labelText: 'Username',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)
                                          ? null
                                          : "Enter valid email address";
                                    },
                                    controller: emailController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'abc@gmail.com',
                                      labelText: 'Email',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  TextFormField(
                                    validator: (val) {
                                      return val.length > 6
                                          ? null
                                          : "Password must be 6 characters long";
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
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  MaterialButton(
                                    color: Colors.teal,
                                    textColor: Colors.white,
                                    child: Text(
                                      "SignUp",
                                    ),
                                    splashColor: Colors.lightGreenAccent,
                                    onPressed: signMeUp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _divider(),
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
                                'SignUp with google',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: (){
                            widget.toggle();
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Already have an account? SignIn ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white70,
                thickness: 1,
              ),
            ),
          ),
          Text(
            'or',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
