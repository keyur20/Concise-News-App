import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:test_2/models/News_Channel_Headlines_Model.dart';
import 'package:test_2/screen_model/news_screen_model.dart';
import 'package:test_2/screens/categories_screen.dart';
import 'package:test_2/models/categories_news_model.dart';
import 'package:test_2/screens/news_detail_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {
  bbcnews,
  theHindu,
  googleNews,
  reuters,
  cnn,
  alJazeera,
  business
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String selectedCategory = 'General'; // Initialize with a default value
  late String name = 'bbc-news'; // Initialize with a default value
  FilterList? selectedMenu; // Define selectedMenu variable

  @override
  void initState() {
    super.initState();
    fetchSelectedCategory();
  }

  // Method to fetch selected category from Firestore based on user's email
  void fetchSelectedCategory() async {
    if (user != null) {
      // Get the user's email
      String userEmail = user!.email!;
      // Fetch the document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('category').doc(userEmail).get();
      // Extract the value of the category field
      String category =
          userDoc.exists ? userDoc.get('category') : 'General'; // Use 'General' as default if document doesn't exist
      setState(() {
        selectedCategory = category;
      });
    }
  }

  signout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  NewsScreenModel newsScreenModel = NewsScreenModel();
  
  final format = DateFormat('MMMM dd, yyyy');

  List<String> sensitiveWords = ['killed', 'flu'];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 27,
            width: 27,
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
                switch (item) {
                  case FilterList.bbcnews:
                    name = 'bbc-news';
                    break;
                  case FilterList.theHindu:
                    name = 'the-hindu';
                    break;
                  case FilterList.googleNews:
                    name = 'google-news-in';
                    break;
                  case FilterList.business:
                    name = 'business-insider';
                    break;
                  case FilterList.reuters:
                    name = 'Reuters';
                    break;
                  case FilterList.cnn:
                    name = 'cnn';
                    break;
                  case FilterList.alJazeera:
                    name = 'al-jazeera-english';
                    break;
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcnews,
                child: Text('BBC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.theHindu,
                child: Text('The-Hindu'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.googleNews,
                child: Text('Google News India'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.business,
                child: Text('Business-Insider'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.reuters,
                child: Text('Reuters'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text('CNN-News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.alJazeera,
                child: Text('Al-Jazeera'),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .50,
              width: width,
              child: FutureBuilder<NewsChannelHeadlinesModel>(
                future: newsScreenModel.fetchNewsChannelheadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime =
                            DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                        String title = snapshot.data!.articles![index].title.toString().toLowerCase();

                        bool containsSensitiveWord = false;
                        for (String word in sensitiveWords) {
                          if (title.contains(word)) {
                            containsSensitiveWord = true;
                            break;
                          }
                        }

                        return InkWell(
                          onTap: () {
                            if (!containsSensitiveWord) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                            newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                            newsTitle: snapshot.data!.articles![index].title.toString(),
                                            newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                            author: snapshot.data!.articles![index].author.toString(),
                                            description: snapshot.data!.articles![index].description.toString(),
                                            content: snapshot.data!.articles![index].content.toString(),
                                            source: snapshot.data!.articles![index].source!.name.toString(),
                                          )));
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Sensitive Content Warning'),
                                    content: Text('The news contains sensitive content. Do you want to continue?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Go Back'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Continue'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => NewsDetailScreen(
                                                        newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                                        newsTitle: snapshot.data!.articles![index].title.toString(),
                                                        newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                                        author: snapshot.data!.articles![index].author.toString(),
                                                        description: snapshot.data!.articles![index].description.toString(),
                                                        content: snapshot.data!.articles![index].content.toString(),
                                                        source: snapshot.data!.articles![index].source!.name.toString(),
                                                      )));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * .78,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * .02,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(child: spinKit2),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error_outline, color: Colors.red),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 17,
                                  child: Card(
                                    elevation: 5,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.all(11),
                                      height: height * .22,
                                      width: width * .62,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.55,
                                            child: Text(
                                              snapshot.data!.articles![index].title.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: width * 0.49,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsScreenModel.fetchCategoriesNewsApi(selectedCategory),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        DateTime dateTime =
                            DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                        String title = snapshot.data!.articles![index].title.toString().toLowerCase();

                        bool containsSensitiveWord = false;
                        for (String word in sensitiveWords) {
                          if (title.contains(word)) {
                            containsSensitiveWord = true;
                            break;
                          }
                        }

                        return InkWell(
                          onTap: () {
                            if (!containsSensitiveWord) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                            newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                            newsTitle: snapshot.data!.articles![index].title.toString(),
                                            newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                            author: snapshot.data!.articles![index].author.toString(),
                                            description: snapshot.data!.articles![index].description.toString(),
                                            content: snapshot.data!.articles![index].content.toString(),
                                            source: snapshot.data!.articles![index].source!.name.toString(),
                                          )));
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Sensitive Content Warning'),
                                    content: Text('The news contains sensitive content. Do you want to continue?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Go Back'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Continue'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => NewsDetailScreen(
                                                        newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                                        newsTitle: snapshot.data!.articles![index].title.toString(),
                                                        newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                                        author: snapshot.data!.articles![index].author.toString(),
                                                        description: snapshot.data!.articles![index].description.toString(),
                                                        content: snapshot.data!.articles![index].content.toString(),
                                                        source: snapshot.data!.articles![index].source!.name.toString(),
                                                      )));
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
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
                                    width: width * .28,
                                    placeholder: (context, url) => Container(
                                      child: Center(
                                        child: SpinKitCircle(
                                          size: 50,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error_outline, color: Colors.red),
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
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
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
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black54,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
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
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: HomeScreen(),
  ));
}
