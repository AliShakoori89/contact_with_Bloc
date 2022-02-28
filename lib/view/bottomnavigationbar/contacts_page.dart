import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/view/add_page.dart';
import 'package:phonebook_with_bloc/view/card_view.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    print("Contact page is loading");
    final contactBloc = BlocProvider.of<ContactBloc>(context);
    contactBloc.add(FetchContactsEvent());
    return BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
      if (state is ContactsIsLoadedState) {
        print("state is loading");
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.grey[300].withOpacity(0.5),
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
                        color: Colors.black,
                      ),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.add, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new AddEditPage()));
                      })
                ],
              )
            ],
          ),
          body: WillPopScope(
              child: contactsListViewBuilder(context, state.getContacts),
            onWillPop: _onBackPressed,
          ),
        );
      }
      return Container();
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10.0))
          ),
          title: Text('Confirm'),
          content: Text('Do you want to exit the App'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); //Will not exit the App
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); //Will exit the App
              },
            )
          ],
        );
      },
    ) ?? false;
  }

  Widget contactsListViewBuilder(context, contacts) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[400].withOpacity(0.5),
            borderRadius: BorderRadius.circular(15)
          ),
            child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {

                  return Dismissible(
                      key: Key('item ${contacts[index]}'),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {} else {
                          print('Remove item');
                        }
                      },
                      child: CardView(contacts[index]));
                }
            )
        ),
      ),
    );
  }
}

