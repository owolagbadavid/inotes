import 'package:flutter/material.dart';
import 'package:inotes/helpers/loading/loading_screen.dart';
import 'package:inotes/styles/styles.dart';
import 'package:inotes/views/login_view.dart';
import 'package:inotes/views/register_view.dart';
import 'package:inotes/views/verify_email_view.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/views/notes/notes_view.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inotes/views/notes/create_update_note_view.dart';

// import 'dart:developer' as dev show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, //
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
                FirebaseAuthProvider()), // Inject your AuthenticationBloc here
          ),
        ],
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerfyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthenticationBloc>().add(AuthEventInitialize());

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(context: context, text: state.loadingText);
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthLoggedOutState) {
        return const LoginView();
      } else if (state is AuthenticationSuccessState) {
        return const NotesView();
      } else if (state is AuthenticationNeedsVerificationState) {
        return const VerfyEmailView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}

// class AdaptiveApp extends StatelessWidget {
//   const AdaptiveApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isIOS) {
//       return CupertinoApp(
//         title: 'Notes',
//         home: const HomePage(),
//         routes: {
//           loginRoute: (context) => const LoginView(),
//           registerRoute: (context) => const RegisterView(),
//           notesRoute: (context) => const NotesView(),
//           verifyEmailRoute: (context) => const VerfyEmailView(),
//           createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
//         },
//         theme: cupertionThemeBuilder(context),
//       );
//     }
//     return MaterialApp(
//       title: 'Notes',
//       theme: lightTheme,
//       darkTheme: darkTheme,
//       themeMode: ThemeMode.system, //
//       home: const HomePage(),
//       routes: {
//         loginRoute: (context) => const LoginView(),
//         registerRoute: (context) => const RegisterView(),
//         notesRoute: (context) => const NotesView(),
//         verifyEmailRoute: (context) => const VerfyEmailView(),
//         createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
//       },
//     );
//   }
// }
