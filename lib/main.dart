import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_contacts/models/contact_model.dart';
import 'package:hive_contacts/views/contacts_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String contactsBoxName = "contacts";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Contact>(ContactAdapter());
  Hive.registerAdapter<Relationship>(RelationshipAdapter());
  await Hive.openBox<Contact>(contactsBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts App',
      home: Contacts(),
    );
  }
}
