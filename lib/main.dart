import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_application_relax_app/oracle.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: "AnswerbookPage",
      routes: {
        "AnswerbookPage": (context) => RelaxWidget(),
        "OraclePage": (context) => OraclePage(),
      },
    ),
  );
}

class RelaxWidget extends StatefulWidget {
  const RelaxWidget({super.key});

  @override
  State<RelaxWidget> createState() => _RelaxWidgetState();
}

class _RelaxWidgetState extends State<RelaxWidget> {
  //解答之書的部分
  String randomImageUrl =
      "https://i.pinimg.com/736x/06/9a/ce/069ace93b7341e7371c018cd946f5531.jpg";
  String answer = "船到橋頭自然直";

  void getRondom() async {
    //命運答案
    Response ansjson = await get(
      Uri.parse("http://answerbook.david888.com/"),
    );
    Map quoteMap = jsonDecode(ansjson.body);
    //隨機可愛貓咪圖片
    Response imagejson = await get(
      Uri.parse("https://api.thecatapi.com/v1/images/search"),
    );
    List<dynamic> imageMap = jsonDecode(imagejson.body);
    setState(() {
      randomImageUrl = imageMap[0]["url"];
      answer = quoteMap["answer"];
    });
  }

  bool sameCat = false; //是否是同一隻貓咪

  //淺草籤
  String luckType = "你嗎";
  String poem = "自幼常為旅，\n逢春駿馬驕，\n前程宜進步，\n得箭降青霄。";
  String explain =
      "如果有真誠心的話，最後會傳達給上天，出人頭地的時候會到來吧。因為上天的恩惠，會得到各種財寶吧。將來會遇見好事吧。因為得到居上位者（菩薩）的力量，能被吸引往好的方向吧。";
  Map result = {};

  Future<void> getOrcle() async {
    Response orclejson = await get(
      Uri.parse("http://answerbook.david888.com/TempleOracleJP"),
    );
    Map orcleMap = jsonDecode(orclejson.body);

    luckType = orcleMap["oracle"]["type"];
    poem =
        "${orcleMap["oracle"]["poem"].substring(0, 5)}，\n${orcleMap["oracle"]["poem"].substring(6, 11)}，\n${orcleMap["oracle"]["poem"].substring(12, 17)}，\n${orcleMap["oracle"]["poem"].substring(18, 23)}。";
    explain = orcleMap["oracle"]["explain"];
    result = orcleMap["oracle"]["result"];
    print(result);
  }

  @override
  void initState() {
    super.initState();

    getOrcle();
    getRondom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                constraints: BoxConstraints(maxHeight: 400),
                margin: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    if (!sameCat) {
                      sameCat = true;
                      await getOrcle();
                    }
                    Navigator.pushNamed(
                      context,
                      "OraclePage",
                      arguments: {
                        "catimageurl": randomImageUrl,
                        "luckType": luckType,
                        "poem": poem,
                        "explain": explain,
                        "resultMap": result,
                      },
                    );
                  },
                  child: Ink.image(
                    image: NetworkImage(randomImageUrl),
                  ),
                ),
              ),
            ),

            Divider(indent: 50, endIndent: 50, color: Colors.orange),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(50),
                child: Text(
                  answer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "ChenYuluoyan",
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sameCat = false;
          setState(() {
            randomImageUrl =
                "https://i.pinimg.com/736x/06/9a/ce/069ace93b7341e7371c018cd946f5531.jpg";
            answer = "貓貓正在思考解答......";
          });
          getRondom();
        },
        backgroundColor: Colors.orange[600],
        splashColor: Colors.orange[700],
        foregroundColor: Colors.orange[900],
        elevation: 0.0,
        child: Icon(Icons.arrow_right_rounded, size: 50),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(3, 0, 0, 20),
        child: Text(
          "如果程式卡住了，嘗試重開他 --by作者 q(≧▽≦q)",
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
