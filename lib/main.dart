import 'package:feed_estimator/src/core/database/app_db.dart';
import 'package:feed_estimator/src/feed_app.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final db = await createDatabase();

  runApp(ProviderScope(overrides: [
    appDatabase.overrideWith((ref) => AppDatabase(db)),
  ], child: const FeedApp()));
}
