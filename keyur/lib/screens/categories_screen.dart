

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:test_2/models/categories_news_model.dart';
import 'package:test_2/screen_model/news_screen_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test_2/screens/adminpanel.dart';
import 'package:test_2/screens/news_detail_screen.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final user = FirebaseAuth.instance.currentUser;

  signout()async{
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  NewsScreenModel newsScreenModel = NewsScreenModel();

  

  final format = DateFormat('MMMM dd, yyyy');

  String categoryName = 'general';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
    
  ];

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      
      appBar: AppBar(
        title: Text('News Category', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPanel()));
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child : Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index){

                  return InkWell(

                    onTap: () {
                      categoryName = categoriesList[index];
                      setState(() {
                        
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoriesList[index] ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          
                        ),
                    
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(child: Text(categoriesList[index].toString(),style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white
                          ),)),
                        ),
                      ),
                    ),
                  );
                  
                }
              ),
            ),

            SizedBox(height:20 ,),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsScreenModel.fetchCategoriesNewsApi(categoryName),
                
                builder: (BuildContext context, snapshot){
              
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  }else{
                    return ListView.builder(
              
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context , index){
                          
                          DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                          return InkWell(
                            onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                              NewsDetailScreen(
                                newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString()))
                            );
                          },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                        fit: BoxFit.cover,
                                        height: height * .18,
                                        width: width * .30,
                                        placeholder: (context, url) => Container(child: Center( child: SpinKitCircle(size: 50,color: Colors.blue,),),),
                                                                                                                                                        
                                                                                      
                                                                                    
                                                                                
                                        errorWidget:(context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                      ),
                                    ),        
                                  Expanded(
                                    child: Container(
                                      height: height * .18,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          Text(
  snapshot.data!.articles![index].title.toString(),
  maxLines: 3,
  style: GoogleFonts.poppins(
    fontSize: 15,
    color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(255, 255, 255, 255) : Colors.black54,
    fontWeight: FontWeight.w700,
  ),
),

                                          Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                             Text(
  snapshot.data!.articles![index].source!.name.toString(),
  maxLines: 3,
  style: GoogleFonts.poppins(
    fontSize: 12,
    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black54,
    fontWeight: FontWeight.w600,
  ),
),

                                              Text(format.format(dateTime),
                                                
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                            
                            
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                
                              ),
                            ),
                          );
                        
                      }
                    ); 
                  }
              
                },
              ),
            ),
          ],

        )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: signout,
          child: Icon(Icons.login_rounded),
        ),
        

      
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
    color: Colors.amber,
    size: 50,
);