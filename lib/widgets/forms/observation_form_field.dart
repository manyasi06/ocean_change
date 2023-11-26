import 'dart:collection';

import 'package:flutter/material.dart';

import '../../models/user_report.dart';
import '../../models/observation.dart';

import '../../widgets/forms/species_form_field.dart';

class ObservationFormField extends StatefulWidget {
  const ObservationFormField(
      {super.key, required this.userReport, required this.observationList});

  final UserReport userReport;
  final List<Observation> observationList;

  @override
  State<ObservationFormField> createState() => _ObservationFormFieldState();
}

class _ObservationFormFieldState extends State<ObservationFormField> {
  late Observation chosenObservation;
  late String observationImg;

  @override
  void initState() {
    super.initState();
    chosenObservation = widget.observationList.first;
    widget.userReport.observation = widget.observationList.first.name;
    observationImg = getImageForObservation(widget.observationList.first.name)!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('What did you see?'),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: DropdownButton<String>(
                value: widget.userReport.observation,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  setState(() {
                    widget.userReport.observation = value!;

                    chosenObservation = widget.observationList.firstWhere(
                        (element) =>
                            element.name == widget.userReport.observation);

                    observationImg = chosenObservation.name;
                  });
                },
                items: widget.observationList
                    .map<DropdownMenuItem<String>>((Observation observation) {
                  return DropdownMenuItem<String>(
                    value: observation.name,
                    child: Text(observation.name),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(child: Image(
              image: AssetImage(getImageForObservation(observationImg)),
              fit: BoxFit.fill,
              height: 150,
            ))

          ],
        ),
        Row(
          children: [
            const Text('Observation Details: '),
            SpeciesFormField(
                userReport: widget.userReport,
                chosenObservation: chosenObservation),
          ],
        )
      ],
    );
  }

  String getImageForObservation(String input) {
    HashMap<String, String> imagesSpecies = HashMap();
    final entries = {
      'Dead crabs in pots': 'assets/images/Dead_Dungeness_crabs_in_pots.png',
      'Dolphin': 'assets/images/dolphin.png',
      'Jellyfish': 'assets/images/water_jelly_OSG.jpg',
      'Moonfish/Opah': 'assets/images/opah.jpg',
      'Ocean sunfish/Mola mola': 'assets/images/mola_mola.jpg',
      'Pyrozomes': 'assets/images/pyrozomes.png',
      'Squid': 'assets/images/humbolt_squid.jpg',
      'Starfish': 'assets/images/starfish.jpg',
      'Whale': 'assets/images/whale.jpg',
      'Trash': 'assets/images/trash.jpg'
    };
    imagesSpecies.addAll(entries);
    final displayImg = entries[input];
    return displayImg ?? 'assets/images/notapplicable.png';
  }
}
