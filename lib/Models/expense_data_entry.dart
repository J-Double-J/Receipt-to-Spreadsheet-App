// ignore_for_file: constant_identifier_names
class ExpenseDataEntry {
  late DateTime _date;
  late String _expenseCategory;
  late String _cost;
  late String _purchaser;

  ExpenseDataEntry(
      {required DateTime date,
      required String expenseCode,
      required String cost,
      required String purchaser}) {
    _date = DateTime(date.year, date.month, date.day);
    _cost = cost;
    _purchaser = purchaser;
    _expenseCategory = expenseCode;
  }

  List<String> getFieldsAsStrings() {
    String dateString =
        "${_date.month.toString().padLeft(2, '0')}/${_date.day.toString().padLeft(2, '0')}/${_date.year.toString()}";

    List<String> stringInterpretation = [
      dateString,
      _expenseCategory,
      _cost,
      _purchaser
    ];

    return stringInterpretation;
  }

  Map<String, dynamic> toJson() => {
        "Date":
            "${_date.month.toString().padLeft(2, '0')}/${_date.day.toString().padLeft(2, '0')}/${_date.year.toString()}",
        "Expense Code": _expenseCategory,
        "Cost": _cost,
        "Buyer": _purchaser
      };
}

enum ExpenseCode { FOOD, GAS, HHG, FUR, DAT, FUN, DEC }

extension ExpenseCodeExtension on ExpenseCode {
  String toStringWithoutPrefix() {
    return toString().split('.').last;
  }

  String toLongFormString() {
    switch (this) {
      case ExpenseCode.FOOD:
        return "Food";
      case ExpenseCode.GAS:
        return "Gas";
      case ExpenseCode.HHG:
        return "Household Goods";
      case ExpenseCode.DEC:
        return "Decoration";
      case ExpenseCode.FUR:
        return "Furniture";
      case ExpenseCode.DAT:
        return "Date";
      case ExpenseCode.FUN:
        return "Fun";
    }
  }
}
