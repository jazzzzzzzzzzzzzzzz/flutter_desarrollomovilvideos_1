import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class DBAdmin {
  Database? myDatabase;
  static final DBAdmin db = DBAdmin._();
  DBAdmin._();

  Future<Database?> checkDataBase() async {
    if (myDatabase != null) {
      return myDatabase;
    }
    myDatabase = await initDatabase();
    return myDatabase;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database dbx, int version) async {
      await dbx.execute(
          'CREATE TABLE Task(id INTEGER PRIMARY KEY, titulo TEXT, description TEXT,status TEXT)');
    });
  }

  Future<int> insertRawTask(
      String titulo, String description, bool status) async {
    // añadiendo parametros

    Database? db = await checkDataBase();
    int res = await db!.rawInsert(
        "INSERT INTO Task(titulo,description,status) VALUES ('$titulo','$description','$status')");
    return res;
  }

  Future<int> insertTask(TaskModel model) async {
    Database? db = await checkDataBase();
    int res = await db!.insert("Task", {
      "titulo": model.titulo,
      "description": model.description,
      "status": model.status.toString(),
    });

    return res;
  }

  getRawTasks() async {
    Database? db = await checkDataBase();
    List tasks = await db!.rawQuery("SELECT * FROM Task");
    print(tasks);
  }

  Future<List<TaskModel>> getTasks() async {
    Database? db = await checkDataBase();
    List<Map<String, dynamic>> tasks = await db!.query("Task");
    List<TaskModel> taskModelList =
        tasks.map((e) => TaskModel.deMapAModel(e)).toList();
    // tasks.forEach((element) {
    //  TaskModel task = TaskModel.deMapAModel(element);
    //  taskModelList.add(task);
    //  });

    return taskModelList;
  }

  updateRawTask() async {
    Database? db = await checkDataBase();
    int res = await db!.rawUpdate(
        "UPDATE TASK SET titulo='Ir de compras', description='comprar alimentos para casa ',status='true' WHERE id=2");
    print(res);
  }

  updateTask() async {
    Database? db = await checkDataBase();
    int res = await db!.update(
        "TASK",
        {
          "title": "Ir al jugar",
          "description": "Es el miercoles en la mañana",
          "status": "false",
        },
        where: "id = 2");
  }

  deleteRawtask() async {
    Database? db = await checkDataBase();
    int res = await db!.rawDelete("DELETE FROM Task WHERE id = 2");
    print(res);
  }

  Future<int> deleteTask(int id) async {
    Database? db = await checkDataBase();
    int res = await db!.delete("Task", where: "id = $id");
    return res;
  }
}
