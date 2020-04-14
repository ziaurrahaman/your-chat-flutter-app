import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_chat_flutter_app/screens/home_screen.dart';
import 'package:your_chat_flutter_app/screens/home_screen2.dart';
import 'package:your_chat_flutter_app/screens/set_profile_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';

enum AuthMode { SignUp, Login }

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    Widget logo() {
      return Positioned(
        top: 60,
        left: 160,
        child: Image.asset('assets/images/messenger_logo.png'),
        height: 80,
        width: 80,
      );
    }

    Widget logoText() {
      return Positioned(
        top: 130,
        left: 145,
        child: Text(
          'Your Chat',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget colorPortion() {
      return Positioned(
        top: 0,
        child: Container(
          height: height * 0.30,
          width: width,
          decoration: BoxDecoration(
            color: Color(0xFF24D39D),
            // color: Color(0xff),
            borderRadius: BorderRadius.only(
                // bottomLeft: Radius.circular(100),
                // bottomRight: Radius.circular(120),
                ),
          ),
        ),
      );
    }

    // Widget colorBackground() {
    //   return Positioned(
    //       top: 420,
    //       child: Container(
    //         height: 100,
    //         width: MediaQuery.of(context).size.width,
    //         decoration: BoxDecoration(
    //           color: Colors.red,
    //           borderRadius: BorderRadius.only(
    //               bottomRight: Radius.circular(120),
    //               bottomLeft: Radius.circular(120),
    //               topRight: Radius.circular(120)),
    //         ),
    //       ));
    // }

    // Widget emailPasswordPortion() {
    //   return;
    // }

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: Color(0xFF24D39D),
              // color: Color.fromARGB(255, 255, 191, 128),
            ),
            colorPortion(),
            logo(),
            logoText(),
            // colorBackground(),
            AuthenticationForm(width: width, height: height)
          ],
        ),
      ),
    );
  }
}

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({
    Key key,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm>
    with SingleTickerProviderStateMixin {
  var passwordTextfieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _auth = FirebaseAuth.instance;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.linear, parent: _controller));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.0), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    setProgressDialogue();
  }

  setProgressDialogue() {
    progressDialog = new ProgressDialog(context);
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    progressDialog.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    progressDialog.show();

    try {
      if (_authMode == AuthMode.SignUp) {
        final response = await _auth.createUserWithEmailAndPassword(
            email: _authData['email'], password: _authData['password']);
        if (response != null) {
          print('Singup button is clicked');
          progressDialog.hide();
          Navigator.of(context).pushNamed(SetProfileScreen.routeName);
        }
      } else {
        final response = await _auth.signInWithEmailAndPassword(
            email: _authData['email'], password: _authData['password']);

        if (response != null) {
          print('login button is clicked');
          progressDialog.hide();
          Navigator.of(context).pushNamed(YourChatHomeScreen.routeName);
        }
      }
    } catch (error) {
      print(error.toString());
      print('log in button is clicked');
    }
  }

  void switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: widget.width,
        height: widget.height * 0.70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                // topRight: Radius.circular(120),
                topLeft: Radius.circular(120))),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              _authMode == AuthMode.SignUp ? 'SignUp Here' : 'LogIn Here',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
              key: _formKey,
              // child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 10,
                      bottom: 10,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (value) {
                        String errorMessage;
                        if (value.isEmpty || !value.contains('@')) {
                          errorMessage = 'Invaid email !';
                        }
                        return errorMessage;
                      },
                      onSaved: (value) {
                        _authData['email'] = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 10,
                      bottom: 10,
                    ),
                    child: TextFormField(
                      controller: passwordTextfieldController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(hintText: 'password'),
                      validator: (value) {
                        String errorMessage;
                        if (value.length <= 5) {
                          errorMessage =
                              'Password must be atleast 6 character long';
                        }

                        if (value.isEmpty) {
                          errorMessage = 'Password must not be null';
                        }
                        return errorMessage;
                      },
                      onSaved: (value) {
                        _authData['password'] = value;
                      },
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.linear,
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                        maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 10,
                        bottom: 10,
                      ),
                      child: FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            enabled: _authMode == AuthMode.SignUp,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration:
                                InputDecoration(hintText: 'confirm password'),
                            validator: _authMode == AuthMode.SignUp
                                ? (value) {
                                    String errorMessage;
                                    if (value !=
                                        passwordTextfieldController.text) {
                                      errorMessage = 'Password not matched';
                                    }
                                    return errorMessage;
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: _authMode == AuthMode.SignUp
                  ? Text(
                      'SignUp',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'LogIn',
                      style: TextStyle(color: Colors.white),
                    ),
              color: Color(0xFF24d39d),
              onPressed: _submit,
            ),
            SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: _authMode == AuthMode.SignUp
                        ? 'Already have an account? '
                        : 'Do not have an account? ',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                TextSpan(
                    text: _authMode == AuthMode.SignUp
                        ? 'Login here.'
                        : 'SignUp here.',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0),
                    recognizer: TapGestureRecognizer()..onTap = switchAuthMode)
              ]),
            )
          ],
        ),
      ),
    );
  }
}
