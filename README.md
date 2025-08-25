# Public Transportation Accessibility System

A comprehensive blockchain-based system for managing public transportation accessibility services, built with Clarity smart contracts.

## Overview

This system provides a decentralized platform for coordinating accessibility services in public transportation, ensuring compliance with accessibility regulations and improving service quality for passengers with disabilities.

## Core Components

### 1. Accessibility Request Management (`accessibility-requests.clar`)
- Process and track accessibility service requests
- Coordinate between passengers and service providers
- Maintain request status and fulfillment tracking

### 2. Vehicle Modification Tracking (`vehicle-modifications.clar`)
- Track vehicle accessibility modifications and equipment
- Manage maintenance schedules and equipment status
- Ensure vehicles meet accessibility standards

### 3. Driver Training Certification (`driver-training.clar`)
- Manage driver sensitivity and accessibility training programs
- Track certification status and renewal requirements
- Maintain training records and compliance

### 4. Service Quality Monitoring (`service-monitoring.clar`)
- Monitor service quality metrics and passenger feedback
- Track performance indicators and improvement areas
- Generate quality reports and analytics

### 5. Compliance Reporting (`compliance-reporting.clar`)
- Generate regulatory compliance reports
- Track adherence to accessibility standards
- Maintain audit trails and documentation

## Key Features

- **Decentralized Coordination**: Blockchain-based coordination between all stakeholders
- **Transparency**: All accessibility services and compliance data on-chain
- **Accountability**: Immutable records of service delivery and quality
- **Efficiency**: Automated workflows for common accessibility processes
- **Compliance**: Built-in regulatory compliance tracking and reporting

## Data Types

- **Requests**: Accessibility service requests with passenger details and requirements
- **Vehicles**: Vehicle information with modification and equipment status
- **Drivers**: Driver profiles with training and certification status
- **Services**: Service delivery records with quality metrics
- **Reports**: Compliance and performance reports

## Error Codes

- `ERR-NOT-AUTHORIZED (u100)`: Unauthorized access attempt
- `ERR-NOT-FOUND (u101)`: Requested resource not found
- `ERR-INVALID-INPUT (u102)`: Invalid input parameters
- `ERR-ALREADY-EXISTS (u103)`: Resource already exists
- `ERR-INVALID-STATUS (u104)`: Invalid status transition

## Getting Started

1. Deploy the smart contracts to the Stacks blockchain
2. Initialize the system with authorized operators
3. Register vehicles and drivers in the system
4. Begin processing accessibility requests
5. Monitor service quality and generate compliance reports

## Testing

Run the test suite with:
\`\`\`bash
npm test
\`\`\`

Tests cover all contract functions and edge cases using Vitest framework.

## Compliance

This system is designed to support compliance with:
- Americans with Disabilities Act (ADA)
- Section 504 of the Rehabilitation Act
- Local accessibility regulations
- Transportation accessibility standards
