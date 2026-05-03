import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:smart_traveler/features/Home/domain/entities/trip.dart';
import 'package:smart_traveler/features/Home/domain/entities/itinerary_item.dart';
import 'package:smart_traveler/features/budget/domain/entities/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smart_traveler.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS expenses');
      await db.execute('''
        CREATE TABLE expenses (
          id TEXT PRIMARY KEY,
          tripId TEXT NOT NULL,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE trips (
        id $idType,
        destination $textType,
        totalBudget $realType,
        startDate $textType,
        endDate $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE itinerary_items (
        id $idType,
        tripId $textType,
        dayNumber $integerType,
        location $textType,
        time $textType,
        estimatedCharge $realType,
        description $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id $idType,
        tripId $textType,
        title $textType,
        amount $realType,
        category $textType,
        date $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  // Settings / Budget Methods
  Future<void> setTotalBudget(double amount) async {
    final db = await database;
    await db.insert('settings', {'key': 'total_budget', 'value': amount.toString()},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<double?> getTotalBudget() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['total_budget'],
    );
    if (maps.isNotEmpty) {
      return double.tryParse(maps.first['value'] as String);
    }
    return null;
  }

  // --- Trip Methods ---
  Future<void> insertTrip(Trip trip) async {
    final db = await instance.database;
    await db.insert('trips', trip.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Trip>> getAllTrips() async {
    final db = await instance.database;
    final result = await db.query('trips');
    return result.map((json) => Trip.fromMap(json)).toList();
  }

  Future<void> updateTrip(Trip trip) async {
    final db = await database;
    await db.update(
      'trips',
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  Future<void> deleteTrip(String id) async {
    final db = await database;
    await db.delete('trips', where: 'id = ?', whereArgs: [id]);
    await db.delete('itinerary_items', where: 'tripId = ?', whereArgs: [id]);
    await db.delete('expenses', where: 'tripId = ?', whereArgs: [id]);
  }

  Future<void> deleteAllTrips() async {
    final db = await database;
    await db.delete('trips');
    await db.delete('itinerary_items');
    await db.delete('expenses');
  }

  // --- Itinerary Item Methods ---
  Future<void> insertItineraryItem(ItineraryItem item) async {
    final db = await instance.database;
    await db.insert('itinerary_items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ItineraryItem>> getItineraryForTrip(String tripId) async {
    final db = await instance.database;
    final result = await db.query(
      'itinerary_items',
      where: 'tripId = ?',
      whereArgs: [tripId],
      orderBy: 'dayNumber ASC, time ASC',
    );
    return result.map((json) => ItineraryItem.fromMap(json)).toList();
  }

  // --- Expense Methods ---
  Future<void> insertExpense(Expense expense) async {
    final db = await instance.database;
    await db.insert('expenses', expense.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Expense>> getExpensesForTrip(String tripId) async {
    final db = await instance.database;
    final result = await db.query(
      'expenses', 
      where: 'tripId = ?',
      whereArgs: [tripId],
      orderBy: 'date DESC'
    );
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
