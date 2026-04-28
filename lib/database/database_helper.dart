import 'package:bookmark_in_seoul/data/sample_data.dart';
import 'package:bookmark_in_seoul/data/sample_menu.dart';
import 'package:bookmark_in_seoul/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // 싱글톤 패턴 적용
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // DB 가져오기
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('my_restaurant.db');
    return _database!;
  }

  // 파일 경로 설정
  Future<Database> _initDB(String filePath) async {
    // 안전한 경로를 자동으로 찾아주는 함수
    final dbPath = await getDatabasesPath();
    // 폴더 경로와 파일 이름 합치기
    final path = join(dbPath, filePath);

    /*
    version 숫자 올릴때 _onUpgrade 함수 작성 필요
     */
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // 테이블 생성
  Future _createDB(Database db, int version) async {

    // 식당 정보 테이블
    await db.execute('''
      CREATE TABLE restaurants (
        id INTEGER PRIMARY KEY,
        restaurantName TEXT,
        district TEXT,
        imgUrl TEXT,
        cntStar INTEGER,
        cntHeart INTEGER,
        cntCheck INTEGER,
        cntX  INTEGER,
        isBookmarked INTEGER,
        bookmark  INTEGER,
        myMemo  TEXT,
        updatedAt TEXT
        )
    ''');

    // 메뉴 정보 테이블
    await db.execute('''
      CREATE TABLE menuList (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      restaurantID INTEGER,
      name  TEXT,
      price INTEGER,
      imageUrl TEXT,
      FOREIGN KEY (restaurantId) REFERENCES restaurants (id) ON DELETE CASCADE
      )
    ''');

    // 샘플 데이터
    for(var res in sampleData){
      await db.insert('restaurants', res.toMap());
    }
    for(var menu in sampleMenu){
      await db.insert('menuList', menu.toMap());
    }
  }

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final db = await instance.database;

    // 트랜잭션 처리. 모두 성공 or 모두 취소
    await db.transaction((txn) async{
      // 식당 정보 저장
      await txn.insert(
        'restaurants',
        restaurant.toMap(),
        // ID 겹치면 덮어쓰기
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // 메뉴 정보 저장
      for (var menu in restaurant.menuList ?? []){
        await txn.insert(
          'menuList',
          menu.toMap(restaurant.id),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    final db = await instance.database;

    // 모든 식당 데이터 갖고오기
    final List<Map<String, dynamic>> resMaps = await db.query('restaurants');

    List<Restaurant> result = [];

    // 각 restaurantId로 해당 식당의 메뉴만 가져오기
    for (var resMap in resMaps){
      // SQL injection 공격을 막기 위해 ? 사용.
      final List<Map<String, dynamic>> menuMaps = await db.query(
        'menuList',
        where : 'restaurantId = ?',
        whereArgs : [resMap['id']],
      );

      result.add(Restaurant.fromMap(resMap, menuMaps));
    }

    return result;
  }

  // 데이터 수정(메모 혹은 북마크 상태)
  Future<int> updateRestaurant(Restaurant restaurant) async {
    final db = await instance.database;
    return await db.update(
      'restaurants',
      restaurant.toMap(),
      where : 'id = ?',
      whereArgs: [restaurant.id],
    );
  }

  // 식당 데이터 삭제
  Future<int> deleteRestaurant(int id) async {
    final db = await instance.database;
    return await db.delete(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}