# MacGuard

MacGuard is a comprehensive authentication solution for macOS that adds an extra layer of security to local logins by introducing Time-based One-Time Password (TOTP) authentication. It enables organizations or users to link a local macOS account with a Google account, generate TOTP secrets securely, and enforce multi-factor authentication at the system login screen.

## Key Features
- **Two-factor authentication (2FA) at macOS login**: Users authenticate with their password and a TOTP code, greatly enhancing login security.
- **Local & Google account linking**: Seamlessly connect a local user account with a Google account for improved identity management.
- **TOTP secret management**: Generates a TOTP secret and stores it securely in the system Keychain.
- **Modular architecture**: Built as three collaborating apps/components:
  - **User-level App**: For account linking, Google login, TOTP secret generation, and account management.
  - **Privileged Helper Tool**: Handles secure operations requiring elevated privileges, such as interaction with local user records and the Keychain.
  - **Login Plugin**: Integrates with the macOS login window to enforce password and TOTP code entry during authentication.

## Architecture Overview

// MacGuard Architecture Overview

/*
+------------------+         XPC         +-----------------------+         XPC         +-------------------+
|   User App       |<------------------->|   Helper Tool         |<------------------->|   Login Plugin    |
+------------------+                     +-----------------------+                     +-------------------+
| - Google Account |                     | - Keychain Access     |                     | - Login UI        |
|   Linking        |                     | - ODRecord Updates    |                     | - TOTP Prompt     |
| - Local Account  |                     | - Secret Storage      |                     | - Password Check  |
|   Linking        |                     | - Account Linking     |                     | - TOTP Check      |
| - TOTP Setup     |                     |   Privileged Actions  |                     |                  |
*/

/*
- Communication between components is exclusively via XPC, secured by code-signing authentication.

## Component Responsibilities & Communication
- User App:
    - Allows users to log in with Google and link Google accounts to local macOS accounts.
    - Enables users to scan a QR code to generate a TOTP secret for two-factor authentication.
    - Communicates with the Helper Tool via XPC for privileged operations.
- Helper Tool:
    - Acts as a secure intermediary between user-level actions and system-level changes.
    - Stores TOTP secrets in the Keychain and links Google/local accounts.
    - Handles privileged tasks like updating ODRecords and managing secrets.
    - Only performs limited, security-sensitive operations.
- Login Plugin:
    - Alters the macOS login experience to prompt for a TOTP code after password entry.
    - Passes the entered TOTP code securely to the Helper Tool via XPC for validation.
    - Grants access only if both the password and TOTP code are correct.

## Authentication Flow
1. User launches the User App, logs in with Google, and links their Google account to their local macOS account.
2. The User App displays a QR code that the user scans to set up TOTP. The secret is sent (over XPC) to the Helper Tool, which stores it in the Keychain.
3. On subsequent logins, after the user successfully enters their password, the Login Plugin prompts for a TOTP code.
4. The TOTP code is sent via XPC to the Helper Tool, which validates it against the secret in the Keychain.
5. If both password and TOTP are verified, login completes successfully.

## Security Model
- All inter-component communication is performed using XPC with code-signing validation for both client and server authenticity.
- The Helper Tool is the only component authorized to make privileged changes and access the Keychain.
- Minimal attack surface: privileges and sensitive storage are tightly constrained to the Helper Tool.

## Deployment & Installation
- The User App is distributed in the standard Applications folder.
- The Privileged Helper Tool is installed and registered using SMAppService.
- The Login Plugin is placed in `/Library/Security/SecurityAgentPlugins`.
- The `security authorizationdb` command updates the authorization database to register the `TOTPVerifier` mechanism.

## Maintenance & Recovery
- If login needs to be reset, the user can update or restore the authorization database using `security authorizationdb` commands.
*/
