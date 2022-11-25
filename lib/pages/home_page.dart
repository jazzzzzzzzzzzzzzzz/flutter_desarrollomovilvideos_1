import 'package:flutter/material.dart';
import '../db/db_admin.dart';
import '../models/task_model.dart';
import '../widgets/my_form_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getFullName() async {
    return "Jazmin Lucero";
  }

  showDialogForm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyFormWidget();
        }).then((value) => {
          setState(
            () {},
          )
        });
  }

  deleteTask(int taskid) {
    DBAdmin.db.deleteTask(taskid).then((value) {
      if (value > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.indigo,
            content: Row(
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("Tarea eliminada"),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialogForm();
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        body: FutureBuilder(
          future: DBAdmin.db.getTasks(),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.hasData) {
              List<TaskModel> myTask = snap.data;
              return ListView.builder(
                  itemCount: myTask.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: UniqueKey(),
                      // confirmDismiss: (DismissDirection direction) async {
                      //  return true;
                      //},
                      direction: DismissDirection.startToEnd,
                      background:
                          Container(color: Color.fromARGB(255, 187, 37, 179)),
                      onDismissed: (DismissDirection direction) {
                        deleteTask(myTask[index].id!);
                      },
                      child: ListTile(
                          title: Text(myTask[index].titulo),
                          subtitle: Text(myTask[index].description),
                          trailing: IconButton(
                            onPressed: () {
                              showDialogForm();
                            },
                            icon: Icon(Icons.edit),
                          )),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
