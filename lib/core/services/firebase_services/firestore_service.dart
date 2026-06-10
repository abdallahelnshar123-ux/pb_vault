import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/response/account/account_dto.dart';
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

  /// ===============================   Accounts   =============================
  CollectionReference<AccountDto> getAccountsCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(AppConstants.accountsCollectionName)
        .withConverter<AccountDto>(
          fromFirestore: (snapshot, options) =>
              AccountDto.fromFireStore(snapshot.data()!),
          toFirestore: (accountDto, options) => accountDto.toFireStore(),
        );
  }

  Future<void> addAccount({
    required AccountDto account,
    required String uId,
  }) {
    var collection = getAccountsCollection(uId);
    var document = collection.doc();
    account.id = document.id;
    return document.set(account);
  }

  Stream<List<AccountDto>> getAccountsStream({required String uId}) {
    return getAccountsCollection(uId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

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
