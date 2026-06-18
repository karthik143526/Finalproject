# Final Project - Web Application

## Overview
This is a PHP/MySQL web application intended to run on XAMPP (Apache + MySQL). It provides:
- User registration & login
- Complaint/request submission
- Admin panels for complaints and feedback
- Tracking and status updates

## Prerequisites
- XAMPP (Apache + MySQL)
- Git (for version control and pushing to GitHub)
- A web browser

## Quick setup (Local - XAMPP)
1. Start XAMPP and enable **Apache** and **MySQL**.
2. Place the project folder inside your XAMPP `htdocs` directory (example: `C:\xampp\htdocs\finalproject`).
3. Import the database:
   - Open phpMyAdmin at `http://localhost/phpmyadmin`.
   - Create a database (example name: `finalproject_db`).
   - Use the **Import** tab to import `eco2.sql` from the project root.
4. Configure database credentials in your PHP files:
   - Search files for the MySQL connection (common files: `register.php`, `login.php`, `request.php`, `admin.php`, `delete.php`).
   - Update host, username, password, database to match your environment. Typical local defaults in XAMPP:
     - host: `localhost`
     - username: `root`
     - password: (empty string)
     - database: `finalproject_db`
5. Open the app in your browser: `http://localhost/finalproject/index.html` or `http://localhost/finalproject/login.html`.

## Detailed step-by-step process (what happens when you use the app)
1. Registration (`register.php` / `register.html`)
   - User fills the registration form.
   - Form posts to `register.php`, which validates input, hashes passwords, and inserts a new user row into the `users` table.
2. Login (`login.php` / `login.html`)
   - User submits credentials.
   - `login.php` checks the email/username and verifies the hashed password, then starts a session and redirects to `dashboard.html` or `dashboard.php`.
3. Submit complaint/request (`request.php` / `complaint.php`)
   - Authenticated users fill the complaint/request form.
   - Server stores the record in the `complaints` (or similarly named) table with status and timestamps.
   - Admin views new submissions in `admin_complaint.php` or `admin_dashboard.php` and can update status (`complete.php`).
4. Feedback (`feedback.php` / `feedback.html`)
   - Users submit feedback; server stores it in a `feedback` table.
5. Admin actions
   - Admin pages (files prefixed with `admin_`) allow viewing, updating, and deleting complaints/feedback.
   - Delete actions call `delete.php`, `delete_complaint.php`, or `delete_feedback.php` as appropriate.

## Run and manual test checklist
- Register a user and confirm record in `users` table.
- Log in and verify session-based pages load.
- Submit a complaint and confirm row in `complaints` table; verify admin can view and update it.
- Submit feedback and confirm it appears in admin feedback.
- Inspect `sms_log.txt` if the app logs SMS messages.

## GitHub: push existing project (commands)
1. Create a GitHub repository (do not initialize with README if pushing existing code).
2. In your project folder (`C:\xampp\htdocs\finalproject`) run:

```bash
git init
git add .
git commit -m "Initial commit - finalproject web app"
git branch -M main
git remote add origin https://github.com/USERNAME/REPO_NAME.git
git push -u origin main
```

3. Recommended `.gitignore` (create a file named `.gitignore` in the project root):

```
# OS
Thumbs.db
.DS_Store

# PHPStorm / VSCode
.idea/
.vscode/

# Node / vendor
/node_modules/
/vendor/

# Environment / secrets
.env
*.log
sms_log.txt

# Database dumps with secrets - use only safe/exported schema without passwords
*.sql

```

Note: If you want to keep `eco2.sql` in the repo for schema/sample-data, make sure it does not contain sensitive credentials.

## Optional: Recommended small improvements
- Move DB connection code to a single `config.php` and include it where needed.
- Store credentials in an `.env` file (and do not commit it).
- Add basic input sanitization and prepared statements to prevent SQL injection.

## Troubleshooting
- "Cannot connect to MySQL": Ensure MySQL is running and credentials are correct.
- Blank pages or errors: enable `display_errors` in `php.ini` for local debugging, or check Apache/PHP error log.
- Session issues: verify `session_start()` is called before output and PHP session path is writable.

## Contributing
- Fork the repo, create a feature branch, submit a pull request.

## License
- Add a `LICENSE` file to declare project license (MIT, Apache-2.0, etc.).

---
Updated: consolidated setup, workflow, and GitHub publish steps. If you want, I can also create a `.gitignore` and commit these changes for you.