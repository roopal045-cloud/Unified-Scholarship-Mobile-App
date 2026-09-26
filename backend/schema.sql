-- Reference schema for the Unified Scholarship App
-- (Documentation only for the hackathon build — actual data is in-memory JS.
-- Can be wired to a real Postgres DB later if time permits.)

CREATE TABLE students (
    student_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    aadhaar_ref VARCHAR(20),
    st_pvtg_status VARCHAR(20),
    state VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE scholarship_applications (
    application_id VARCHAR(30) PRIMARY KEY,
    student_id VARCHAR(20) REFERENCES students(student_id),
    scheme VARCHAR(30) NOT NULL, -- PRE_MATRIC, POST_MATRIC, TOP_CLASS, NFST, NOS
    source_system VARCHAR(10) NOT NULL, -- NSP, SFMP, NOS
    status VARCHAR(30) NOT NULL, -- under_verification, sanctioned, disbursed, action_required
    amount DECIMAL(10,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT NOW()
);

CREATE TABLE verification_status (
    id SERIAL PRIMARY KEY,
    application_id VARCHAR(30) REFERENCES scholarship_applications(application_id),
    document_type VARCHAR(50) NOT NULL, -- income_certificate, caste_certificate, etc.
    verified BOOLEAN DEFAULT FALSE,
    verification_source VARCHAR(20), -- AISHE, UDISE+, UGC-NTA, e-District
    checked_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE disbursements (
    id SERIAL PRIMARY KEY,
    application_id VARCHAR(30) REFERENCES scholarship_applications(application_id),
    amount DECIMAL(10,2) NOT NULL,
    dbt_status VARCHAR(20), -- pending, completed
    disbursed_at TIMESTAMP
);