import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../data/model/response/my_user_dto.dart';
import '../../../data/model/response/platform_account_dto/platform_account_dto.dart';
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
  CollectionReference<PlatformAccountDto> getAccountsCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(AppConstants.accountsCollectionName)
        .withConverter<PlatformAccountDto>(
          fromFirestore: (snapshot, options) =>
              PlatformAccountDto.fromFireStore(snapshot.data()!),
          toFirestore: (accountDto, options) => accountDto.toFireStore(),
        );
  }

  Future<void> addAccount({
    required PlatformAccountDto account,
    required String uId,
  }) {
    var collection = getAccountsCollection(uId);
    var document = collection.doc();
    return document.set(account.copyWith(document.id));
  }
  Future<void> updateAccount({
    required PlatformAccountDto account,
    required String uId,
  }) {
    return getAccountsCollection(uId).doc(account.id).set(account);

  }

  Stream<List<PlatformAccountDto>> getAccountsStream({required String uId}) {
    return getAccountsCollection(uId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Future<void> deleteAccount({required String uId, required String accountId}) {
    return getAccountsCollection(uId).doc(accountId).delete();
  }

  // Future<void> updateAccount({required String uId, required AccountDto platform_account}) {
  //   return getAccountsCollection(uId).doc(platform_account.id).update(platform_account.toFireStore());
  // }
}
