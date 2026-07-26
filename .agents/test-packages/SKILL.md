---
name: test-packages
description: Write and organize unit tests for functions, methods, and classes using `package:test`. Use when creating new logic or fixing bugs to ensure code remains correct and regression-free.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Fri, 24 Apr 2026 15:07:58 GMT
---
# Testing Dart and Flutter Applications

## Contents
- [Structuring Test Files](#structuring-test-files)
- [Naming Convention](#naming-convention)
- [Writing Tests](#writing-tests)
- [Executing Tests](#executing-tests)
- [Layer-Specific Guidelines](#layer-specific-guidelines)
  - [Mappers](#mappers)
  - [Data Sources](#data-sources)
  - [Repositories](#repositories)
  - [Use Cases](#use-cases)
  - [Services (Stateful)](#services-stateful)
  - [BLoC/Cubit (bloc_test)](#bloc-cubit-bloc_test)
  - [Flutter Widget Tests](#flutter-widget-tests)
- [Testing ChangeNotifier/ViewModels](#testing-changenotifierviewmodels)
- [Testing Streams (Firestore Patterns)](#testing-streams-firestore-patterns)
- [Advanced Testing Patterns](#advanced-testing-patterns)
- [Testing Randomness and Uniqueness](#testing-randomness-and-uniqueness)
- [Test Implementation Workflow](#test-implementation-workflow)
- [Examples](#examples)

## Structuring Test Files
Organize test files to mirror the `lib` directory structure to maintain predictability.

* Place all test code within the `test` directory at the root of the package.
* Append `_test.dart` to the end of all test file names (e.g., `lib/src/utils.dart` should be tested in `test/src/utils_test.dart`).

## Naming Convention
Follow the standard naming convention for test cases to ensure clarity:
`test('should [expected outcome] when [condition/scenario]', () { ... });`

* **Good**: `test('should return AuthUserDto when sign in is successful', () async { ... });`
* **Good**: `test('should throw ServerException when FirebaseAuthException occurs', () async { ... });`

## Writing Tests
Utilize `package:test` as the standard testing library for Dart applications.

* Import `package:test/test.dart` (or `package:flutter_test/flutter_test.dart` for Flutter).
* Group related tests using the `group()` function to provide shared context.
* Define individual test cases using the `test()` function.
* Validate outcomes using the `expect()` function alongside matchers (e.g., `equals()`, `isTrue`, `throwsA()`).
* **Object Identity Verification (CRITICAL)**:
    * Use `same(expected)` to verify that the result is the EXACT same instance.
    * Use `expect(identical(actual, expected), isTrue)` as an alternative for identity checks.
* **Precise Exception Matching**: Use `throwsA()` with `isA<T>().having()` to verify specific properties (e.g., error messages).
* **Value Equality**: Ensure custom objects (Entities, DTOs) extend `package:equatable/equatable.dart`.
* **Mocktail Basics**:
    * Define mocks by extending `Mock`: `class MockRepo extends Mock implements Repo {}`.
    * Use closures for stubbing: `when(() => mock.method()).thenAnswer(...)`.
    * Use closures for verification: `verify(() => mock.method()).called(1)`.
    * **Strict Verification (CRITICAL)**:
        * **ALWAYS** use `verifyNoMoreInteractions(mock)` after all expected calls to ensure no other methods were called.
        * **ALWAYS** use `verifyZeroInteractions(mock)` for dependencies that should NOT be touched in a specific test case (especially error paths).
* **Argument Matchers**:
    * **Enums & Custom Classes**: Register fallback values in `setUpAll()` when using `any()`: `registerFallbackValue(ThemeMode.system);`.

## Executing Tests
* Flutter project: `flutter test`
* Specific file: `flutter test test/path/to/file_test.dart`

## Layer-Specific Guidelines

### Mappers
* Test both `toEntity()` and `toDto()` (if applicable).
* Use direct object comparison (thanks to `Equatable`).
* Ensure all fields are mapped correctly, including nested objects and dates.

### Data Sources
* Test against external service mocks (e.g., `FirebaseAuthService`, `FirestoreService`).
* **Complete Error Coverage**: Test all relevant error codes (e.g., `email-already-in-use`, `invalid-credential` for Firebase).
* Verify that platform-specific exceptions are mapped to domain-specific `AppExceptions` (e.g., `SocketException` -> `NetworkException`).
* Use `expectLater(..., throwsA(...))` for async exceptions.

### Repositories
* Coordinate between multiple Data Sources (Local and Remote).
* **Success Paths**: Verify data flows correctly, including saving to local cache if required.
* **Error Paths**:
    * Verify `AppException` from Data Source is mapped to the correct `Failure`.
    * Verify unexpected `Exception` is mapped to `UnexpectedFailure`.
* **Isolation**: Use `verifyZeroInteractions` for the Local Data Source if the Remote Data Source fails early.

### Use Cases
* Simple delegation tests to ensure the correct Repository method is called with the correct arguments.
* Verify success and failure propagation.

### Services (Stateful)
* For services like `VaultCryptoService` that maintain internal state:
    * **Initial State**: Verify the object is in the expected state immediately after instantiation (e.g., `isLocked` is true).
    * **State Transitions**: Verify that actions (like unlocking) correctly update the internal state.
    * **Constraint Enforcement**: Verify that methods throw exceptions if called while the service is in an invalid state (e.g., `encrypt` while locked).
    * **Resetting State**: Ensure "lock" methods correctly return the service to its restricted initial state.

### BLoC/Cubit (bloc_test)
Use `package:bloc_test` for verifying state emissions.
* **State Matching**: Use `isA<T>().having(...)` in the `expect` block to verify state properties.
* **Internal Logic**: For methods that don't emit states (e.g., `getInitialRoute`), use standard `test()` functions.
* **Strict Mock Verification**: Perform `verifyNoMoreInteractions` and `verifyZeroInteractions` inside the `verify` callback of `blocTest`.
* **Dependency Mocking**: When a Cubit depends on another, use `MockCubit<S>`.

### Flutter Widget Tests
* **Avoid Build-Phase Side Effects**: Do NOT trigger methods that call `notifyListeners()` or `setState()` directly inside a `Builder` or `build` method (e.g., in `pumpWidget`). This causes "setState() or markNeedsBuild() called during build" errors.
* **Interaction-Based Testing**: Trigger state changes via `tester.tap()`, etc., followed by `tester.pump()`.
* **InheritedWidgets (Provider Testing)**:
    * Use `Builder` to access `context` and verify `of(context)` returns the `same()` instance as the controller.
    * Verify `maybeOf(context)` returns `null` when the provider is missing.
    * Verify `maybeOf(context)` returns the current provider instance when it exists.

## Testing Randomness and Uniqueness
* **Property Verification**: Verify the output type and length rather than specific values: `expect(result, hasLength(16))`.
* **Uniqueness**: Verify that multiple calls produce different results: `expect(first, isNot(equals(second)))`.

## Test Implementation Workflow

- [ ] 1. Create the test file mirroring `lib/`.
- [ ] 2. Setup `Mock` classes for all dependencies.
- [ ] 3. Register fallback values in `setUpAll` (including enums).
- [ ] 4. Initialize the system under test in `setUp`.
- [ ] 5. Write tests for **Success Paths** (using `same()` for instance checks).
- [ ] 6. Write tests for **All Error Paths** (Specific exceptions, mapping, early exits).
- [ ] 7. **Apply Strict Verification**: Add `verifyNoMoreInteractions` and `verifyZeroInteractions`.
- [ ] 8. Execute tests and fix implementation.

## Examples

### Object Identity Example (Widget Test)
```dart
testWidgets('should provide the exact same controller instance', (tester) async {
  await tester.pumpWidget(
    ThemeScope(
      controller: controller,
      child: Builder(
        builder: (context) {
          final provided = ThemeScope.of(context).notifier;
          expect(provided, same(controller)); // Correct: Identity check
          return const SizedBox();
        },
      ),
    ),
  );
});
```

### Strict Verification Example (Repository)
```dart
test('should return Left(ServerFailure) when remote call fails', () async {
  // Arrange
  when(() => mockRemoteDataSource.getData()).thenThrow(ServerException());

  // Act
  final result = await repository.getData();

  // Assert
  expect(result, Left(ServerFailure()));
  verify(() => mockRemoteDataSource.getData()).called(1);
  verifyNoMoreInteractions(mockRemoteDataSource);
  verifyZeroInteractions(mockLocalDataSource); // Local should not be touched
});
```

### Stateful Service Example
```dart
test('should throw Exception when calling action while locked', () {
  expect(service.isLocked, isTrue);
  expect(() => service.performAction(), throwsA(isA<LockedException>()));
});
```
