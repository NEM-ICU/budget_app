import 'package:flutter/material.dart';

// ignore: camel_case_types
enum ExpenzCategory { food, helth, vechical, entertainment }

Map<ExpenzCategory, String> expenzCategoryImages = {
  ExpenzCategory.food: "imageassets/expenze/icons8-circus-64.png",
  ExpenzCategory.helth: "imageassets/expenze/icons8-health-48.png",
  ExpenzCategory.vechical: "imageassets/expenze/icons8-car-64.png",
  ExpenzCategory.entertainment: "imageassets/expenze/icons8-edible-48.png"
};
Map<ExpenzCategory, Color> incomeColors = {
  ExpenzCategory.food: const Color(0xff5FD068),
  ExpenzCategory.helth: const Color(0xffCC704B),
  ExpenzCategory.vechical: const Color(0xff8FBDD3),
  ExpenzCategory.entertainment: const Color(0xffF8C4B4)
};

// ignore: camel_case_types
class Expenzes {
  final int Id;
  final ExpenzCategory catrgory;
  final String title;
  final String discription;
  final String amount;
  final String date;
  final String time;

  Expenzes(
      {required this.Id,
      required this.catrgory,
      required this.title,
      required this.discription,
      required this.amount,
      required this.date,
      required this.time});

  // List<Expenzes> expenzList = [];
}