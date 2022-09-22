import 'package:flutter/material.dart';
import 'package:percistent/helpers/database_helper.dart';

import '../models/cat_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? catid;
  final textControllerRace = TextEditingController();
  final textControllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite example with cats'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: textControllerRace,
              decoration: const InputDecoration(
                  icon: Icon(Icons.view_comfortable),
                  labelText: "Input the race of cat"),
            ),
            TextFormField(
              controller: textControllerName,
              decoration: const InputDecoration(
                  icon: Icon(Icons.text_format_outlined),
                  labelText: "Input the Name of cat"),
            ),
            Center(
              child: (FutureBuilder<List<Cat>>(
                future: DatabaseHelper.instance.getCats(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Cat>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: const Text('Loading...')));
                  } else {
                    return snapshot.data!.isEmpty
                        ? Center(
                            child: Container(
                                child: const Text('No Cats in the list')))
                        : ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.map((cat) {
                              return Center(
                                child: ListTile(
                                  title: Text(
                                      'Name: ${cat.name} | Race: ${cat.race}'),
                                  onLongPress: () {
                                    setState(() {
                                      DatabaseHelper.instance.delete(cat.id!);
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      if (catid == null) {
                                        textControllerName.text = cat.name;
                                        textControllerRace.text = cat.race;
                                        catid = cat.id;
                                      } else {
                                        textControllerName.clear();
                                        textControllerRace.clear();
                                        catid = null;
                                      }
                                    });
                                  },
                                ),
                              );
                            }).toList());
                  }
                },
              )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (catid != null) {
            await DatabaseHelper.instance.update(Cat(
                name: textControllerName.text,
                race: textControllerRace.text,
                id: catid));
          } else {
            DatabaseHelper.instance.add(Cat(
                race: textControllerName.text, name: textControllerName.text));
          }
          setState(() {
            textControllerName.clear();
            textControllerRace.clear();
          });
        },
      ),
    );
  }
}
