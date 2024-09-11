import 'colorPalette.dart';
// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class cashierPage extends StatefulWidget {
  const cashierPage({super.key});

  @override
  State<cashierPage> createState() => _cashierPage();
}

class _cashierPage extends State<cashierPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorPalette.color1,
      body: Text("Cashier Page",style: TextStyle(color: ColorPalette.color4),),
    );
  }
}