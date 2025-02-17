class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = '************';
  static const String supabaseAnonKey = '****************';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // Record Types
  static const String labRecordType = 'lab';
  static const String prescriptionRecordType = 'prescription';
  static const String illnessRecordType = 'illness';

  // Routes
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String profileRoute = '/profile';
  static const String recordsRoute = '/records';
  static const String addRecordRoute = '/records/add';

  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.png';

  // Animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
} 