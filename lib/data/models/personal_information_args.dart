// lib/data/models/personal_information_args.dart
//
// ? Route args for [PersonalInformationScreen].
class PersonalInformationArgs {
  const PersonalInformationArgs({this.isOnboarding = false});

  final bool isOnboarding;

  static PersonalInformationArgs from(Object? arguments) {
    if (arguments is PersonalInformationArgs) return arguments;
    return const PersonalInformationArgs();
  }
}
