// import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:finshyt/constants/app_colors.dart';
// import 'package:finshyt/screens/auth/auth_screen.dart';
// import 'package:finshyt/widgets/common/snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class VerificationCard extends StatefulWidget {
//   const VerificationCard({super.key});

//   @override
//   State<VerificationCard> createState() => _VerificationCardState();
// }

// class _VerificationCardState extends State<VerificationCard> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthEmailVerificationSent) {
//           showSnackBar(context, 'Verification Email sent');
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           color: Theme.of(context).colorScheme.surface,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: Column(
//             children: [
//               // email verification icon
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.mark_email_read_outlined,
//                   size: 50,
//                   color: AppColors.primary,
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // main message
//               Text(
//                 'Check Your Email',
//                 style: GoogleFonts.inter(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),

//               Text(
//                 'Please click the verification link sent to your email to activate your account.',
//                 style: GoogleFonts.inter(
//                   fontSize: 16,
//                   color: AppColors.secondaryText,
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),

//               // continue button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => const Login()),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     foregroundColor: AppColors.background,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: Text(
//                     'Continue',
//                     style: GoogleFonts.inter(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.background,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Resend email button
//               TextButton(
//                 onPressed: () {
//                   context.read<AuthBloc>().add(
//                     const AuthEventSendEmailVerification(),
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Text('Verification email sent!'),
//                       backgroundColor: AppColors.secondary,
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   'Resend Email',
//                   style: GoogleFonts.inter(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Instructions
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: AppColors.primary.withOpacity(0.2),
//                     width: 1,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.info_outline,
//                       color: AppColors.primary,
//                       size: 24,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Didn\'t receive the email?',
//                       style: GoogleFonts.inter(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Check your spam folder or click "Resend Email" to try again.',
//                       style: GoogleFonts.inter(
//                         fontSize: 12,
//                         color: AppColors.secondaryText,
//                         height: 1.4,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
