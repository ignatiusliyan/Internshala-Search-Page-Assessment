import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internshala_search_page/main.dart';

import 'FilterPage.dart';

class InternshipPage extends StatefulWidget {
  const InternshipPage({super.key});

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

class _InternshipPageState extends State<InternshipPage> {
  Map<String, dynamic> filteredInternships = {};
  Map<String, dynamic> internships = {};

  Map<int, dynamic> profiles = {};
  Map<int, dynamic> location = {};
  Map<int, dynamic> duration = {};

  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_searchInternships);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchInternships);
    _searchController.dispose();
    super.dispose();
  }

  void _searchInternships() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredInternships = internships;
      });
    } else {
      List<int> matchingIds = profiles.entries
          .where(
              (entry) => entry.value.toString().toLowerCase().contains(query))
          .map((entry) => entry.key)
          .toList();

      setState(() {
        filteredInternships = {
          'internship_ids': internships['internship_ids']
              .where((id) => matchingIds.contains(id))
              .toList(),
          'internships_meta': internships['internships_meta'],
        };
      });
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://internshala.com/flutter_hiring/search'));

      if (response.statusCode == 200) {
        internships = json.decode(response.body);
        filteredInternships = internships;
        for (int i = 0; i < internships['internship_ids'].length; i++) {
          int id = internships['internship_ids'][i];
          profiles[id] =
              internships['internships_meta'][id.toString()]['title'];
          duration[id] =
              internships['internships_meta'][id.toString()]['duration'];
          location[id] =
              internships['internships_meta'][id.toString()]['location_names'];
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  int _selectedIndex = 2;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isSearchBarVisible = false;
  double _searchBarHeight =0;



  void _toggleSearchBar() {
    setState(() {
      _isSearchBarVisible = !_isSearchBarVisible;
      _searchBarHeight = _isSearchBarVisible ? 60.0 : 0.0;
    });
  }

  void _openFiltersPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FiltersPage(
          profiles: profiles,
          locations: location,
          durations: duration,
          onApplyFilters:
              (selectedProfiles, selectedLocations, selectedDurations) {
            _applyFilters(
                selectedProfiles, selectedLocations, selectedDurations);
          },
        ),
      ),
    );
  }

  void _applyFilters(
      Map<int, dynamic> selectedProfiles,
      Map<int, dynamic> selectedLocations,
      Map<int, dynamic> selectedDurations) {
    List<int> internshipIds = List<int>.from(internships['internship_ids']);
    List<int> matchingIds = internshipIds.where((id) {
      bool matchesProfile =
          selectedProfiles.isEmpty || selectedProfiles.containsKey(id);
      bool matchesLocation =
          selectedLocations.isEmpty || selectedLocations.containsKey(id);
      bool matchesDuration =
          selectedDurations.isEmpty || selectedDurations.containsKey(id);
      return matchesProfile && matchesLocation && matchesDuration;
    }).toList();

    if(matchingIds.isEmpty){
      const SnackBar noresult=SnackBar(
        backgroundColor: AppColors.primaryColor,
          duration:Duration(seconds: 2),
          content: Text('No results found',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),));

      ScaffoldMessenger.of(context).showSnackBar(noresult);
    }

    setState(() {
      filteredInternships = {
        'internship_ids': matchingIds,
        'internships_meta': internships['internships_meta'],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.lightBlueAccent.shade100,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: const Text(
          'Internships',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: _toggleSearchBar,
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message_outlined),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off,
                        size: 50,
                        color: Colors.blue,
                      ),
                      const Text('Error occurred'),
                      TextButton(
                        onPressed: fetchData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (_isSearchBarVisible)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            filled: true,
                            fillColor: Colors.grey[200],
                            focusColor: AppColors.primaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        filteredInternships=internships;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      size: 22,
                                      color: Colors.red.shade300,
                                    )),
                                IconButton(
                                    onPressed: _openFiltersPage,
                                    icon: const Icon(
                                      Icons.filter_alt_outlined,
                                      size: 22,
                                      color: AppColors.primaryColor,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child:ListView.builder(
                        itemCount: filteredInternships['internship_ids'].length,
                        itemBuilder: (BuildContext context, int index) {
                          int ids =
                              filteredInternships['internship_ids'][index];
                          return Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (filteredInternships[
                                              'internships_meta']
                                          [ids.toString()]['is_active'])
                                        Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.trending_up,
                                                  size: 15,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Actively hiring',
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 3),
                                      Text(
                                        filteredInternships['internships_meta']
                                            [ids.toString()]['title'],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        filteredInternships['internships_meta']
                                            [ids.toString()]['company_name'],
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(filteredInternships[
                                                              'internships_meta']
                                                          [ids.toString()]
                                                      ['location_names']
                                                  .isNotEmpty
                                              ? filteredInternships[
                                                          'internships_meta']
                                                      [ids.toString()]
                                                  ['location_names'][0]
                                              : filteredInternships[
                                          'internships_meta']
                                          [ids.toString()]
                                          ['is_active']==true
                                              ?'Work From Home'
                                              :'Not Mentioned'),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.play_circle_outline),
                                          const SizedBox(width: 4),
                                          Text(filteredInternships[
                                                  'internships_meta']
                                              [ids.toString()]['start_date']),
                                          const SizedBox(width: 15),
                                          const Icon(
                                              Icons.calendar_today_rounded),
                                          const SizedBox(width: 4),
                                          Text(filteredInternships[
                                                  'internships_meta']
                                              [ids.toString()]['duration']),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.money_outlined),
                                          const SizedBox(width: 4),
                                          Text(filteredInternships[
                                                              'internships_meta']
                                                          [ids.toString()]
                                                      ['stipend']['salary']
                                                  .isNotEmpty
                                              ? filteredInternships[
                                                          'internships_meta']
                                                      [ids.toString()]
                                                  ['stipend']['salary']
                                              : ' Not disclosed'),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.timer_outlined),
                                          const SizedBox(width: 4),
                                          Text(filteredInternships[
                                          'internships_meta']
                                          [ids.toString()]
                                          ['expiring_in']
                                              .isNotEmpty
                                              ? filteredInternships[
                                          'internships_meta']
                                          [ids.toString()]
                                          ['expiring_in']
                                              : ' Not Mentioned'),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          const Icon(Icons.cases_outlined),
                                          const SizedBox(width: 4),
                                          Text(filteredInternships[
                                          'internships_meta']
                                          [ids.toString()]
                                          ['experience']
                                              .isNotEmpty
                                              ? filteredInternships[
                                          'internships_meta']
                                          [ids.toString()]
                                          ['experience']
                                              : 'Experience not disclosed'),
                                        ],
                                      ),
                                      const SizedBox(height: 3,),
                                      if(filteredInternships['internships_meta'][ids.toString()]['job_segments'].isNotEmpty)
                                        Row(
                                        children: [
                                          const SizedBox(height: 25,),
                                            Container(
                                                decoration: BoxDecoration(
                                                  color:Colors.grey.shade200,
                                                  border: Border.all(color: Colors.grey.shade300),
                                                  borderRadius: BorderRadius.circular(3),
                                                ),
                                                child: const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                    child: Text('Intership for Women',style: TextStyle(fontSize: 12),)),
                                              ),
                                        ],
                                      ),
                                      if(filteredInternships['internships_meta'][ids.toString()]['part_time'])
                                        Row(
                                          children: [
                                            const SizedBox(height: 25,),
                                            Container(
                                              decoration: BoxDecoration(
                                                color:Colors.grey.shade200,
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child:const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  child: Text('Part time',style: TextStyle(fontSize: 12),)),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 0.7),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('View details'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Apply Now'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_post_office_rounded), label: 'Jobs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.send_outlined), label: 'Internships'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
