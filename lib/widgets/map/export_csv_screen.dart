import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/csv_exporter.dart';

class ExportCsvScreen extends StatelessWidget {
  static const String routeName = 'ExportCsvScreen';
  const ExportCsvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ocean Change')),
      body: const Center(
        child: Column(
          children: [CheckBoxWidget()],
        ),
      ),
    );
  }
}

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CheckBoxWidgetState();
  }
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool? isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value;
              });
            }),
        const Text("Export only my observations"),
        ElevatedButton(
          onPressed: () {
            if (isChecked != null) {
              exportCSVByUser(isChecked!);
            } else {
              exportCSVByUser(false);
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          child: const Text('CSV Export'),
        )
      ],
    );
  }
}
