import 'package:flutter/material.dart';
import 'package:internshala_search_page/main.dart';

class FiltersPage extends StatefulWidget {
  final Map<int, dynamic> profiles;
  final Map<int, dynamic> locations;
  final Map<int, dynamic> durations;
  final Function(Map<int, dynamic> selectedProfiles, Map<int, dynamic> selectedLocations, Map<int, dynamic> selectedDurations) onApplyFilters;

  const FiltersPage({
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
        title: const Text('Filters'),
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
              const SizedBox(height: 15,),
              const Spacer(),
              ElevatedButton(

                  onPressed: (){
                    widget.onApplyFilters(selectedProfiles, selectedLocations, selectedDurations);
                    Navigator.pop(context);
                  }, child:const Text('Apply Filters')),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Map<int, dynamic> items, Map<int, dynamic> selectedItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding:const EdgeInsets.all(8),
            child: Row(
              children: [
                const Text('Filter by  '),
                Text(title,style: const TextStyle(fontSize: 15,color: AppColors.primaryColor),)
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1.5,
                color: Colors.grey.shade400
              )
          
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ExpansionTile(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(0),
                ),
                collapsedShape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(0),
                ),
                title: Text(title),
                children: items.entries.map((entry) {
                  return CheckboxListTile(
                    activeColor: AppColors.primaryColor,
                    title: Text(entry.value.toString().replaceAll('[', '').replaceAll(']','')),
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
            ),
          ),
        ),

      ],
    );
  }
}
