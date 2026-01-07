import 'expense.dart';

class Balance {
  Balance({
    required this.amount,
    required this.date,
  }) : id = uuid.v4();

  final String id;
  final double amount;
  final DateTime date;
}
