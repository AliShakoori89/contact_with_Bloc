import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook_with_bloc/bloc/contactPage_bloc.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:phonebook_with_bloc/view/add_page.dart';

class EditedtPage extends StatefulWidget {
  final Contact contact;
  EditedtPage({this.contact});

  @override
  _EditedtPageState createState() => _EditedtPageState(this.contact);
}

class _EditedtPageState extends State<EditedtPage> {
  final Contact contact;
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _lastNameFormKey= GlobalKey<FormState>();
  bool _userEdited = false;
  Contact _editedContact;
  bool isvalid = false;
  File imageFile;
  final imagePicker = ImagePicker();

  _EditedtPageState(this.contact);

  @override
  void initState() {
    super.initState();

    _editedContact = Contact.fromMap(widget.contact.toMap());

    _nameController.text  = _editedContact.name;
    _lastNameController.text = _editedContact.lastName;
    _emailsController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  Future getFromCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      contact.imgPath = image.path;
    });
  }

  Future getFromGallery() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      contact.imgPath = image.path;
    });
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
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Positioned(// (background container size) - (circle height / 2)
                    child: Container(
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height/4.5,
                      left: MediaQuery.of(context).size.height/2.3,
                    ),
                      child: GestureDetector(
                          child: Icon(Icons.delete),
                      onTap: (){
                        final contactBloc = BlocProvider.of<ContactBloc>(context);
                        contactBloc.add(DeleteContactEvent(this.contact));
                        Navigator.pop(context);
                      },
                      )
                  )
                ],
              ),
              buildExpanded(context)
            ],
          ),
          // Profile image
          Positioned(
            top: 150.0, // (background container size) - (circle height / 2)
            child: GestureDetector(
                  onTap: () {
                    showPicker(context);
                  },
                  child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: contact.imgPath == null
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
                        child: CircleAvatar(
                          radius: 20.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: MediaQuery.of(context).size.height / 2,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Image.file(File(contact.imgPath),fit: BoxFit.fill,),
                            ),
                          ),
                        )
                      )
                    // Image.file(_image),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildExpanded(BuildContext context) {
    return Expanded(
              child: Container(
                width: 500,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/5),
                    TextFieldClass(
                        formKey: _nameFormKey,
                        controller: _nameController,
                        hintText: 'Name',
                        alarmText: 'Name',
                        icon: Icons.person,),
                    SizedBox(height: MediaQuery.of(context).size.height/50),
                    TextFieldClass(
                      formKey: _lastNameFormKey,
                      controller: _lastNameController,
                      hintText: 'LastName',
                      alarmText: 'LastName',
                      icon: Icons.person,),
                    SizedBox(height: MediaQuery.of(context).size.height/50),
                    TextFieldClass(
                      controller: _emailsController,
                      hintText: 'Email',
                      alarmText: 'Email',
                      icon: Icons.email,),
                    SizedBox(height: MediaQuery.of(context).size.height/50),
                    TextFieldClass(
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      controller: _phoneController,
                      hintText: 'PhoneNumber',
                      alarmText: 'PhoneNumber',
                      icon: Icons.phone,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/30,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          child: Icon(Icons.save),
                          onPressed: () {
                            Contact contact = Contact();
                            contact.name = this._nameController.text;
                            contact.lastName = this._lastNameController.text;
                            contact.phone = this._phoneController.text;
                            contact.email = this._emailsController.text;
                            contact.imgPath = contact.imgPath ;
                            final contactBloc = BlocProvider.of<ContactBloc>(context);
                            contactBloc.add(EditContactEvent(_editedContact));
                            Navigator.pop(context);
                          }
                      ),
                    )
                  ],
                ),
              ),
            );
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
          title: Text('Make a Choice: '),
          content : SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                    child: Text('Gallery'),
                    onTap: (){
                      AddEditPageState().getFromCamera();
                    }
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                    child: Text('Camera'),
                    onTap: (){
                      AddEditPageState().getFromCamera();
                    }
                )
              ],
            ),
          )
      );
    }
    );
  }

  Widget _decideImageView(){
    return GestureDetector(
        child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(40.0),
                image: DecorationImage(
                    colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.dstATop),
                    image: _editedContact.imgPath != null
                        ? FileImage(File(_editedContact.imgPath)) :
                    AssetImage('asset/images/User.png'),fit: BoxFit.fill),
              )
          ),
        ),
        onTap: (){
          _showChoiceDialog(context);
        }
    );
  }
}

class TextFieldClass extends StatefulWidget {

  final controller;
  final hintText;
  final alarmText;
  final image;
  final icon;
  final formKey;
  final maxLength;
  final keyboardType;
  final inputFormatters;

  const TextFieldClass({this.controller, this.hintText,
    this.alarmText, this.image, this.icon,
    this.formKey, this.maxLength,
    this.keyboardType, this.inputFormatters});

  @override
  _TextFieldClassState createState() =>
      _TextFieldClassState(controller, hintText, alarmText, image,
          icon, formKey, maxLength, keyboardType, inputFormatters);
}

class _TextFieldClassState extends State<TextFieldClass> {

  final controller;
  final hintText;
  final alarmText;
  final image;
  final icon;
  final formKey;
  final maxLength;
  final keyboardType;
  final inputFormatters;

  bool _userEdited = false;
  Contact _editedContact;

  _TextFieldClassState(this.controller, this.hintText,
      this.alarmText, this.image, this.icon,
      this.formKey, this.maxLength,
      this.keyboardType, this.inputFormatters);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height/3,
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
        )
        ,
      ),
    );
  }
}

