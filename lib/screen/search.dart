import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          ...[
            Text("Search by Interest",style: Theme.of(context).textTheme.headline6,),
          ],
          Wrap(
            children: [
              "Sports",
              "Fun",
              "Education",
              "Trip",
              "Reading",
              "Writing",
              "Swimming",
              "Science",
              "Technology"
            ]
                .map(
                  (String text) => Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        text,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
