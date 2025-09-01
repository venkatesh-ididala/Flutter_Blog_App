import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    if (box.isEmpty) return [];

    print("Offline Hive data: ${box.get('blogs_list')}");
    // ✅ Read the stored list
    final data = box.get('blogs_list', defaultValue: []) as List;

    return data
        .map((e) => BlogModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    final data = blogs.map((b) => b.toJson()).toList();
    // ✅ store entire list under one key
    box.put('blogs_list', data);
  }
}
