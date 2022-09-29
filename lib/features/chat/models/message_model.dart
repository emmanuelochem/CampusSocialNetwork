// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessagesFields {
  static const String TableName = 'messages';
  static const String id = 'id';
  static const String conversationId = 'chat_id';
  static const String messageId = 'message_id';
  static const String messageUuid = 'message_uuid';
  static const String senderId = 'sender_id';
  static const String receiverId = 'receiver_id';
  static const String content = 'content';
  static const String receipt = 'receipt';
  static const String isMine = 'is_mine';
  static const String isDeleted = 'is_deleted';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class MessagesModel {
  int id;
  int chat_id;
  int message_id;
  String message_uuid;
  int sender_id;
  int receiver_id;
  String content;
  String receipt;
  int is_deleted;
  String created_at;
  String updated_at;
  String is_mine;

  MessagesModel({
    this.id,
    this.chat_id,
    this.message_id,
    this.message_uuid,
    this.sender_id,
    this.receiver_id,
    this.content,
    this.receipt,
    this.is_deleted,
    this.created_at,
    this.updated_at,
    this.is_mine,
  });

  MessagesModel copyWith({
    int id,
    int chat_id,
    int message_id,
    String message_uuid,
    int sender_id,
    int receiver_id,
    String content,
    String receipt,
    int is_deleted,
    String created_at,
    String updated_at,
    String is_mine,
  }) {
    return MessagesModel(
      id: id ?? this.id,
      chat_id: chat_id ?? this.chat_id,
      message_uuid: message_uuid ?? this.message_uuid,
      sender_id: sender_id ?? this.sender_id,
      receiver_id: receiver_id ?? this.receiver_id,
      content: content ?? this.content,
      receipt: receipt ?? this.receipt,
      is_deleted: is_deleted ?? this.is_deleted,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_mine: is_mine ?? this.is_mine,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      //'id': id,
      'chat_id': chat_id,
      'message_id': message_id,
      'message_uuid': message_uuid,
      'sender_id': sender_id,
      'receiver_id': receiver_id,
      'content': content,
      'receipt': receipt,
      'is_deleted': is_deleted,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_mine': is_mine,
    };
  }

  factory MessagesModel.fromMap(Map<String, dynamic> map) {
    return MessagesModel(
      //id: map['id'] as int,
      chat_id: map['chat_id'] as int,
      message_id: map['id'] as int,
      message_uuid: map['message_uuid'] as String,
      sender_id: map['sender_id'] as int,
      receiver_id: map['receiver_id'] as int,
      content: map['content'] as String,
      receipt: map['receipt'] as String,
      is_deleted: map['is_deleted'] as int,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      is_mine: map['is_mine'].toString(),
    );
  }

  factory MessagesModel.fromOfflineMap(Map<String, dynamic> map) {
    return MessagesModel(
      id: map['id'] as int,
      chat_id: map['chat_id'] as int,
      message_id: map['message_id'] as int,
      message_uuid: map['message_uuid'] as String,
      sender_id: map['sender_id'] as int,
      receiver_id: map['receiver_id'] as int,
      content: map['content'] as String,
      receipt: map['receipt'] as String,
      is_deleted: map['is_deleted'] as int,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      is_mine: map['is_mine'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessagesModel.fromJson(String source) =>
      MessagesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessagesModel(id: $id, chat_id: $chat_id, message_id: $message_id, message_uuid: $message_uuid,sender_id: $sender_id, receiver_id: $receiver_id, content: $content, receipt: $receipt, is_deleted: $is_deleted, created_at: $created_at, updated_at: $updated_at, is_mine: $is_mine)';
  }

  @override
  bool operator ==(covariant MessagesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.chat_id == chat_id &&
        other.message_id == message_id &&
        other.message_uuid == message_uuid &&
        other.sender_id == sender_id &&
        other.receiver_id == receiver_id &&
        other.content == content &&
        other.receipt == receipt &&
        other.is_deleted == is_deleted &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.is_mine == is_mine;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chat_id.hashCode ^
        message_id.hashCode ^
        message_uuid.hashCode ^
        sender_id.hashCode ^
        receiver_id.hashCode ^
        content.hashCode ^
        receipt.hashCode ^
        is_deleted.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        is_mine.hashCode;
  }
}
