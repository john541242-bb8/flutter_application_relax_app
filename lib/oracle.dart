import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class OraclePage extends StatefulWidget {
  const OraclePage({super.key});

  @override
  State<OraclePage> createState() => _OraclePageState();
}

class _OraclePageState extends State<OraclePage> {
  Map data = {};
  String luckType = "你嗎";
  String poem = "自幼常為旅，\n逢春駿馬驕，\n前程宜進步，\n得箭降青霄。";
  String explain =
      "如果有真誠心的話，最後會傳達給上天，出人頭地的時候會到來吧。因為上天的恩惠，會得到各種財寶吧。將來會遇見好事吧。因為得到居上位者（菩薩）的力量，能被吸引往好的方向吧。";
  Map result = {};

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    data = ModalRoute.of(context)!.settings.arguments as Map;
    luckType = data["luckType"];
    poem = data["poem"];
    explain = data["explain"];
    result = data["resultMap"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          "此貓之低語......",
          style: TextStyle(fontFamily: "ChenYuluoyan", fontSize: 40),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          CircleAvatar(
            backgroundImage: NetworkImage(data["catimageurl"]),
            radius: 70,
          ),
          Text(
            luckType,
            style: TextStyle(
              fontFamily: "TWFont",
              fontSize: 60,
              color: Colors.red,
            ),
          ),
          Text(
            poem,
            style: TextStyle(fontSize: 35, fontFamily: "PoemFont"),
          ),
          Divider(indent: 60, endIndent: 60),
          Text(
            "解釋：",
            style: TextStyle(
              fontSize: 30,
              fontFamily: "ChenYuluoyan",
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20.0,
            ),
            // height: 125,
            child: AutoSizeText(
              explain,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "IansuiRegular"),
              maxLines: 6,
            ),
          ),

          Divider(indent: 70, endIndent: 70),
          Column(
            children: result.entries.map((entry) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${entry.key}：",
                    style: TextStyle(fontFamily: "IansuiRegular"),
                  ),
                  Text(
                    "${entry.value}",
                    style: TextStyle(
                      fontFamily: "IansuiRegular",
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
