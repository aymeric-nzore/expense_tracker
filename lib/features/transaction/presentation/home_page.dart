import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/features/transaction/models/category.dart';
import 'package:expense_tracker_app/features/transaction/providers/category_provider.dart';
import 'package:expense_tracker_app/features/transaction/providers/transaction_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategories = "All";
  final List<String> _categories = [
    "All",
    "Sport",
    "Nourriture",
    "Shopping",
    "Salaire",
  ];
  bool _showAll = false;

  Category? _findCategoryByName(
    List<Category> categories,
    String categoryName,
  ) {
    for (final c in categories) {
      if (c.name.toLowerCase() == categoryName.toLowerCase()) return c;
    }
    return null;
  }

  Category? _findCategoryById(
    List<Category> categories,
    String categoryId,
  ) {
    for (final c in categories) {
      if (c.id.toLowerCase() == categoryId.toLowerCase()) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return Scaffold(body: Center(child: Text("User not authenticated")));
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Debug print
          print("Connection state: ${snapshot.connectionState}");
          print("Has data: ${snapshot.hasData}");
          print("Has error: ${snapshot.hasError}");

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final docSnapshot = snapshot.data;

          if (docSnapshot == null) {
            return Center(child: Text("No data available"));
          }

          if (!docSnapshot.exists) {
            // Create the user document once, then wait for the next snapshot
            Future.microtask(() async {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .set({
                    'username': user.email?.split('@').first ?? 'User',
                    'email': user.email ?? '',
                    'photoUrl': '',
                    'createdAt': Timestamp.now(),
                  });
            });
            return Center(child: CircularProgressIndicator());
          }

          final data = docSnapshot.data();

          if (data == null) {
            return Center(child: Text("User data is null"));
          }

          final photoUrl = data['photoUrl'] as String? ?? '';

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 26),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Hello, ",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Text(
                            "${data['username']}",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(0.1),
                          border: Border.all(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: photoUrl.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  photoUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.person, color: colorScheme.primary),
                                ),
                              )
                            : Icon(Icons.person, color: colorScheme.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        return Padding(
                          padding: const EdgeInsetsGeometry.symmetric(
                            horizontal: 4.0,
                          ),
                          child: FilterChip(
                            selectedColor: colorScheme.primary.withOpacity(0.3),
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            label: Text(
                              category,
                              style: TextStyle(
                                color: _selectedCategories == category
                                    ? colorScheme.primary
                                    : theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            selected: _selectedCategories == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategories = category;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: 260,
                    width: 360,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<TransactionProvider>(
                          builder: (context, transactionProvider, _) {
                            final income = transactionProvider.totalIncome();
                            final expense = transactionProvider.totalExpense();
                            final balance = transactionProvider.balance();
                            
                            return Text(
                              "Balance : ${balance.toStringAsFixed(2)}€",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8),
                        Consumer<TransactionProvider>(
                          builder: (context, transactionProvider, _) {
                            // Afficher les valeurs réelles ou 0 si pas de transactions
                            final income = transactionProvider.totalIncome();
                            final expense = transactionProvider.totalExpense();
                            
                            return cardBuilder(
                              income: income,
                              expense: expense,
                              theme: theme,
                              colorScheme: colorScheme,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Transactions",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAll = !_showAll;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.primary),
                          ),
                          child: Text(
                            _showAll ? "See Less" : "See All",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Consumer2<TransactionProvider, CategoryProvider>(
                      builder: (context, transactionProvider, categoryProvider, _) {
                        final allTransactions = transactionProvider.all;
                        
                        // Sort transactions by date (most recent first)
                        final sortedTransactions = List.from(allTransactions)
                          ..sort((a, b) => b.date.compareTo(a.date));
                        
                        final filteredTransactions =
                            _selectedCategories == "All"
                            ? sortedTransactions
                            : sortedTransactions
                                  .where(
                                    (t) {
                                      final cat = _findCategoryById(
                                        categoryProvider.all,
                                        t.categoryId,
                                      );
                                      return cat?.name == _selectedCategories;
                                    },
                                  )
                                  .toList();

                        final transactionsToShow = _showAll
                            ? filteredTransactions
                            : filteredTransactions.take(3).toList();

                        if (transactionsToShow.isEmpty) {
                          return Center(child: Text("Aucune transaction"));
                        }

                        return ListView.builder(
                          itemCount: transactionsToShow.length,
                          itemBuilder: (context, index) {
                            final transaction = transactionsToShow[index];
                            final category = _findCategoryById(
                              categoryProvider.all,
                              transaction.categoryId,
                            );
                            final categoryName = category?.name ?? '';
                            final formatedDate = DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(transaction.date);

                            return ListTile(
                              leading: category != null
                                  ? Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: categoryName == "Sport"
                                            ? Colors.amber[100]
                                            : categoryName == "Nourriture"
                                            ? Colors.blueGrey[100]
                                            : categoryName == "Shopping"
                                            ? Colors.purple[100]
                                            : Colors.blue[100],
                                        borderRadius:   BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(
                                        category.imageAssets,
                                        width: 28,
                                        height: 28,
                                      ),
                                    )
                                  : Icon(Icons.receipt_long),
                              title: Text(transaction.name),
                              subtitle: Text(transaction.categoryId),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${transaction.isIncome ? '+' : '-'}${transaction.amount}€',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: transaction.isIncome
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  Text(formatedDate),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class cardBuilder extends StatelessWidget {
  final double income;
  final double expense;
  final ThemeData theme;
  final ColorScheme colorScheme;
  const cardBuilder({
    super.key,
    required this.income,
    required this.expense,
    required this.theme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //container income
                Container(
                  height: 60,
                  width: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green[300],
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //income text
                    Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    //income amount
                    Text(
                      '+${income.toStringAsFixed(2)}€',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                //container expense
                Container(
                  height: 60,
                  width: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red[300],
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //expense text
                    Text(
                      "Expense",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    //expense amount
                    Text(
                      '-${expense.toStringAsFixed(2)}€',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 180,
          width: 180,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: income,
                  color: Colors.green[300],
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: expense,
                  color: Colors.red[300],
                  showTitle: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
