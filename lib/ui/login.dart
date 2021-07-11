import 'package:carrotmmu/logic/api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:styled_widget/styled_widget.dart';

import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _uid = "";
  String _password = "";
  bool _loading = false;
  InputDecoration _decoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
      filled: true,
      hintText: 'Your ID',
      hintStyle: TextStyle(color: Colors.black.withOpacity(.3)),
      fillColor: Colors.white.withOpacity(.25),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: new BorderRadius.circular(100.0),
      ));

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    MyApp.observer.analytics.setCurrentScreen(
      screenName: '/login',
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (API.isSessionExpired)
        Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Color(0xff5F5637),
          title: "Oops",
          message: "Your session has expired.",
          duration: Duration(seconds: 3),
        )..show(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      // statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    ));

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Add your onPressed code here!
        //   },
        //   elevation: 0,
        //   child: Icon(FeatherIcons.chevronRight, color: Colors.amber),
        //   backgroundColor: Colors.white,
        // ),
        floatingActionButton: (_uid.length < 8 || _password.length < 6)
            ? null
            : FloatingActionButton.extended(
                foregroundColor: Colors.amber,
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  var success = await API.login(_uid, _password);
                  setState(() {
                    _loading = false;
                  });

                  if (!success) {
                    Flushbar(
                      flushbarStyle: FlushbarStyle.GROUNDED,
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Color(0xff5F5637),
                      title: "Oops",
                      message: "Don't feed me with wrong Id/Password.",
                      duration: Duration(seconds: 3),
                    )..show(context);
                  }

                  // if (_formKey.currentState.validate()) {
                  //   // Process data.
                  // }
                },
                elevation: 0,
                label: _loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.amber)))
                    : Row(
                        children: [
                          Text('Login',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Icon(FeatherIcons.chevronRight, color: Colors.amber)
                        ],
                      ),
                // icon: Icon(FeatherIcons.chevronRight, color: Colors.amber),
                backgroundColor: Colors.white,
              ),
        body: Container(
            width: double.infinity,
            color: Colors.amber.shade100,
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                        child: Image(image: AssetImage('assets/icon/icon.png')))
                    .height(100)
                    .clipRRect(all: 35)
                    .boxShadow(
                        color: Colors.amber.shade800.withOpacity(.5),
                        blurRadius: 45,
                        offset: Offset(0, 10))
                    .padding(bottom: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                        decoration: _decoration,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {
                            _uid = text;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                        obscureText: true,
                        decoration: _decoration.copyWith(hintText: "Password"),
                        onChanged: (text) {
                          setState(() {
                            _password = text;
                          });
                        },
                      ),
                    ],
                  ),
                ).constrained(maxWidth: 200),
                FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          backgroundColor: Colors.amber[50],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          title: Text('CarrotMMU')
                              .textColor(Colors.black.withOpacity(.9))
                              .fontWeight(FontWeight.bold),
                          content: Container(
                              child: Text(
                                      'This app is created by mmu student. The account credentials that you provided will be used to fill up our carrot. We use your credentials to help you pay camsys fees, resource fees. And with your credentials, we can now help you reply email of your dear lecturers. Besides that, we also use your credentials to help you sign attendance in case you missed out your class. We also will help you submit MMLS assignment and do some quizzes if you allow us to do so. Thanks for using us! - the Carrot')
                                  .textColor(Colors.black.withOpacity(.8))
                                  .textAlignment(TextAlign.start)),
                        ));
                  },
                  child: Text('T&C'),
                )
              ],
            )),
      ),
    );
  }
}
