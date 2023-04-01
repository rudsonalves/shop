import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 70,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepOrange.shade900,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                transform: Matrix4.rotationZ(-10 * math.pi / 180)
                  ..translate(-5.0),
                child: const Text(
                  'My Shop',
                  style: TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 45,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: double.infinity,
                height: 20,
              ),
              const AuthForm(),
            ],
          ),
        ],
      ),
    );
  }
}
