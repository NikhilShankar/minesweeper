
import 'dart:collection';

import 'package:mine_sweeper/cells/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Singleton Helper class
class Helper {

  static final Helper _instance = Helper._privateConstructor();
  HashMap<int, String> cellAssetMap = new HashMap();
  final String bombImage = "assets/main/bomb.png";
  final String flagImage = "assets/main/flagged.png";
  final String faceDownImage = "assets/main/facing_down.png";

  Helper._privateConstructor(){
    cellAssetMap[0] = "assets/main/0.png";
    cellAssetMap[1] = "assets/main/1.png";
    cellAssetMap[2] = "assets/main/2.png";
    cellAssetMap[3] = "assets/main/3.png";
    cellAssetMap[4] = "assets/main/4.png";
    cellAssetMap[5] = "assets/main/5.png";
    cellAssetMap[6] = "assets/main/6.png";
    cellAssetMap[7] = "assets/main/7.png";
    cellAssetMap[8] = "assets/main/8.png";
  }

  factory Helper(){
    return _instance;
  }

  //returing different images based on the number it holds
  String getSafeCellImage(int n) {
    return cellAssetMap[n];
  }

  String getBombImage() {
    return bombImage;
  }

  String getFlaggedImage() {
    return flagImage;
  }

  String getClosedImage() {
    return faceDownImage;
  }


  //Preferences Helper
  static const String HISCORE = "hiscore_time";

  //get hi score for different levels.
  Future<String> getHighScore(Level level) async {
      String day = level.toString().split('.').last;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int hi = prefs.getInt(HISCORE + day);
      if (hi != null)
        return hi.toString();
      return null;
  }

  //Set hi score for different levels.
  setHiScore(int time, Level level) async {
      String day = level.toString().split('.').last;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int hi = prefs.getInt(HISCORE + day);
      if(hi == null) {
        prefs.setInt(HISCORE + day, time);
      } else {
        if(time < hi) {
          prefs.setInt(HISCORE + day, time);
        }
      }
  }

}