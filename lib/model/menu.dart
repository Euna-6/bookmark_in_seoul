class Menu {
  final int? id;  // Primary Key. DB에서 자동생성할 것이므로 Nullable
  final int? restaurantId;  // 서버에서 데이터 받아올때 유연함을 위해 Nullable
  final String name;
  final int price;
  final String? imageUrl;

  Menu({
    this.id,
    this.restaurantId,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  // 로컬 DB (sqflite) 연동을 위한 객체->Map 변환 함수
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'restaurantId' : restaurantId,
      'name' : name,
      'price' : price,
      'imageUrl' : imageUrl,
    };
  }

  /*
  *** factory 생성자
  인스턴스를 직접 생성하지 않음.
  보통 JSON 데이터를 모델 객체로 바꿀때 많이 사용
   */
  factory Menu.fromMap(Map<String, dynamic> map){
    return Menu(
      id: map['id'],
      restaurantId: map['restaurantId'],
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }
}