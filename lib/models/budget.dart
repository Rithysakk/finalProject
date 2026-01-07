import 'expense.dart';

class Budget {
  Budget({
    required this.category,
    required this.monthlyLimit,
    required this.month,
    required this.year,
  }) : id = uuid.v4();

  final String id;
  final Category category;
  final double monthlyLimit;
  final int month;
  final int year;
}
