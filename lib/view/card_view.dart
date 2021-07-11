import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:phonebook_with_bloc/view/contact_details.dart';
import 'package:phonebook_with_bloc/view/edit_page.dart';

class CardView extends StatefulWidget {
  final Contact contact;
  const CardView(this.contact);

  @override
  _CardViewState createState() => _CardViewState(contact);
}

class _CardViewState extends State<CardView> {
  Contact contact;
  _CardViewState(this.contact);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 80),
        child: Container(
            height: MediaQuery.of(context).size.height /10,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),),
          margin: EdgeInsets.all(MediaQuery.of(context).size.height / 80),
          child: Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.height / 80,),
              Align(
                alignment: Alignment.center,
                child: widget.contact.imgPath == null
                    ? CircleAvatar(
                  radius: 20.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/User.png'),
                              fit: BoxFit.fill)),
                    ),
                  ),
                )
                    : CircleAvatar(
                  radius: 20.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.height / 2,
                      child: Image.file(
                        File(widget.contact.imgPath),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.height / 50,
                  ),
                  Text(
                    widget.contact.name,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height / 80,
                  ),
                  Text(
                    widget.contact.lastName,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
      onTap: (){
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new ContactDetails(widget.contact)));
      },
    );
  }
}
