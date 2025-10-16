Overview

This project demonstrates API test automation using the Robot Framework, with detailed reporting via Allure Reports.
It includes:

API test suites for REST and GraphQL services

Mock payment simulations for different response codes (200, 503)

JWT validation with a custom Python library

Allure reporting integration for rich visual reports

🏗️ Project Structure
RobotFrameworkAPITesting/
│
├── RestAPITests/
│   ├── config/
│   │   └── testdata.robot            # API test configuration variables
│   │
│   ├── Resources/                    # Reusable keyword libraries
│   │   ├── Payment_Keywords.robot
│   │   ├── Webhook_Keywords.robot
│   │   └── Invalid_Amount.robot
│   │
│   ├── Tests/                        # Test suites
│   │   ├── countries_graphql.robot   # GraphQL country API tests
│   │   ├── jwt_poc.robot             # JWT validation tests
│   │   ├── Payment_Test.robot        # Payment order creation and validation
│   │   ├── Payment_ServerDown_Test.robot
│   │   └── Payment_InvalidAmount_Test.robot
│   │
│   ├── webhook/                      # Mock services
│   │   ├── webhook_server.py
│   │   ├── payment_stub_200.py
│   │   ├── payment_stub_503.py
│   │   └── JwtValidator.py           # Custom JWT decoder/validator
│   │
│   ├── allure-results/               # Allure test results (auto-generated)
│   ├── output.xml                    # Robot test result (auto-generated)
│   ├── log.html                      # Robot log (auto-generated)
│   └── report.html                   # Robot report (auto-generated)
│
└── README.md

⚙️ Prerequisites

Before running the tests, ensure you have the following installed:

Tool	Version	Purpose
Python	≥ 3.8	Base language
Robot Framework	≥ 7.0	Core test automation
RequestsLibrary	Latest	HTTP/REST interactions
Allure-RobotFramework	Latest	For report generation
Flask	Latest	Mock server for payment simulation
🔧 Installation

Run these commands to set up your environment:

# Create virtual environment (optional but recommended)
python -m venv .venv
.venv\Scripts\activate   # For Windows

# Install dependencies
pip install robotframework
pip install robotframework-requests
pip install allure-robotframework
pip install Flask

🚀 Running Tests
🧩 Run all test suites
robot --listener "allure_robotframework;allure_results" Tests

🧩 Run specific test file
robot --listener "allure_robotframework;allure_results" Tests/jwt_poc.robot

🧩 Run GraphQL or REST API tests
robot Tests/countries_graphql.robot
