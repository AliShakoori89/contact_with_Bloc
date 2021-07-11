import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/map_screen.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:flutter/services.dart';

class AddEditPage extends StatefulWidget {
  final Contact contact;

  AddEditPage({this.contact});

  @override
  AddEditPageState createState() => AddEditPageState();
}

class AddEditPageState extends State<AddEditPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _lastNameFormKey = GlobalKey<FormState>();
  Contact _editedContact;
  bool userEdited = false;
  File imageFile;
  final imagePicker = ImagePicker();

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }

    _nameController.text = _editedContact.name;
    _lastNameController.text = _editedContact.lastName;
    _emailsController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  Future getFromCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image.path);
    });
  }

  Future getFromGallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 4.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/header.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height:  MediaQuery.of(context).size.height/100 ,),
                buildSafeArea(context),
              ],
            ),
          ),
          // Profile image
          Positioned(
            top: MediaQuery.of(context).size.height / 6,
            child: GestureDetector(
              onTap: () {
                showPicker(context);
              },
              child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: imageFile == null
                      ? Container(
                          width: MediaQuery.of(context).size.height / 8,
                          height: MediaQuery.of(context).size.height / 8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: AssetImage('assets/images/User.png'),
                                  fit: BoxFit.fill)),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.height / 9,
                          height: MediaQuery.of(context).size.height / 9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: FileImage(imageFile),
                                  fit: BoxFit.fill)),
                        )),
            ),
          )
        ],
      ),
    );
  }

  showPicker(context) {
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
                        getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Container buildSafeArea(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Colors.grey[400].withOpacity(0.5),
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 14),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 60),
            child: TextFieldClass(
              type: 'name',
              formKey: _nameFormKey,
              controller: _nameController,
              hintText: 'Name',
              alarmText: 'Name',
              icon: Icons.person,
              userEdited: true,
            ),
          ),

          ///name
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 60),
            child: TextFieldClass(
              type: 'lastName',
              formKey: _lastNameFormKey,
              controller: _lastNameController,
              hintText: 'LastName',
              alarmText: 'LastName',
              icon: Icons.person,
              userEdited: true,
            ),
          ),

          ///lastname
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 60),
            child: TextFieldClass(
              type: 'email',
              controller: _emailsController,
              hintText: 'Email',
              alarmText: 'Email',
              icon: Icons.email,
              userEdited: true,
            ),
          ),

          ///email
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 60),
            child: TextFieldClass(
              keyboardType: TextInputType.number,
              maxLength: 11,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              type: 'phone',
              controller: _phoneController,
              hintText: 'PhoneNumber',
              alarmText: 'PhoneNumber',
              icon: Icons.phone,
              userEdited: true,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 60,
                top: MediaQuery.of(context).size.height / 20,
                bottom: MediaQuery.of(context).size.height / 100),
            child: GestureDetector(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 100),
                    child: Icon(Icons.add_location_alt),
                  ),
                  Text('   Add Route ->      '),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        image: DecorationImage(
                            image: AssetImage('assets/images/mapRoute.jpg'),
                            fit: BoxFit.fill)),
                    width: MediaQuery.of(context).size.height / 7,
                    height: MediaQuery.of(context).size.height / 25,
                    // child: Icon(
                    //   Icons.add_location_alt ,
                    //   color: Colors.grey[850]),
                  ),
                ],
              ),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapScreen()));
              },
            ),
          ),

          ///phone
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 10,
                  right: MediaQuery.of(context).size.width / 15,
                ),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.save, color: Colors.white,),
                  ),
                  onTap: (){
                    if (_nameFormKey.currentState.validate() &&
                        _lastNameFormKey.currentState.validate()) {
                      Contact contact = Contact();
                      contact.name = this._nameController.text;
                      contact.lastName = this._lastNameController.text;
                      contact.phone = this._phoneController.text;
                      contact.email = this._emailsController.text;
                      if (imageFile != null) {
                        contact.imgPath = imageFile.path;
                      } else {
                        contact.imgPath = null;
                      }
                      contact.favorite = 0;
                      contact.latitude = MapScreenState.latitude;
                      contact.longitude = MapScreenState.longitude;
                      final contactBloc =
                      BlocProvider.of<ContactBloc>(context);
                      contactBloc.add(AddContactEvent(contact));
                      Navigator.pop(context);
                    }
                  },
                )
            ),
          )
        ],
      ),
    );
  }
}

class TextFieldClass extends StatefulWidget {
  final controller;
  final hintText;
  final alarmText;
  final icon;
  final type;
  final formKey;
  final maxLength;
  final keyboardType;
  final inputFormatters;
  final userEdited;

  const TextFieldClass(
      {this.controller,
      this.hintText,
      this.alarmText,
      this.icon,
      this.formKey,
      this.maxLength,
      this.keyboardType,
      this.inputFormatters,
      this.userEdited,
      this.type});

  @override
  _TextFieldClassState createState() => _TextFieldClassState(
      controller,
      hintText,
      alarmText,
      icon,
      formKey,
      maxLength,
      keyboardType,
      inputFormatters,
      userEdited,
      type);
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
  final userEdited;
  final type;
  bool _userEdited = false;
  Contact _editedContact;

  _TextFieldClassState(
      this.controller,
      this.hintText,
      this.alarmText,
      this.icon,
      this.formKey,
      this.maxLength,
      this.keyboardType,
      this.inputFormatters,
      this.userEdited,
      this.type);

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
