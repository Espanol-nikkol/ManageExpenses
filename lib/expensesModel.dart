
import 'package:intl/intl.dart';
import 'package:managerexpenses/ExpenseDB.dart';
import 'package:managerexpenses/expense.dart';
import 'package:scoped_model/scoped_model.dart';

class ExpensesModel extends Model {
  List<Expense> _items = [];
  Map<int, int> _years = Map();
  int _idGenerator = 0;
  double _sum;
  int _chooseYear;

  String get getSumString => "Total expense: " + _sum.toString();
  int get getCountRecords => _items.length;
  int get getCountYears => _years.length;
  Map<int, int> get getYears => _years;
  int get getChooseYear =>  _chooseYear == null ? DateTime.now().year : _chooseYear;

  set chooseYear(int v) => _chooseYear = v;

  List<double> expensePerMonth (int y) {
    List<double> _expensePerMonth = List.filled(12, 0);
    int _year = _chooseYear == null && getCountYears > 1 ? getChooseYear : _years.keys.first;
    _items.forEach((i) {
      if (i.date.year == _year) {
        _expensePerMonth[i.date.month-1] += i.price;
      }
    });
    return _expensePerMonth;
  }

  Expense getExpense(int i) => _items[i];

  ExpenseDB _db;

  ExpensesModel() {
    _db = ExpenseDB();
    load();
  }

  void load() {
    Future<List<Expense>> future = _db.getAllExpense();
    future.then((list) {
      double _realSum = 0;
      Map <int, int> _realYears = Map();
      _items = list;
      _items.forEach((i) {
        _realSum += i.price;
        if (_realYears.containsKey(i.date.year)) {
          _realYears[i.date.year] += 1;
        } else {
          _realYears[i.date.year] = 1;
        }
      });

      if (_realSum != _sum) {
        _sum = _realSum;
      }
      if (_realYears.keys != _years.keys || _realYears.values != _years.values) {
        _years = _realYears;
      } else {
        _realYears.keys.forEach((i) {
          if (_realYears[i] != _years[i]) {
            _years = _realYears;
          }
        });
      }
      notifyListeners();
    });
  }

  String getKey(int index) {
    return _items[index].id.toString();
  }

  String getText(int index) {
    Expense e = _items[index];
    return e.name + " for " +
        e.price.toString() + "\n" +
        DateFormat.yMMMMd().format(e.date);
  }

  void removeAt(int index) {
    int _id = _items[index].id;
    int _year = _items[index].date.year;
    _sum -= _items[index].price;
    _years[_year] -= 1;
    _items.removeAt(index);
    notifyListeners();
    _db.removeAt(_id).then((_) {
      load();
    });
  }

  void addExpense(String name, double price, DateTime date) {
    Future<void> future = _db.addExpense(name, price, date);
    future.then((_) {
      load();
    });
    _idGenerator += 1;
    _items.add(Expense(_idGenerator, date, name, price));

    int year = date.year;
    if (_years.containsKey(year)) {
      _years[year] += 1;
    } else {
      _years[year] = 1;
    }

    _sum += price;

    notifyListeners();
  }

  void editExpense(int index, String name, double price, DateTime date) {
    Expense _currentRecord = _items[index];
    _currentRecord.date = date;
    _currentRecord.name = name;
    _currentRecord.price = price;
    notifyListeners();
    _db.editExpense(_currentRecord);
    load();
  }
}