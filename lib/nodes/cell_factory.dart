import 'package:mine_sweeper/nodes/cell.dart';

//Abstract Factory Implementation for creating different types
//of node based on the value it needs to hold.
class CellFactory {

  CellFactory(){}

  Cell getCell(int num) {
    if(num < 8)
      return new SafeCell(num);
    return new CellNode(num);

  }

}