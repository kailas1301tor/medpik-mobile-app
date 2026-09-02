import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/res/enums/enums.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/profile/model/profile_model.dart';
import 'package:medpik/src/profile/model/store_profile_model.dart';
import 'package:medpik/src/profile/notifier/profile_notifier.dart';
import 'package:medpik/src/profile/repo/profile_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileNotifier store profile', () {
    late ProviderContainer container;
    late FakeProfileRepo repository;

    setUp(() {
      repository = FakeProfileRepo();
      container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      );
    });

    tearDown(() => container.dispose());

    test('loads support contacts without changing customer profile', () async {
      final notifier = container.read(profileNotifierProvider.notifier);
      await notifier.fetchProfile();
      final customerProfile = container.read(profileNotifierProvider).profile;

      repository.storeResponse = const Right(
        StoreProfileResponse(
          results: StoreProfileResults(
            data: StoreProfileModel(
              supportPhone: '+1234567890',
              supportEmail: 'support@medpik.com',
            ),
          ),
        ),
      );
      await notifier.fetchStoreProfile();

      final state = container.read(profileNotifierProvider);
      expect(state.supportLoaderState, LoaderState.loaded);
      expect(state.storeProfile?.supportEmail, 'support@medpik.com');
      expect(state.profile, same(customerProfile));
    });

    test('uses noData when the response has no usable contacts', () async {
      repository.storeResponse = const Right(
        StoreProfileResponse(
          results: StoreProfileResults(data: StoreProfileModel()),
        ),
      );

      final notifier = container.read(profileNotifierProvider.notifier);
      await notifier.fetchStoreProfile();

      expect(
        container.read(profileNotifierProvider).supportLoaderState,
        LoaderState.noData,
      );
    });
  });
}

class FakeProfileRepo implements ProfileRepo {
  Either<ResponseError, StoreProfileResponse> storeResponse = const Right(
    StoreProfileResponse(results: StoreProfileResults(data: StoreProfileModel())),
  );

  @override
  Future<Either<ResponseError, ProfileResponse>> getProfile() async => Right(
    ProfileResponse(
      results: const ProfileResults(data: ProfileModel(firstName: 'Test')),
    ),
  );

  @override
  Future<Either<ResponseError, StoreProfileResponse>> getStoreProfile() async =>
      storeResponse;

  @override
  Future<Either<ResponseError, ProfileResponse>> updateProfile(
    ProfileModel profile,
  ) async => Right(ProfileResponse(results: ProfileResults(data: profile)));
}
