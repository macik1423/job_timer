import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:timer/bloc/add_form/add_form_bloc.dart';
import 'package:timer/cubit/navigation/navigation_cubit.dart';
import 'package:timer/repository/shift_hive.dart';
import 'package:timer/repository/shift_repository.dart';
import 'package:timer/screen/root_screen.dart';
import 'package:timer/shift_box.dart';
import 'package:timer/util/duration_adapter.dart';
import 'package:timer/widgets/duration_modifier.dart';

import 'bloc/repo/repo_bloc.dart';
import 'cubit/shift/shift_cubit.dart';
import 'model/shift.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive
    ..initFlutter(appDocumentDirectory.path)
    ..registerAdapter(ShiftAdapter())
    ..registerAdapter(DurationAdapter());

  HydratedBlocOverrides.runZoned(() => runApp(const MyApp()),
      createStorage: () async {
    return HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.box(ShiftBox.boxName).compact();
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
                    shiftApi: ShiftHiveApi(ShiftBox()),
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
        child: MultiProvider(providers: [
          ChangeNotifierProvider<SliderChanged>(
            create: (_) => SliderChanged(),
          )
        ], child: const RootScreen()),
      ),
    );
  }
}
