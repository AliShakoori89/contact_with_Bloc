import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';

class ContactDetails extends StatelessWidget {

  const ContactDetails({Contact contact});

  @override
  Widget build(BuildContext context) {
    final contactBloc = BlocProvider.of<ContactBloc>(context);
    contactBloc.add(FetchContactsEvent());
    return BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
      if (state is ContactIsLoadedState) {
        // return ContactDetailsView(context, state.getContact);
      }
    });
  }

  Widget ContactDetailsView(context,contacts) {
    return Stack (
      alignment: Alignment.center,
      children: <Widget>[
        // background image and bottom contents
        Column (
          children: <Widget>[
            Stack (
              children: [
                Container (
                  height: 200.0,
                  width: 400.0,
                  decoration: BoxDecoration (
                    border: Border.all (
                    ),
                    borderRadius: BorderRadius.circular (
                        20.0),
                    image: DecorationImage (
                      image: contacts.imgPath == null
                          ?
                      Image.file (
                          File (
                              contacts.imgPath))
                          :
                      AssetImage (
                          'assets/images/header.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // child: Image.asset('assets/images/header.png', fit: BoxFit.fill,),
                ),
              ],
            ),
            // buildExpanded(context)
          ],
        ),
        // Profile image
        Positioned (
          top: 150.0, // (background container size) - (circle height / 2)
          child: Container (
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration (
              image: DecorationImage (
                  image: AssetImage (
                    'assets/images/User.png',),
                  fit: BoxFit.fill
              ),
              border: Border.all (
                  color: Colors.white,width: 4.0),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}