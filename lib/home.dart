import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqfilte_notes_app/models/notes_model.dart';
import 'package:sqfilte_notes_app/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper databaseHelper;
  late Future<List<Notes>> notesList;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    loadData();
  }

  loadData(){
    notesList = databaseHelper.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes app"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {


            databaseHelper.insert(
              Notes(
                title: "First Note",
                description: "nsknsknsknsksl",
                date: "23/3/2024",
              ),
            ).then((value) {
              print("data added");
              setState(() {
                notesList = databaseHelper.getNotesList();
              });
            }).onError((error, stackTrace) {
              print(error.toString());
            });

        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<Notes>> snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return Dismissible(
                            onDismissed:(DismissDirection direction){
                              databaseHelper.deleteNote(snapshot.data![index].id!);
                              setState(() {
                                notesList = databaseHelper.getNotesList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });

                            } ,
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.delete_forever),

                            ),
                            key: ValueKey<int>(snapshot.data![index].id!),

                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data![index].title.toString()),
                                subtitle: Text(snapshot.data![index].description.toString()),
                                trailing: Text(snapshot.data![index].id.toString()),
                              ),
                            ),
                          );
                        });
                  }else {
                    return CircularProgressIndicator();
                  }

            }),
          )
        ],
      ),
    );
  }
}
