# BloodConnect - Blood Donation Web Application

BloodConnect is a full-stack Web Application built using **Java Servlets, JSP, JDBC, MySQL, Bootstrap 5, and MVC Architecture**. The platform connects blood donors with recipients and hospitals, allows users to search donors by blood group and location, manages emergency donation requests, and provides administrators with real-time analytics.

---

## 🚀 Tech Stack

- **Backend**: Java EE 8 / Java 11 (Servlets, JDBC)
- **Frontend**: JSP, JSTL (no scriptlets), HTML5, CSS3 (Glassmorphism design), JavaScript, Bootstrap 5
- **Database**: MySQL 8.0+
- **Connection Pool**: HikariCP JDBC connection pooling
- **Security**: BCrypt password hashing (`jbcrypt`)
- **Analytics**: Chart.js
- **Architecture**: MVC (Model-View-Controller)
- **Server**: Apache Tomcat 9.x / 10.x (with javax namespace)

---

## 📁 Project Structure

```
BloodConnect/
├── pom.xml                                   # Maven build configuration
├── database/
│   └── schema.sql                            # MySQL tables & sample seed data
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── bloodconnect/
│       │           ├── config/
│       │           │   └── DBConnection.java  # HikariCP connection pool
│       │           ├── model/                # Domain POJO classes
│       │           │   ├── User.java
│       │           │   ├── Donor.java
│       │           │   ├── Recipient.java
│       │           │   ├── BloodRequest.java
│       │           │   └── RequestResponse.java
│       │           ├── dao/                  # Data Access Layer (JDBC PreparedStatements)
│       │           │   ├── UserDAO.java
│       │           │   ├── DonorDAO.java
│       │           │   └── RequestDAO.java
│       │           ├── filter/               # Security & Authentication
│       │           │   └── AuthFilter.java
│       │           └── controller/           # Controller Servlets
│       │               ├── AuthServlet.java
│       │               ├── DonorServlet.java
│       │               ├── RequestServlet.java
│       │               ├── SearchServlet.java
│       │               └── AdminServlet.java
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml                   # Deployment descriptor & custom error pages
│           │   └── views/                    # JSTL views
│           │       ├── common/               # Header, Navbar, Footer fragments
│           │       ├── auth/                 # Login & Register views
│           │       ├── donor/                # Donor dashboard
│           │       ├── recipient/            # Recipient dashboard
│           │       ├── search/               # Search results
│           │       ├── request/              # Request forms & lists
│           │       ├── admin/                # Admin analytics dashboard
│           │       └── error/                # 404 & 500 error pages
│           ├── static/                       # Assets
│           │   ├── css/style.css
│           │   └── js/
│           │       ├── main.js
│           │       └── admin-charts.js
│           └── index.jsp                     # Landing page
└── README.md
```

---

## 🛠️ Database Setup (MySQL)

1. Start your local MySQL server.
2. Run the SQL initialization script:
   ```bash
   mysql -u root -p < database/schema.sql
   ```
3. The database `bloodconnect_db` will be created with sample seed data.

### Sample Login Credentials (All passwords are `password123`):
- **Admin**: `admin@bloodconnect.com`
- **Donor**: `john.donor@gmail.com`
- **Recipient**: `robert.recipient@gmail.com`

---

## ⚙️ DB Connection Configuration

You can override default database parameters using Environment Variables if needed:
- `DB_URL`: `jdbc:mysql://localhost:3306/bloodconnect_db`
- `DB_USER`: `root`
- `DB_PASSWORD`: `root`

---

## 📦 Build & Tomcat Deployment

1. **Build WAR file using Maven**:
   ```bash
   mvn clean package
   ```
2. The generated WAR file will be located at `target/BloodConnect.war`.
3. Copy `BloodConnect.war` into your Tomcat `webapps/` folder.
4. Start Apache Tomcat:
   ```bash
   ./bin/startup.sh   # Linux / macOS
   bin\startup.bat    # Windows
   ```
5. Open your browser and navigate to:
   `http://localhost:8080/BloodConnect/`

---

## 🔐 Key Non-Functional Features

- **SQL Injection Prevention**: PreparedStatements used in all DAO query executions.
- **BCrypt Password Hashing**: Passwords stored as salted BCrypt hashes.
- **Session Protection**: `AuthFilter` protects `/admin/*`, `/donor/*`, and `/recipient/*` routes with role checks.
- **Dynamic Charts**: Chart.js graphs for donor blood group distribution and request status metrics.
