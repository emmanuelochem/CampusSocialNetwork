// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mysocial_app/features/chat/models/message_model.dart';
import 'package:mysocial_app/features/chat/models/user_model.dart';

class ChatFields {
  static const String TableName = 'chats';
  static const String id = 'id';
  static const String chatId = 'chat_id';
  static const String status = 'status';
  static const String members = 'recipient_id';
  static const String createdAt = 'created_at';
}

enum ChatStatus { active, suspended, blocked }

extension EnumParsing on ChatStatus {
  String value() {
    return toString().split('.').last;
  }

  static ChatStatus fromString(String status) {
    return ChatStatus.values.firstWhere((element) => element.value() == status);
  }
}

class ChatModel {
  int id;
  int chat_id;
  ChatStatus status;
  List<MessagesModel> messages = [];
  UserModel users;
  String created_at;
  int unread = 0;
  MessagesModel mostRecent;

  ChatModel({
    this.id,
    this.chat_id,
    this.status,
    this.messages,
    this.users,
    this.created_at,
    this.unread,
    this.mostRecent,
  });

  ChatModel copyWith({
    int id,
    int chat_id,
    ChatStatus status,
    List<MessagesModel> messages,
    UserModel users,
    List<Map> membersId,
    String created_at,
    int unread,
    MessagesModel mostRecent,
  }) {
    return ChatModel(
      id: id ?? this.id,
      chat_id: chat_id ?? this.chat_id,
      status: status ?? this.status,
      messages: messages ?? this.messages,
      users: users ?? users,
      created_at: created_at ?? this.created_at,
      unread: unread ?? this.unread,
      mostRecent: mostRecent ?? this.mostRecent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chat_id': chat_id,
      'status': status.value(),
      'created_at': created_at,
      //'unread': unread,
      //'mostRecent': mostRecent.toMap(),
    };
  }

  factory ChatModel.fromOnlineMap(Map<String, dynamic> map) {
    // print(map['users']);
    return ChatModel(
      //id: map['id'] as int,
      chat_id: map['id'] as int,
      status: EnumParsing.fromString(map['status']),
      users: UserModel.fromOnlineMap(map['users'][0] as Map<String, dynamic>),
      created_at: map['created_at'] as String,
      //unread: map['unread'] as int,
      mostRecent:
          MessagesModel.fromMap(map['messages'][0] as Map<String, dynamic>),
    );
  }

  static ChatModel fromOfflineMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as int,
      chat_id: map['chat_id'] as int,
      status: EnumParsing.fromString(map['status']),
      created_at: map['created_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromOnlineMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, chat_id: $chat_id, status: $status, messages: $messages, users: $users, created_at: $created_at, unread: $unread, mostRecent: $mostRecent)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.chat_id == chat_id &&
        other.status == status &&
        listEquals(other.messages, messages) &&
        other.users == users &&
        other.created_at == created_at &&
        other.unread == unread &&
        other.mostRecent == mostRecent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chat_id.hashCode ^
        status.hashCode ^
        messages.hashCode ^
        users.hashCode ^
        created_at.hashCode ^
        unread.hashCode ^
        mostRecent.hashCode;
  }
}
