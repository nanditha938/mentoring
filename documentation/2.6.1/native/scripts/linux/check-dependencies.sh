#!/bin/bash

# Define ANSI color codes for output formatting
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check Node.js installation
check_nodejs() {
    if command -v node > /dev/null 2>&1; then
        echo -e "${GREEN}Node.js is installed. Version: $(node --version)${NC}"
    else
        echo -e "${RED}Node.js is not installed.${NC}"
    fi
}

# Function to check Apache Kafka and Zookeeper installation
check_kafka() {
    if [ -d "/opt/kafka" ]; then
        echo -e "${GREEN}Kafka directory exists.${NC}"
    else
        echo -e "${RED}Kafka directory does not exist.${NC}"
    fi

    if systemctl is-active --quiet zookeeper; then
        echo -e "${GREEN}Zookeeper service is running.${NC}"
    else
        echo -e "${RED}Zookeeper service is not running.${NC}"
    fi

    if systemctl is-active --quiet kafka; then
        echo -e "${GREEN}Kafka service is running.${NC}"
    else
        echo -e "${RED}Kafka service is not running.${NC}"
    fi
}

check_redis() {
    if command -v redis-server > /dev/null 2>&1; then
        echo -e "${GREEN}Redis server is installed. Version: $(redis-server --version)${NC}"
    else
        echo -e "${RED}Redis server is not installed.${NC}"
        return
    fi

    if systemctl status redis-server.service &> /dev/null; then
        echo -e "${GREEN}Redis service is running.${NC}"
    else
        echo -e "${RED}Redis service is not running or inactive.${NC}"
    fi
}

# Function to check Citus installation
check_citus() {
    if sudo su - postgres -c "psql -p 9700 -c 'SELECT citus_version();'" &> /dev/null; then
        echo -e "${GREEN}Citus is running on port 9700.${NC}"
    else
        echo -e "${RED}Citus is not running or not installed.${NC}"
    fi
}

# Function to check PM2 installation
check_pm2() {
    if command -v pm2 > /dev/null 2>&1; then
        echo -e "${GREEN}PM2 is installed. Version: $(pm2 -v)${NC}"
    else
        echo -e "${RED}PM2 is not installed.${NC}"
    fi
}

# Function to check PostgreSQL installation and service
check_postgres() {
    if command -v psql > /dev/null 2>&1; then
        echo -e "${GREEN}PostgreSQL is installed. Version: $(psql --version)${NC}"
    else
        echo -e "${RED}PostgreSQL is not installed.${NC}"
    fi

    if systemctl is-active --quiet postgresql; then
        echo -e "${GREEN}PostgreSQL service is running.${NC}"
    else
        echo -e "${RED}PostgreSQL service is not running.${NC}"
    fi
}

# Main execution flow of the script
echo "MentorEd Dependencies Status"

check_nodejs
check_kafka
check_redis
check_pm2
check_postgres
check_citus
