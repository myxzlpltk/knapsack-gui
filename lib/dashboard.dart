import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knapsack_gui/app_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController profitController = TextEditingController();

    return ChangeNotifierProvider<AppProvider>(
      create: (context) => AppProvider(),
      builder: (context, _) => Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.spaceMono(fontSize: 14),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelText: "Kapasistas Knapsack",
                              ),
                              initialValue: Provider.of<AppProvider>(context,
                                      listen: false)
                                  .maxWeight
                                  .toString(),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .maxWeight = 0;
                                  return;
                                }

                                try {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .maxWeight = double.parse(value);
                                } catch (e) {
                                  // do nothing
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Total Profit Maksimum",
                              style: GoogleFonts.spaceMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Consumer<AppProvider>(
                              builder: (context, state, _) => Text(
                                state.totalProfit.toString(),
                                style: GoogleFonts.spaceMono(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.spaceMono(fontSize: 14),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelText: "Nama",
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  Provider.of<AppProvider>(context,
                                      listen: false)
                                      .name = "";
                                  return;
                                }

                                try {
                                  Provider.of<AppProvider>(context,
                                      listen: false)
                                      .name = value;
                                } catch (e) {
                                  // do nothing
                                }
                              },
                            ),
                            const SizedBox(height: 16),TextFormField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: GoogleFonts.spaceMono(fontSize: 14),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelText: "Berat",
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  Provider.of<AppProvider>(context,
                                      listen: false)
                                      .weight = 0;
                                  return;
                                }

                                try {
                                  Provider.of<AppProvider>(context,
                                      listen: false)
                                      .weight = double.parse(value);
                                } catch (e) {
                                  // do nothing
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: profitController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.spaceMono(fontSize: 14),
                              decoration: InputDecoration(
                                labelStyle: GoogleFonts.spaceMono(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelText: "Keuntungan",
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .profit = 0;
                                  return;
                                }

                                try {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .profit = double.parse(value);
                                } catch (e) {
                                  // do nothing
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<AppProvider>(
                                child: Text(
                                  "Simpan",
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                builder: (context, state, child) =>
                                    ElevatedButton(
                                  onPressed: state.isInputValid
                                      ? () {
                                          weightController.text = "";
                                          profitController.text = "";
                                          Provider.of<AppProvider>(context,
                                                  listen: false)
                                              .add();
                                        }
                                      : null,
                                  child: child,
                                  style: ElevatedButton.styleFrom(
                                    visualDensity: VisualDensity.comfortable,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Text(
                      "Daftar Barang",
                      style: GoogleFonts.spaceMono(
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Consumer<AppProvider>(
                          builder: (context, state, _) => Wrap(
                            runSpacing: 16,
                            spacing: 16,
                            alignment: WrapAlignment.center,
                            children: List.generate(
                              state.items.length,
                              (i) => ItemCard(
                                item: state.items[i],
                                onTap: () {
                                  state.delete(i);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  final void Function()? onTap;

  const ItemCard({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.isSelected ? Colors.green.shade50 : Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width / 10,
        child: Column(
          children: [
            Text(
              item.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceMono(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Weight",
                        style: GoogleFonts.spaceMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${item.weight}",
                        style: GoogleFonts.spaceMono(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Profit",
                        style: GoogleFonts.spaceMono(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${item.profit}",
                        style: GoogleFonts.spaceMono(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1),
            Column(
              children: [
                Text(
                  "Density",
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.density.toStringAsFixed(2),
                  style: GoogleFonts.spaceMono(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                child: Text(
                  "Hapus",
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red.shade300,
                  visualDensity: VisualDensity.comfortable,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
