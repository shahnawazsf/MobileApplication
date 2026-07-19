import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ProviderScope — the Riverpod root
import 'app.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // ProviderScope must wrap the whole app for any ref.watch/read to work
}
