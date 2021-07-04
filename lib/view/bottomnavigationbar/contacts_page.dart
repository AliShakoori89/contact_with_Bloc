import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:phonebook_with_bloc/view/add_page.dart';
import 'package:phonebook_with_bloc/view/card_view.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  @override
  Widget build(BuildContext context) {
    print("Contact page is loading");
    final contactBloc = BlocProvider.of<ContactBloc>(context);
    contactBloc.add(FetchContactsEvent());
    return BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
      if (state is ContactsIsLoadedState) {
        print("state is loading");
        return Scaffold(
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
                                builder: (context) => new AddEditPage()));
                      })
                ],
              )
            ],
          ),
          body: contactsListViewBuilder(context, state.getContacts),
        );
      }
      return Container(
        color: Colors.white,
        child: Text("oops nothing here", style: TextStyle(color: Colors.white12,fontSize: 14.0),),
      );
    });
  }

  Widget contactsListViewBuilder(context, contacts) {
    return Container(
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
    );
  }
}

