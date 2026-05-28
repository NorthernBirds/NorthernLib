Library Management System Copyright (c) 2026 Yusuf Enes Corp. All rights reserved.

A backend-oriented system for academic library management, focusing on modularity, secure data flow, and centralized control.

System Architecture

The project is structured into functional layers:

Components
modules/: Core business logic. Each module handles specific operational processes, including book tracking, member management, and categorization.

utils/: Utility functions for system-wide requirements, such as logging and email communication.

db/: Data access layer. Encapsulates SQL operations and manages database connections, abstracting interaction from the business logic.

Core Engine (backend.py)
The system employs a Single Entry Point design, functioning as the centralized gateway for all operations.

Request Routing: Primary interface for the frontend; all incoming requests are mediated here.

Authentication & Authorization: All requests are validated via the verifyToken function in auth.py.

Access Control: User roles and permissions are evaluated before request routing.

Security: Direct interaction between the frontend and the database layer is restricted to mitigate security risks.

Configuration & Deployment

To ensure system stability, ensure the following requirements are met:

License Compliance: Usage must strictly adhere to the defined license terms.

Environment Configuration: Modify the following files according to your infrastructure requirements:

backend.py (Line 16)

config.py (Line 16)

setupSQL.sql (Lines 4, 5, 41)

sendEMail.py (Line 23)

Directory Structure: Ensure all directories excluded by .gitignore (e.g., logs/) are manually created in your local environment.

Developer: Yusuf Enes Kuş