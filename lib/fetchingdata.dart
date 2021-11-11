import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:search_app/full_image.dart';

// ignore: must_be_immutable
class QueryPage extends StatefulWidget {
  String query;
  QueryPage({Key? key, required this.query}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

bool faild = false;
int page = 0;
List data = [];
ScrollController _scrollController = ScrollController();

class _QueryPageState extends State<QueryPage> {
  apirequest() async {
    Uri url = Uri.parse('https://api.pexels.com/v1/search?query=' +
        widget.query +
        '&per_page=40&page=' +
        (++page).toString());
    var response = await http.get(url, headers: {
      "Authorization":
          "563492ad6f91700001000001d0723de5292844059b618a1a9b37f3b7",
    });
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          data.addAll(json.decode(response.body)['photos']);
        });
      }
    } else {
      print("data not found");
    }
    if (data.length.toInt() == 0) {
      faild = true;
    }
  }

  @override
  void initState() {
    super.initState();
    apirequest();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        apirequest();
      }
    });
  }

  @override
  void dispose() {
    data.clear();
    faild = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.query),
      ),
      body: Column(
        children: [
          Expanded(
            child: faild == true
                ? const Center(
                    child: Text("it is empty..."),
                  )
                : GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          String src = data[index]['src']['portrait'];
                          int id = data[index]['id'];
                          Box box = await Hive.openBox(id.toString());
                          TextEditingController comment =
                              TextEditingController();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullImage(
                                      src: src,
                                      id: id,
                                      box: box,
                                      comment: comment)));
                        },
                        child: Container(
                          child: Image.network(
                            data[index]['src']['tiny'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
