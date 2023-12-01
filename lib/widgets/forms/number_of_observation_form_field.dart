import 'package:flutter/material.dart';
import 'package:ocean_change/models/user_report.dart';

class NumberOfObservationFormField extends StatefulWidget {
  const NumberOfObservationFormField({super.key, required this.userReport});
  final UserReport userReport;

  @override
  State<NumberOfObservationFormField> createState() =>
      _NumberOfObservationFormFieldState();
}

class _NumberOfObservationFormFieldState extends State<NumberOfObservationFormField> {
  // List for dropdown values
  final List<String> _obsNumber = <String>[
    'Single (1)',
    'A Few (2-10)',
    'Many (11-100)',
    'Abundant (100+)'];
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        const Row(
          children: [Text("How many did you see?")]
        ),
        Row(
          children: [
            SizedBox(
              height: 70,
              width: 210,
              child:
                DropdownButtonFormField<String>(
                  items: _obsNumber.map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value
                    ),
                  )).toList(),
                  // Update user report and value for display
                  // when different selection is chosen
                  onChanged: (String? value) {
                    setState(() {
                      widget.userReport.observationNumber = value!;
                      dropdownValue = value;
                    });
                  },
                  value: dropdownValue,
                  hint: const Text("Select Option"),
                  icon: const Icon(Icons.arrow_downward),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please make a selection';
                    } else {
                      return null;
                    }
                  },
                )
            )]
        )]
    );
  }
}
