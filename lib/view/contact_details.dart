import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:phonebook_with_bloc/view/edit_page.dart';
import 'package:phonebook_with_bloc/view/home_page.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;

  const ContactDetails(this.contact);

  @override
  ContactDetailsState createState() => ContactDetailsState(contact);
}

class ContactDetailsState extends State<ContactDetails> {
  final Contact contact;
  Contact _editedContact;

  ContactDetailsState(this.contact);

  @override
  void initState() {
    super.initState();
    int isLiked = contact.favorite;
    _editedContact = Contact.fromMap(widget.contact.toMap());
    _editedContact.name = contact.name;
    _editedContact.lastName = contact.lastName;
    _editedContact.email = contact.email;
    _editedContact.phone = contact.phone;
    _editedContact.latitude = contact.latitude;
    _editedContact.longitude = contact.longitude;
  }

  @override
  Widget build(BuildContext context) {
    final contactBloc = BlocProvider.of<ContactBloc>(context);
    contactBloc.add(FetchContactEvent(widget.contact));
    return WillPopScope(
      onWillPop: () async{
        return Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomePage()));
      },
      child: Scaffold(
        body: BlocBuilder<ContactBloc, ContactState>(builder: (context, state) {
          if (state is ContactIsLoadedState) {
            return ContactDetailsView(
                context,
                state.getContact.phone,
                state.getContact.email,
                state.getContact.name,
                state.getContact.lastName,
                state.getContact.imgPath);
          }
          return Center(
          );
        }),
      ),
    );
  }

  Icon setFavoriteIcon() {
    print(contact.favorite);
    if (contact.favorite == 1) {
      contact.favorite = 0;
      return Icon(Icons.star, color: Colors.amber);
    } else {
      contact.favorite = 1;
      return Icon(Icons.star_border, color: Colors.black);
    }
  }

  Widget ContactDetailsView(
      context, phone, String email, String name, String lastname, String img) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                height: MediaQuery.of(context).size.height / 4.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/header.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )
              ,
            ),
            SizedBox(height:  MediaQuery.of(context).size.height/100,),
            Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height/1.8,
                decoration: BoxDecoration(
                    color: Colors.grey[400].withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: setFavoriteIcon(),
                            onPressed: () {
                              final contactBloc = BlocProvider.of<ContactBloc>(context);
                              contactBloc.add(AddContactToFavoriteEvent(contact));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new EditedtPage(contact: widget.contact)));
                            },),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30,
                        left: MediaQuery.of(context).size.height / 50,
                        right:  MediaQuery.of(context).size.height / 50,
                      ),
                      child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height /10,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone_android_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                        width: MediaQuery.of(context).size.height / 20),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Mobile',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey)),
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height / 200),
                                        Text(
                                          '$phone',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.height / 40,),
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      UrlLauncher.launch(
                                          "tel:${widget.contact.phone}");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 50,
                        left: MediaQuery.of(context).size.height / 50,
                        right:  MediaQuery.of(context).size.height / 50,
                      ),
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height /10,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.height / 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Email',style: TextStyle(fontSize: 12.0,color: Colors.grey)),
                                      SizedBox(height: MediaQuery.of(context).size.height / 200),
                                      Text('$email',style: TextStyle(fontSize: 15,color: Colors.black),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.height / 40,),
                                child: GestureDetector(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      )
                                  ),
                                  onTap: () async {
                                    _launchURL('$email', '', '');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 50,
                        left: MediaQuery.of(context).size.height / 50,
                        right:  MediaQuery.of(context).size.height / 50,
                      ),
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height /10,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.height / 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Location',
                                          style: TextStyle(fontSize: 12.0,color: Colors.grey)),
                                      SizedBox(height: MediaQuery.of(context).size.height / 200),
                                      Text('----------->',style: TextStyle(fontSize: 15,color: Colors.black),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.height / 40,
                                ),
                                child: GestureDetector(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () async {
                                      final availableMaps = await MapLauncher.installedMaps;
                                      await availableMaps.first.showMarker(
                                        coords: Coords(
                                            widget.contact.latitude,
                                            widget.contact.longitude),
                                        title: "Ocean Beach",
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        // Profile image
        Container(
          alignment: Alignment(0.0, -0.6),
          child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: img == null
                  ? Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: AssetImage('assets/images/User.png'),
                        fit: BoxFit.fill)),
              )
                  : Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: Image.file(File(img)).image,
                        fit: BoxFit.fill)),
              )
            // Image.file(_image),
          ),
        )
      ],
    );
  }

  void _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
