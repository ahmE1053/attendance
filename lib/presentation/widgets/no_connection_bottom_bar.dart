import 'package:flutter/material.dart';

class NoConnectionBottomBar extends StatelessWidget {
  const NoConnectionBottomBar(
    this.height, {
    Key? key,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.black87,
      ),
      padding: const EdgeInsets.all(20),
      child: const FittedBox(
        child: Text(
          'هناك مشكلة في الاتصال بالشبكة، برجاء التحقق من اتصال الانترنت لديك',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
