import 'package:flutter/material.dart';
import 'package:phonebook_with_bloc/view/bottomnavigationbar/call_logs.dart';
import 'package:phonebook_with_bloc/view/bottomnavigationbar/favorite_contacts.dart';
import 'bottomnavigationbar/contacts_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    ContactPage(),
    CallLogs(),
    FavoriteContacts()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.withOpacity(0.5),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.contacts),
                  title: Text('Contact'),
                  backgroundColor: Colors.grey[300]
                  ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_rounded),
                title: Text('Resent'),
                  backgroundColor: Colors.grey[300]
                ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  title: Text('Favorites'),
                backgroundColor: Colors.grey[300]
                  ),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            iconSize: 25,
            onTap: _onItemTapped,
            elevation: 5),
        body: _children[_selectedIndex]);
  }
}
