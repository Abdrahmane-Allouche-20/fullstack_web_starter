#!/usr/bin/env bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' 

# Check Node.js
check_nodejs() {
    if ! command -v node > /dev/null; then
        echo -e "${RED}✗ Error: Node.js not found. Install it from https://nodejs.org/${NC}" >&2
        exit 1
    fi
    echo -e "${GREEN}✓ Node.js is installed${NC}"
}

# Check npm
check_npm() {
    if ! command -v npm > /dev/null; then
        echo -e "${RED}✗ Error: npm not found. Please install it ${NC}" >&2
        exit 1
    fi
    echo -e "${GREEN}✓ npm is installed${NC}"
}

# Create app.js
create_appjs() {
    cat > app.js <<'EOF'
require('dotenv').config();
const express = require('express');
const app = express();
const cors = require('cors');
const your_route = require('./routes/route');
const connectDB = require('./database/connect');
const errorHandler = require('./middlewares/errorHandler');

// Middleware
app.use(cors());
app.use(express.json());

// API Routes
app.use('/api', your_route);

// Health check
app.get('/', (req, res) => res.send('API is running'));

// Error handling
app.use(errorHandler);

// Server
const PORT = process.env.PORT || 4000;

const Start = async () => {
  try {
    await connectDB(process.env.MONGO_URI)
    app.listen(PORT, () => { console.log(`server listening on ${PORT}`) })
  } catch (error) {
    console.log(error.message)
  }
}

Start()
EOF
    echo -e "${GREEN}✓ app.js created in root folder${NC}"
}

# Create .env
create_dotenv() {
    cat > .env <<'EOF'
# App Configuration
PORT=4000

# Database
MONGO_URI=your_mongodb_connection_string_here

# Authentication
JWT_SECRET=your_jwt_secret_here
JWT_EXPIRES_IN=30d
EOF
    echo -e "${GREEN}✓ .env file created${NC}"
}

# Create database connection
create_database_connect() {
    mkdir -p database
    cat > database/connect.js <<'EOF'
const mongoose = require('mongoose')

const connectDB = (URI) => {
    return mongoose.connect(URI)
        .then(() => { console.log("connected to database") })
        .catch((error) => {
            console.log('connection failed')
            console.log(error.message)
        })
}

module.exports = connectDB;
EOF
    echo -e "${GREEN}✓ Database connection file created${NC}"
}

# Create routes
create_routes() {
    mkdir -p routes
    cat > routes/route.js <<'EOF'
const express = require('express');
const router = express.Router();

// Example route
// router.route("/sample").get(require('../controllers/sampleController').getSampleData);

module.exports = router;
EOF
    echo -e "${GREEN}✓ Routes created${NC}"
}

# Create controllers
create_controllers() {
    mkdir -p controllers
    cat > controllers/sampleController.js <<'EOF'
exports.getSampleData = async (req, res) => {
    res.status(200).send("simple controller");
};
EOF
    echo -e "${GREEN}✓ Controllers created${NC}"
}

# Create middlewares
create_middlewares() {
    mkdir -p middlewares
    cat > middlewares/auth.js <<'EOF'
const jwt = require('jsonwebtoken')
const { StatusCodes } = require('http-status-codes')
const auth = async (req, res, next) => {
    if (!process.env.JWT_SECRET) {
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error: 'JWT_SECRET is not defined' });
    }
    const authHeader = req.headers.authorization;
    if (!authHeader) {
        return res.status(StatusCodes.UNAUTHORIZED).json({ error: "INVALID AUTHORISATION" })
    }
    const token = authHeader.split(' ')[1].trim()

    try {
        const payload = jwt.verify(token, process.env.JWT_SECRET)
        next()
    } catch (error) {
        return res.status(StatusCodes.UNAUTHORIZED).json({ error: error })
    }
}
module.exports = auth
EOF

    cat > middlewares/errorHandler.js <<'EOF'
const { StatusCodes } = require('http-status-codes');

const errorHandler = (err, req, res, next) => {
    const statusCode = err.statusCode || StatusCodes.INTERNAL_SERVER_ERROR;
    const message = err.message || 'Internal Server Error';
    res.status(statusCode).json({ error: message });
};

