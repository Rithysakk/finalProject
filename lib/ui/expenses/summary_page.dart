import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/expense.dart';
import '../../models/balance.dart';
import '../../models/budget.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({
    super.key,
    required this.expenses,
    required this.balanceEntries,
    required this.budgets,
  });

  final List<Expense> expenses;
  final List<Balance> balanceEntries;
  final List<Budget> budgets;

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
  }

  List<Expense> getExpensesForMonth(int year, int month) {
    return widget.expenses.where((expense) {
      return expense.date.year == year && expense.date.month == month;
    }).toList();
  }

  List<Balance> getBalancesForMonth(int year, int month) {
    return widget.balanceEntries.where((balance) {
      return balance.date.year == year && balance.date.month == month;
    }).toList();
  }

  double getIncomeForMonth(int year, int month) {
    final balances = getBalancesForMonth(year, month);
    return balances.fold(0.0, (sum, balance) => sum + balance.amount);
  }

  double getExpenseForMonth(int year, int month) {
    final expenses = getExpensesForMonth(year, month);
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Map<Category, double> getExpensesByCategory(int year, int month) {
    final expenses = getExpensesForMonth(year, month);
    final Map<Category, double> categoryTotals = {};
                          
    for (var expense in expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  Budget? getBudgetForCategory(Category category, int year, int month) {
    try {
      return widget.budgets.firstWhere(
        (b) => b.category == category && b.month == month && b.year == year,
      );
    } catch (e) {
      return null;
    }
  }

  String getCategoryName(Category category) {
    switch (category) {
      case Category.food:
        return 'Foods';
      case Category.education:
        return 'Education';
      case Category.travel:
        return 'Transportation';
      case Category.internet:
        return 'Internet';
      case Category.games:
        return 'Games';
      case Category.others:
        return 'Others';
      case Category.medicineBeauty:
        return 'Medicine&Beauty';
    }
  }

  IconData getCategoryIcon(Category category) {
    switch (category) {
      case Category.food:
        return Icons.restaurant;
      case Category.education:
        return Icons.school;
      case Category.travel:
        return Icons.directions_car;
      case Category.internet:
        return Icons.wifi;
      case Category.games:
        return Icons.gamepad;
      case Category.others:
        return Icons.more_horiz;
      case Category.medicineBeauty:
        return Icons.medical_services;
    }
  }

  Color getCategoryColor(Category category) {
    switch (category) {
      case Category.food:
        return const Color(0xFFFF6B6B);
      case Category.education:
        return const Color(0xFF4ECDC4);
      case Category.travel:
        return const Color(0xFF95E1D3);
      case Category.internet:
        return const Color(0xFFFFA07A);
      case Category.games:
        return const Color(0xFFDDA15E);
      case Category.others:
        return const Color(0xFFBC6C25);
      case Category.medicineBeauty:
        return const Color(0xFFFF9FF3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final income = getIncomeForMonth(selectedMonth.year, selectedMonth.month);
    final expense = getExpenseForMonth(selectedMonth.year, selectedMonth.month);
    final categoryExpenses = getExpensesByCategory(selectedMonth.year, selectedMonth.month);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Monthly Summary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Selector
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667eea).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(
                            selectedMonth.year,
                            selectedMonth.month - 1,
                          );
                        });
                      },
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat.MMMM().format(selectedMonth),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.y().format(selectedMonth),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                      onPressed: () {
                        setState(() {
                          selectedMonth = DateTime(
                            selectedMonth.year,
                            selectedMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Expense Chart
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Expense Breakdown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Stacked Horizontal Bar Chart
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final totalExpense = categoryExpenses.values.isEmpty
                              ? 1.0
                              : categoryExpenses.values.fold(0.0, (a, b) => a + b);
                          
                          return Row(
                            children: Category.values.map((category) {
                              final amount = categoryExpenses[category] ?? 0;
                              final widthPercent = totalExpense > 0 ? amount / totalExpense : 0;
                              
                              if (amount == 0) return const SizedBox.shrink();
                              
                              return Expanded(
                                flex: (widthPercent * 1000).toInt(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: getCategoryColor(category),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Category.values.map((category) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: getCategoryColor(category),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              getCategoryName(category),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Income and Expense Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF11998e).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_downward_rounded, 
                                   color: Colors.white, size: 24),
                          const SizedBox(height: 12),
                          const Text(
                            'Income',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${income.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B6B).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_upward_rounded, 
                                   color: Colors.white, size: 24),
                          const SizedBox(height: 12),
                          const Text(
                            'Expense',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${expense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Type of Expense
              const Text(
                'Type of Expense',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 16),
              
              // Category List
              ...Category.values.map((category) {
                final amount = categoryExpenses[category] ?? 0;
                final budget = getBudgetForCategory(category, selectedMonth.year, selectedMonth.month);
                
                // Skip if no expense and no budget
                if (amount == 0 && budget == null) return const SizedBox.shrink();
                
                final budgetLimit = budget?.monthlyLimit ?? 0;
                final percentage = budgetLimit > 0 ? (amount / budgetLimit).clamp(0.0, 1.0) : 0.0;
                final isNearLimit = percentage >= 0.8 && percentage < 1.0;
                final isOverBudget = percentage >= 1.0;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: isOverBudget 
                        ? Border.all(color: const Color(0xFFFF6B6B), width: 2)
                        : isNearLimit
                            ? Border.all(color: const Color(0xFFFF9800), width: 2)
                            : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  getCategoryColor(category),
                                  getCategoryColor(category).withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              getCategoryIcon(category),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getCategoryName(category),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                if (budget != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Budget: \$${budgetLimit.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '-\$${amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: getCategoryColor(category),
                                ),
                              ),
                              if (budget != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${(percentage * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isOverBudget 
                                        ? const Color(0xFFFF6B6B)
                                        : isNearLimit
                                            ? const Color(0xFFFF9800)
                                            : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      if (budget != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isOverBudget 
                                  ? const Color(0xFFFF6B6B)
                                  : isNearLimit
                                      ? const Color(0xFFFF9800)
                                      : getCategoryColor(category),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                      if (isOverBudget) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_rounded, color: Color(0xFFFF6B6B), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Over budget by \$${(amount - budgetLimit).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF6B6B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (isNearLimit) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9800).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: Color(0xFFFF9800), size: 16),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Approaching budget limit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF9800),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
