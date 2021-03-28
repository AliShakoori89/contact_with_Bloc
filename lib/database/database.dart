import 'package:path/path.dart';
import 'package:phonebook_with_bloc/model/contact_model.dart';
import 'package:sqflite/sqflite.dart';


final table = 'my_table';

final columnId = 'id';
final columnName = 'name';
final columnLastname = 'lastname';
final columnEmail = 'email';
final columnPhone = 'phone';
final columnImg = 'img';
final columnLatitude = 'latitude';
final columnLongitude = 'longitude';


class DatabaseHelper {

  DatabaseHelper();

  static const databaseName = 'MyDatabase.db';
  static final DatabaseHelper instance = DatabaseHelper (
  );
  static Database _database;


  Future<Database> get database async {
    if(_database == null){
      return await _initDatabase (
      );
    }
    return _database;
  }

  _initDatabase() async {
    return await openDatabase (
        join (
            await getDatabasesPath (
            ),databaseName),
        version: 1,onCreate: (Database db,int version) async {
      await db.execute (
          'CREATE TABLE $table ( '
              ' $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,'
              ' $columnName TEXT NOT NULL ,'
              ' $columnLastname TEXT NOT NULL ,'
              ' $columnPhone TEXT ,'
              ' $columnEmail TEXT ,'
              ' $columnImg TEXT ,'
              ' $columnLatitude REAL ,'
              ' $columnLongitude REAL)');
    });
  }

  Future<bool> saveContact(Contact contact) async {
    var myContact = await database;
    await myContact.insert (
        Contact.TABLENAME,contact.toMap (
    ),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print (
        'aaaaaaaaaaaaaaaaaaaaaaa${contact.toMap (
        )}');
    return true;
  }

  Future<List> getAllContacts() async {
    var myContact = await database;
    List listMap = await myContact.rawQuery (
        'SELECT * FROM my_table');
    var listContact = <Contact>[];
    for (Map m in listMap) {
      listContact.add (
          Contact.fromMap (
              m));
    }
    return listContact;
  }

  getContact(int id) async {
    var myContact = await database;
    var result = await myContact.query ("my_table", where:"$columnId=?",whereArgs: [id]);
    print(result);
    return  Contact.fromMap (result.first) ;
  }

  Future close() async {
    var myContact = await instance.database;
    return myContact.close (
    );
  }

  Future<int> deleteContact(int id) async {
    print("id is too delete");
    print(id);
    var dbContact = await database;
    return await dbContact.delete("my_table", where: '$columnId = ?', whereArgs: [id]);
  }

  updateContact(Contact person) async {
    var myContact = await database;
    await myContact.update (
        Contact.TABLENAME,
        person.toMap (
        ),
        where: "id=?",whereArgs: [person.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}


