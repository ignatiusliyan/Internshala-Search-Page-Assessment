import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internshala_search_page/main.dart';

class internship_page extends StatefulWidget {
  const internship_page({super.key});

  @override
  State<internship_page> createState() => _internship_pageState();
}

class _internship_pageState extends State<internship_page> {


  //Method to parse the data into json after checking the request has been succeeded

  Future fetchdata() async{
    final response = await http.get(Uri.parse('https://internshala.com/flutter_hiring/search'));

    if (response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      throw Exception('Failed to Load Data');
    }
  }

  int _selectedIndex =2;
  TextEditingController _searchController = TextEditingController();

  void currentnavBar(int Index){
    setState(() {
      _selectedIndex = Index;
    });
  }

  bool _isSearchBarVisible = false;
  double _searchBarHeight = 0.0;

  void _toggleSearchBar() {
    setState(() {
      _isSearchBarVisible = !_isSearchBarVisible;
      _searchBarHeight = _isSearchBarVisible ? 60.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.lightBlueAccent.shade100,
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: (){},
         icon: const Icon(Icons.menu),
        ),
        title: Text('Internships',style: TextStyle(fontSize: 22),),
        actions: [
          IconButton(
              onPressed:
                _toggleSearchBar,
              icon:Icon(Icons.search)
          ),

          IconButton(
              onPressed: (){},
              icon:Icon(Icons.notifications_none)
          ),
          IconButton(
              onPressed: (){},
              icon:Icon(Icons.message_outlined)
          ),
        ],
      ),
      body:FutureBuilder(future: fetchdata(), builder: (context,snapshot){
        if (snapshot.connectionState==ConnectionState.waiting){
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Center(
                  child: CircularProgressIndicator(color: AppColors.primaryColor,),
                )
              ]);
        }else if(snapshot.hasError){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(Icons.cloud_off,size: 50,color: AppColors.primaryColor,),
              ),
              const Text('No Internet Connection'),
              TextButton(onPressed: (){
                setState(() {
                  fetchdata();
                });
              }, child: Text('Retry'))
            ],
          );
        }
        else{
          return Column(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _searchBarHeight,
                child: Visibility(
                  visible: _isSearchBarVisible,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: (){
                                  _searchController.clear();
                                },
                                icon: Icon(Icons.cancel_outlined,size: 25,color:Colors.red.shade300,),
                              ),
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.filter_alt_outlined,size: 25,color: AppColors.primaryColor,),
                              ),
                            ],
                          ),
                          hintText: 'Search...',
                          filled: true,
                          fillColor:Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:snapshot.data['internship_ids'].length,
                  itemBuilder: (BuildContext context,int index){
                    int ids = snapshot.data['internship_ids'][index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(snapshot.data['internships_meta'][ids.toString()]['title'],style: const TextStyle(fontSize: 18),),
                                const SizedBox(width: 2,),
                                Text(snapshot.data['internships_meta'][ids.toString()]['company_name'],style: const TextStyle(color:Colors.grey),),
                                const SizedBox(height: 6,),
                              ],

                            ),

                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_on,color: Colors.grey,),
                                    const SizedBox(width: 4,),
                                    Text(snapshot.data['internships_meta'][ids.toString()]['location_names'].isNotEmpty
                                        ?snapshot.data['internships_meta'][ids.toString()]['location_names'][0]: ' Not Mentioned'),
                                  ],
                                ),
                                const SizedBox(height: 6,),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.play_circle_outline),
                                    const SizedBox(width: 4,),
                                    Text(snapshot.data['internships_meta'][ids.toString()]['start_date']),
                                    const SizedBox(width: 15,),
                                    const Icon(Icons.calendar_today_rounded),
                                    const SizedBox(width: 4,),
                                    Text(snapshot.data['internships_meta'][ids.toString()]['duration']),
                                  ],
                                ),
                                const SizedBox(height: 6,),
                                Row(
                                  children: [
                                    const Icon(Icons.money_outlined),
                                    const SizedBox(width: 4,),
                                    Text(snapshot.data['internships_meta'][ids.toString()]['stipend']['salary'].isNotEmpty
                                        ?snapshot.data['internships_meta'][ids.toString()]['stipend']['salary']: ' Not disclosed'),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Divider(thickness: 0.7,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: (){},
                                child: const Text('View details'),
                              ),
                              ElevatedButton(
                                  onPressed: (){},
                                  child: const Text('Apply Now'))
                            ],
                          ),
                          // const SizedBox(width: 10,)
                        ],
                      ),
                    );
                  },)
              ),
            ],
          );
        }
      }),
        bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.local_post_office_rounded),label: 'Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.send_outlined),label: 'Internships'),
      ],
        currentIndex: _selectedIndex,
          onTap: currentnavBar,
    )

    );
  }
}
