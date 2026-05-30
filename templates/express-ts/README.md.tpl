# __PROJECT_TITLE__

Express TypeScript API project.

## Requirements
- Node.js 22+ (or Bun)
- Docker (optional)

## Setup

1. Copy `.env.development.local` to `.env` if not already loaded automatically.
   ```bash
   cp .env.development.local .env
   ```

2. Install dependencies:
   ```bash
   __PACKAGE_MANAGER__ install
   ```

3. Run the development server:
   ```bash
   __RUN_CMD__ dev
   ```

4. Build for production:
   ```bash
   __RUN_CMD__ build
   ```

## Folder Structure
- `src/api`: Route controllers and handlers
- `src/config`: Application configuration and environment variables
- `src/database`: Database connection and setup (e.g. Prisma)
- `src/errors`: Custom error types and handler definitions
- `src/lib`: External library wrappers
- `src/middleware`: Express middlewares
- `src/queues`: Background jobs and workers
- `src/types`: TypeScript typings
- `src/utils`: Reusable helper functions
