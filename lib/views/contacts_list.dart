import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_contacts/models/contact_model.dart';
import 'package:hive_contacts/views/add_contact.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Contacts extends StatefulWidget {
  Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Box<Contact> _box = Hive.box<Contact>('contacts');
  // var allContacts = <dynamic>[];
  var allContacts;
  // var contactsList;
  //
  final String contactsBoxName = "contacts";
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _box.addAll(allContacts);
    print(_box);
    super.initState();
  }

  void filterSearchResults(String val) {
    // var filteredUsers = box.values.where((user) => user.name.startsWith('d'));
    // print(allContacts.name);
    var filteredUsersSrchList = _box.values;
    print(filteredUsersSrchList);

    if (val.isNotEmpty) {
      filteredUsersSrchList.forEach((element) {
        if (element.name.contains(val.toUpperCase())) {
          print('Yes');
        }
        // print(element.name.contains(val.toUpperCase()));
      });

      // setState(() {
      //   items.clear();
      //   items.addAll(dummyListData);
      // });
    }

    // List<dynamic> contactSearchList = <dynamic>[];

    // contactSearchList.addAll(allContacts.toList());
    // print("contactSearchList: $contactSearchList");

    // if (val.isNotEmpty) {
    //   List<dynamic> contactListData = <dynamic>[];
    //   // print("contactListData: $contactListData");
    //   // return;
    //   contactSearchList.forEach((item) {
    //     print(item.);
    //     print(item.name.contains(val));
    //     print(item.name);
    //     print(val);
    //     // return;
    //     if (item.name == val) {
    //       contactListData.add(item);
    //     }
    //   });
    //   setState(() {
    //     allContacts.clear();
    //     allContacts.addAll(contactListData);
    //   });
    //   return;
    // } else {
    //   setState(() {
    //     allContacts.clear();
    //     allContacts.addAll(allContacts);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Contact>(contactsBoxName).listenable(),
                  builder: (context, box, _) {
                    if (box.values.isEmpty)
                      return Center(
                        child: Text("No contacts"),
                      );
                    allContacts = box.values.toList();
                    // print(allContacts);
                    return ListView.builder(
                      // itemCount: box.values.length,
                      itemCount: allContacts.length,
                      itemBuilder: (context, index) {
                        // Contact currentContact = box.getAt(index);
                        String relationship =
                            relationshipString[allContacts[index].relationship];
                        // print('${allContacts[index]}');
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                      "Do you want to delete ${allContacts[index].name}?",
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: Text("Yes"),
                                        onPressed: () async {
                                          await box.deleteAt(index);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 5),
                                  Text(allContacts[index].name),
                                  SizedBox(height: 5),
                                  Text(allContacts[index].phoneNumber),
                                  SizedBox(height: 5),
                                  Text("Age: ${allContacts[index].age}"),
                                  SizedBox(height: 5),
                                  Text("Relationship: $relationship"),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddContact()));
            },
          );
        },
      ),
    );
  }
}
