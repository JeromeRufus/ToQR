import 'package:flutter/material.dart';

class sliderMenu extends StatefulWidget {
  const sliderMenu({ Key? key }) : super(key: key);

  @override
  State<sliderMenu> createState() => _sliderMenuState();
}

class _sliderMenuState extends State<sliderMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
          )
        ],
      ),
      
    );
  }
}