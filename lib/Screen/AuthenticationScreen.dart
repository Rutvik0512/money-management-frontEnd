import 'package:flutter/material.dart';
import 'package:money_management/Payload/Authentication.dart';
import 'package:provider/provider.dart';
import 'dart:math';

enum AuthMode {
  logIn,
  signUp
}

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  AuthMode authMode = AuthMode.logIn;

  @override
   Widget build(BuildContext context) {
    var mediaQuery= MediaQuery.of(context);
    return Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: mediaQuery.size.height,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.lightBlueAccent,
                    Colors.white
                  ],
                  radius: 5
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: mediaQuery.size.height,
                  width: mediaQuery.size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: const Text(
                            'Money Management',
                            style: TextStyle(
                                fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: mediaQuery.size.width > 600 ? 2 : 1,
                        child: AuthCard(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}

class AuthCard extends StatefulWidget {

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _password = FocusNode();
  final _confirmpassword = FocusNode();
  final _email = FocusNode();
  var _obscureText=true;

  AuthMode _authMode = AuthMode.logIn;

  Map<String, String> _authData = {
    'fullName': '',
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async{
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.logIn) {
        await Provider.of<Authentication>(context, listen: false).logIn(_authData);
      } else {
        await Provider.of<Authentication>(context, listen: false).signIn(_authData);
      }
    } catch (error) {
      print(error);
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _visiblePassword(){
    setState(() {
      _obscureText=!_obscureText;
    });
  }

  void _switchAuthMode() {
    _formKey.currentState!.reset();
    _passwordController.clear();
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.signUp ? 330 : 260,
        constraints:
        BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 330 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if(_authMode == AuthMode.signUp)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Full Name'),
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(_email);
                    },
                    validator: (name){
                      if(name!.isEmpty) {
                        return 'Enter Name';
                      }
                    },
                    onSaved: (value){
                      _authData['fullName'] = value!;
                    },
                  ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                  focusNode: _email,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_password),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye_sharp),
                        onPressed: _visiblePassword,
                      )
                  ),
                  obscureText: _obscureText,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  focusNode: _password,
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                  onFieldSubmitted: (_){
                    if(_authMode==AuthMode.logIn) {
                      _submit();
                    }
                    else{
                      FocusScope.of(context).requestFocus(_confirmpassword);
                    }
                  },
                ),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                    }
                        : null,
                    focusNode: _confirmpassword,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child:
                    Text(_authMode == AuthMode.logIn ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.logIn ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


