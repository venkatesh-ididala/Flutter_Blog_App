import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);

  //upload image to supabase storage
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });

  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  // @override
  // Future<BlogModel> uploadBlog(BlogModel blog) async {
  //   try {
  //     final blogData = await supabaseClient
  //         .from('blogs')
  //         .insert(blog.toJson())
  //         .select()
  //         .single(); // returns the single inserted row

  //     return BlogModel.fromJson(blogData);
  //   } on PostgrestException catch (e) {
  //     throw ServerException(e.message);
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toRemoteJson()) // ✅ only DB fields
          .select()
          .single();

      return BlogModel.fromJson(blogData);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog}) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id,
          image); //file is image and path is the location of storage image

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message); //when an error occur in database
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient.from('blogs').select(
          '*,profiles (name)'); //join of profiles and blogs table with the posterid

      return blogs.map<BlogModel>((blog) {
        final model = BlogModel.fromJson(blog);
        final name = blog['profiles']?['name'] ?? '';
        return model.copyWith(posterName: name);
      }).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message); //when an error occur in database
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
