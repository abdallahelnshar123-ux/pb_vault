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
    * Register fallback values in `setUpAll()` for custom classes: `registerFallbackValue(MyClass(...));`.

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
* **Success Paths**:
    * Verify data flows correctly, including saving to local cache if required.
    * **Sensitive Fields**: Verify encryption/decryption of **ALL** sensitive fields (e.g., password, notes, recovery codes, secrets) if multiple exist in the entity.
    * **Stream Content**: For streams used in lists, verify they only contain basic info and that sensitive fields are null/empty if they require explicit decryption.
* **Error Paths**:
    * **Specific Mapping**: Verify `AppException` from Data Source is mapped to the correct `Failure` (e.g., `ServerException` -> `ServerFailure`).
    * **Generic Mapping**: Verify unexpected `Exception` is mapped to `UnexpectedFailure` with the correct string representation.
    * **Stream Errors**: Verify that exceptions in the source stream are caught and emitted as `Left(Failure)`.
* **Isolation**: Use `verifyZeroInteractions` for the Local Data Source if the Remote Data Source fails early.
* **Bulk Data Integrity**: For bulk operations (e.g., `decryptMultiple`), explicitly test scenarios where the result list contains `null` values to ensure the mapping back to entities is handled correctly and doesn't crash or misalign.

### Use Cases
* **Granular Multi-step Testing**: For use cases involving multiple sequential repository calls, write separate tests for the failure of **every single step**.
* **Failure Propagation & Isolation**: Verify that a failure in any step returns the correct `Left(Failure)` and that subsequent steps are **NOT** executed (use `verifyZeroInteractions`).
* **Non-blocking Resilience**: If a specific check is non-critical (e.g., a "same-as-old" check that should fail open), verify that the use case **continues** to the next step even if that check returns a `Left`.
* **Post-Operation Side Effects**: If the main operation succeeds but a necessary post-operation (e.g., updating biometric keys) fails, ensure the failure is propagated as the final result.
* **Option Handling**: Explicitly test scenarios where a repository returns `Right(None())` for required data, ensuring it's mapped to a suitable `Failure` (e.g., `UnexpectedFailure`).

### Services (Stateful)
* For services like `VaultCryptoService` that maintain internal state:
    * **Initial State**: Verify the object is in the expected state immediately after instantiation (e.g., `isLocked` is true).
    * **State Transitions**: Verify that actions (like unlocking) correctly update the internal state.
    * **Constraint Enforcement**: Verify that methods throw exceptions if called while the service is in an invalid state (e.g., `encrypt` while locked).
    * **Resetting State**: Ensure "lock" methods correctly return the service to its restricted initial state.
    * **Data Integrity**: For cryptographic services, verify that tampering with encrypted data (e.g., changing a single byte of the MAC) results in the appropriate security exception (e.g., `SecretBoxAuthenticationError`).
    * **Bulk Handling**: When services offer "multiple" or "bulk" operations, explicitly test the handling of `null`, empty strings, and whitespace within the input list.

### BLoC/Cubit (bloc_test)
Use `package:bloc_test` for verifying state emissions.
* **State Matching**: Use `isA<T>().having(...)` in the `expect` block to verify state properties.
* **Internal Logic**: For methods that don't emit states (e.g., `getInitialRoute`), use standard `test()` functions.
* **Exhaustive Failure Testing**: For **EVERY** UI action, explicitly test how the BLoC/Cubit handles failures from dependencies (e.g., Use Case returning `Left(Failure)`). Verify that it emits the correct `ErrorState` with the expected message.
* **Strict Mock Verification**: Perform `verifyNoMoreInteractions` and `verifyZeroInteractions` inside the `verify` callback of `blocTest`.
* **Dependency Mocking**: When a Cubit depends on another, use `MockCubit<S>`.

## Testing Randomness and Uniqueness
* **Property Verification**: Verify the output type and length rather than specific values: `expect(result, hasLength(16))`.
* **Uniqueness**: Verify that multiple calls produce different results (e.g., salts, nonces): `expect(first, isNot(equals(second)))`.

## Testing Determinism
* **Consistency**: For functions like hashing or verifiers, verify that the same input always produces exactly the same output: `expect(first, equals(second))`.

## Test Implementation Workflow

- [ ] 1. Create the test file mirroring `lib/`.
- [ ] 2. Setup `Mock` classes for all dependencies.
- [ ] 3. Register fallback values in `setUpAll` if using `any()`.
- [ ] 4. Initialize the system under test in `setUp`.
- [ ] 5. Write tests for **Success Paths**.
- [ ] 6. Write tests for **All Error Paths** (Specific exceptions, mapping, early exits).
- [ ] 7. **Apply Strict Verification**: Add `verifyNoMoreInteractions` and `verifyZeroInteractions`.
- [ ] 8. Execute tests and fix implementation.

## Examples

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
