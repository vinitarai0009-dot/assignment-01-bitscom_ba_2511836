## Database Recommendation

**Word Count: 287**

### Patient Management System

For a healthcare patient management system, I would recommend **MySQL (RDBMS)** for the core system. Here's why:

**ACID Compliance**: Patient records require strict ACID properties. Medical data cannot tolerate inconsistencies—if a patient's prescription is updated during a doctor's visit while a billing system reads it, we need strong consistency. MySQL's ACID guarantees ensure data integrity across related tables (patients, appointments, prescriptions, billing).

**Complex Relationships**: Healthcare data has complex relationships—patients have multiple appointments, doctors, prescriptions, and insurance claims. MySQL's relational model with foreign keys ensures referential integrity that MongoDB's document model would require application-level enforcement.

**CAP Theorem Consideration**: Patient management prioritizes **Consistency** over Availability. If a network partition occurs, it's better to temporarily block writes than risk inconsistent medical records. MySQL's CP (Consistency + Partition tolerance) design aligns with healthcare requirements where accuracy is critical.

### Adding Fraud Detection Module

**My answer would change** with fraud detection. I'd recommend a **hybrid approach**:

- **Keep MySQL** for the core patient management system (ACID requirements remain)
- **Add MongoDB** for fraud detection for these reasons:

1. **Write-Heavy Workload**: Fraud detection generates massive amounts of audit logs, transaction metadata, and behavioral patterns. MongoDB's high write throughput and sharding capabilities handle this scale better.

2. **Schema Flexibility**: Fraud patterns evolve constantly. MongoDB's flexible schema allows adding new anomaly detection attributes (device fingerprints, geolocation patterns, behavioral scores) without schema migrations.

3. **Eventual Consistency (BASE)**: Fraud detection can tolerate eventual consistency. It's acceptable if a fraud alert is delayed by seconds, but losing transactions due to strict ACID constraints isn't acceptable for performance.

4. **CAP Trade-off**: Fraud detection benefits from **Availability**—we want to capture all transaction data even during network partitions. MongoDB's AP (Availability + Partition tolerance) focus suits this use case.

The hybrid approach—MySQL for transactional patient data, MongoDB for fraud detection analytics—gives the best of both worlds: strong consistency for critical records and high scalability for analytical workloads.