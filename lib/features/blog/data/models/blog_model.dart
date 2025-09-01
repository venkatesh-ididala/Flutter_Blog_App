// import 'package:blog_app/features/blog/domain/entities/blog.dart';

// class BlogModel extends Blog {
//   BlogModel({
//     required super.id,
//     required super.posterId,
//     required super.title,
//     required super.content,
//     required super.imageUrl,
//     required super.topics,
//     required super.updatedAt,
//     super.posterName,
//   });

//   Map<String, dynamic> toJson() {
//     return <String, dynamic>{
//       'id': id,
//       'poster_id': posterId,
//       'title': title,
//       'content': content,
//       'image_url': imageUrl,
//       'topics': topics,
//       'updated_at': updatedAt.toIso8601String(),
//       'poster_name': posterName ?? "", // ✅ persist posterName
//     };
//   }

//   factory BlogModel.fromJson(Map<String, dynamic> map) {
//     return BlogModel(
//       id: map['id'] as String,
//       posterId: map['poster_id'] as String,
//       title: map['title'] as String,
//       content: map['content'] as String,
//       imageUrl: map['image_url'] as String,
//       topics: List<String>.from(map['topics'] ?? []),
//       updatedAt: map['updated_at'] == null
//           ? DateTime.now()
//           : DateTime.parse(map['updated_at']),
//       posterName: map['poster_name'] as String? ?? "", // ✅ restore posterName
//     );
//   }

//   BlogModel copyWith({
//     String? id,
//     String? posterId,
//     String? title,
//     String? content,
//     String? imageUrl,
//     List<String>? topics,
//     DateTime? updatedAt,
//     String? posterName,
//   }) {
//     return BlogModel(
//       id: id ?? this.id,
//       posterId: posterId ?? this.posterId,
//       title: title ?? this.title,
//       content: content ?? this.content,
//       imageUrl: imageUrl ?? this.imageUrl,
//       topics: topics ?? this.topics,
//       updatedAt: updatedAt ?? this.updatedAt,
//       posterName: posterName ?? this.posterName,
//     );
//   }
// }

import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    super.posterName,
  });

  // ✅ Used ONLY for Hive/local cache (NOT Supabase insert)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),

      // Extra fields for offline cache only
      'poster_name': posterName ?? "",
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
      posterName: map['poster_name'] as String? ?? "",
    );
  }

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }

  // ✅ Separate method for Supabase upload (no posterName/avatar)
  Map<String, dynamic> toRemoteJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
