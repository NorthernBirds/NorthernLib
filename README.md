NorthernLib
Copyright © 2026 Yusuf Enes Kuş

A backend-oriented system for academic library management, focusing on modularity, secure data flow, and centralized control.

System Architecture

The project is structured into functional layers:

1. Components
   
modules/: Core business logic. Each module handles specific operational processes, including book tracking, member management, and categorization.

utils/: Utility functions for system-wide requirements, such as logging and setup for new users.

db/: Data access layer. Encapsulates SQL operations and manages database connections, abstracting interaction from the business logic.

<<<<<<< HEAD
Core Engine (backend.py)
=======
2. Core Engine (backend.py)
   
The system employs a Single Entry Point design, functioning as the centralized gateway for all operations.

Request Routing: Primary interface for the frontend; all incoming requests are mediated here.

Authentication & Authorization: All requests are validated via the verifyToken functions in auth.py.

Access Control: User roles and permissions are evaluated before request routing.

Security: Direct interaction between the frontend and the database layer is restricted to mitigate security risks.

Configuration & Deployment

To ensure system stability, ensure the following requirements are met:

License Compliance: Usage must strictly adhere to the defined license terms.

Environment Configuration: Modify the following files according to your infrastructure requirements:

(Rename) configExample.dart -> config.dart (Line 5)

(Rename) .env.example -> .env (Line 1,2,3,4,5)

Directory Structure: Ensure all directories excluded by .gitignore (e.g., logs/) are manually created in your local environment.

You can download the app from Microsoft Store.

Developer: Yusuf Enes Kuş