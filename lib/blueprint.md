# Application Blueprint

## Overview

This application is a mobile utility for scanning and printing, designed to work with Zebra TC21 devices. It features user authentication and local data storage using Hive.

## Project Structure

The project follows a feature-driven directory structure to ensure code is organized, scalable, and maintainable.

*   `lib/`: The main directory for all Dart source code.
    *   `l10n/`: Contains the `.arb` files for internationalization (i18n).
    *   `model/`: Contains the data model classes that represent the application's data structures.
        *   `admin_model.dart`: Data model for an admin user, compatible with Hive.
        *   `store_model.dart`: Data model for a store, compatible with Hive.
    *   `screens/`: Contains all the UI screens (widgets that represent a full page).
        *   `login_screen.dart`: The user login screen.
        *   `register_store_screen.dart`: Screen for registering a new store and generating a license.
        *   `register_admin_screen.dart`: Screen for creating the initial admin user for a store.
        *   `register_admin_add_screen.dart`: Screen to input the new admin's details.
        *   `inventory_page.dart`: The inventory view within the main dashboard.
        *   `dashboard_screen.dart`: The main screen after a user logs in.
    *   `services/`: Contains application-wide services, such as database management.
        *   `hive_service.dart`: Service for initializing and managing the Hive database.
        *   `email_service.dart`: Service for handling email notifications (currently simulated).
    *   `main.dart`: The main entry point of the application.

## Features Implemented

*   **User Authentication & Registration Flow:**
    *   A polished and modern login screen (`login_screen.dart`) serves as the app's entry point.
    *   **Superuser Login:** Implemented logic for a special credential (`superusu` / `Id14304++`) that navigates to the store registration screen.
    *   **Admin Login:** Implemented login logic for registered admin users. A successful login navigates to the `DashboardScreen`, while a failed attempt shows an error message.
*   **Main Dashboard:**
    *   A stateful `DashboardScreen` serves as the main application hub.
    *   Features a `BottomNavigationBar` for mobile with three sections: "Inventario", "Facturación", and "Reportes".
    *   On web/desktop, navigation icons have a "lift" hover effect for better user feedback.
    *   Includes a "Logout" button in the `AppBar`.
    *   **Store Registration:** A dedicated screen (`register_store_screen.dart`) to input store details, select a license plan, and generate a license key.
    *   **Admin Registration Flow:**
        *   After store registration, the user is navigated to `register_admin_screen.dart`.
        *   This screen requires the user to verify the store's name and email.
        *   Upon successful verification against the Hive database, the user is navigated to `register_admin_add_screen.dart`, passing the verified store's data.
        *   The final registration screen allows for the creation of an admin user, linking them to the store via the store's license key.
    *   **Data Persistence:** On the store registration screen, all store details are saved to the local Hive database when the "Register Store & Create Admin" button is pressed.
    *   **Email Notification (Simulated):** After a successful store registration, the application simulates sending an email with the store's details to a predefined company address. This is implemented with a placeholder service to avoid insecurely embedding credentials in the client app.
    *   **Form Validation:** The store registration form now includes validation to ensure all fields are filled out correctly before submission.

*   **Hardware Integration (Zebra TC21):**
    *   Added `flutter_datawedge` dependency for scanner integration.
    *   Created a `ScannerService` to abstract DataWedge communication.
    *   The "Inventario" tab on the dashboard displays the last scanned data and includes a `FloatingActionButton` to trigger the scanner.
    *   Upon a successful scan, an `AlertDialog` is displayed to the user, showing the captured data.
*   **Local Storage:**
    *   Integrated `hive` and `hive_flutter` for a fast, lightweight, and cross-platform local database solution.
    *   `HiveService` handles initialization for both mobile and web platforms.
    *   The app uses `hive_generator` and `build_runner` to create `TypeAdapter`s for custom data models (`Store`, `Admin`).
    *   The `Store` and `Admin` models are registered and their respective boxes are opened on app startup.

## Current Plan

The next step is to build out the features of the main application dashboard, such as integrating the scanner and printer functionalities.
