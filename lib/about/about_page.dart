import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About'),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'App Name: Imus App',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Version: 1.0',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Credits: ',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    Text(
                      'Lorem Ipsum Dolor',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Lorem Ipsum Dolor',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Lorem Ipsum Dolor',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
