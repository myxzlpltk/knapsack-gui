import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    items.sort((a, b) => b.density.compareTo(a.density));
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

  double _maxWeight = 10;
  double get maxWeight => _maxWeight;
  set maxWeight(double maxWeight) {
    _maxWeight = maxWeight;
    compute();
  }

  List<Item> items = [
    Item("Item #1", 40, 2),
    Item("Item #2", 50, 3.14),
    Item("Item #3", 100, 1.98),
    Item("Item #4", 95, 5),
    Item("Item #5", 30, 3),
  ];

  void add() {
    if (isInputValid) {
      items.add(Item(name, profit, weight));
      items.sort((a, b) => b.density.compareTo(a.density));

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
