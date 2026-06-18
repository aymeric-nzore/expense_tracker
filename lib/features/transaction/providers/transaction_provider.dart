import 'package:expense_tracker_app/features/transaction/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _items = [];
  int _idCounter = 0;

  TransactionProvider() {
    _items.addAll([
      Transaction(
        id: '1',
        name: 'Épicerie',
        amount: 45.50,
        categoryId: 'Nourriture',
        isIncome: false,
        date: DateTime.now().subtract(Duration(days: 3)),
      ),
      Transaction(
        id: '2',
        name: 'Salle de sport',
        amount: 30,
        categoryId: 'Sport',
        isIncome: false,
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      Transaction(
        id: '3',
        name: 'Courses',
        amount: 120,
        categoryId: 'Shopping',
        isIncome: false,
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      Transaction(
        id: '4',
        name: 'Restaurant',
        amount: 35.75,
        categoryId: 'Nourriture',
        isIncome: false,
        date: DateTime.now(),
      ),
      Transaction(
        id: '5',
        name: 'Salaire',
        amount: 35.75,
        categoryId: 'Salaire',
        isIncome: true,
        date: DateTime.now().subtract(Duration(days: 8)),
      ),
      Transaction(
        id: '6',
        name: 'Wave',
        amount: 200,
        categoryId: 'Salaire',
        isIncome: true,
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
    ]);
    _idCounter = _items.length;
  }
  List<Transaction> get all => List.unmodifiable(_items);

  void addTransaction(
    String name,
    double amount,
    String categoryId,
    bool isIncome,
  ) {
    _idCounter++;
    final transaction = Transaction(
      id: _idCounter.toString(),
      name: name,
      amount: amount,
      categoryId: categoryId,
      isIncome: isIncome,
      date: DateTime.now(),
    );
    _items.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _items.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  double totalIncome() =>
      _items.where((t) => t.isIncome).fold(0.0, (i, n) => i + n.amount);
  double totalExpense() =>
      _items.where((t) => !t.isIncome).fold(0.0, (i, n) => i + n.amount);
  double balance() => totalIncome() - totalExpense();

  Map<String, double> expensePerCategory() {
    final Map<String, double> m = {};
    for (final t in _items.where((t) => !t.isIncome)) {
      m[t.categoryId] = (m[t.categoryId] ?? 0) + t.amount;
    }
    return m;
  }
}
