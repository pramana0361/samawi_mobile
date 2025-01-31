import 'package:path/path.dart';
import 'package:simawi_mobile/utils/functions.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _dbName = 'simrs_test.db';
  static const _dbVersion = 1;
  static late Database _db;
  static late String _dbPath;
  static DatabaseService? _instance;
  factory DatabaseService() => _instance ??= DatabaseService._();
  DatabaseService._();

  Future<void> initDatabase() async {
    try {
      printDebug('Database initDatabase() ...');
      var databasesPath = await getDatabasesPath();
      _dbPath = join(databasesPath, _dbName);

      // Delete database
      // await deleteDatabase(_dbPath);

      _db = await openDatabase(_dbPath, version: _dbVersion,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE TbUser (id INTEGER PRIMARY KEY, email TEXT, password TEXT, name TEXT, role TEXT, created_at INTEGER, updated_at INTEGER)');
        await db.execute(
            'CREATE TABLE TbPatient (id INTEGER PRIMARY KEY, record_number INTEGER, name TEXT, birth TEXT, nik TEXT, phone TEXT, address TEXT, blood_type TEXT, weight REAL, height REAL, created_at INTEGER, updated_at INTEGER)');
        await db.execute(
            'CREATE TABLE TbPatientHistory (id INTEGER PRIMARY KEY, record_number INTEGER, date_visit INTEGER, registered_by INTEGER, consultation_by INTEGER, symptoms TEXT, doctor_diagnose TEXT, icd_10_code TEXT, icd_10_name TEXT, is_done INTEGER)');
        printDebug('Creating tables done');
      });
      printDebug('Database initDatabase() done');
    } catch (e) {
      printDebug('initDatabase() error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<int> putUser(Map<String, dynamic> userMap) async {
    try {
      int id = await _db.transaction<int>((txn) async {
        return await txn.rawInsert(
            'INSERT INTO TbUser(email, password, name, role, created_at, updated_at) VALUES(?,?,?,?,?,?)',
            [
              userMap['email'],
              userMap['password'],
              userMap['name'],
              userMap['role'],
              userMap['created_at'],
              userMap['updated_at']
            ]);
      });
      printDebug('Database putUser(${userMap['email']}) success');
      return id;
    } catch (e) {
      printDebug('putUser(${userMap['email']}) error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<void> updateUser(Map<String, dynamic> userMap) async {
    try {
      int count = await _db.transaction<int>((txn) async {
        return await txn.rawUpdate(
            'UPDATE TbUser SET email = ?, password = ?, name = ?, role = ?, updated_at = ? WHERE id = ?',
            [
              userMap['email'],
              userMap['password'],
              userMap['name'],
              userMap['role'],
              userMap['updated_at'],
              userMap['id']
            ]);
      });
      if (count > 0) {
        printDebug('Database updateUser(${userMap['id']}) success');
      } else {
        throw Exception();
      }
    } catch (e) {
      printDebug('updateUser(${userMap['id']}) error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<void> deleteUser(int userId) async {
    try {
      int count = await _db.transaction<int>((txn) async {
        return await txn.rawUpdate('DELETE FROM TbUser WHERE id = ?', [
          userId,
        ]);
      });
      if (count > 0) {
        printDebug('Database deleteUser($userId) success');
      } else {
        throw Exception();
      }
    } catch (e) {
      printDebug('deleteUser($userId) error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getUserAll() async {
    try {
      List<Map<String, dynamic>> list =
          await _db.rawQuery('SELECT * FROM TbUser');
      printDebug('Database getUserAll() success');
      return list;
    } catch (e) {
      printDebug('getUserAll() error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> getUserByEmailAndPassword(
      {required String email, required String password}) async {
    try {
      List<Map<String, dynamic>> list = await _db.rawQuery(
          'SELECT * FROM TbUser WHERE email = ? AND password = ?',
          [email, password]);
      printDebug('Database getUserByEmailAndPassword(${list.first}) success');
      return list.first;
    } catch (e) {
      printDebug('getUserByEmailAndPassword($email) error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<int> putPatient(Map<String, dynamic> patientMap) async {
    try {
      int id = await _db.transaction<int>((txn) async {
        return await txn.rawInsert(
            'INSERT INTO TbPatient(record_number, name, birth, nik, phone, address, blood_type, weight, height, created_at, updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,?)',
            [
              patientMap['record_number'],
              patientMap['name'],
              patientMap['birth'],
              patientMap['nik'],
              patientMap['phone'],
              patientMap['address'],
              patientMap['blood_type'],
              patientMap['weight'],
              patientMap['height'],
              patientMap['created_at'],
              patientMap['updated_at']
            ]);
      });
      printDebug('Database putPatient(${patientMap['record_number']}) success');
      return id;
    } catch (e) {
      printDebug('putPatient(${patientMap['record_number']}) error: $e',
          isError: true);
      return Future.error(e);
    }
  }

  static Future<int> putPatientHistory(
      Map<String, dynamic> patientHistoryMap) async {
    try {
      int id = await _db.transaction<int>((txn) async {
        return await txn.rawInsert(
            'INSERT INTO TbPatientHistory(record_number, date_visit, registered_by, consultation_by, symptoms, doctor_diagnose, icd_10_code, icd_10_name, is_done) VALUES(?,?,?,?,?,?,?,?,?)',
            [
              patientHistoryMap['record_number'],
              patientHistoryMap['date_visit'],
              patientHistoryMap['registered_by'],
              patientHistoryMap['consultation_by'],
              patientHistoryMap['symptoms'],
              patientHistoryMap['doctor_diagnose'],
              patientHistoryMap['icd_10_code'],
              patientHistoryMap['icd_10_name'],
              patientHistoryMap['is_done'],
            ]);
      });
      printDebug(
          'Database putPatientHistory(${patientHistoryMap['record_number']}) success');
      return id;
    } catch (e) {
      printDebug(
          'putPatientHistory(${patientHistoryMap['record_number']}) error: $e',
          isError: true);
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> getPatientByRecordNumber(
      int recordNumber) async {
    try {
      List<Map<String, dynamic>> list = await _db
          .rawQuery('SELECT * FROM TbPatient WHERE record_number = ?', [
        recordNumber,
      ]);
      printDebug('Database getPatientByRecordNumber($recordNumber) success');
      return list.first;
    } catch (e) {
      printDebug('getPatientByRecordNumber($recordNumber) error: $e',
          isError: true);
      return Future.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getPatientAll() async {
    try {
      List<Map<String, dynamic>> list =
          await _db.rawQuery('SELECT * FROM TbPatient');
      printDebug('Database getPatientAll() success');
      return list;
    } catch (e) {
      printDebug('getPatientAll() error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<int> countPatientAll() async {
    try {
      final count = Sqflite.firstIntValue(
          await _db.rawQuery('SELECT COUNT(*) FROM TbPatient'));
      printDebug('Database countPatientAll() success');
      return count ?? 0;
    } catch (e) {
      printDebug('countPatientAll() error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getPatientHistoryAll() async {
    try {
      List<Map<String, dynamic>> list =
          await _db.rawQuery('SELECT * FROM TbPatientHistory');
      printDebug('Database getPatientHistoryAll() success');
      return list;
    } catch (e) {
      printDebug('getPatientHistoryAll() error: $e', isError: true);
      return Future.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getPatientHistoryByRecordNumber(
      int recordNumber) async {
    try {
      List<Map<String, dynamic>> list = await _db
          .rawQuery('SELECT * FROM TbPatientHistory WHERE record_number = ?', [
        recordNumber,
      ]);
      printDebug(
          'Database getPatientHistoryByRecordNumber($recordNumber) success');
      return list;
    } catch (e) {
      printDebug('getPatientHistoryByRecordNumber($recordNumber) error: $e',
          isError: true);
      return Future.error(e);
    }
  }

  static Future<void> updatePatientHistory(
      Map<String, dynamic> patientHistoryMap) async {
    try {
      int count = await _db.transaction<int>((txn) async {
        return await txn.rawUpdate(
            'UPDATE TbPatientHistory SET consultation_by = ?, symptoms = ?, doctor_diagnose = ?, icd_10_code = ?, icd_10_name = ?, is_done = ? WHERE id = ?',
            [
              patientHistoryMap['consultation_by'],
              patientHistoryMap['symptoms'],
              patientHistoryMap['doctor_diagnose'],
              patientHistoryMap['icd_10_code'],
              patientHistoryMap['icd_10_name'],
              patientHistoryMap['is_done'],
              patientHistoryMap['id']
            ]);
      });
      if (count > 0) {
        printDebug(
            'Database updatePatientHistory(${patientHistoryMap['id']}) success');
      } else {
        throw Exception();
      }
    } catch (e) {
      printDebug('updatePatientHistory(${patientHistoryMap['id']}) error: $e',
          isError: true);
      return Future.error(e);
    }
  }
}
