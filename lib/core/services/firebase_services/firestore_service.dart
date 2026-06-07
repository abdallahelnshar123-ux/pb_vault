import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/response/my_user_dto.dart';
import '../../constants/app_constants.dart';

@lazySingleton
class FirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreService(this._firebaseFirestore);

  CollectionReference<MyUserDto> getUsersCollection() {
    return _firebaseFirestore
        .collection(AppConstants.usersCollectionName)
        .withConverter<MyUserDto>(
          fromFirestore: (snapshot, options) =>
              MyUserDto.fromFireStore(snapshot.data()!),
          toFirestore: (user, options) => user.toFireStore(),
        );
  }

  Future<void> addUserToFireStore(MyUserDto myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  Future<MyUserDto?> getUserFromFireStore(String uId) async {
    var documentSnapshot = await getUsersCollection().doc(uId).get();
    return documentSnapshot.data();
  }

  Future<void> updateUserDataToFirestore(MyUserDto user) async {
    var querySnapshot = getUsersCollection().doc(user.id);
    await querySnapshot.update(user.toFireStore());
  }

  Future<void> deleteUserFromFirestore(String uId) async {
    await getUsersCollection().doc(uId).delete();
  }

  /// ===============================   watchlist   =============================
  // CollectionReference<MovieDto> getWatchListCollection(String uId) {
  //   return getUsersCollection()
  //       .doc(uId)
  //       .collection(AppConstants.watchListCollectionName)
  //       .withConverter<MovieDto>(
  //         fromFirestore: (snapshot, options) =>
  //             MovieDto.fromJson(snapshot.data()),
  //         toFirestore: (movieDto, options) => movieDto.toJson(),
  //       );
  // }
  //
  // Future<void> addMovieToWatchList({
  //   required MovieDto movie,
  //   required String uId,
  // }) {
  //   return getWatchListCollection(uId).doc(movie.id.toString()).set(movie);
  // }
  //
  // Future<void> deleteMovieFromWatchList({
  //   required MovieDto movie,
  //   required String uId,
  // }) {
  //   return getWatchListCollection(uId).doc(movie.id.toString()).delete();
  // }
  //
  // Stream<DocumentSnapshot<MovieDto>> watchMovieInWatchList({
  //   required String uId,
  //   required MovieDto movie,
  // }) {
  //   return getWatchListCollection(uId).doc(movie.id.toString()).snapshots();
  // }
  //
  // Stream<List<MovieDto>> getWatchListMovies({required String uId}) {
  //   return getWatchListCollection(uId).snapshots().map(
  //     (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
  //   );
  // }

  /// ========================== history ====================================

  // CollectionReference<MovieDto> getHistoryCollection(String uId) {
  //   return getUsersCollection()
  //       .doc(uId)
  //       .collection(AppConstants.historyCollectionName)
  //       .withConverter<MovieDto>(
  //         fromFirestore: (snapshot, options) =>
  //             MovieDto.fromJson(snapshot.data()),
  //         toFirestore: (movieDto, options) => movieDto.toJson(),
  //       );
  // }
  //
  // Future<void> addMovieToHistory({
  //   required MovieDto movie,
  //   required String uId,
  // }) async {
  //   return await getHistoryCollection(uId).doc(movie.id.toString()).set(movie);
  // }
  //
  // Stream<List<MovieDto>> getHistoryMovies({required String uId}) {
  //   return getHistoryCollection(uId).snapshots().map(
  //     (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
  //   );
  // }
}
