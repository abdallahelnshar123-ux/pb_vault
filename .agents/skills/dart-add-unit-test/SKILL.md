---
name: dart-add-unit-test
description: Write and organize unit tests for functions, methods, and classes using `package:test`. Use when creating new logic or fixing bugs to ensure code remains correct and regression-free.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Fri, 24 Apr 2026 15:07:58 GMT
---
# Testing Dart and Flutter Applications

## Contents
- [Structuring Test Files](#structuring-test-files)
- [Writing Tests](#writing-tests)
- [Executing Tests](#executing-tests)
- [Testing BLoC/Cubit (bloc_test)](#testing-bloc-cubit-bloc_test)
- [Testing ChangeNotifier/ViewModels](#testing-changenotifierviewmodels)
- [Testing Streams (Firestore Patterns)](#testing-streams-firestore-patterns)
- [Advanced Testing Patterns](#advanced-testing-patterns)
- [Test Implementation Workflow](#test-implementation-workflow)
- [Examples](#examples)

## Structuring Test Files
Organize test files to mirror the `lib` directory structure to maintain predictability.

* Place all test code within the `test` directory at the root of the package.
* Append `_test.dart` to the end of all test file names (e.g., `lib/src/utils.dart` should be tested in `test/src/utils_test.dart`).
* If writing integration tests, place them in an `integration_test` directory at the root of the package.

## Writing Tests
Utilize `package:test` as the standard testing library for Dart applications.

* Import `package:test/test.dart` (or `package:flutter_test/flutter_test.dart` for Flutter).
* Group related tests using the `group()` function to provide shared context.
* Define individual test cases using the `test()` function.
* Validate outcomes using the `expect()` function alongside matchers (e.g., `equals()`, `isTrue`, `throwsA()`).
* **Precise Exception Matching**: When testing for specific exceptions and their properties (e.g., error messages), use `throwsA()` with `isA<T>().having()`:
    ```dart
    expect(
      () => dataSource.call(),
      throwsA(isA<ServerException>().having((e) => e.message, 'message', 'error_msg')),
    );
    ```
* **Value Equality**: For `expect()` to correctly compare custom objects (DTOs, Entities), ensure they extend `package:equatable/equatable.dart`. This allows comparing by field values rather than memory references.
* Write asynchronous tests using standard `async`/`await` syntax. The test runner automatically waits for the `Future` to complete.
* Manage test setup and teardown using `setUp()` and `tearDown()` callbacks.
* If testing code that relies on dependency injection, use `package:mocktail` alongside `package:test` to create mock objects without code generation, configure scenarios, and verify interactions.
* **Mocktail Basics**:
    * Define mocks by extending `Mock`: `class MockRepo extends Mock implements Repo {}`.
    * **Fake Classes**: For classes used as arguments where you don't need to stub specific methods but need a valid instance, use `Fake`: `class FakeData extends Fake implements Data {}`.
    * Use closures for stubbing: `when(() => mock.method()).thenAnswer(...)`.
    * **Stubbing Void/Future<void>**: When stubbing methods that return `void` or `Future<void>`, use `{}` instead of `null` in `thenAnswer`: `thenAnswer((_) async => {})`.
    * Use closures for verification: `verify(() => mock.method()).called(1)`.
    * **Strict Verification**:
        * Use `verifyNoMoreInteractions(mock)` after all expected calls to ensure no other methods were called on that mock.
        * Use `verifyZeroInteractions(mock)` to prove that a mock was never used during a specific test case (e.g., in error scenarios where a dependency shouldn't be touched).
* **Argument Matchers and Custom Types**:
    * For primitive types (String, int, etc.), use `any()`.
    * For **custom classes** (DTOs, Entities), you MUST register a fallback value in `setUpAll()` before using `any()`: `registerFallbackValue(MyClass(...));` or `registerFallbackValue(FakeClass());`.
    * If a method uses named arguments, use `any(named: 'argName')`.

## Executing Tests
Select the appropriate test runner based on the project type and test location.

* If working on a pure Dart project, execute tests using the `dart test` command.
* If working on a Flutter project, execute tests using the `flutter test` command.
* If running integration tests, explicitly specify the directory path, as the default runner ignores it: `dart test integration_test` or `flutter test integration_test`.

## Testing BLoC/Cubit (bloc_test)
Use `package:bloc_test` for verifying BLoC and Cubit behavior.

* **Standard State Testing**: Use `blocTest<B, S>` to verify state emissions.
    * `build`: Initialize the Cubit/BLoC with mocks.
    * `act`: Trigger the method or event being tested.
    * `expect`: Define the sequence of expected states using matchers like `isA<T>().having()`.
    * `verify`: Perform strict verification on mocks and internal state (e.g., `expect(cubit.list, [...])`).
* **Mocking BLoCs/Cubits**: When a Cubit depends on another Cubit, use `MockCubit<S>` from `package:bloc_test/src/mock_bloc.dart`:
    ```dart
    class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}
    ```
* **Strict Verification in BLoC Tests**:
    * Always include a `verify` block within `blocTest` to ensure interactions occurred as expected.
    * Use `verifyNoMoreInteractions(mock)` for all mocks touched by the method.
    * Use `verifyZeroInteractions(mock)` for all other mocks in the suite to ensure isolation.

## Testing ChangeNotifier/ViewModels
For classes extending `ChangeNotifier`, verify state changes and listener notifications manually.

* **Listener Verification**: Add a listener to the ViewModel to track if `notifyListeners()` was called.
    ```dart
    test('should notify listeners when data changes', () {
      bool notified = false;
      viewModel.addListener(() => notified = true);
      viewModel.doSomething();
      expect(notified, isTrue);
    });
    ```
* **Optimization Verification**: Ensure listeners are NOT notified if the state remains identical (e.g., setting the same index).
    ```dart
    test('should not notify if value is unchanged', () {
      bool notified = false;
      viewModel.addListener(() => notified = true);
      viewModel.setIndex(0); // already 0
      expect(notified, isFalse);
    });
    ```
* **Strict Verification**: Even for standard ViewModels, use `verifyNoMoreInteractions(mock)` to ensure dependencies are used exactly as intended.

## Testing Streams (Firestore Patterns)
When testing methods that return `Stream<Either<Failure, T>>` (common in Firestore repositories), use `toList()` to capture all emitted events for precise assertions.

* **Success Path**:
    1. Mock the Data Source stream using `Stream.fromIterable([[dto1], [dto1, dto2]])`.
    2. Convert the Repository stream to a list: `final actual = await repository.getStream().toList();`.
    3. Assert length and use `fold` to verify content: `actual[0].fold((l) => fail('Expected Right'), (r) => expect(r, [entity1]));`.
* **Error Path**:
    1. Mock the Data Source stream to emit an error: `Stream.error(ServerException(...))`.
    2. Capture emissions: `final actual = await repository.getStream().toList();`.
    3. Verify emission is a `Left` with the expected `Failure`.

## Advanced Testing Patterns

### Flutter Environment Setup
If your test uses Flutter-specific services like `Clipboard` or `MethodChannels`, ensure you initialize the binding in `setUp()`:
```dart
setUp(() {
  TestWidgetsFlutterBinding.ensureInitialized();
});
```

### Testing Stream Subscription Management
To ensure a Cubit correctly cancels previous subscriptions (e.g., when calling a fetch method multiple times), use `StreamController`:
```dart
test('should cancel previous subscription', () async {
  final controller1 = StreamController<T>();
  final controller2 = StreamController<T>();

  when(() => useCase.invoke()).thenAnswer((_) => controller1.stream);
  cubit.fetch(); // First call

  when(() => useCase.invoke()).thenAnswer((_) => controller2.stream);
  cubit.fetch(); // Second call

  expect(controller1.hasListener, isFalse);
  expect(controller2.hasListener, isTrue);
});
```

### Conditional Error Handling
When testing streams that might emit errors you want to ignore (e.g., `permission-denied`), ensure your `expect` block matches the intended behavior:
```dart
blocTest<MyCubit, MyState>(
  'emits [Loading] and ignores specific error',
  build: () {
    when(() => useCase.invoke()).thenAnswer((_) => Stream.error('permission-denied'));
    return cubit;
  },
  act: (cubit) => cubit.start(),
  expect: () => [isA<LoadingState>()],
);
```

## Test Implementation Workflow

Follow this sequential workflow when implementing new test suites. Copy the checklist to track your progress.

### Task Progress
- [ ] 1. Create the test file in the `test/` directory, ensuring the `_test.dart` suffix.
- [ ] 2. Import `package:test/test.dart` and the target library.
- [ ] 3. Define a `main()` function.
- [ ] 4. Initialize shared resources or mocks using `setUp()`.
- [ ] 5. Write `test()` cases grouped by functionality using `group()`.
- [ ] 6. Execute the test suite using the appropriate CLI command.
- [ ] 7. **Feedback Loop**: Run test -> Review stack trace for failures -> Fix implementation or assertions -> Re-run until passing.

## Examples

### Standard Unit Test Suite
Demonstrates grouping, setup, synchronous, and asynchronous testing.

```dart
import 'package:test/test.dart';
import 'package:my_package/calculator.dart';

void main() {
  group('Calculator', () {
    late Calculator calc;

    setUp(() {
      calc = Calculator();
    });

    test('adds two numbers correctly', () {
      expect(calc.add(2, 3), equals(5));
    });

    test('handles asynchronous operations', () async {
      final result = await calc.fetchRemoteValue();
      expect(result, isNotNull);
      expect(result, greaterThan(0));
    });
  });
}
```

### BLoC/Cubit Unit Test with Strict Verification
Demonstrates `blocTest` with complex state matching and strict mocktail verification.

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/user_cubit.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  late UserCubit userCubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockHomeCubit mockHomeCubit;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockHomeCubit = MockHomeCubit();
    userCubit = UserCubit(mockLoginUseCase, mockHomeCubit);
  });

  group('UserCubit', () {
    blocTest<UserCubit, UserState>(
      'emits [Loading, Success] when login succeeds',
      build: () {
        when(() => mockLoginUseCase.invoke(any(), any()))
            .thenAnswer((_) async => Right(User(id: '1')));
        return userCubit;
      },
      act: (cubit) => cubit.login('email', 'password'),
      expect: () => [
        isA<LoadingState>(),
        isA<AuthenticatedState>().having((s) => s.user.id, 'id', '1'),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.invoke('email', 'password')).called(1);
        verifyNoMoreInteractions(mockLoginUseCase);
        verifyZeroInteractions(mockHomeCubit); // Ensures other dependencies aren't touched
      },
    );
  });
}
```

### Mocking with Mocktail and Testing Streams
Demonstrates configuring a mock object, registering fallback values, verifying interactions with `Equatable`, and testing Stream emissions.

```dart
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:equatable/equatable.dart';
import 'package:my_package/api_client.dart';
import 'package:my_package/data_service.dart';

// 1. Ensure custom classes use Equatable for easier comparison in expect()
class UserDto extends Equatable {
  final String id;
  final String name;

  const UserDto({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  // 2. Register fallback values for custom types if using any()
  setUpAll(() {
    registerFallbackValue(const UserDto(id: '', name: ''));
  });

  group('DataService', () {
    late MockApiClient mockApiClient;
    late DataService dataService;

    setUp(() {
      mockApiClient = MockApiClient();
      dataService = DataService(apiClient: mockApiClient);
    });

    test('returns parsed data on successful API call', () async {
      // 3. Configure the mock using closure syntax
      when(() => mockApiClient.get(any())).thenAnswer((_) async => '{"id": 1}');

      // Execute the system under test
      final result = await dataService.fetchData();

      // 4. Verify outcomes and interactions
      expect(result.id, equals(1));
      verify(() => mockApiClient.get(any())).called(1);
    });

    test('emits mapped users when stream emits data', () async {
      // 5. Stream Testing Pattern
      final tDto = UserDto(id: '1', name: 'Test');
      when(() => mockApiClient.getUsersStream()).thenAnswer(
        (_) => Stream.fromIterable([[tDto]]),
      );

      final stream = dataService.getUsersStream();
      final actual = await stream.toList();

      expect(actual.length, 1);
      actual[0].fold(
        (failure) => fail('Expected Right'),
        (users) => expect(users, [User(id: '1', name: 'Test')]),
      );

      verify(() => mockApiClient.getUsersStream()).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test('calls save with specific user object', () async {
      final user = UserDto(id: '1', name: 'Test');
      when(() => mockApiClient.saveUser(user: any(named: 'user')))
          .thenAnswer((_) async => true);

      await dataService.save(user);

      // Verification also uses Equatable for value-based matching
      verify(() => mockApiClient.saveUser(user: user)).called(1);
    });
  });
}
```
</HomeState></ServerException>