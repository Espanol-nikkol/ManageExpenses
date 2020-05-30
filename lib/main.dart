import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:managerexpenses/addExpense.dart';
import 'package:managerexpenses/expensesModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'editExpense.dart';
import 'expensesPerMonth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager by Kolganov NA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'The best Expense Manager'),
    );
  }
}



class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: ScopedModel(
            model: ExpensesModel(),
            child: ScopedModelDescendant<ExpensesModel>(
                builder: (context, child, model) =>
                    DefaultTabController(
                      length: 2,
                      child: Scaffold(
                          appBar: AppBar(
                            title: Text(title),
                            bottom: TabBar(
                              tabs: <Widget>[
                                Text("All expenses"),
                                Text("Expenses per month")
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: [
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return ListTile(
                                        title: Text(model.getSumString)
                                    );
                                  } else {
                                    index -= 1;
                                    return Dismissible(
                                      key: Key(model.getKey(index)),
                                      child: ListTile(
                                        title: Text(model.getText(index)),
                                        leading: Icon(Icons.attach_money),
                                        trailing: Icon(Icons.delete),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return EditExpense(model, index);
                                                  }
                                              )
                                          );
                                        },
                                      ),
                                      onDismissed: (direction) {
                                        model.removeAt(index);
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(content: Text(
                                                "Deleted record $index"))
                                        );
                                      },
                                      confirmDismiss: (DismissDirection direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirm"),
                                              content: const Text("Are you sure you wish to delete this record?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text("CANCEL"),
                                                ),
                                                FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: const Text("DELETE")
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: model.getCountRecords + 1
                              ),
                              ExpensesPerMonth(model),
                            ]
                          ),

                          floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) {
                                          return addExpense(model);
                                        }
                                    )
                                );
                              },
                              child: Icon(Icons.add)
                          )
                      ),
                    )
            )
        )
    );
  }
}
