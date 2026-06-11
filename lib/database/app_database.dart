import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Model classes ------------------------------------------------------------
class Address {
  final int? id;
  final String street;
  final String? complement;
  final String number;
  final String neighborhood;
  final String country;
  final String zipCode;

  Address({this.id, required this.street, this.complement, required this.number, required this.neighborhood, required this.country, required this.zipCode});

  Map<String, dynamic> toMap() => {
        'id': id,
        'street': street,
        'complement': complement,
        'number': number,
        'neighborhood': neighborhood,
        'country': country,
        'zip_code': zipCode,
      };

  factory Address.fromMap(Map<String, dynamic> map) => Address(
        id: map['id'] as int?,
        street: map['street'] as String,
        complement: map['complement'] as String?,
        number: map['number'] as String,
        neighborhood: map['neighborhood'] as String,
        country: map['country'] as String,
        zipCode: map['zip_code'] as String,
      );
}

class Company {
  final int? id;
  final String name;
  final String cnpj;
  final int addressId;

  Company({this.id, required this.name, required this.cnpj, required this.addressId});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'cnpj': cnpj,
        'address_id': addressId,
      };

  factory Company.fromMap(Map<String, dynamic> map) => Company(
        id: map['id'] as int?,
        name: map['name'] as String,
        cnpj: map['cnpj'] as String,
        addressId: map['address_id'] as int,
      );
}

class College {
  final int? id;
  final String name;
  final bool active;
  final int addressId;

  College({this.id, required this.name, required this.active, required this.addressId});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'active': active ? 1 : 0,
        'address_id': addressId,
      };

  factory College.fromMap(Map<String, dynamic> map) => College(
        id: map['id'] as int?,
        name: map['name'] as String,
        active: (map['active'] as int) == 1,
        addressId: map['address_id'] as int,
      );
}

class User {
  final int? id;
  final String role;
  final String email;
  final String password;

  User({this.id, required this.role, required this.email, required this.password});

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role,
        'email': email,
        'password': password,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as int?,
        role: map['role'] as String,
        email: map['email'] as String,
        password: map['password'] as String,
      );
}

class Fleet {
  final int? id;
  final String licensePlate;
  final String busModel;

  Fleet({this.id, required this.licensePlate, required this.busModel});

  Map<String, dynamic> toMap() => {
        'id': id,
        'license_plate': licensePlate,
        'bus_model': busModel,
      };

  factory Fleet.fromMap(Map<String, dynamic> map) => Fleet(
        id: map['id'] as int?,
        licensePlate: map['license_plate'] as String,
        busModel: map['bus_model'] as String,
      );
}

class Student {
  final int? id;
  final String name;
  final String birthDate;
  final String schoolName;
  final bool active;
  final int userId;
  final int companyId;
  final int addressId;
  final int collegeId;

  Student({this.id, required this.name, required this.birthDate, required this.schoolName, required this.active, required this.userId, required this.companyId, required this.addressId, required this.collegeId});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'birth_date': birthDate,
        'school_name': schoolName,
        'active': active ? 1 : 0,
        'user_id': userId,
        'company_id': companyId,
        'address_id': addressId,
        'college_id': collegeId,
      };

  factory Student.fromMap(Map<String, dynamic> map) => Student(
        id: map['id'] as int?,
        name: map['name'] as String,
        birthDate: map['birth_date'] as String? ?? '',
        schoolName: map['school_name'] as String? ?? '',
        active: (map['active'] as int) == 1,
        userId: map['user_id'] as int,
        companyId: map['company_id'] as int,
        addressId: map['address_id'] as int,
        collegeId: map['college_id'] as int,
      );
}

class Manager {
  final int? id;
  final String name;
  final int companyId;
  final int userId;

  Manager({this.id, required this.name, required this.companyId, required this.userId});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'company_id': companyId,
        'user_id': userId,
      };

  factory Manager.fromMap(Map<String, dynamic> map) => Manager(
        id: map['id'] as int?,
        name: map['name'] as String,
        companyId: map['company_id'] as int,
        userId: map['user_id'] as int,
      );
}

class Driver {
  final int? id;
  final String name;
  final String driverLicense;
  final String birthDate;
  final int userId;
  final int companyId;

  Driver({this.id, required this.name, required this.driverLicense, required this.birthDate, required this.userId, required this.companyId});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'driver_license': driverLicense,
        'birth_date': birthDate,
        'user_id': userId,
        'company_id': companyId,
      };

  factory Driver.fromMap(Map<String, dynamic> map) => Driver(
        id: map['id'] as int?,
        name: map['name'] as String,
        driverLicense: map['driver_license'] as String,
        birthDate: map['birth_date'] as String? ?? '',
        userId: map['user_id'] as int,
        companyId: map['company_id'] as int,
      );
}

