import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

import 'addExpense.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime _date;
  _DatePickerBottomSheetState d;
  DatePickerBottomSheet(this._date) {
    d = _DatePickerBottomSheetState(_date);
  }
  DateTime get date => d.getDate;

  @override
  _DatePickerBottomSheetState createState() => d;
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  final DateTime minDatetime = DateTime.now().subtract(Duration(days: 365*100));
  final DateTime maxDatetime = DateTime.now().add(Duration(days: 365*100));
  DateTime date;

  _DatePickerBottomSheetState(this.date);

  DateTime get getDate => date;


  @override
  Widget build(BuildContext context) {
    final DateTime initDatetime = date == null ? DateTime.now() : date;
    String _dateAsString = intl.DateFormat.yMMMMd().format(date);

    return GestureDetector(
      child: Container(
        height: 50,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: 15, bottom: 0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF9B9B9B), width: 1.5))
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _dateAsString,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Date",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF747474),
                ),
              )
            ],
          ),
      ),
      onTap: () {
        DatePicker.showDatePicker(
          context,
          pickerTheme: DateTimePickerTheme(
            showTitle: true,
            confirm: Text('Done', style: TextStyle(color: Colors.cyan)),
            cancel: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          minDateTime: minDatetime,
          maxDateTime: maxDatetime,
          initialDateTime: initDatetime,
          onChange: (dateTime, List<int> index) {
            setState(() {
              date = dateTime;
            });
          },
        );
      },
    );
  }
}