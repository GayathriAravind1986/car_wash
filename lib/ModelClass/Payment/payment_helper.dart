class Payment {
  DateTime date;
  double amount;
  String mode;
  String notes;

  Payment({
    required this.date,
    this.amount = 0.0,
    this.mode = "Cash",
    this.notes = "",
  });
}
