import 'package:elite_jersey/Base de datos/jersey.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "jerseys";

  // Inicializar la base de datos
  static Future<void> initDB() async {
    if (_db != null) return;

    try {
      String _path = join(await getDatabasesPath(), 'jersey.db');
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "nombreJersey TEXT,"
            "anio INTEGER,"
            "numeroEquipacion INTEGER,"
            "cantidades TEXT,"
            "imagen TEXT,"
            "precio REAL"
            ")",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // Insertar un nuevo jersey
  static Future<int> insert(Jersey? jersey) async {
    if (_db == null) {
      throw Exception('Database not initialized');
    }

    // Convertir listas a JSON para almacenar
    final Map<String, dynamic> jerseyJson = jersey!.toJson();
    jerseyJson['cantidades'] = (jersey.cantidades ?? [])
        .join(','); // Convertir lista de cantidades a String

    return await _db!.insert(_tableName, jerseyJson);
  }

  // Consultar todos los jerseys
  static Future<List<Jersey>> query() async {
    if (_db == null) {
      throw Exception('Database not initialized');
    }

    final List<Map<String, dynamic>> maps = await _db!.query(_tableName);

    return List.generate(maps.length, (i) {
      final jersey = Jersey.fromJson(maps[i]);
      return jersey;
    });
  }

  // Eliminar un jersey
  static Future<int> delete(int id) async {
    if (_db == null) {
      throw Exception('Database not initialized');
    }
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Actualizar un jersey
  static Future<int> update(Jersey jersey) async {
    if (_db == null) {
      throw Exception('Database not initialized');
    }

    // Convertir listas a JSON para actualizar
    final Map<String, dynamic> jerseyJson = jersey.toJson();
    jerseyJson['cantidades'] = (jersey.cantidades ?? [])
        .join(','); // Convertir lista de cantidades a String

    return await _db!.update(
      _tableName,
      jerseyJson,
      where: 'id = ?',
      whereArgs: [jersey.id],
    );
  }
}
