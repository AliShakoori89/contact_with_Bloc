import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:phonebook_with_bloc/view/card_view.dart';
import 'package:phonebook_with_bloc/view/home_page.dart';

class FavoriteContacts extends StatefulWidget {
  final Contact contact;

  const FavoriteContacts({Key key, this.contact}) : super(key: key);

  @override
  _FavoriteContactsState createState() => _FavoriteContactsState(contact);
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  Contact contact;
  _FavoriteContactsState(this.contact);

  @override
  Widget build(BuildContext context) {
    final contactBloc = BlocProvider.of<ContactBloc>(context);
    contactBloc.add(FetchFavoriteContactEvent(contact));
    return BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
    if (state is ContactsIsLoadedState) {
    print("state is loading");
    return Scaffold(
      backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.grey[300].withOpacity(0.5),
            title: Center(
              child: Text(
                'Favorit Contacts',
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            )
          ),
          body: WillPopScope(
              child: contactsListViewBuilder(context, state.getContacts)),
        );
      }
    return Container(
      color: Colors.white,
      child: Text("oops nothing here", style: TextStyle(color: Colors.white12,fontSize: 14.0),),
    );});}

  Widget contactsListViewBuilder(context, contacts) {
      return Center(
        child: Container(
            width: MediaQuery.of(context).size.width/1.05,
            height: MediaQuery.of(context).size.height / 1.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[400].withOpacity(0.5),
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
      );
  }
}