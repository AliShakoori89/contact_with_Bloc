import 'package:phonebook_with_bloc/database/database.dart';

class Contact {
  int id;
  String name;
  String lastname;
  String email;
  String phone;
  String imgPath;
  double latitude;
  double longitude;

  Contact(
      {this.id,
      this.name,
      this.lastname,
      this.email,
      this.phone,
      this.imgPath,
      this.latitude,
      this.longitude});

  static const String TABLENAME = "my_table";

  Contact.Map(dynamic Contact) {
    this.id = Contact['id'];
    this.name = Contact['name'];
    this.lastname = Contact['lastname'];
    this.email = Contact['email'];
    this.phone = Contact['phone'];
    this.imgPath = Contact['img'];
    this.latitude = Contact['latitude'];
    this.longitude = Contact['longitude'];
  }

  Contact.fromMap(Map map) {
    id = map[columnId];
    name = map[columnName];
    lastname = map[columnLastname];
    email = map[columnEmail];
    phone = map[columnPhone];
    imgPath = map[columnImg];
    latitude = map[columnLatitude];
    longitude = map[columnLongitude];
  }

  Contact.MaptoObject(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    lastname = map['lastname'];
    email = map['email'];
    phone = map['phone'];
    imgPath = map['img'];
    latitude = map['latitude'];
    longitude = map['longitude'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'img': imgPath,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
