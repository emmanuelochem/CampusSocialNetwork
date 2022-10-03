// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'dart:developer';

class UserFields {
  static const String usersTable = 'users';
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String nickname = 'nickname';
  static const String phone = 'phone';
  static const String photo = 'photo';
  static const String gender = 'gender';
  static const String is_self = 'is_self';
  static const String is_followed = 'is_followed';
  static const String is_crush = 'is_crush';
  static const String level_id = 'level_id';
  static const String level_name = 'level_name';
  static const String department_id = 'department_id';
  static const String department_name = 'department_name';
}

class UserModel {
  int id;
  int user_id;
  String nickname;
  String phone;
  String gender;
  String photo;
  //String token;
  String is_self;
  String is_followed;
  String is_crush;
  int level_id;
  String level_name;
  int department_id;
  String department_name;
  UserModel({
    this.id,
    this.user_id,
    this.nickname,
    this.phone,
    this.gender,
    this.photo,
    this.is_self,
    this.is_followed,
    this.is_crush,
    this.level_id,
    this.level_name,
    this.department_id,
    this.department_name,
  });

  UserModel copyWith({
    int id,
    int user_id,
    String nickname,
    String phone,
    String gender,
    String photo,
    String is_self,
    String is_followed,
    String is_crush,
    String level_id,
    String level_name,
    String department_id,
    String department_name,
  }) {
    return UserModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      is_self: is_self ?? this.is_self,
      is_followed: is_followed ?? this.is_followed,
      is_crush: is_crush ?? this.is_crush,
      level_id: level_id ?? this.level_id,
      level_name: level_name ?? this.level_name,
      department_id: department_id ?? this.department_id,
      department_name: department_name ?? this.department_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      //'id': id,
      'user_id': user_id,
      'nickname': nickname,
      'phone': phone,
      'gender': gender,
      'photo': photo,
      'is_self': is_self,
      'is_followed': is_followed,
      'is_crush': is_crush,
      'level_id': level_id,
      'level_name': level_name,
      'department_id': department_id,
      'department_name': department_name,
    };
  }

  factory UserModel.fromOnlineMap(Map<String, dynamic> map) {
    //log(map.toString());
    return UserModel(
      //id: map['id'] as int,
      user_id: map['id'] as int,
      nickname: map['nickname'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
      photo: map['photo'] as String,
      is_self: map['is_self'].toString(),
      is_followed: map['is_followed'].toString(),
      is_crush: map['is_crush'].toString(),
      level_id: map['levels']['id'] as int,
      level_name: map['levels']['name'] as String,
      department_id: map['departments']['id'] as int,
      department_name: map['departments']['name'] as String,
    );
  }

  factory UserModel.fromOfflineMap(Map<String, dynamic> map) {
    log(map.toString());
    return UserModel(
      //id: map['id'] as int,
      user_id: map['user_id'] as int,
      nickname: map['nickname'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
      photo: map['photo'] as String,
      is_self: map['is_self'].toString(),
      is_followed: map['is_followed'].toString(),
      is_crush: map['is_crush'].toString(),
      level_id: map['level_id'] as int,
      level_name: map['level_name'] as String,
      department_id: map['department_id'] as int,
      department_name: map['department_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromOnlineMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, user_id: $user_id, nickname: $nickname, phone: $phone, gender: $gender, photo: $photo, is_self: $is_self, is_followed: $is_followed, is_crush: $is_crush, level_id: $level_id, level_name: $level_name, department_id: $department_id, department_name: $department_name)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.nickname == nickname &&
        other.phone == phone &&
        other.gender == gender &&
        other.photo == photo &&
        other.is_self == is_self &&
        other.is_followed == is_followed &&
        other.is_crush == is_crush &&
        other.level_id == level_id &&
        other.level_name == level_name &&
        other.department_id == department_id &&
        other.department_name == department_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        nickname.hashCode ^
        phone.hashCode ^
        gender.hashCode ^
        photo.hashCode ^
        is_self.hashCode ^
        is_followed.hashCode ^
        is_crush.hashCode ^
        level_id.hashCode ^
        level_name.hashCode ^
        department_id.hashCode ^
        department_name.hashCode;
  }
}
