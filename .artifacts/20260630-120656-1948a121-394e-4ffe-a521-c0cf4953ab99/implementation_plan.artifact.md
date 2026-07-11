# Implementation Plan - Update UserCubit Tests for HomeCubit Dependency

Update the `UserCubit` unit tests to reflect the architectural changes where `HomeCubit` is now a direct constructor dependency.

## Proposed Changes

### Tests

#### [user_view_model_test.dart](file:///E:/flutter/assignments/pb-vault/test/features/auth/cubit/user_view_model_test.dart)

- **Constructor Update**: Pass `mockHomeCubit` to the `UserCubit` constructor in `setUp`.
- **Refactor `logout` and `deleteUser` Tests**:
    - Convert `testWidgets` back to `blocTest` as `HomeCubit` is no longer accessed via `BuildContext`.
    - Continue to mock `BuildContext` to satisfy the `context.mounted` check.
- **Maintain Strict Verification**: Update the `verify` blocks to account for the direct interaction with `_homeCubit`.

## Verification Plan

### Automated Tests
- Run `flutter test test/features/auth/cubit/user_view_model_test.dart`
