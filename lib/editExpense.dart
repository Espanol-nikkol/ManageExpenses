import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerexpenses/expensesModel.dart';

import 'chooseDate.dart';
import 'expense.dart';

class EditExpense extends StatefulWidget {
  final ExpensesModel _model;
  final int _index;
  EditExpense(this._model, this._index);
  @override
  State<StatefulWidget> createState() => _EditExpenseState(_model, _index);
}

class _EditExpenseState extends State<EditExpense> {
  ExpensesModel _model;
  int _index;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  _EditExpenseState(this._model, this._index);


  @override
  Widget build(BuildContext context) {
    Expense _record = _model.getExpense(_index);
    double _price = _record.price;
    String _name = _record.name;
    DateTime _date = _record.date;
    DatePickerBottomSheet calendar = DatePickerBottomSheet(_date);
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(title: Text("Edit Record")),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget> [
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(
                      suffix: Text('Description'),
                    ),
                    validator: (value) {
                      if (value == " " || value.isEmpty) {
                        return "Write something";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _name = value;
                    },
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                        suffix: Text('Price'),
                      ),
                      initialValue: _price.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (double.tryParse(value) == null || double.tryParse(value) == 0) {
                          return "Enter the valid price";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _price = double.parse(value);
                      }
                  ),

                  calendar,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <RaisedButton>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            _formkey.currentState.save();
                            if (_name != _record.name || _price != _record.price || calendar.date != _record.date) {
                              _model.editExpense(_index, _name, _price, calendar.date);
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Edit"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }


