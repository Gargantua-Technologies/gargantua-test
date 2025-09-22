
DROP TABLE IF EXISTS paid_procedures;
DROP TABLE IF EXISTS payout_rules;
DROP TABLE IF EXISTS doctors;

-- =================================================================
--  1. Tables
-- =================================================================

-- Doctors Table
CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Payout Rules Table
-- Each doctor can have one rule. Using UNIQUE on doctor_id enforces this.
CREATE TABLE payout_rules (
    id SERIAL PRIMARY KEY,
    doctor_id INT UNIQUE NOT NULL,
    rule_type VARCHAR(50) NOT NULL CHECK (rule_type IN ('percentage', 'fixed')),
    value DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- Paid Procedures Table
-- Represents procedures that have been paid by patients/insurance and are ready for payout calculation.
CREATE TABLE paid_procedures (
    id SERIAL PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    doctor_id INT NOT NULL,
    total_value DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Add indexes for performance, as queries will frequently filter by doctor_id and payment_date
CREATE INDEX idx_procedures_doctor_id ON paid_procedures(doctor_id);
CREATE INDEX idx_procedures_payment_date ON paid_procedures(payment_date);

-- =================================================================
--  2. Data Seeding
-- =================================================================

-- Insert Doctors
INSERT INTO doctors (id, name) VALUES
(1, 'Dr. Eleanor Vance'),
(2, 'Dr. Benedict Carter'),
(3, 'Dr. Olivia Reed'),
(4, 'Dr. Samuel Quinn'),
(5, 'Dr. Clara Knight'),
(6, 'Dr. Julian Hayes'),
(7, 'Dr. Amelia Stone'),
(8, 'Dr. Leo Maxwell'),
(9, 'Dr. Sophia Chen'),
(10, 'Dr. Mason Brooks'),
(11, 'Dr. Isabella Rossi'),
(12, 'Dr. William Foster'),
(13, 'Dr. Harper Wright'),
(14, 'Dr. Ethan Grant'),
(15, 'Dr. Ava Mitchell'),
(16, 'Dr. Noah Coleman'),
(17, 'Dr. Mia Peterson'),
(18, 'Dr. Lucas Bell'),
(19, 'Dr. Chloe Davis'),
(20, 'Dr. Jacob Rodriguez');

-- Insert Payout Rules
INSERT INTO payout_rules (doctor_id, rule_type, value) VALUES
(1, 'percentage', 30.00), -- 30%
(2, 'fixed', 150.00),     -- $150 fixed per procedure
(3, 'percentage', 25.00),
(4, 'percentage', 40.00),
(5, 'fixed', 100.00),
(6, 'percentage', 35.00),
(7, 'percentage', 28.50),
(8, 'fixed', 120.00),
(9, 'percentage', 50.00), -- High percentage
(10, 'percentage', 22.00),
(11, 'fixed', 200.00),    -- High fixed value
(12, 'percentage', 33.33),
(13, 'percentage', 27.00),
(14, 'fixed', 80.00),
(15, 'percentage', 38.00),
(16, 'percentage', 31.00),
(17, 'fixed', 95.00),
(18, 'percentage', 45.00);

-- Insert Paid Procedures
-- The target month for the test is SEPTEMBER 2025.

-- Procedures for SEPTEMBER 2025 (TARGET DATA)
INSERT INTO paid_procedures (description, doctor_id, total_value, payment_date) VALUES
-- Batch 1
('Initial Consultation', 1, 350.00, '2025-09-02'),
('X-Ray Analysis', 2, 280.00, '2025-09-02'),
('Minor Surgery', 3, 1500.00, '2025-09-03'),
('Follow-up Visit', 4, 200.00, '2025-09-03'),
('Blood Test Panel', 5, 450.00, '2025-09-04'),
('Physical Therapy Session', 6, 300.00, '2025-09-04'),
('Dermatology Check-up', 7, 250.00, '2025-09-05'),
('Ultrasound', 8, 550.00, '2025-09-05'),
('Cardiology Consultation', 9, 600.00, '2025-09-06'),
('Vaccination', 10, 150.00, '2025-09-06'),
('Specialist Consultation', 11, 750.00, '2025-09-07'),
('Nutritional Advise', 12, 180.00, '2025-09-07'),
('MRI Scan', 13, 2200.00, '2025-09-08'),
('Allergy Test', 14, 320.00, '2025-09-08'),
('Routine Check-up', 15, 190.00, '2025-09-09'),
('Dental Cleaning', 16, 210.00, '2025-09-09'),
('Eye Exam', 17, 230.00, '2025-09-10'),
('Psychological Evaluation', 18, 480.00, '2025-09-10'),
-- Batch 2
('Follow-up Visit', 1, 200.00, '2025-09-11'),
('X-Ray Analysis', 2, 280.00, '2025-09-11'),
('Initial Consultation', 3, 350.00, '2025-09-12'),
('Minor Surgery', 4, 1500.00, '2025-09-12'),
('Blood Test Panel', 5, 450.00, '2025-09-13'),
('Physical Therapy Session', 6, 300.00, '2025-09-13'),
('Dermatology Check-up', 7, 250.00, '2025-09-14'),
('Ultrasound', 8, 550.00, '2025-09-14'),
('Cardiology Consultation', 9, 600.00, '2025-09-15'),
('Vaccination', 10, 150.00, '2025-09-15'),
('Specialist Consultation', 11, 750.00, '2025-09-16'),
('Nutritional Advise', 12, 180.00, '2025-09-16'),
('MRI Scan', 13, 2200.00, '2025-09-17'),
('Allergy Test', 14, 320.00, '2025-09-17'),
('Routine Check-up', 15, 190.00, '2025-09-18'),
('Dental Cleaning', 16, 210.00, '2025-09-18'),
('Eye Exam', 17, 230.00, '2025-09-19'),
('Psychological Evaluation', 18, 480.00, '2025-09-19'),
-- Batch 3 with more variety and repeats
('Initial Consultation', 1, 350.00, '2025-09-20'),
('Follow-up Visit', 1, 200.00, '2025-09-21'),
('Minor Surgery', 3, 1650.00, '2025-09-22'),
('Cardiology Consultation', 9, 620.00, '2025-09-22'),
('Cardiology Consultation', 9, 620.00, '2025-09-23'),
('MRI Scan', 13, 2300.00, '2025-09-24'),
('Specialist Consultation', 11, 800.00, '2025-09-25'),
('Specialist Consultation', 11, 800.00, '2025-09-26'),
('Specialist Consultation', 11, 800.00, '2025-09-27'),
('Physical Therapy Session', 6, 310.00, '2025-09-28'),
('X-Ray Analysis', 2, 290.00, '2025-09-29'),
('Routine Check-up', 15, 195.00, '2025-09-30');

INSERT INTO paid_procedures (description, doctor_id, total_value, payment_date)
SELECT
    'Routine Procedure',
    floor(random() * 18 + 1)::int,
    (random() * 500 + 100)::numeric(10,2),
    '2025-09-01'::date + floor(random() * 30)::int
FROM generate_series(1, 280);


INSERT INTO paid_procedures (description, doctor_id, total_value, payment_date) VALUES
('Emergency Consultation', 19, 500.00, '2025-09-10'),
('Lab Work Review', 19, 150.00, '2025-09-20'),
('Standard Consultation', 20, 300.00, '2025-09-15');



INSERT INTO paid_procedures (description, doctor_id, total_value, payment_date) VALUES
-- August 2025
('Annual Check-up', 1, 400.00, '2025-08-15'),
('Dental X-Ray', 16, 180.00, '2025-08-22'),
('Follow-up Visit', 3, 200.00, '2025-08-30'),
-- October 2025
('Flu Shot', 5, 80.00, '2025-10-01'),
('Initial Consultation', 7, 250.00, '2025-10-02');

SELECT 'Seed script executed successfully!' AS status;
