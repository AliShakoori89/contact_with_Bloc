import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:flutter/services.dart';


class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _lastNameFormKey = GlobalKey<FormState>();
  File _image;
  final imagePicker = ImagePicker();
  Contact _editedContact;

  bool isValid = false;

  Future _getFromCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }

  Future _getFromGallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    // body: BlocProvider(
    //   create: (BuildContext context) => ContactBloc(ContactRepository()),
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Container(
                height: 200.0,
                width: 400.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: AssetImage('assets/images/header.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Image.asset('assets/images/header.png', fit: BoxFit.fill,),
              ),
              buildSafeArea(context),
            ],
          ),
          // Profile image
          Positioned(
            top: 150.0, // (background container size) - (circle height / 2)
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: _image == null
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
                            image: FileImage(_image),
                            fit: BoxFit.fill)),
                  )
                  // Image.file(_image),
              ),
            ),
          )
        ],
      ),
    );
  }


  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  SafeArea buildSafeArea(BuildContext context) {
    return SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 14),
                    TextFieldClass(
                      formKey: _nameFormKey,
                      controller: _nameController,
                      hintText: 'Name',
                      alarmText: 'Name',
                      icon: Icons.person,
                    ),

                    ///name
                    TextFieldClass(
                      formKey: _lastNameFormKey,
                      controller: _lastNameController,
                      hintText: 'LastName',
                      alarmText: 'LastName',
                      icon: Icons.person,
                    ),

                    ///lastname
                    TextFieldClass(
                      controller: _emailsController,
                      hintText: 'Email',
                      alarmText: 'Email',
                      icon: Icons.email,
                    ),

                    ///email
                    TextFieldClass(
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      controller: _phoneController,
                      hintText: 'PhoneNumber',
                      alarmText: 'PhoneNumber',
                      icon: Icons.phone,
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),

            ///phone
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.height / 100,
                ),
                child: Container(
                    width: 45,
                    child: FloatingActionButton(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                "assets/images/header.png",
                              ),
                            ),
                            Center(child: Icon(Icons.save)),
                          ],
                        ),
                        onPressed: () {
                          if (_nameFormKey.currentState.validate() &&
                              _lastNameFormKey.currentState.validate()) {
                            Contact contact = Contact();
                            contact.name = this._nameController.text;
                            contact.lastname = this._lastNameController.text;
                            contact.phone = this._phoneController.text;
                            contact.email = this._emailsController.text;
                            contact.imgPath = _image.path;
                            final contactBloc =
                                BlocProvider.of<ContactBloc>(context);
                            contactBloc.add(AddContactEvent(contact));
                            Navigator.pop(context);
                          }
                        }
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextFieldClass extends StatefulWidget {
  final controller;
  final hintText;
  final alarmText;
  final icon;
  final formKey;
  final maxLength;
  final keyboardType;
  final inputFormatters;

  const TextFieldClass(
      {this.controller,
      this.hintText,
      this.alarmText,
      this.icon,
      this.formKey,
      this.maxLength,
      this.keyboardType,
      this.inputFormatters});

  @override
  _TextFieldClassState createState() => _TextFieldClassState(
      controller,
      hintText,
      alarmText,
      icon,
      formKey,
      maxLength,
      keyboardType,
      inputFormatters);
}

class _TextFieldClassState extends State<TextFieldClass> {
  final controller;
  final hintText;
  final alarmText;
  final icon;
  final formKey;
  final maxLength;
  final keyboardType;
  final inputFormatters;

  _TextFieldClassState(
      this.controller,
      this.hintText,
      this.alarmText,
      this.icon,
      this.formKey,
      this.maxLength,
      this.keyboardType,
      this.inputFormatters);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      width: MediaQuery.of(context).size.height / 2.5,
      child: Form(
          key: formKey,
          child: TextFormField(
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            maxLength: maxLength,
            cursorColor: Colors.deepOrange,
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter $alarmText';
              }
              return null;
            },
            autocorrect: false,
            decoration: InputDecoration(
              enabledBorder: new UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[850])),
              hintText: hintText,
              hintStyle: (TextStyle(color: Colors.grey[600])),
              icon: Icon(
                icon,
                color: Colors.grey[850],
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
            ),
          )),
    );
  }
}
