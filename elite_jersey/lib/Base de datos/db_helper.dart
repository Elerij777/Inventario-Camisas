import 'package:elite_jersey/Base de datos/jersey.dart';
import 'package:elite_jersey/Base de datos/venta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _jerseysTable = "jerseys";
  static final String _ventasTable = "ventas";

  // Inicializar la base de datos
  static Future<void> initDB() async {
    if (_db != null) return;

    try {
      String _path = join(await getDatabasesPath(), 'jersey.db');
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE $_jerseysTable ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "nombreJersey TEXT,"
            "anio INTEGER,"
            "numeroEquipacion INTEGER,"
            "cantidades TEXT,"
            "imagen TEXT,"
            "precio REAL"
            ")",
          );
          db.execute(
            "CREATE TABLE $_ventasTable ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "jerseyId INTEGER,"
            "cantidad INTEGER,"
            "precio REAL,"
            "fecha TEXT,"
            "FOREIGN KEY (jerseyId) REFERENCES $_jerseysTable (id)"
            ")",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // Métodos para Jerseys
  static Future<int> insertJersey(Jersey? jersey) async {
    if (_db == null) throw Exception('Database not initialized');

    final Map<String, dynamic> jerseyJson = jersey!.toJson();
    jerseyJson['cantidades'] = (jersey.cantidades ?? []).join(',');

    return await _db!.insert(_jerseysTable, jerseyJson);
  }

  static Future<List<Jersey>> queryJerseys() async {
    if (_db == null) throw Exception('Database not initialized');

    final List<Map<String, dynamic>> maps = await _db!.query(_jerseysTable);

    return List.generate(maps.length, (i) => Jersey.fromJson(maps[i]));
  }

  static Future<int> deleteJersey(int id) async {
    if (_db == null) throw Exception('Database not initialized');
    return await _db!.delete(_jerseysTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateJersey(Jersey jersey) async {
    if (_db == null) throw Exception('Database not initialized');

    final Map<String, dynamic> jerseyJson = jersey.toJson();
    jerseyJson['cantidades'] = (jersey.cantidades ?? []).join(',');

    return await _db!.update(
      _jerseysTable,
      jerseyJson,
      where: 'id = ?',
      whereArgs: [jersey.id],
    );
  }

  // Métodos para Ventas
  static Future<int> insertVenta(Venta? venta) async {
    if (_db == null) throw Exception('Database not initialized');
    return await _db!.insert(_ventasTable, venta!.toJson());
  }

  static Future<List<Venta>> queryVentas() async {
    if (_db == null) throw Exception('Database not initialized');

    final List<Map<String, dynamic>> maps = await _db!.query(_ventasTable);

    return List.generate(maps.length, (i) => Venta.fromJson(maps[i]));
  }

  static Future<int> deleteVenta(int id) async {
    if (_db == null) throw Exception('Database not initialized');
    return await _db!.delete(_ventasTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateVenta(Venta venta) async {
    if (_db == null) throw Exception('Database not initialized');
    return await _db!.update(
      _ventasTable,
      venta.toJson(),
      where: 'id = ?',
      whereArgs: [venta.id],
    );
  }
}
