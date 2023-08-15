import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository{
  CollectionReference<CategoryModel> categoryRef = FirebaseService.db.collection("categories")
      .withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
    Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if(!hasData){
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>>  getCategory(String categoryId) async {
      try{
        print(categoryId);
        final response = await categoryRef.doc(categoryId).get();
        return response;
      }catch(e){
        rethrow;
      }
  }

  List<CategoryModel> makeCategory(){
      return [
        CategoryModel(categoryName: "Cold Drinks", status: "active", imageUrl: "https://img.freepik.com/free-photo/cold-coffee-with-ice-cream_1220-4091.jpg"),
        CategoryModel(categoryName: "Hot Drinks", status: "active", imageUrl: "https://www.acouplecooks.com/wp-content/uploads/2021/05/Latte-Art-069.jpg"),
        CategoryModel(categoryName: "Bakery", status: "active", imageUrl: "https://thumbs.dreamstime.com/b/fresh-bread-shelves-bakery-90006158.jpg"),
        CategoryModel(categoryName: "Icecream", status: "active", imageUrl: "https://img.freepik.com/free-vector/flat-ice-cream-collection_23-2148981567.jpg"),
      ];
  }



}