# === Stage 1: Build and install dependencies ===
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
COPY src ./src

# Preload dependencies and compile tests
RUN mvn clean install -DskipTests

# === Stage 2: Run tests ===
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Install useful CLI tools (optional)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app /app

# Run tests
CMD ["mvn", "test"]
