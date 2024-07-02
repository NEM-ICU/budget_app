import 'dart:convert';

import 'package:expenze_manager/model/incomemodel.dart';
import 'package:expenze_manager/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeService {
  //income key
  static const String _incomeKey = "incomes";
  //income list
  //List<Incomes> incomeList = [];

//methos for save income
  // Future<void> saveIncome(Incomes income, BuildContext context) async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     List<String>? existingIncomeList = pref.getStringList(_incomeKey);
  //     List<Incomes> incomeList = [];
  //     if (existingIncomeList != null) {
  //       incomeList = existingIncomeList
  //           .map((e) => Incomes.fromJSON(jsonDecode(e)))
  //           .toList();
  //       print("not null");
  //     }
  //     //add to list
  //     incomeList.add(income);
  //     //convert to json encoded format
  //     List<String>? updatedIncomeList =
  //         incomeList.map((e) => jsonEncode(e.toJSON())).toList();
  //     //save in shared preferenes
  //     await pref.setStringList(_incomeKey, updatedIncomeList);
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           backgroundColor: kcButtonBlue,
  //           content: Text(
  //             "income added succsussfuly",
  //             style: TextStyle(color: kcButtonText),
  //           ),
  //         ),
  //       );
  //     }
  //   } catch (err) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(milliseconds: 3000),
  //           backgroundColor: kcCardRed,
  //           content: Text(
  //             "something went wrong",
  //             style: TextStyle(color: kcButtonText),
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> saveIncome(Incomes income, BuildContext context) async {
    try {
      // Save to SharedPreferences
      final SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? existingIncomeList = pref.getStringList(_incomeKey) ?? [];

      // Add new income to local list
      List<Incomes> incomeList = existingIncomeList
          .map((e) => Incomes.fromJSON(jsonDecode(e)))
          .toList();
      incomeList.add(income);

      // Convert list to JSON and save to SharedPreferences
      List<String> updatedIncomeList =
          incomeList.map((e) => jsonEncode(e.toJSON())).toList();
      await pref.setStringList(_incomeKey, updatedIncomeList);

      // Save to Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference incomeCollection = firestore.collection('incomes');
      await incomeCollection.add(income.toJSON());

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 3000),
            backgroundColor: kcButtonBlue,
            content: Text(
              "Income added successfully",
              style: TextStyle(color: kcButtonText),
            ),
          ),
        );
      }
    } catch (err) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 3000),
            backgroundColor: kcCardRed,
            content: Text(
              "Something went wrong",
              style: TextStyle(color: kcButtonText),
            ),
          ),
        );
      }
    }
  }

  //load a income from shared preferences
  // Future<List<Incomes>?> loadIncome() async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     List<String>? existingIncomeList = pref.getStringList(_incomeKey);
  //     List<Incomes> incomeList = [];
  //     //get existing  income list
  //     if (existingIncomeList != null) {
  //       incomeList = existingIncomeList
  //           .map(
  //             (e) => Incomes.fromJSON(
  //               jsonDecode(e),
  //             ),
  //           )
  //           .toList();
  //     }

  //     return incomeList;
  //   } catch (err) {
  //     return [];
  //   }
  // }

  Future<List<Incomes>> loadIncome() async {
    try {
      // Initialize Firestore and reference the collection
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference incomeCollection = firestore.collection('incomes');

      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await incomeCollection.get();

      // Map Firestore documents to Incomes objects
      List<Incomes> incomeList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Incomes.fromJSON(
            data); // Assuming you have a method to convert JSON to Incomes
      }).toList();

      return incomeList;
    } catch (err) {
      // Handle error, e.g., log error and return empty list
      print("Error loading income data: $err");
      return []; // Return empty list in case of error
    }
  }

  //delete an Income
  // Future<void> deleteIncome(int id, BuildContext context) async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     List<String>? existingExpenzes = pref.getStringList(_incomeKey);
  //     List<Incomes> incomeList = [];
  //     if (existingExpenzes != null) {
  //       incomeList = existingExpenzes
  //           .map((e) => Incomes.fromJSON(json.decode(e)))
  //           .toList();
  //       //remove the expenz
  //       incomeList.removeWhere((element) => element.id == id);
  //       //encode the expenz list to json and store it
  //       List<String> updatedExpenzList =
  //           incomeList.map((e) => json.encode(e.toJSON())).toList();
  //       pref.setStringList(_incomeKey, updatedExpenzList);
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             duration: const Duration(seconds: 1),
  //             backgroundColor: kcButtonBlue,
  //             content: Text(
  //               "Income deleted succsussfuly",
  //               style: TextStyle(color: kcButtonText),
  //             )));
  //       }
  //     }
  //   } catch (err) {
  //     if (context.mounted) {
  //       print(err);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           duration: const Duration(seconds: 1),
  //           backgroundColor: kcCardRed,
  //           content: Text(
  //             "something went wrong",
  //             style: TextStyle(color: kcButtonText),
  //           )));
  //     }
  //   }
  // }

  Future<void> deleteIncome(int id, BuildContext context) async {
    try {
      // Delete from SharedPreferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? existingIncomeList = pref.getStringList(_incomeKey);
      List<Incomes> incomeList = [];

      if (existingIncomeList != null) {
        incomeList = existingIncomeList
            .map((e) => Incomes.fromJSON(json.decode(e)))
            .toList();

        // Remove the income with matching ID
        incomeList.removeWhere((element) => element.id == id);

        // Update SharedPreferences
        List<String> updatedIncomeList =
            incomeList.map((e) => json.encode(e.toJSON())).toList();
        await pref.setStringList(_incomeKey, updatedIncomeList);
      }

      // Delete from Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference incomeCollection = firestore.collection('incomes');

      QuerySnapshot querySnapshot =
          await incomeCollection.where('id', isEqualTo: id).get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: kcButtonBlue,
          content: Text(
            "Income deleted successfully",
            style: TextStyle(color: kcButtonText),
          ),
        ));
      }
    } catch (err) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: kcCardRed,
          content: Text(
            "Something went wrong: ${err.toString()}",
            style: TextStyle(color: kcButtonText),
          ),
        ));
      }
    }
  }

  //remove all incomes
  Future<void> removeAllIncomes(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove(_incomeKey);
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kcCardRed,
            content: Text(
              "something went wrong",
              style: TextStyle(color: kcButtonText),
            ),
          ),
        );
      }
    }
  }
}
