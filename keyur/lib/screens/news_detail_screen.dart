
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:test_2/screens/detail_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {

  final String newImage,newsTitle, newsDate,author,description,content,source;

// constructor passed 
   const NewsDetailScreen({Key? key ,

    required this.newImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source, 
    

  }) : super(key: key);
  


  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

  final format = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    DateTime dateTime = DateTime.parse(widget.newsDate);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height * .45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                  imageUrl: widget.newImage,
                fit: BoxFit.cover,
                placeholder: (context,ulr ) => Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .4),
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                Text(widget.newsTitle, style: GoogleFonts.poppins(fontSize: 20,color: Colors.black87 , fontWeight: FontWeight.w700),),
                SizedBox(height: height * .02,),
                Row(
                  children: [
                    Expanded(child: Text(widget.source, style: GoogleFonts.poppins(fontSize: 13,color: Colors.black87, fontWeight: FontWeight.w600),)),
                    Text(format.format(dateTime), style: GoogleFonts.poppins(fontSize: 12,color: Colors.black87, fontWeight: FontWeight.w600),),
                  ],
                ),
                
                SizedBox(height: height * .03,),
                Text(widget.description,maxLines: 6, style: GoogleFonts.poppins(fontSize: 15,color: Colors.black87, fontWeight: FontWeight.w500),),
                
                // //Text(widget.content,maxLines: 6, style: GoogleFonts.poppins(fontSize: 15,color: Colors.black87, fontWeight: FontWeight.w500),),
                
              ],
            ),
            
          ),
          Positioned(
            
              bottom: 20.0, // Adjust bottom spacing as per your requirement
              right: 20.0, // Adjust right spacing as per your requirement
              child: SizedBox(
                width: 150.0, // Width of the button
                height: 50.0, // Height of the button
                
                child: ElevatedButton(
                  onPressed: () 
                  async {
                      final String urlString = widget.source; // Assuming 'source' contains the URL
                      final Uri url = Uri.parse(urlString);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => WebView(
                            newsTitle: widget.newsTitle,
                            newsDate: widget.newsDate,
                            author: widget.author,
                            description: widget.description,
                            content: widget.content,
                            source: widget.source, 
                          ),
                        ),
                      );
                  
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                        
                      } else {
                        // Handle the case where the URL cannot be launched
                        // For example, show a SnackBar with an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch $urlString')),
                        );
                    };
                  },
                  child: Text('Read More',style: GoogleFonts.poppins(fontSize: 15 ,color: Colors.black87, fontWeight: FontWeight.w700),),
                ),
              ),
            ),
        ],
      ),
    );
  }
}