/// DatabaseHelper -----------------------------------------------------------
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async => _db ??= await _initDb();

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'app.sqlite');
    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS drivers');
      await db.execute('DROP TABLE IF EXISTS managers');
      await db.execute('DROP TABLE IF EXISTS students');
      await db.execute('DROP TABLE IF EXISTS fleets');
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS colleges');
      await db.execute('DROP TABLE IF EXISTS companies');
      await db.execute('DROP TABLE IF EXISTS addresses');
      await _onCreate(db, newVersion);
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        street TEXT NOT NULL,
        complement TEXT,
        number TEXT NOT NULL,
        neighborhood TEXT NOT NULL,
        country TEXT NOT NULL,
        zip_code TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE companies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cnpj TEXT NOT NULL,
        address_id INTEGER NOT NULL,
        FOREIGN KEY(address_id) REFERENCES addresses(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE colleges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        active INTEGER NOT NULL,
        address_id INTEGER NOT NULL,
        FOREIGN KEY(address_id) REFERENCES addresses(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE fleets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        license_plate TEXT NOT NULL,
        bus_model TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birth_date TEXT,
        school_name TEXT,
        active INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        company_id INTEGER NOT NULL,
        address_id INTEGER NOT NULL,
        college_id INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(company_id) REFERENCES companies(id),
        FOREIGN KEY(address_id) REFERENCES addresses(id),
        FOREIGN KEY(college_id) REFERENCES colleges(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE managers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        company_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY(company_id) REFERENCES companies(id),
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE drivers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        driver_license TEXT NOT NULL,
        birth_date TEXT,
        user_id INTEGER NOT NULL,
        company_id INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(company_id) REFERENCES companies(id)
      );
    ''');
  }

  // ---------- Address CRUD ----------
  Future<int> createAddress(Address address) async {
    final db = await database;
    return await db.insert('addresses', address.toMap());
  }

  Future<List<Address>> getAllAddresses() async {
    final db = await database;
    final maps = await db.query('addresses');
    return maps.map((m) => Address.fromMap(m)).toList();
  }

  Future<Address?> getAddressById(int id) async {
    final db = await database;
    final maps = await db.query('addresses', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Address.fromMap(maps.first);
  }

  Future<int> updateAddress(Address address) async {
    final db = await database;
    return await db.update('addresses', address.toMap(), where: 'id = ?', whereArgs: [address.id]);
  }

  Future<int> deleteAddress(int id) async {
    final db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Company CRUD ----------
  Future<int> createCompany(Company company) async {
    final db = await database;
    return await db.insert('companies', company.toMap());
  }

  Future<List<Company>> getAllCompanies() async {
    final db = await database;
    final maps = await db.query('companies');
    return maps.map((m) => Company.fromMap(m)).toList();
  }

  Future<Company?> getCompanyById(int id) async {
    final db = await database;
    final maps = await db.query('companies', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Company.fromMap(maps.first);
  }

  // ---------- College CRUD ----------
  Future<int> createCollege(College college) async {
    final db = await database;
    return await db.insert('colleges', college.toMap());
  }

  Future<List<College>> getAllColleges() async {
    final db = await database;
    final maps = await db.query('colleges');
    return maps.map((m) => College.fromMap(m)).toList();
  }

  // ---------- User CRUD ----------
  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // ---------- Student CRUD ----------
  Future<int> createStudent(Student student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final maps = await db.query('students');
    return maps.map((m) => Student.fromMap(m)).toList();
  }

  Future<List<Student>> getStudentsByCollege(int collegeId) async {
    final db = await database;
    final maps = await db.query('students', where: 'college_id = ?', whereArgs: [collegeId]);
    return maps.map((m) => Student.fromMap(m)).toList();
  }

  // ---------- Manager CRUD ----------
  Future<int> createManager(Manager manager) async {
    final db = await database;
    return await db.insert('managers', manager.toMap());
  }

  // ---------- Driver CRUD ----------
  Future<int> createDriver(Driver driver) async {
    final db = await database;
    return await db.insert('drivers', driver.toMap());
  }

  Future<List<Driver>> getAllDrivers() async {
    final db = await database;
    final maps = await db.query('drivers');
    return maps.map((m) => Driver.fromMap(m)).toList();
  }

  // ---------- Fleet CRUD ----------
  Future<int> createFleet(Fleet fleet) async {
    final db = await database;
    return await db.insert('fleets', fleet.toMap());
  }

  Future<List<Fleet>> getAllFleets() async {
    final db = await database;
    final maps = await db.query('fleets');
    return maps.map((m) => Fleet.fromMap(m)).toList();
  }

// ---------- Seed admin ----------
  // ---------- User Auth ----------
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final maps = await db.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password], limit: 1);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
  // ---------- Seed admin ----------

  Future<void> seedAdmin() async {
    const adminEmail = 'admin@navway.com';
    const adminPassword = 'admin123'; // In production store a hashed password.
    final existing = await getUserByEmail(adminEmail);
    if (existing == null) {
      await createUser(User(role: 'admin', email: adminEmail, password: adminPassword));
    }
  }
}

class AppDatabase {
  static final DatabaseHelper _helper = DatabaseHelper.instance;

  Future<int> insertUser(User user) => _helper.createUser(user);

  Future<User?> getUserByEmailAndPassword(String email, String password) => _helper.getUserByEmailAndPassword(email, password);
}

