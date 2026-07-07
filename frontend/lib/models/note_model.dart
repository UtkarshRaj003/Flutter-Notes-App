// ignore_for_file: public_member_api_docs, sort_constructors_first
class NoteModel {

  final String id;
  final String title;
  final String content;

  final List<String> tags;

  final bool isPinned;
  final bool isArchived;

  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.isPinned,
    required this.isArchived,
    required this.createdAt,
  });

  factory NoteModel.fromJson(
      Map<String, dynamic> json) {

    return NoteModel(
      id: json['_id'],

      title: json['title'],

      content: json['content'],

      tags:
          List<String>.from(json['tags']),

      isPinned: json['isPinned'],

      isArchived:
          json['isArchived'],

      createdAt:
          DateTime.parse(
        json['createdAt'],
      ),
    );
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
