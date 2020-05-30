import 'dart:io';
import 'package:managerexpenses/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDB {
  Database _db;

  Future<Database> get db async {
    if(_db == null) {
      _db = await initialize();
    }
    return _db;
  }

  ExpenseDB();

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    return openDatabase(
      documentsDir.path + "/" + "db.db",
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT, price REAL, date TEXT)");
      }
    );
  }

  Future<List<Expense>> getAllExpense() async {
    Database database = await db;
//    var query = database.rawQuery("select * from expenses order by date(date) desc");
    List<Map> query = await database.rawQuery("SELECT * FROM Expenses ORDER BY date DESC");
    List<Expense> result = [];
    query.forEach((i) => result.add(Expense(i["id"],
        DateTime.parse(i["date"]), i["name"], i["price"])));
    return result;
  }

  Future<void> addExpense(String name, double price, DateTime dateTime) async {
    Database database = await db;
    String dateAsText = dateTime.toString();
    await database.rawInsert("insert into Expenses (name, price, date) values (\"$name\", $price, \"$dateAsText\")");
  }

  Future<void> removeAt(int id) async {
    Database database = await db;
    await database.rawDelete("delete from Expenses where id=$id");
  }

  Future<double> getSum() async {
    Database database = await db;
    List<Map> query = await database.rawQuery("select sum(price) as s from Expenses;");
    return query[0]["s"];
  }

  Future<void> editExpense(Expense currentRecord) async {
    Database database = await db;
    String _date = currentRecord.date.toString();
    double _price = currentRecord.price;
    String _name = currentRecord.name;
    int _id = currentRecord.id;
    await database.rawUpdate(
        "update Expenses "
          "set "
            "date = \"$_date\", "
            "name = \"$_name\", "
            "price = $_price "
          "where id = $_id ");
  }

//  Future<List> getYears() async {
//    print("DB STEP 1");
//    Database database = await db;
//    print("DB STEP 2");
//    List<Map> query = await database.rawQuery("select date from Expenses;");
//    print("DB STEP 3");
//    List result;
//    query.forEach((f) => result.add(DateTime(f["date"]).year));
//    print("DB STEP 4");
//    return result;
//  }
}