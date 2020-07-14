
import 'dart:collection';

class Helper {

  static final Helper _instance = Helper._privateConstructor();
  HashMap<int, String> nodeAssetMap = new HashMap();
  final String bombImage = "assets/main/bomb.png";
  final String flagImage = "assets/main/flagged.png";
  final String faceDownImage = "assets/main/facing_down.png";

  Helper._privateConstructor(){
    nodeAssetMap[0] = "assets/main/0.png";
    nodeAssetMap[1] = "assets/main/1.png";
    nodeAssetMap[2] = "assets/main/2.png";
    nodeAssetMap[3] = "assets/main/3.png";
    nodeAssetMap[4] = "assets/main/4.png";
    nodeAssetMap[5] = "assets/main/5.png";
    nodeAssetMap[6] = "assets/main/6.png";
    nodeAssetMap[7] = "assets/main/7.png";
    nodeAssetMap[8] = "assets/main/8.png";
  }

  factory Helper(){
    return _instance;
  }

  String getSafeNodeImage(int n) {
    return nodeAssetMap[n];
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

}