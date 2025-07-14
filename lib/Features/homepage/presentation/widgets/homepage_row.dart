import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:finshyt/core/constants/app_colors.dart';
import 'package:finshyt/core/constants/app_dimensions.dart';
import 'package:finshyt/core/constants/app_strings.dart';
import 'package:finshyt/core/constants/misc.dart';
import 'package:finshyt/Features/auth/presentation/screens/auth/auth_screen.dart';
import 'package:finshyt/core/utility/dialogs/showErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomepageRow extends StatelessWidget {
  const HomepageRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showErrorDialog(context, state.message);
        } else if (state is AuthLoggedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AppDimensions.edgePadding),
          child: Row(
            children: [
              Image.asset(Misc.logoUrl, height: 40),
              const Spacer(),

              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == AppStrings.logOut) {
                    context.read<AuthBloc>().add(AuthEventLogout());
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: AppStrings.logOut,
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 20, color: AppColors.icons),
                          SizedBox(width: 8),
                          Text(AppStrings.logOut),
                        ],
                      ),
                    ),
                  ];
                },
                child: Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.background,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
