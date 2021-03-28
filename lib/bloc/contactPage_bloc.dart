import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:phonebook_with_bloc/repository/contactPage_repository.dart';

class ContactEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ContactState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw [];
}

class FetchContactsEvent extends ContactEvents {}

class AddContactEvent extends ContactEvents {
  final Contact contact;

  AddContactEvent(this.contact);

  @override
  List<Object> get props => [contact];
}

class ContactDetailsContactEvent extends ContactEvents {
  final Contact contact;

  ContactDetailsContactEvent(this.contact);

  @override
  List<Object> get props => [contact];
}

class EditContactEvent extends ContactEvents{
  final Contact contact;

  EditContactEvent(this.contact);

  @override
  List<Object> get props => [contact];
}

class DeleteContactEvent extends ContactEvents{
  final Contact contact;

  DeleteContactEvent(this.contact);
  @override
  List<Object> get props => [contact];
}

class FetchContactEvent extends ContactEvents{
  final Contact contact;

  FetchContactEvent(this.contact);
  @override
  List<Object> get props => [contact];
}

class ContactsIsLoadedState extends ContactState {
  final _contacts;

  ContactsIsLoadedState(this._contacts);

  List<Contact> get getContacts => _contacts;

  @override
  List<Object> get props => [_contacts];
}

class ContactIsLoadedState extends ContactState {
  final _contact;

  ContactIsLoadedState(this._contact);

  Contact get getContact => _contact;

  @override
  List<Object> get props => [_contact];
}

class ContactIsNotLoadedState extends ContactState {}

class ContactBloc extends Bloc<ContactEvents, ContactState> {
  ContactRepository contactRepo;

  ContactBloc(this.contactRepo) : super(ContactIsNotLoadedState());

  @override
  Stream<ContactState> mapEventToState(ContactEvents event) async* {
    if(event is AddContactEvent){
      print("bloc save is called");
     await contactRepo.saveContactRepo(event.contact);
     List<Contact> contacts  = await contactRepo.getAllContactsRepo();
     yield ContactsIsLoadedState(contacts);
      print("bloc save is finished");
    }
    if (event is FetchContactsEvent) {
      List<Contact> contacts = await contactRepo.getAllContactsRepo();
      yield ContactsIsLoadedState(contacts);
    }
    if (event is EditContactEvent) {
      await contactRepo.updateContactRepo(event.contact);
      List<Contact> contacts = await contactRepo.getAllContactsRepo();
      yield ContactsIsLoadedState(contacts);
    }
    if (event is DeleteContactEvent) {
      print("DeleteContactEvent in contactpage bloc");
      await contactRepo.deleteContactRepo(event.contact.id);
      List<Contact> contacts = await contactRepo.getAllContactsRepo();
      yield ContactsIsLoadedState(contacts);
    }
    if (event is FetchContactEvent) {
      print("Fetch in contactpage bloc");
      Contact contact = await contactRepo.getContactRepo(event.contact.id);
      yield ContactIsLoadedState(contact);
    }
  }
}
