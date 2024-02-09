import 'package:daily_advices/advice.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const String _dbFileName = 'app_db.db';
  static const String _advicesTable = 'advices';
  static const String _idColumn = 'id';
  static const String _adviceColumn = 'advice';
  static const String _createdAtColumn = 'created_at';
  static const int _version = 1;

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbFileName),
        onCreate: (db, version) async {
      return await db.execute(
          'CREATE TABLE $_advicesTable($_idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $_adviceColumn TEXT NOT NULL, $_createdAtColumn TEXT NOT NULL)');
    }, version: _version);
  }

  static Future<AdviceEntity?> getTodaysAdvice() async {
    final Database db = await _getDB();

    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    List<Map> maps = await db.query(_advicesTable,
        columns: [_idColumn, _adviceColumn, _createdAtColumn],
        where: '$_createdAtColumn = ?',
        whereArgs: [today]);

    if (maps.isNotEmpty) {
      final Map map = maps.first;

      return AdviceEntity(
          id: map[_idColumn],
          advice: map[_adviceColumn],
          createdAt: DateTime.parse(map[_createdAtColumn]));
    }

    return null;
  }

  static Future<List<AdviceEntity>> getAdvices() async {
    final Database db = await _getDB();

    List<Map> maps = await db.query(_advicesTable);

    List<AdviceEntity> advices = maps.map((map) {
      return AdviceEntity(
          id: map[_idColumn],
          advice: map[_adviceColumn],
          createdAt: DateTime.parse(map[_createdAtColumn]));
    }).toList();

    return advices;
  }

  static insertAdvice(Map<String, dynamic> adviceMap) async {
    final Database db = await _getDB();

    await db.insert(_advicesTable, {
      _advicesTable: adviceMap['advice'],
      _createdAtColumn: adviceMap['created_at']
    });
  }
}
