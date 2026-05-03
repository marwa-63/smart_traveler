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
      version: 1,
      onCreate: _createDB,
    );
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
        title $textType,
        amount $realType,
        category $textType,
        date $textType
      )
    ''');
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

  Future<List<Expense>> getAllExpenses() async {
    final db = await instance.database;
    final result = await db.query('expenses', orderBy: 'date DESC');
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
