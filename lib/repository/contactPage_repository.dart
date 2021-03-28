import 'package:phonebook_with_bloc/database/database.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';

class ContactRepository {
  Future<List> getAllContactsRepo() async {
    var helper = DatabaseHelper();

    return await helper.getAllContacts();
  }

  Future<Contact> getContactRepo(int id) async {
    var helper = DatabaseHelper();
    print("hi id is ");
    print(id);
    return await helper.getContact(id);
  }

  Future<bool> saveContactRepo(Contact contact) async {
    var helper = DatabaseHelper();
    return await helper.saveContact(contact);
  }

  Future<int> deleteContactRepo(int id) async {
    print('deleteContactRepo id ');
    print(id);
    var helper = DatabaseHelper();
    return await helper.deleteContact(id);
  }

  Future<int> updateContactRepo(Contact contact) async {
    var helper = DatabaseHelper();
    return await helper.updateContact(contact);
  }

  Future closeRepo() async {
    var helper = DatabaseHelper();
    helper.close();
  }
}
