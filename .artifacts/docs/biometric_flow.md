# Biometric Authentication Flow

## Overview

The Master Password is the source of truth.

Biometric authentication is **only** a convenient way to unlock the locally stored SecretKey.

The user's Master Password is never stored.

---

# Registration Flow

## 1. User creates a Master Password

- User enters a Master Password.
- Generate a random salt.
- Derive SecretKey using PBKDF2(masterPassword, salt).
- Create password verifier (hash).
- Store in Firestore:
    - passwordVerifier
    - salt

---

## 2. Check biometric support

Check whether the device supports local authentication.

Supported methods include:

- Fingerprint
- Face ID
- Device PIN
- Device Pattern
- Device Password

---

## 3. Ask to enable biometric

If biometric is supported:

Show:

> Enable biometric authentication for faster unlock?

### If user accepts

- Store SecretKey in FlutterSecureStorage.
- Save `useBiometric = true` in SharedPreferences.

### If user declines

- Save `useBiometric = false`.
- Continue normally.

Do not ask again until the user enables it from Settings.

---

# Login Flow

## 1. User enters Master Password

- Read verifier and salt from Firestore.
- Verify password.
- If verification fails:
    - Show invalid password.
    - Stop flow.

---

## 2. Create SecretKey

Derive SecretKey again using PBKDF2.

Store it only in memory.

---

## 3. Offer biometric

If:

- device supports biometric
- biometric is not enabled

Ask:

> Enable biometric authentication?

### Accept

- Save SecretKey in FlutterSecureStorage.
- Save useBiometric = true.

### Decline

- Continue normally.

---

# App Launch Flow

## On startup

Check:

- useBiometric == true
- SecretKey exists in SecureStorage

---

## Case 1

Both are true.

Authenticate using biometric.

If authentication succeeds:

- Read SecretKey.
- Store SecretKey in VaultCryptoService.
- Navigate to Home.

If authentication fails:

Show Master Password screen.

---

## Case 2

Biometric disabled.

Navigate directly to Master Password screen.

User enters password.

Verify password.

Derive SecretKey.

Navigate to Home.

---

## Case 3

useBiometric == true

but SecretKey does not exist.

Possible reasons:

- App restored
- SecureStorage cleared
- Device reset

Fallback:

- Ask for Master Password.
- Verify password.
- Derive SecretKey.
- Ask to enable biometric again.

---

# Logout Flow

Logout means:

The user is signing out of the Firebase account.

Perform:

- Firebase signOut()
- Clear SecretKey from memory.
- Delete SecretKey from FlutterSecureStorage.
- Save useBiometric = false.
- Clear cached decrypted data.
- Navigate to Login.

---

# Lock Flow (Future Feature)

Lock is different from Logout.

Lock should:

- Clear SecretKey from memory.
- Keep SecureStorage.
- Keep useBiometric.

Next unlock:

- biometric
  or
- Master Password.

---

# Disable Biometric

From Settings.

Perform:

- Delete SecretKey from SecureStorage.
- Save useBiometric = false.

---

# Enable Biometric

From Settings.

Requirements:

- User must verify Master Password first.

Then:

- Store current SecretKey.
- Save useBiometric = true.

---

# Change Master Password

User enters:

- Current password
- New password

Steps:

- Verify current password.
- Generate new salt.
- Derive new SecretKey.
- Re-encrypt all vault data.
- Store new verifier.
- Store new salt.

If biometric is enabled:

Replace SecretKey in SecureStorage.

---

# Edge Cases

## Device has no biometric

Never ask to enable biometric.

Always require Master Password.

---

## User removes all fingerprints

Biometric authentication fails.

Fallback:

- Ask for Master Password.
- Recreate SecretKey.

---

## User changes lock screen PIN

Treat as normal biometric authentication.

No action required.

---

## SecureStorage is cleared

Fallback:

- Master Password.
- Derive SecretKey.
- Ask to enable biometric again.

---

## Wrong Master Password

- Do not create SecretKey.
- Do not overwrite SecureStorage.
- Stay on master password screen.

---

## Firestore unavailable

Show appropriate error.

Do not continue.

---

# Security Rules

- Never store the Master Password.
- Never upload SecretKey to Firestore.
- SecretKey exists only:
    - in memory
    - in FlutterSecureStorage (when biometric is enabled)
- Always clear SecretKey from memory on logout.
- Always verify password before deriving SecretKey.
- Never trust SharedPreferences alone.
- Biometric is only a convenience layer, not the source of truth.