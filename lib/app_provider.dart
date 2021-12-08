import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    int index = 7;
    switch (index) {
      case 1:
        _maxWeight = 1500;
        items = [
          Item("Jambu", 11500, 600),
          Item("Kiwi", 18000, 500),
          Item("Lemon", 6000, 450),
          Item("Buah Naga", 6200, 400),
          Item("Apel", 6900, 200),
        ];
        break;
      case 2:
        _maxWeight = 1750;
        items = [
          Item("Delima", 5500, 800),
          Item("Salak", 20000, 850),
          Item("Buah Naga", 6200, 400),
          Item("Srikaya", 3500, 500),
          Item("Markisa", 5000, 600),
        ];
        break;
      case 3:
        _maxWeight = 1600;
        items = [
          Item("Salak", 20000, 850),
          Item("Delima", 5500, 800),
          Item("Buah Naga", 6200, 400),
          Item("Nanas", 8000, 800),
          Item("Mangga", 10000, 750),
          Item("Blimbing", 6200, 400),
        ];
        break;
      case 4:
        _maxWeight = 1400;
        items = [
          Item("Buah Naga", 6200, 400),
          Item("Anggur", 8000, 100),
          Item("Pisang", 12000, 700),
          Item("Kurma", 12000, 800),
          Item("Jeruk", 3800, 250),
          Item("Kelengkeng", 13300, 750),
        ];
        break;
      case 5:
        _maxWeight = 2000;
        items = [
          Item("Blimbing", 6200, 400),
          Item("Strawberry", 14500, 500),
          Item("Jambu", 11500, 600),
          Item("Anggur", 8000, 100),
          Item("Salak", 20000, 850),
          Item("Nanas", 8000, 800),
        ];
        break;
      case 6:
        _maxWeight = 1000;
        items = [
          Item("Jambu", 11500, 600),
          Item("Kurma", 12000, 800),
          Item("Nanas", 8000, 800),
          Item("Apel", 6900, 200),
        ];
        break;
      case 7:
        _maxWeight = 1500;
        items = [
          Item("Blimbing", 6200, 400),
          Item("Rambutan", 8900, 500),
          Item("Kurma", 12000, 800),
          Item("Jeruk", 3800, 250),
        ];
        break;
      default:
        _maxWeight = 0;
        items = [];
        break;
    }

    compute();
  }

  bool get isInputValid => _name.isNotEmpty && _weight > 0 && _profit > 0;

  String _name = "";
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  double _weight = 0;
  double get weight => _weight;
  set weight(double weight) {
    _weight = weight;
    notifyListeners();
  }

  double _profit = 0;
  double get profit => _profit;
  set profit(double profit) {
    _profit = profit;
    notifyListeners();
  }

  late double _maxWeight;
  double get maxWeight => _maxWeight;
  set maxWeight(double maxWeight) {
    _maxWeight = maxWeight;
    compute();
  }

  late List<Item> items;

  void add() {
    if (isInputValid) {
      items.add(Item(name, profit, weight));

      compute();

      _profit = 0;
      _weight = 0;

      notifyListeners();
    }
  }

  void delete(int i) {
    items.removeAt(i);
    compute();
    notifyListeners();
  }

  double totalProfit = 0;

  Timer? _debounce;
  void compute() {
    if (_debounce != null && _debounce!.isActive) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      Node result = knapsack(maxWeight, items);

      totalProfit = result.totalProfit;
      for (var item in items) {
        item.isSelected = false;
      }

      Node? temp = result;
      while (temp != null) {
        if (temp.level >= 0) {
          items[temp.level].isSelected = temp.status;
        }

        temp = temp.parent;
      }

      notifyListeners();
    });
  }

  Node knapsack(double maxWeight, List<Item> items) {
    // Pengurutan density secara descending
    items.sort((a, b) => b.density.compareTo(a.density));

    // Membuat queue untuk penjelajahan graf
    Node u = Node(level: -1);
    Node v1 = Node();
    Node v2 = Node();
    Queue<Node> queue = Queue.from([u]);

    // Proses komputasi brute force BFS
    Node maxNode = u;

    while (queue.isNotEmpty) {
      // Dequeue node
      u = queue.removeFirst();

      // Jika tidak punya cabang maka skip
      if (u.level == items.length - 1) {
        continue;
      }

      // Ambil node
      v1 = Node(
        level: u.level + 1,
        totalWeight: u.totalWeight + items[u.level + 1].weight,
        totalProfit: u.totalProfit + items[u.level + 1].profit,
        parent: u,
        status: true,
      );

      // Jika profit baru kurang dari W dan profit lebih besar dari sebelumnya
      // Update profit
      if (v1.totalWeight <= maxWeight) {
        queue.addLast(v1);

        if (v1.totalProfit > maxNode.totalProfit) {
          maxNode = v1;
        }
      }

      if (u.level < items.length - 2) {
        // Tidak mengambil node
        v2 = Node(
          level: u.level + 1,
          totalWeight: u.totalWeight,
          totalProfit: u.totalProfit,
          parent: u,
        );

        queue.addLast(v2);
      }
    }

    return maxNode;
  }
}

class Item {
  bool isSelected = false;
  final String name;
  final double profit;
  final double weight;

  Item(this.name, this.profit, this.weight);

  double get density => profit / weight;

  @override
  String toString() => "Item(name: $name, profit: $profit, weight: $weight)";
}

class Node {
  final Node? parent;
  final bool status;
  final double totalProfit;
  final double totalWeight;
  final int level;

  Node({
    this.status = false,
    this.level = 0,
    this.parent,
    this.totalProfit = 0,
    this.totalWeight = 0,
  });

  @override
  String toString() =>
      "Node(level: $level, profit: ${totalProfit}, weight: ${totalWeight}, status: $status)";
}
