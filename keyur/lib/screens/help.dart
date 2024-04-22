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
              question: 'What is Lorem Ipsum?',
              answer:
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            ),
            FAQItem(
              question: 'Why do we use it?',
              answer:
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
            ),
            FAQItem(
              question: 'Where does it come from?',
              answer:
                  'Contrary to popular belief, Lorem Ipsum is not simply random text.',
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
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            ),
            AboutUsItem(
              title: 'Our Vision',
              description:
                  'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.',
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
