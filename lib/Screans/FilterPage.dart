import 'package:flutter/material.dart';
import 'package:internshala_search_page/main.dart';

class FiltersPage extends StatefulWidget {
  final Map<int, dynamic> profiles;
  final Map<int, dynamic> locations;
  final Map<int, dynamic> durations;
  final Function(Map<int, dynamic> selectedProfiles, Map<int, dynamic> selectedLocations, Map<int, dynamic> selectedDurations) onApplyFilters;

  FiltersPage({
    required this.profiles,
    required this.locations,
    required this.durations,
    required this.onApplyFilters,
  });

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {

  late Map<int, dynamic> processedProfiles;
  late Map<int, dynamic> processedLocations;
  late Map<int, dynamic> processedDurations;

  @override
  void initState() {
    super.initState();
    processedProfiles = _removeDuplicates(widget.profiles);
    processedLocations = _removeDuplicates(widget.locations);
    processedDurations = _removeDuplicates(widget.durations);
  }

  Map<int, dynamic> _removeDuplicates(Map<int, dynamic> items) {
    final seenValues = <dynamic>{};
    final result = <int, dynamic>{};

    items.forEach((key, value) {
      if (seenValues.add(value) && value.isNotEmpty) {
        result[key] = value;
      }
    });

    return result;
  }
  Map<int, dynamic> selectedProfiles = {};
  Map<int, dynamic> selectedLocations = {};
  Map<int, dynamic> selectedDurations = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildFilterSection('Profiles', processedProfiles, selectedProfiles),
                _buildFilterSection('Locations', processedLocations, selectedLocations),
                _buildFilterSection('Durations', processedDurations, selectedDurations),

              ],
            ),
          ),
          Row(
            children: [
              SizedBox(height: 15,),
              Spacer(),
              ElevatedButton(

                  onPressed: (){
                    widget.onApplyFilters(selectedProfiles, selectedLocations, selectedDurations);
                    Navigator.pop(context);
                  }, child:Text('Apply Filters')),
              Spacer(),
            ],
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Map<int, dynamic> items, Map<int, dynamic> selectedItems) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpansionTile(
          title: Text(title),
          children: items.entries.map((entry) {
            return CheckboxListTile(
              activeColor: AppColors.primaryColor,
              title: Text(entry.value.toString()),
              value: selectedItems.containsKey(entry.key),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedItems[entry.key] = entry.value.toString();
                  } else {
                    selectedItems.remove(entry.key);
                  }
                });
              },
            );
          }).toList(),
        ),

      ],
    );
  }
}
