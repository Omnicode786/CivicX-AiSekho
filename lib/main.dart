import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'core/theme/app_theme.dart';
import 'data/services/firestore_service.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CivixApp());
}

class CivixApp extends StatelessWidget {
  const CivixApp({super.key});
  @override
  Widget build(BuildContext context) => Provider(
    create: (_) => FirestoreService(FirebaseFirestore.instance),
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CIVIX AI',
      theme: AppTheme.dark(),
      routerConfig: appRouter,
    ),
  );
}
