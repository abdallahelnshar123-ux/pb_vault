# Implementation Plan - MasterPasswordCubit Unit Tests

This plan outlines the creation of unit tests for `MasterPasswordCubit` to ensure proper handling of master password setup and verification, following the guidelines in `SKILL.md`.

## Proposed Changes

### Tests

#### [NEW] [master_password_view_model_test.dart](file:///E:/flutter/assignments/pb-vault/test/features/master_password_screen/cubit/master_password_view_model_test.dart)

- Create a new test file for `MasterPasswordCubit`.
- Mock dependencies:
    - `SetMasterPasswordUseCase`
    - `CreateVaultVerifierUseCase`
    - `UnlockVaultUseCase`
- Test cases for `setMasterPassword`:
    - Success: Emits `[MasterPasswordSetupLoading, MasterPasswordSetupSuccess]` when everything goes right.
    - Failure: Emits `[MasterPasswordSetupLoading, MasterPasswordSetupError]` when `SetMasterPasswordUseCase` returns a `Failure`.
- Test cases for `verifyMasterPassword`:
    - Success: Emits `[MasterPasswordVerifyLoading, MasterPasswordVerifySuccess]` when `UnlockVaultUseCase` returns `true`.
    - Failure: Emits `[MasterPasswordVerifyLoading, MasterPasswordVerifyError]` when `UnlockVaultUseCase` returns `false`.

## Verification Plan

### Automated Tests
- Run the newly created test suite:
    ```bash
    flutter test test/features/master_password_screen/cubit/master_password_view_model_test.dart
    ```
