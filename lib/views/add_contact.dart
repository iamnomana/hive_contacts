import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_contacts/models/contact_model.dart';

class AddContact extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final String contactsBoxName = "contacts";
  String name;
  int age;
  String phoneNumber;
  Relationship relationship;

  void onFormSubmit() {
    Box<Contact> contactsBox = Hive.box<Contact>(contactsBoxName);
    contactsBox.add(Contact(name, age, phoneNumber, relationship));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: "",
                    maxLength: 3,
                    maxLengthEnforcement: null,
                    decoration: const InputDecoration(
                      labelText: "Age",
                    ),
                    validator: (val) {
                      return val == null ? "This field is required" : null;
                    },
                    onChanged: (value) {
                      setState(() {
                        age = int.parse(value);
                      });
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: "",
                    decoration: const InputDecoration(
                      labelText: "Phone",
                    ),
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                    validator: (val) {
                      return val == null ? "This field is required" : null;
                    },
                  ),
                  DropdownButton<Relationship>(
                    items: relationshipString.keys.map((Relationship value) {
                      return DropdownMenuItem<Relationship>(
                        value: value,
                        child: Text(relationshipString[value]),
                      );
                    }).toList(),
                    value: relationship,
                    hint: Text("Relationship"),
                    onChanged: (value) {
                      setState(() {
                        relationship = value;
                      });
                    },
                  ),
                  TextButton(
                    child: Text("Submit"),
                    onPressed: onFormSubmit,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue,
                      ),
                      // shape:
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
