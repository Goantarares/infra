## [0.2.0] - 2026-04-26

### Added
- PostgreSQL schema with three tables: users, flights, reservations
- Custom ENUM types for user roles, reservation status, and flight classes
- Database-level constraints for data integrity
- Seed data with 10 flights across 6 European routes and 2 test users
- IO Service: full CRUD API for users, flights, and reservations
- Flight search with optional filters: origin, destination, class, date
- Automatic seat count adjustment on reservation creation and cancellation
- Auth Service: user registration and login with JWT token generation
- Password hashing with bcrypt
- Token verification endpoint for gateway integration
- Health check endpoints on both services
- Docker Compose configuration with correct service startup ordering
- Network separation between database and application layers
- Adminer integration for visual database inspection
- Input validation middleware for flights and reservations
- Database transactions for reservation operations to ensure data consistency
- Inter-service authentication via shared secret to protect IO Service
- Structured JSON logging with Winston on both services

### Fixed
- Package dependencies were swapped between services causing startup failures
- Docker build context paths were incorrect in docker-compose.yml
- YAML indentation error in docker-compose.yml

### Known Issues
- IO Service port exposed to host for development purposes, should be 
  removed in production
- Secrets managed via .env files, should use Docker secrets in production

### Contributii
- Proiectul este realizat individual