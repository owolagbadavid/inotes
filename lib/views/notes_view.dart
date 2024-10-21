import 'package:flutter/material.dart';
import 'package:inotes/constants/routes.dart';
import 'package:inotes/enums/menu_action.dart';
import 'package:inotes/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inotes/utils/show_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is AuthenticationFailureState) {
          showErrorDialog(context, state.errorMessage);
        } else if (state is LogoutConfirmationState) {
          final shouldLogOut = await showLogOutDialog(context);

          if (shouldLogOut) {
            if (context.mounted) {
              BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
            }
          }
        } else if (state is AuthenticationSuccessState) {
          if (state.user == null) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginRoute, (_) => false);
          }
        } else if (state is AuthenticationLoadingState && state.isLoading) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Notes"), actions: <Widget>[
          PopupMenuButton<MenuAction>(
            tooltip: 'Menu',
            itemBuilder: (context) => const <PopupMenuEntry<MenuAction>>[
              PopupMenuItem(
                value: MenuAction.logout,
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    ConfirmLogoutRequested(),
                  );
                  return;
              }
            },
          )
        ]),
        body: const Text("Hello World"),
      ),
    );
  }
}
