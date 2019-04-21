import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:getpet/pets.dart';

class PetEngine {
  List<Pet> currentList;
  List<Pet> liked;
  Queue<Pet> skipped;
  SwipeNotifier notifier;

  Pet get currentPet => currentList.last;

  Pet get nextPet {
    if (currentList.length < 2) return null;
    return currentList[currentList.length - 2];
  }

  PetEngine(List<Pet> pets) {
    notifier = SwipeNotifier();

    this.currentList = pets;
    this.skipped = Queue<Pet>();
    this.liked = [];
  }

  removeCurrentPet() {
    currentList.removeLast();
  }

  void skip(Pet pet) {
    this.skipped.addLast(pet);
  }

  void getRecentlySkipped() {
    if (this.skipped.isNotEmpty) {
      this.currentList.add(this.skipped.removeLast());
    }
  }
}

enum Swiped { left, right, undo, none }

class SwipeNotifier extends ChangeNotifier {
  Swiped swiped = Swiped.none;

  likeCurrent() {
    swiped = Swiped.right;
    notifyListeners();
  }

  skipCurrent() {
    swiped = Swiped.left;
    notifyListeners();
  }

  undo() {
    swiped = Swiped.undo;
    notifyListeners();
  }
}
