import 'package:go_router/go_router.dart';
import 'package:kmschool/screens/account_info_screen.dart';
import 'package:kmschool/screens/forgot_password_screen.dart';
import 'package:kmschool/screens/lesson_progress_screen.dart';
import 'package:kmschool/screens/lunch_menu_screen.dart';
import 'package:kmschool/screens/meeting_with_office_screen.dart';
import 'package:kmschool/screens/meeting_with_teacher_screen.dart';
import 'package:kmschool/screens/message_from_school_screen.dart';
import 'package:kmschool/screens/message_to_office_screen.dart';
import 'package:kmschool/screens/message_to_teacher_screen.dart';
import 'package:kmschool/screens/profile_screen.dart';
import 'package:kmschool/screens/school_calender_screen.dart';
import 'package:kmschool/screens/set_remider_screen.dart';
import 'package:kmschool/screens/snack_menu_screen.dart';
import 'package:kmschool/screens/student_photo_screen.dart';
import 'package:kmschool/screens/switch_child_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class Routes {
  // static const selectionPage = '/';
  static const mainHome = '/home';
  static const selectLanguage = '/selectLanguage';
  static const messageFromSchool = '/message-from-school';
  static const account = '/account';
  static const signIn = '/';
  static const forgotPassword = '/forgot_password';
  static const verifyEmail = '/verify-email';
  static const deviceInfo = '/device-info';

  static const accountInfo = '/account-info';
  static const pairFailed = '/pair-failed';
  static const alreadyPaired = '/already-paired';
  static const messageToOffice = '/message-to-office';
  static const messageToTeacher = '/message-to-teacher';
  static const meetingWithOffice = '/meeting-with-office';
  static const meetingWithTeacher = '/meeting-with-teacher';
  static const schoolCalender = '/school-calender';
  static const lunchMenu = '/lunch-menu';
  static const snackMenu = '/snack-menu';
  static const switchChild = '/switch-child';
  static const studentPhotos = '/student-photos';
  static const lessonProgress = '/lesson-progress';
  static const setReminder = '/set-reminder';
}

GoRouter buildRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: Routes.signIn,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: Routes.mainHome,
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: Routes.messageFromSchool,
        builder: (_, __) => const MessageFromSchoolPage(),
      ),


      GoRoute(
        path: Routes.messageToOffice,
        builder: (_, __) => const MessageToOfficePage(),
      ),
      GoRoute(
        path: Routes.messageToTeacher,
        builder: (_, __) => const MessageToTeacherPage(),
      ),
      GoRoute(
        path: Routes.meetingWithTeacher,
        builder: (_, __) => const MeetingWithTeacherPage(),
      ),
      GoRoute(
        path: Routes.meetingWithOffice,
        builder: (_, __) => const MeetingWithOfficePage(),
      ),

      GoRoute(
        path: Routes.lunchMenu,
        builder: (_, __) => const LunchMenuPage(),
      ),

      GoRoute(
        path: Routes.snackMenu,
        builder: (_, __) => const SnackMenuPage(),
      ),
   GoRoute(
        path: Routes.switchChild,
        builder: (_, __) => const SwitchChildPage(),
      ),
   GoRoute(
        path: Routes.studentPhotos,
        builder: (_, __) => const StudentPhotoPage(),
      ),

   GoRoute(
        path: Routes.lessonProgress,
        builder: (_, __) => const LessonProgressPage(),
      ),

   GoRoute(
        path: Routes.schoolCalender,
        builder: (_, __) => const SchoolCalenderPage(),
      ),

  GoRoute(
        path: Routes.setReminder,
        builder: (_, __) => const SetReminderPage(),
      ),

  GoRoute(
        path: Routes.accountInfo,
        builder: (_, __) => const ProfilePage(),
      ),


    ],
  );
}
