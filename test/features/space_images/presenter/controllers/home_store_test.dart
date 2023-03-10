import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_clean_arch/core/errors/failure.dart';
import 'package:nasa_clean_arch/features/space_images/domain/usecase/get_space_media_from_date_usecase.dart';
import 'package:nasa_clean_arch/features/space_images/presenter/controllers/home_store.dart';
import '../../../../mocks/date_mock.dart';
import '../../../../mocks/space_media_entity_mock.dart';

class MockGetSpaceMediaFromDaateUseCase extends Mock
    implements GetSpaceMediaFromDateUsecase {}

void main() {
  late HomeStore store;
  late GetSpaceMediaFromDateUsecase usecase;

  setUp(() {
    usecase = MockGetSpaceMediaFromDaateUseCase();
    store = HomeStore(usecase);
    registerFallbackValue(DateTime(0, 0, 0));
  });

  test('should return a SpaceMedia from the usecase', () async {
    when(() => usecase(any())).thenAnswer(
      (invocation) async => const Right(tSpaceMedia),
    );
    await store.getSpaceMediaFromDateUsecase(tDate);
    store.observer(onState: (state) {
      expect(state, tSpaceMedia);
      verify(() => usecase).called(1);
    });
  });

  final tFailure = ServerFailure();
  test('should return a Failure from the usecase when there is an error',
      () async {
    when(() => usecase(any())).thenAnswer(
      (invocation) async => Left(tFailure),
    );
    await store.getSpaceMediaFromDateUsecase(tDate);
    store.observer(onError: (error) {
      expect(error, tFailure);
      verify(() => usecase(tDate)).called(1);
    });
  });
}
