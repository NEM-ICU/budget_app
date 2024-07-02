import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenze_manager/model/expenzmodel.dart';
import 'package:expenze_manager/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenzeService {
  //expenz data list
  List<Expenzes> expenList = [];
//define the key for store the xepenzesin sharedpreferences
  static const String expenzKey = "expenzes";

  //save the expenz in shared preferences
  // Future<void> saveExpenz(Expenzes expenz, BuildContext context) async {
  //   try {
  //     //create instance
  //     final SharedPreferences pref = await SharedPreferences.getInstance();
  //     //get existng expenzes
  //     List<String>? existingExpenzes = pref.getStringList(expenzKey);
  //     //convert encoded strings to expenze object and added to the list
  //     if (existingExpenzes != null) {
  //       expenList = existingExpenzes
  //           .map((e) => Expenzes.fromJSON(json.decode(e)))
  //           .toList();
  //     }
  //     expenList.add(expenz);
  //     //expenz list to decoded string list
  //     List<String> updatedExpenzesList =
  //         expenList.map((e) => json.encode(e.toJSON())).toList();
  //     //store in shared preferences
  //     pref.setStringList(expenzKey, updatedExpenzesList);
  //     //show massage
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(milliseconds: 3000),
  //           backgroundColor: kcButtonBlue,
  //           content: Text(
  //             "Expenze is added succsessfuly",
  //             style: TextStyle(color: kcButtonText),
  //           ),
  //         ),
  //       );
  //     }

  //     //if any error
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

  Future<void> saveExpenz(Expenzes expenz, BuildContext context) async {
    try {
      // Save to SharedPreferences
      final SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? existingExpenzes = pref.getStringList(expenzKey);

      if (existingExpenzes != null) {
        expenList = existingExpenzes
            .map((e) => Expenzes.fromJSON(json.decode(e)))
            .toList();
      }
      expenList.add(expenz);

      List<String> updatedExpenzesList =
          expenList.map((e) => json.encode(e.toJSON())).toList();
      pref.setStringList(expenzKey, updatedExpenzesList);

      // Save to Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference expenzCollection = firestore.collection('expenzes');
      await expenzCollection.add(expenz.toJSON());

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 3000),
            backgroundColor: kcButtonBlue,
            content: Text(
              "Expenze added successfully",
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

  //load the current expenzes
  // Future<List<Expenzes>>? loadExpenzes() async {
  //   try {
  //     final SharedPreferences pref = await SharedPreferences.getInstance();
  //     List<String>? existingExpenzes = pref.getStringList(expenzKey);
  //     //convert encoded strings to expenze object and added to the list
  //     if (existingExpenzes != null) {
  //       expenList = existingExpenzes
  //           .map((e) => Expenzes.fromJSON(json.decode(e)))
  //           .toList();
  //     }
  //     return expenList;
  //   } catch (err) {
  //     return [];
  //   }
  // }

  Future<List<Expenzes>> loadExpenzes() async {
    try {
      // Initialize Firestore and reference the collection
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference expenzCollection = firestore.collection('expenzes');

      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await expenzCollection.get();

      // Map Firestore documents to Expenzes objects
      List<Expenzes> expenList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Expenzes.fromJSON(
            data); // Assuming you have a method to convert JSON to Expenzes
      }).toList();

      return expenList;
    } catch (err) {
      // Handle error, e.g., log error and return empty list
      print("Error loading expenzes data: $err");
      return []; // Return empty list in case of error
    }
  }

  //delete an expenz
  // Future<void> deleteExpenz(int id, BuildContext context) async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     List<String>? existingExpenzes = pref.getStringList(expenzKey);
  //     if (existingExpenzes != null) {
  //       expenList = existingExpenzes
  //           .map((e) => Expenzes.fromJSON(json.decode(e)))
  //           .toList();
  //       //remove the expenz
  //       expenList.removeWhere((element) => element.id == id);
  //       //encode the expenz list to json and store it
  //       List<String> updatedExpenzList =
  //           expenList.map((e) => json.encode(e.toJSON())).toList();
  //       pref.setStringList(expenzKey, updatedExpenzList);
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             duration: const Duration(seconds: 1),
  //             backgroundColor: kcButtonBlue,
  //             content: Text(
  //               "Expenz deleted succsussfuly",
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

  Future<void> deleteExpenz(int id, BuildContext context) async {
    try {
      // Delete from SharedPreferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? existingExpenzes = pref.getStringList(expenzKey);
      List<Expenzes> expenList = [];

      if (existingExpenzes != null) {
        expenList = existingExpenzes
            .map((e) => Expenzes.fromJSON(json.decode(e)))
            .toList();

        // Remove the expenz with matching ID
        expenList.removeWhere((element) => element.id == id);

        // Update SharedPreferences
        List<String> updatedExpenzList =
            expenList.map((e) => json.encode(e.toJSON())).toList();
        await pref.setStringList(expenzKey, updatedExpenzList);
      }

      // Delete from Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference expenzCollection = firestore.collection('expenzes');

      QuerySnapshot querySnapshot =
          await expenzCollection.where('id', isEqualTo: id).get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: kcButtonBlue,
          content: Text(
            "Expenz deleted successfully",
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

  Future<void> removeAllExpenzes(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove(expenzKey);
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
