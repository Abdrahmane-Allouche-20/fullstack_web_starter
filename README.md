# JS Fullstack Starter

A Bash-powered scaffolding tool for quickly creating a modern full-stack JavaScript project with a **React (Vite) frontend** and a **modular Express.js backend**.

---

## Features

### Frontend (`frontend.sh`)
- Creates a new React app using Vite (JavaScript).
- Installs all dependencies and optionally: React Router, Axios, Redux Toolkit, React Icons.
- Checks for Node.js and npm before starting.
- Easy prompts and clear instructions.

### Backend (`backend.sh`)
- Sets up an Express.js backend with a clean structure:
  - All source code is organized under folders: `controllers/`, `database/`, `middlewares/`, `models/`, `routes/`, `utils/`
  - Generates a ready-to-run `app.js` entry point.
  - Includes a sample controller, error handler, and database connection.
  - Creates a `.env` file for configuration.
  - Installs all core and dev dependencies (Express, Mongoose, JWT, bcrypt, nodemon, etc.).
  - Adds a `.gitignore` file.

---

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v16+ recommended)
- [npm](https://www.npmjs.com/)
- Bash shell (Linux, macOS, or Git Bash on Windows)

---

### 1. Clone or Download This Repo

```bash
git clone https://github.com/your-username/js-fullstack-starter.git
cd js-fullstack-starter
```

---

### 2. Create the Frontend

```bash
bash frontend.sh
```
- Follow the prompts to name your React app and (optionally) install extra packages.

---

### 3. Create the Backend

```bash
bash backend.sh
```
- Follow the prompts to name your backend folder.
- Edit the generated `.env` file with your MongoDB URI and secrets.

---

### 4. Run Your Apps

**Frontend:**
```bash
cd your-frontend-folder
npm run dev
```

**Backend:**
```bash
cd your-backend-folder
npm run dev
```

---

## Project Structure

```
your-backend-folder/
├── app.js
├── .env
├── package.json
├── .gitignore
├── controllers/
├── database/
├── middlewares/
├── models/
├── routes/
└── utils/
```

---

## Customization

- Add your own routes, controllers, models, and utilities inside the respective folders.
- Update `.env` with your configuration.
- Extend the frontend as needed.

---

## License

MIT

---

**Happy Coding! 🚀**
