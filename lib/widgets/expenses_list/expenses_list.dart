import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder:
          (ctx, index) => Dismissible(
            key: ValueKey(expenses[index]),
            onDismissed: (direction) => onRemoveExpense(expenses[index]),
            // background: ColoredBox(color: const Color.fromARGB(106, 32, 29, 17)),
            background: Container(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal
              ),
            ),
            child: ExpenseItem(expenses[index]),
          ),
    );
  }
}
