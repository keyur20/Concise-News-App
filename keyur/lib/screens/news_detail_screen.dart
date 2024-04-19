import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:test_2/screens/detail_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newImage,
      newsTitle,
      newsDate,
      author,
      description,
      content,
      source;

  const NewsDetailScreen({
    Key? key,
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

  bool _happySelected = false;
  bool _sadSelected = false;
  bool _angrySelected = false;
  bool _likeSelected = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
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
                Text(
                  widget.newsTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: height * .02),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.source,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .03),
                Text(
                  widget.description,
                  maxLines: 6,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          Positioned(
            bottom: 20.0,
            right: 20.0,
            left: 20.0, // Add left padding to align with the right padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out children equally
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Show emoji selection
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return EmojiSelection(
                          onEmojiSelected: (emoji) {
                            // Handle selected emoji
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    'Select Emoji',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Navigate to WebView or launch URL
                  },
                  child: Text(
                    'Read More',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiSelection extends StatelessWidget {
  final void Function(String) onEmojiSelected;

  const EmojiSelection({Key? key, required this.onEmojiSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Select Emoji',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onEmojiSelected("😊");
                },
                child: Text("😊", style: TextStyle(fontSize: 30)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onEmojiSelected("😔");
                },
                child: Text("😔", style: TextStyle(fontSize: 30)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onEmojiSelected("😠");
                },
                child: Text("😠", style: TextStyle(fontSize: 30)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  onEmojiSelected("👍");
                },
                child: Text("👍", style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
