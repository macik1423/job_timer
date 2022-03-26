import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:timer/bloc/add_form/add_form_bloc.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/repository/shift_hive.dart';
import 'package:timer/repository/shift_repository.dart';
import 'package:timer/screen/root_screen.dart';

import 'bloc/repo/repo_bloc.dart';
import 'cubit/shift/shift_cubit.dart';
import 'model/shift.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(ShiftAdapter());
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.box("shifts").compact();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu',
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ShiftCubit>(
            create: (context) => ShiftCubit(),
          ),
          BlocProvider<RepoBloc>(
            create: ((context) => RepoBloc(
                  ShiftRepository(
                    shiftApi: ShiftHiveApi(),
                  ),
                )..add(
                    RepoSubscriptionRequested(),
                  )),
          ),
          BlocProvider(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider(
            create: (context) => AddFormBloc(),
          ),
        ],
        child: const RootScreen(),
      ),
    );
  }
}
