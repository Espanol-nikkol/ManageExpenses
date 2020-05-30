import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerexpenses/expensesModel.dart';

import 'chooseDate.dart';

class addExpense extends StatefulWidget{
  final ExpensesModel _model;

  addExpense(this._model);
  @override
  State<StatefulWidget> createState() => addExpenseState(_model);
}

class addExpenseState extends State<addExpense> {
  double _price;
  String _name;
  ExpensesModel _model;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();

  addExpenseState(this._model);

  @override
  Widget build(BuildContext context) {
    DatePickerBottomSheet calendar = DatePickerBottomSheet(_date);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text("Add Expense")),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget> [
                TextFormField(
                  initialValue: " ",
                  decoration: const InputDecoration(
                    suffix: Text('Description'),
                  ),
                  validator: (value) {
                    if (value == " "  || value.isEmpty) {
                      return "Write something";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    _name = value.trimLeft();
                  },
                ),
                TextFormField(
                    decoration: const InputDecoration(
                      suffix: Text('Price'),
                    ),
                  initialValue: "0",
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
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();
                      _model.addExpense(_name, _price, calendar.date);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