module.exports = errorHandler;
EOF
    echo -e "${GREEN}✓ Middlewares created${NC}"
}

# Create models
create_models() {
    mkdir -p models
    cat > models/Sample.js <<'EOF'
const mongoose = require('mongoose');

const SampleSchema = new mongoose.Schema({ 
    // Define your schema here
});

module.exports = mongoose.model('Sample', SampleSchema);
EOF
    echo -e "${GREEN}✓ Models created${NC}"
}

# Create utils directory
create_utils() {
    mkdir -p utils
    echo -e "${GREEN}✓ Utils directory created${NC}"
}

# Create .gitignore
create_gitignore() {
    cat > .gitignore <<'EOF'
.env
node_modules/
EOF
    echo -e "${GREEN}✓ .gitignore file created${NC}"
}

# Install additional dependencies
install_additional_deps() {
    echo -e "${BLUE}📦 Installing additional dependencies...${NC}"
    npm install http-status-codes --save
    npm install nodemon --save-dev 
    echo -e "${GREEN}✓ Additional dependencies installed${NC}"
}

# Create proper package.json
create_package_json() {
    cat > package.json << EOF
{
  "name": "express-app",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "dev": "nodemon app.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
EOF
    echo -e "${GREEN}✓ package.json created with proper formatting${NC}"
}

# Main function
create_backend_app() {
    echo -e "\n${YELLOW}🚀 Express.js Backend App Creator${NC}"
    echo -e "${YELLOW}=================================${NC}"

    check_nodejs
    check_npm

    while true; do
        read -p "Enter project folder name: " folderName
        if [ -z "$folderName" ]; then
            echo -e "${RED}✗ Name cannot be empty.${NC}" >&2
        elif [ -d "$folderName" ]; then
            echo -e "${RED}✗ Directory '$folderName' already exists.${NC}" >&2
        else
            break
        fi
    done

    echo -e "\n${BLUE}📂 Creating project directory...${NC}"
    mkdir "$folderName" && cd "$folderName" || {
        echo -e "${RED}✗ Failed to create or enter directory${NC}" >&2
        exit 1
    }
    echo -e "${GREEN}✓ Project directory created${NC}"

    echo -e "\n${BLUE}⚙️ Creating package.json...${NC}"
    create_package_json

    echo -e "\n${BLUE}📦 Installing core dependencies...${NC}"
    npm install express mongoose dotenv cors jsonwebtoken bcryptjs || {
        echo -e "${RED}✗ Failed to install core dependencies${NC}" >&2
        exit 1
    }

    echo -e "\n${BLUE}📦 Installing development dependencies...${NC}"
    install_additional_deps

    echo -e "\n${BLUE}📄 Creating application files...${NC}"
    create_appjs
    create_dotenv
    create_database_connect
    create_routes
    create_controllers
    create_middlewares
    create_models
    create_utils
    create_gitignore

    echo -e "\n${GREEN}🎉 Express backend app created successfully in ./${folderName}${NC}"
    echo -e "\n${YELLOW}👉 Next Steps:${NC}"
    echo -e "1. ${BLUE}cd ${folderName}${NC}"
    echo -e "2. Edit the ${BLUE}.env${NC} file with your configuration"
    echo -e "3. Run ${GREEN}npm run dev${NC} to start the development server"
    echo -e "\n${YELLOW}📁 Project Structure:${NC}"
    if command -v tree > /dev/null; then
        tree -L 2
    else
        echo -e "${BLUE}"
        echo "."
        echo "├── app.js"
        echo "├── .env"
        echo "├── package.json"
        echo "├── controllers/"
        echo "├── database/"
        echo "├── middlewares/"
        echo "├── models/"
        echo "├── routes/"
        echo "└── utils/"
        echo -e "${NC}"
    fi
    echo -e "\n${GREEN}to start the server type \"npm run dev\" in the terminal ${NC}"
    echo -e "\n${BLUE}----------------${NC}"
    echo -e "\n${GREEN}#### Happy coding! ##### ${NC}"
    
}

# Run the script
create_backend_app