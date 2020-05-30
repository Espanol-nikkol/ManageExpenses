import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:managerexpenses/expensesModel.dart';

class ExpensesPerMonth extends StatefulWidget{
  final ExpensesModel _model;
  ExpensesPerMonth(this._model);
  @override
  State<StatefulWidget> createState() => _ExpensesPerMonthState(_model);
}


class _ExpensesPerMonthState extends State<ExpensesPerMonth> {
  ExpensesModel _model;

  _ExpensesPerMonthState(this._model);

  int _chooseYear;

  @override
  Widget build(BuildContext context) {
    _chooseYear = _model.getChooseYear;
    Map<int, int> mapYear = _model.getYears;
    List<int> listYear = mapYear.keys.toList();
    List<String> _listMonth = ["January", "Febrary", "March", "April", "May",
      "June", "Jule", "August", "September", "October", "November", "December"];
    List<double> _listExpensePerMonth = _model.expensePerMonth(_chooseYear);
    return Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_model.getCountYears, (index) {
              return MaterialButton(
                onPressed: () {
                  _model.chooseYear = listYear[index];
                  setState(() {
                    _chooseYear = listYear[index];
                  });
                },
                child: Text(listYear[index].toString()),
                color: listYear[index] == _model.getChooseYear ? Color(
                    0xFFB9BBBC) : Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
              );
            }),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              padding: EdgeInsets.only(top: 85, bottom: 20, right: 20, left: 20),
              children: List.generate(12, (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFFB9BBBC),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(_listMonth[index].toString()),
                      Text(_listExpensePerMonth[index].toString())
                    ],
                  ),

                );
              }),
            )
          )
        ]
    );
  }
}