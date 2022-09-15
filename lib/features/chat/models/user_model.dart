import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserFields {
  static const String usersTable = 'users';
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String nickname = 'nickname';
  static const String phone = 'phone';
  static const String photo = 'photo';
  static const String is_self = 'is_self';
  static const String is_followed = 'is_followed';
  static const String is_crush = 'is_crush';
  static const String levels = 'levels';
  static const String departments = 'departments';
}

class LocalUser {
  int id;
  int user_id;
  String nickname;
  String phone;
  String gender;
  String photo;
  String token;
  String is_self;
  String is_followed;
  String is_crush;
  Map levels;
  Map departments;
  LocalUser({
    this.id,
    this.user_id,
    this.nickname,
    this.phone,
    this.gender,
    this.photo,
    this.token,
    this.is_self,
    this.is_followed,
    this.is_crush,
    this.levels,
    this.departments,
  });

  LocalUser copyWith({
    int id,
    int user_id,
    String nickname,
    String phone,
    String gender,
    String photo,
    String token,
    String is_self,
    String is_followed,
    String is_crush,
    Map levels,
    Map departments,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      token: token ?? this.token,
      is_self: is_self ?? this.is_self,
      is_followed: is_followed ?? this.is_followed,
      is_crush: is_crush ?? this.is_crush,
      levels: levels ?? this.levels,
      departments: departments ?? this.departments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': user_id,
      'nickname': nickname,
      'phone': phone,
      'gender': gender,
      'photo': photo,
      'token': token,
      'is_self': is_self,
      'is_followed': is_followed,
      'is_crush': is_crush,
      'levels': json.encode(levels),
      'departments': json.encode(departments),
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      id: map['id'] as int,
      user_id: map['id'] as int,
      nickname: map['nickname'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
      photo: map['photo'] as String,
      token: map['token'] as String,
      is_self: map['is_self'].toString(),
      is_followed: map['is_followed'].toString(),
      is_crush: map['is_crush'].toString(),
      levels: map['levels'] as Map,
      departments: map['departments'] as Map,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalUser.fromJson(String source) =>
      LocalUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LocalUser(id: $id, user_id: $user_id, nickname: $nickname, phone: $phone, gender: $gender, photo: $photo, token: $token, is_self: $is_self, is_followed: $is_followed, is_crush: $is_crush, levels: $levels, departments: $departments)';
  }

  @override
  bool operator ==(covariant LocalUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user_id == user_id &&
        other.nickname == nickname &&
        other.phone == phone &&
        other.gender == gender &&
        other.photo == photo &&
        other.token == token &&
        other.is_self == is_self &&
        other.is_followed == is_followed &&
        other.is_crush == is_crush &&
        mapEquals(other.levels, levels) &&
        mapEquals(other.departments, departments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user_id.hashCode ^
        nickname.hashCode ^
        phone.hashCode ^
        gender.hashCode ^
        photo.hashCode ^
        token.hashCode ^
        is_self.hashCode ^
        is_followed.hashCode ^
        is_crush.hashCode ^
        levels.hashCode ^
        departments.hashCode;
  }
}
