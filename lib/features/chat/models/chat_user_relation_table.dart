// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatUserRelationFields {
  static const String TableName = 'chat_user';
  static const String id = 'id';
  static const String chatId = 'chat_id';
  static const String userId = 'user_id';
  //static const String created_at = 'created_at';
}

class ChatUserRelation {
  int id;
  int chat_id;
  int user_id;
  ChatUserRelation({
    this.id,
    this.chat_id,
    this.user_id,
  });

  ChatUserRelation copyWith({
    int id,
    int chat_id,
    int user_id,
  }) {
    return ChatUserRelation(
      id: id ?? this.id,
      chat_id: chat_id ?? this.chat_id,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chat_id': chat_id,
      'user_id': user_id,
    };
  }

  factory ChatUserRelation.fromMap(Map<String, dynamic> map) {
    return ChatUserRelation(
      id: map['id'] as int,
      chat_id: map['chat_id'] as int,
      user_id: map['user_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUserRelation.fromJson(String source) =>
      ChatUserRelation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatUserRelation(id: $id, chat_id: $chat_id, user_id: $user_id)';

  @override
  bool operator ==(covariant ChatUserRelation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.chat_id == chat_id &&
        other.user_id == user_id;
  }

  @override
  int get hashCode => id.hashCode ^ chat_id.hashCode ^ user_id.hashCode;
}
