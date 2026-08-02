import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  static const name = 'map';
  static const route = '/map';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Map')));
  }
}
