import 'package:canli_sohbet3/repository/user_repository.dart';
import 'package:canli_sohbet3/services/bildirim_gonderme.dart';
import 'package:canli_sohbet3/services/fake_auth_service.dart';
import 'package:canli_sohbet3/services/firebase_auth_service.dart';
import 'package:canli_sohbet3/services/firebase_storage_service.dart';
import 'package:canli_sohbet3/services/firestoredb_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setuplocator(){
  locator.registerLazySingleton(()=>FirebaseAuthService());
  locator.registerLazySingleton(()=>FakeAuthService());
  locator.registerLazySingleton(()=>FirestoreDbService());
  locator.registerLazySingleton(()=>FirebaseStorageService());
  locator.registerLazySingleton(()=>UserRepo());
  locator.registerLazySingleton(()=>BildirimGonderim());



}