import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'comments.dart'; // Import the CommentsPage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'detail_view.dart';

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

  String? _selectedEmoji;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    DateTime dateTime = DateTime.parse(widget.newsDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _shareOnWhatsApp();
            },
            icon: Icon(Icons.share),
          ),
        ],
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
            left: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return EmojiSelection(
                          onEmojiSelected: (emoji) {
                            setState(() {
                              _selectedEmoji = emoji;
                            });
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {
                                _selectedEmoji = null;
                              });
                            });
                            // Store selected emoji in Firestore
                            _storeEmojiInFirestore(emoji);
                          },
                          selectedEmoji: _selectedEmoji,
                        );
                      },
                    );
                  },
                  child: Text(
                    'Select Emoji',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String newsId = _generateNewsId(widget.newsTitle);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentsPage(newsId: newsId)),
                    );
                  },
                  icon: Icon(Icons.comment),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailView(
                        newsTitle: widget.newsTitle,
                        newsDate: widget.newsDate,
                        author: widget.author,
                        description: widget.description,
                        content: widget.content,
                        source: widget.source,
                      )),
                    );
                  },
                  child: Text(
                    'Read More',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedEmoji != null)
            Positioned(
              bottom: 110.0,
              right: 80.0,
              child: AnimatedOpacity(
                opacity: _selectedEmoji != null ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: Text(
                  _selectedEmoji ?? '',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _shareOnWhatsApp() {
    String title = widget.newsTitle;
    String description = widget.description;
    String imageUrl = widget.newImage;
    String appDownloadLink = 'https://example.com'; // Replace with your actual app download link

    String shareMessage = '$title\n$description\n$imageUrl\n\nFor more such news, download the app: $appDownloadLink';

    try {
      Share.share(shareMessage);
    } catch (e) {
      print('Error sharing on WhatsApp: $e');
    }
  }

  void _storeEmojiInFirestore(String emoji) {
    // Get the current user's ID and email
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final email = currentUser.email;

      // Use the news title and user ID as the document ID
      String newsId = _generateNewsId(widget.newsTitle);
      String documentId = '$newsId-$userId';

      FirebaseFirestore.instance.collection('emojis').doc(documentId).set({
        'emoji': emoji,
        'user_email': email, // Add user's email to Firestore
      });
    }
  }

  String _generateNewsId(String newsTitle) {
    // Remove spaces and convert to lowercase to create a unique ID
    return newsTitle.replaceAll(' ', '').toLowerCase();
  }
}

class EmojiSelection extends StatelessWidget {
  final void Function(String) onEmojiSelected;
  final String? selectedEmoji;

  const EmojiSelection({Key? key, required this.onEmojiSelected, this.selectedEmoji})
      : super(key: key);

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
              buildEmojiButton(context, "😊"),
              buildEmojiButton(context, "😔"),
              buildEmojiButton(context, "😠"),
              buildEmojiButton(context, "👍"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEmojiButton(BuildContext context, String emoji) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onEmojiSelected(emoji);
      },
      child: Opacity(
        opacity: selectedEmoji == emoji ? 1.0 : 0.5,
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 30,
            color: selectedEmoji == emoji ? Colors.black : Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final String newsTitle;
  final String newsDate;
  final String author;
  final String description;
  final String content;
  final String source;

  const DetailView({
    Key? key,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Article'),
      ),
      body: Center(
        child: Text('Detail View Content'),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsDetailScreen(
        newImage: 'https://via.placeholder.com/150',
        newsTitle: 'Sample News',
        newsDate: '2024-04-23',
        author: 'John Doe',
        description: 'Sample Description',
        content: 'Sample Content',
        source: 'Sample Source',
      ),
    );
  }
}
