import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/view/add_page.dart';
import 'package:phonebook_with_bloc/view/card_view.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text('Home Page', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
  //   Text('Search Page', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
  //   Text('Profile Page', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time_rounded),
                title: Text('Resent'),
                backgroundColor: Colors.white70
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                title: Text('Contact'),
                backgroundColor: Colors.white70
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.star),
                title: Text('Favorites'),
                backgroundColor: Colors.white70
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 25,
          onTap: _onItemTapped,
          elevation: 5
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          'All',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        )),
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.add, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new AddPage()));
                  })
            ],
          )
        ],
      ),
      body: ContactPage(),
    );
  }
}

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contactBloc = BlocProvider.of<ContactBloc>(context);
    contactBloc.add(FetchContactsEvent());
    return BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
      if (state is ContactIsLoadedState) {
        print("state is loading");
        return contactsListViewBuilder(context, state.getContacts);
      }
      return Center(
        child: Text("oops nothing here"),
      );
    });
  }

  Widget contactsListViewBuilder(context, contacts) {
    return Container(
        child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              return CardView(contacts[index]);
            }));
  }
}
