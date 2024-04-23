import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs and About'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            FAQItem(
              question: 'How can I share an article?',
              answer:
                  'To share an article, tap on the share icon at the top right corner of the article detail screen.',
            ),
            FAQItem(
              question: 'Can I save articles for later?',
              answer:
                  'Yes, you can save articles by tapping on the bookmark icon on the article detail screen.',
            ),
            FAQItem(
              question: 'How do I view comments on an article?',
              answer:
                  'To view comments on an article, tap on the comment icon on the article detail screen.',
            ),
            SizedBox(height: 32.0),
            Text(
              'About Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            AboutUsItem(
              title: 'Our Mission',
              description:
                  'Our mission is to provide users with the latest news from reliable sources and enhance their reading experience.',
            ),
            AboutUsItem(
              title: 'Our Vision',
              description:
                  'We envision a platform where users can stay informed about current events and engage with high-quality journalism.',
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          answer,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}

class AboutUsItem extends StatelessWidget {
  final String title;
  final String description;

  const AboutUsItem({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
