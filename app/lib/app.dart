import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/features/auth/bloc/auth_bloc.dart';
import 'package:app/features/bookings/bloc/my_bookings_bloc.dart';

class QuickSlotApp extends StatefulWidget {
  const QuickSlotApp({super.key});

  @override
  State<QuickSlotApp> createState() => _QuickSlotAppState();
}

class _QuickSlotAppState extends State<QuickSlotApp> {
  late final AuthBloc _authBloc;
  late final MyBookingsBloc _myBookingsBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
    _myBookingsBloc = MyBookingsBloc(getIt<ApiClient>());
    _router = AppRouter.create(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _myBookingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _myBookingsBloc),
      ],
      child: MaterialApp.router(
        title: 'QuickSlot',
        routerConfig: _router,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
