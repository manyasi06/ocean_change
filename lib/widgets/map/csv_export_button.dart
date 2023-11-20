import 'package:flutter/material.dart';
import 'package:ocean_change/widgets/map/export_csv_screen.dart';

import '../../components/csv_exporter.dart';

class CSVExportButton extends StatelessWidget {
  const CSVExportButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, ExportCsvScreen.routeName);
      },
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      child: const Text('CSV'),
    );
  }
}
