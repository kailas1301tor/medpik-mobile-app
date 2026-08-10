// test/src/product_detail/notifier/product_detail_prescription_notifier_test.dart
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpik/data/models/product_model.dart';
import 'package:medpik/data/remote/network_base_services.dart';
import 'package:medpik/providers/cart_providers.dart';
import 'package:medpik/providers/prescription_providers.dart';
import 'package:medpik/services/repo_di.dart';
import 'package:medpik/src/product_detail/model/product_detail_model.dart';
import 'package:medpik/src/product_detail/notifier/product_detail_notifier.dart';
import 'package:medpik/src/product_detail/repo/product_detail_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductDetailNotifier prescription mode', () {
    late ProviderContainer container;
    late FakeProductDetailRepo fakeRepo;

    const testProduct = ProductModel(
      id: 101,
      name: 'Paracetamol',
      category: 'Medicine',
      price: 50,
      imageUrl: 'https://example.com/p.png',
      requiresPrescription: true,
    );

    setUp(() {
      fakeRepo = FakeProductDetailRepo();
      container = ProviderContainer(
        overrides: [
          productDetailRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    ProductDetailNotifier readNotifier() =>
        container.read(productDetailNotifierProvider.notifier);

    ProductDetailModel buildDetail() {
      return ProductDetailModel(
        product: testProduct,
        dosage: '500mg',
        packLabel: '10 tablets',
        aboutText: 'About',
        howToUse: 'Use',
        safetyInformation: 'Safe',
      );
    }

    test('addToPrescription updates selected products without cart', () async {
      fakeRepo.nextResponse = Right(
        ProductDetailResponse(
          results: ProductDetailResultsModel(
            data: ProductDetailDataModel(detail: buildDetail()),
          ),
        ),
      );

      final notifier = readNotifier();
      await notifier.loadProduct(101, isFromUploadPrescription: true);
      expect(
        container.read(productDetailNotifierProvider).isFromUploadPrescription,
        isTrue,
      );

      final cartBefore = container.read(cartNotifierProvider).items.length;
      final ok = await notifier.addToPrescription();
      expect(ok, isTrue);

      final prescriptionState = container.read(prescriptionNotifierProvider);
      expect(prescriptionState.selectedProducts.length, 1);
      expect(prescriptionState.selectedProducts.first.product.id, 101);
      expect(prescriptionState.selectedProducts.first.quantity, 1);
      expect(container.read(cartNotifierProvider).items.length, cartBefore);
    });
  });
}

class FakeProductDetailRepo implements ProductDetailRepo {
  Either<ResponseError, ProductDetailResponse>? nextResponse;

  @override
  Future<Either<ResponseError, ProductDetailResponse>> getProductById(
    int id,
  ) async {
    return nextResponse ??
        Left(ResponseError(message: 'missing', key: ApiErrorTypes.oops));
  }
}
