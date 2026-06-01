import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Addresses,
  Companies,
  Colleges,
  Users,
  Students,
  Managers,
  Drivers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ----- Address CRUD -----
  Future<int> createAddress(AddressesCompanion entry) => into(addresses).insert(entry);
  Future<List<Address>> getAllAddresses() => select(addresses).get();
  Future<Address?> getAddressById(int id) => (select(addresses)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<bool> updateAddress(Address entry) => update(addresses).replace(entry);
  Future<int> deleteAddress(int id) => (delete(addresses)..where((t) => t.id.equals(id))).go();

  // ----- Company CRUD -----
  Future<int> createCompany(CompaniesCompanion entry) => into(companies).insert(entry);
  Future<List<Company>> getAllCompanies() => select(companies).get();
  Future<Company?> getCompanyById(int id) => (select(companies)..where((t) => t.id.equals(id))).getSingleOrNull();

  // ----- College CRUD -----
  Future<int> createCollege(CollegesCompanion entry) => into(colleges).insert(entry);
  Future<List<College>> getAllColleges() => select(colleges).get();

  // ----- User CRUD -----
  Future<int> createUser(UsersCompanion entry) => into(users).insert(entry);
  Future<User?> getUserByEmail(String email) => (select(users)..where((t) => t.email.equals(email))).getSingleOrNull();

  // ----- Student CRUD -----
  Future<int> createStudent(StudentsCompanion entry) => into(students).insert(entry);
  Future<List<Student>> getStudentsByCollege(int collegeId) => (select(students)..where((t) => t.collegeId.equals(collegeId))).get();

  // ----- Manager CRUD -----
  Future<int> createManager(ManagersCompanion entry) => into(managers).insert(entry);

  // ----- Driver CRUD -----
  Future<int> createDriver(DriversCompanion entry) => into(drivers).insert(entry);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}

@pragma('sqlite.immutable')
class Addresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get street => text().withLength(min: 1, max: 255)();
  TextColumn get complement => text().nullable()();
  TextColumn get number => text()();
  TextColumn get neighborhood => text()();
  TextColumn get country => text()();
  TextColumn get zipCode => text().named('zip_code')();
}

@pragma('sqlite.immutable')
class Companies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get cnpj => text()();
  IntColumn get addressId => integer().customConstraint('REFERENCES addresses(id) NOT NULL')();
}

@pragma('sqlite.immutable')
class Colleges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get active => boolean().withDefault(Constant(true))();
  IntColumn get addressId => integer().customConstraint('REFERENCES addresses(id) NOT NULL')();
}

@pragma('sqlite.immutable')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => text()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();
}

@pragma('sqlite.immutable')
class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get active => boolean().withDefault(Constant(true))();
  IntColumn get userId => integer().customConstraint('REFERENCES users(id) NOT NULL')();
  IntColumn get companyId => integer().customConstraint('REFERENCES companies(id) NOT NULL')();
  IntColumn get addressId => integer().customConstraint('REFERENCES addresses(id) NOT NULL')();
  IntColumn get collegeId => integer().customConstraint('REFERENCES colleges(id) NOT NULL')();
}

@pragma('sqlite.immutable')
class Managers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get companyId => integer().customConstraint('REFERENCES companies(id) NOT NULL')();
  IntColumn get userId => integer().customConstraint('REFERENCES users(id) NOT NULL')();
}

@pragma('sqlite.immutable')
class Drivers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get driverLicense => text().named('driver_license')();
  IntColumn get userId => integer().customConstraint('REFERENCES users(id)').notNull()();
  IntColumn get companyId => integer().customConstraint('REFERENCES companies(id)').notNull()();
}
