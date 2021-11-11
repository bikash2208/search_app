import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:search_app/fetchingdata.dart';

class SearchScreen extends StatefulWidget {
  late Box box;
  SearchScreen({Key? key, req, required this.box}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController query = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter any text";
                          }
                          return null;
                        },
                        controller: query,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30)),
                          filled: true,
                          hintText: "Search Term",
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(30)),
                          child: InkWell(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  for (int i = 4; i > 0; i--) {
                                    widget.box.putAt(i, widget.box.get(i - 1));
                                  }
                                  widget.box.putAt(0, query.text);
                                  setState(() {});
                                  query.clear();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QueryPage(
                                                query: widget.box.get(0),
                                              )));
                                }
                              },
                              child: const Text(
                                "SEARCH",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )),
                        )),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      getbtn(0),
                      getbtn(1),
                      getbtn(2),
                      getbtn(3),
                      getbtn(4),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getbtn(int a) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QueryPage(
                        query: widget.box.get(a),
                      )));
        },
        child: Text(
          widget.box.get(a),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
