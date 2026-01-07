import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/expense.dart';
import '../../models/budget.dart';

class BudgetSettingsPage extends StatefulWidget {
  const BudgetSettingsPage({
    super.key,
    required this.budgets,
    required this.onSaveBudgets,
  });

  final List<Budget> budgets;
  final Function(List<Budget>) onSaveBudgets;

  @override
  State<BudgetSettingsPage> createState() => _BudgetSettingsPageState();
}

class _BudgetSettingsPageState extends State<BudgetSettingsPage> {
  late Map<Category, TextEditingController> _controllers;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _controllers = {};
    
    for (var category in Category.values) {
      final existingBudget = widget.budgets.firstWhere(
        (b) => b.category == category && 
               b.month == _selectedMonth.month && 
               b.year == _selectedMonth.year,
        orElse: () => Budget(
          category: category,
          monthlyLimit: 0,
          month: _selectedMonth.month,
          year: _selectedMonth.year,
        ),
      );
      _controllers[category] = TextEditingController(
        text: existingBudget.monthlyLimit > 0 
            ? existingBudget.monthlyLimit.toStringAsFixed(0) 
            : '',
      );
    }
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
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

  void _saveBudgets() {
    List<Budget> newBudgets = [];
    
    // Keep budgets from other months
    newBudgets.addAll(
      widget.budgets.where(
        (b) => b.month != _selectedMonth.month || b.year != _selectedMonth.year,
      ),
    );
    
    // Add new budgets for selected month
    _controllers.forEach((category, controller) {
      final amount = double.tryParse(controller.text) ?? 0;
      if (amount > 0) {
        newBudgets.add(Budget(
          category: category,
          monthlyLimit: amount,
          month: _selectedMonth.month,
          year: _selectedMonth.year,
        ));
      }
    });
    
    widget.onSaveBudgets(newBudgets);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          'Budget Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Month selector
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
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
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month - 1,
                      );
                      // Update controllers with budgets for new month
                      for (var category in Category.values) {
                        final existingBudget = widget.budgets.firstWhere(
                          (b) => b.category == category && 
                                 b.month == _selectedMonth.month && 
                                 b.year == _selectedMonth.year,
                          orElse: () => Budget(
                            category: category,
                            monthlyLimit: 0,
                            month: _selectedMonth.month,
                            year: _selectedMonth.year,
                          ),
                        );
                        _controllers[category]!.text = existingBudget.monthlyLimit > 0 
                            ? existingBudget.monthlyLimit.toStringAsFixed(0) 
                            : '';
                      }
                    });
                  },
                ),
                Column(
                  children: [
                    Text(
                      ['January', 'February', 'March', 'April', 'May', 'June',
                       'July', 'August', 'September', 'October', 'November', 'December']
                          [_selectedMonth.month - 1],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_selectedMonth.year}',
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
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month + 1,
                      );
                      // Update controllers with budgets for new month
                      for (var category in Category.values) {
                        final existingBudget = widget.budgets.firstWhere(
                          (b) => b.category == category && 
                                 b.month == _selectedMonth.month && 
                                 b.year == _selectedMonth.year,
                          orElse: () => Budget(
                            category: category,
                            monthlyLimit: 0,
                            month: _selectedMonth.month,
                            year: _selectedMonth.year,
                          ),
                        );
                        _controllers[category]!.text = existingBudget.monthlyLimit > 0 
                            ? existingBudget.monthlyLimit.toStringAsFixed(0) 
                            : '';
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: Category.values.map((category) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
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
                  child: Row(
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
                            const SizedBox(height: 8),
                            TextField(
                              controller: _controllers[category],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                hintText: 'Budget limit',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.attach_money,
                                  color: Color(0xFF667eea),
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF5F7FA),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Save button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveBudgets,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Save Budgets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
