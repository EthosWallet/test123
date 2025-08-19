# Test Dockerfile for Dependency Confusion and Repository Jacking Detection
# This file contains intentional vulnerabilities for testing purposes

# Base image repository jacking test - potentially hijackable custom registry
FROM customregistry/nonexistent-base:latest

# Set working directory
WORKDIR /app

# Repository jacking test - clone from potentially non-existent GitHub repo
RUN git clone https://github.com/nonexistent-org/fake-dependency.git /tmp/fake-dep

# Dependency confusion tests for multiple package managers
# Python packages
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install fake-internal-package==1.0.0
RUN pip install suspicious-org-package

# Node.js packages  
COPY package.json .
RUN npm install
RUN npm install @nonexistent-org/internal-tool
RUN npm install fake-company-utils

# Ruby gems
COPY Gemfile .
RUN bundle install
RUN gem install internal-company-gem
RUN gem install fake-private-lib

# Go modules
COPY go.mod .
RUN go mod download
RUN go get github.com/fake-org/internal-module
RUN go get private-company.com/secret-package

# Java/Maven
COPY pom.xml .
RUN mvn dependency:resolve
RUN mvn install:install-file -DgroupId=com.company -DartifactId=internal-lib -Dversion=1.0 -Dpackaging=jar

# .NET/NuGet
COPY *.csproj .
RUN dotnet restore
RUN dotnet add package CompanyInternalPackage
RUN dotnet add package FakePrivateLib

# Rust/Cargo
COPY Cargo.toml .
RUN cargo build
RUN cargo install company-internal-crate
RUN cargo install fake-org-tool

# PHP/Composer
COPY composer.json .
RUN composer install
RUN composer require company/internal-package
RUN composer require fake-org/private-lib

# Environment variables that might reference internal packages
ENV INTERNAL_PACKAGE_VERSION=1.2.3
ENV COMPANY_LIB_PATH=/opt/company-lib
ENV PRIVATE_REGISTRY_URL=registry.company.internal

# Additional repository jacking through build args
ARG REPO_URL=https://github.com/potentially-fake-org/build-tools.git
RUN git clone $REPO_URL /build-tools

# Multi-stage build with potential hijackable image
FROM hijackable-org/custom-runtime:v1.0 as runtime
COPY --from=0 /app /app

# Expose port
EXPOSE 8080

# Run application
CMD ["./app"]
