import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlDb {


  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
    } else {
      return _db;
    }

    return _db;
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'tasks.db');
    Database mydb = await openDatabase(path, onCreate: _onCreate,version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {

  }

  // "Title": "Go to the Gym",
  // "date": DateFormat('EEE, MMM d, ''yyyy').format(DateTime.utc(2022,12,20)),
  // "checked": false,
  // "subtask": [
  // "Chapter 1",
  // "Chapter 2",
  // "Chapter 3",

  _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE "task" (
        "task_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "task_title" TEXT NOT NULL,
        "task_date" DATETIME ,
        "task_check" INTEGER
      )
      '''
    );
    await db.execute(
        '''
      CREATE TABLE "sub_task" (
        "sub_task_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "sub_task_title" TEXT NOT NULL,
        "sub_task_check" INTEGER,
        "sub_task_taskid" INTEGER,
        FOREIGN KEY(sub_task_taskid) REFERENCES task(task_id) ON DELETE CASCADE ON UPDATE CASCADE
      )
      '''
    );

    print("Created !");

    return db;
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }



}