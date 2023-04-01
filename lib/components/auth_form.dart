import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exceptions.dart';
import '../models/auth.dart';

enum AuthenticationMode { signUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthenticationMode authMode = AuthenticationMode.login;

  bool isHiddenPass = true;
  bool isHiddenCheck = true;
  bool isLoading = false;

  Map<String, String> authData = {
    'email': '',
    'password': '',
  };

  bool get _isLogin => authMode == AuthenticationMode.login;

  bool get _isSignUp => authMode == AuthenticationMode.signUp;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin) {
        authMode = AuthenticationMode.signUp;
      } else {
        authMode = AuthenticationMode.login;
      }
    });
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() => isLoading = true);

    _formKey.currentState?.save();

    Authentication auth = Provider.of(context, listen: false);

    try {
      if (_isLogin) {
        await auth.login(
          authData['email']!,
          authData['password']!,
        );
      } else {
        await auth.signup(
          authData['email']!,
          authData['password']!,
        );
      }
    } on AuthExceptions catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Sorry, an unexpected error has occured!');
    }

    setState(() => isLoading = false);
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        icon: const Icon(Icons.error),
        iconColor: Colors.red,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        // height: 305,
        width: deviceWidth * .75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (email) => authData['email'] = email ?? '',
                validator: (value) {
                  final email = value ?? '';
                  final RegExp exp = RegExp(r'^[\w-\.]+@[\w-\.]+\.[a-z]{2,3}$');
                  if (!exp.hasMatch(email)) {
                    return 'Enter a valid email address!';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '*********',
                  suffixIcon: InkWell(
                    child: Icon(
                      isHiddenPass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onTap: () {
                      setState(() {
                        isHiddenPass = !isHiddenPass;
                      });
                    },
                  ),
                ),
                obscureText: isHiddenPass,
                onSaved: (password) => authData['password'] = password ?? '',
                validator: _isLogin
                    ? null
                    : (value) {
                        final password = value ?? '';
                        final RegExp exp =
                            RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}');
                        if (password.length < 5 || !exp.hasMatch(password)) {
                          return 'Must have at least 5 characters, 1 capital letter and 1 number.';
                        }
                        return null;
                      },
              ),
              if (_isSignUp)
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Confirm Your Password',
                    hintText: '*********',
                    suffixIcon: InkWell(
                      child: Icon(
                        isHiddenCheck ? Icons.visibility_off : Icons.visibility,
                      ),
                      onTap: () {
                        setState(() {
                          isHiddenCheck = !isHiddenCheck;
                        });
                      },
                    ),
                    // Icon(Icons.visibility_off),
                  ),
                  obscureText: isHiddenCheck,
                  validator: (value) {
                    final password = value ?? '';
                    if (password != _passwordController.text) {
                      return 'The passwords don\'t match!';
                    }

                    return null;
                  },
                ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        _isLogin ? 'Login' : 'Sign Up',
                      ),
                    ),
              // const Spacer(),
              const SizedBox(height: 40),
              _isLogin
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have account?'),
                        TextButton(
                          onPressed: _switchAuthMode,
                          child: const Text('Sign up!'),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Have account?'),
                        TextButton(
                          onPressed: _switchAuthMode,
                          child: const Text('Login!'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
