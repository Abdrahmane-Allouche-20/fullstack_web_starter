#!/usr/bin/env bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

check_nodejs() {
  if ! command -v node > /dev/null; then
    echo -e "${RED}✗ Error: Node.js not found. Install from: https://nodejs.org/${NC}" >&2
    exit 1
  fi
  echo -e "${GREEN}✓ Found Node.js $(node -v)${NC}"
}

check_npm() {
  if ! command -v npm > /dev/null; then
    echo -e "${RED}✗ Error: npm not found. Reinstall Node.js.${NC}" >&2
    exit 1
  fi
  echo -e "${GREEN}✓ Found npm $(npm -v)${NC}"
}

create_react_app() {
  echo -e "\n${BLUE}React App Creator${NC}"
  echo -e "${BLUE}----------------${NC}"
  
  while true; do
    read -p "Enter app name: " appName
    if [ -z "$appName" ]; then
      echo -e "${RED}✗ App name cannot be empty.${NC}" >&2
    elif [ -d "$appName" ]; then
      echo -e "${RED}✗ Directory '$appName' already exists.${NC}" >&2
    else
      break
    fi
  done

  echo -e "\n${BLUE}⚙️ Creating React app with Vite...${NC}"
  if ! npx create-vite@latest "$appName" --template react; then
    echo -e "${RED}✗ Failed to create Vite project${NC}" >&2
    exit 1
  fi

  cd "$appName" || {
    echo -e "${RED}✗ Failed to enter project directory${NC}" >&2
    exit 1
  }

  echo -e "\n${BLUE}📦 Installing dependencies...${NC}"
  if ! npm install; then
    echo -e "${RED}✗ Dependency installation failed${NC}" >&2
    exit 1
  fi

  echo -e "\n${GREEN}✅ Success! React app '$appName' created.${NC}"
 
  echo -ne "\n${BLUE}Do you want to install additional packages? (y/n): ${NC}"
  read -r answer
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo -e "\n${BLUE}Installing additional packages...${NC}"
    npm install react-router-dom axios react-redux @reduxjs/toolkit react-icons
    echo -e "${GREEN}✓ Additional packages installed successfully${NC}"
  fi

  echo -e "\n${BLUE}Commands to remember:${NC}"
  echo -e "  cd $appName"
  echo -e "  npm run dev   # Start development server"
  echo -e "  npm run build # Create production build"
}

# Main execution
echo -e "\n${BLUE}Checking requirements...${NC}"
check_nodejs
check_npm

create_react_app