import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(ImageListApp());

class ImageListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ImageListScreen(),
    );
  }
}

class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  List<dynamic> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list?page=1&limit=20'),
    );

    if (response.statusCode == 200) {
      setState(() {
        images = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scrollable Image List"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: fetchImages),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchImages,
                child: ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final image = images[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            image['download_url'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              image['author'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
