import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:phonebook_with_bloc/view/contact_details.dart';
import 'package:phonebook_with_bloc/view/edit_page.dart';

class CardView extends StatelessWidget {
  final Contact contact;

  const CardView(this.contact);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: contact.imgPath == null ? CircleAvatar(
                    radius: 20.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(),
                    ),
                  ) : CircleAvatar(
                    radius: 20.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: MediaQuery.of(context).size.height / 2,
                        child: Image.file(File(contact.imgPath),fit: BoxFit.fill,),
                      ),
                ),
                  ),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height / 50,
                        ),
                        Text(
                          contact.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.height / 80,
                        ),
                        Text(
                          contact.lastName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      onTap: (){
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new ContactDetails(contact)));
      },
      onLongPress: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new EditedtPage(contact: contact)));
      },
    );
  }
}
