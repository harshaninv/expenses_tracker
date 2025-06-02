import 'package:expenses_tracker/widgets/chart/chart.dart';
import 'package:expenses_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpeses = [
    Expense(
      title: 'Flutter course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpenses),
    );
  }

  // add expense to the list
  void _addExpenses(Expense expense) {
    setState(() {
      _registeredExpeses.add(expense);
    });
  }

  // remove expense from the list
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpeses.indexOf(expense);

    setState(() {
      _registeredExpeses.remove(expense);
    });

    // if again again user remove expence we want clear previos snack bar immediatly
    ScaffoldMessenger.of(context).clearSnackBars();

    // confirm deletion process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpeses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = (MediaQuery.of(context).size.width);

    Widget mainContext = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpeses.isNotEmpty) {
      mainContext = ExpensesList(
        expenses: _registeredExpeses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Expenses Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: screenWidth < 600 
      ? Column(
        children: [
          Chart(expenses: _registeredExpeses),
          Expanded(child: mainContext),
        ],
      )
      : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpeses)),
          Expanded(child: mainContext),
        ],
      )
    );
  }
}
