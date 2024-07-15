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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
          onPressed: (){},
         icon: Icon(Icons.menu),
        ),
        title: Text('Internships'),
        actions: [
          IconButton(
              onPressed: (){},
              icon:Icon(Icons.search)
          ),
          IconButton(
              onPressed: (){},
              icon:Icon(Icons.bookmark_border)
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
          return Column(
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
              Center(
                child: Icon(Icons.cloud_off,size: 50,color: AppColors.primaryColor,),
              ),
              Text('No Internet Connection')
            ],
          );
        }
        else{
          return ListView.builder(
            itemCount:snapshot.data['internship_ids'].length,
            itemBuilder: (BuildContext context,int index){
            return ListTile(
              leading: Text(snapshot.data['internship_ids'][index].toString()),
            );
          },);
        }
      })
    );
  }
}
