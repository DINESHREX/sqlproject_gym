create schema gym_management

use gym_management

# MEMBERS TABLE 
CREATE TABLE members(
 member_id INT PRIMARY KEY AUTO_INCREMENT,
 m_name VARCHAR(50),
 gender VARCHAR(10),
 phone VARCHAR(15) UNIQUE,
 email VARCHAR(100)UNIQUE,
 date_of_birth DATE,
 status VARCHAR(20)
)


#TRAINER TABLE

CREATE TABLE trainers(
 trainer_id INT PRIMARY KEY AUTO_INCREMENT,
 t_name VARCHAR(50),
 specialization VARCHAR(100),
 phone VARCHAR(15),
 hire_date DATE
) 

# MEMBERSHIP PLAN TABLE

CREATE TABLE membership_plan(
 plan_id INT PRIMARY KEY AUTO_INCREMENT,
 plan_name VARCHAR(100),
 d_month INT,
 price DECIMAL(10,2)
) 
RENAME TABLE membership_plan TO membership_plans;


# MEMBERS MEMBERSHIP TABLE

CREATE TABLE members_membership(
 membership_id INT PRIMARY KEY AUTO_INCREMENT,
 member_id INT,
 plan_id INT,
 start_date DATE,
 end_date DATE,
 FOREIGN KEY(member_id) REFERENCES members(member_id),
 FOREIGN KEY(plan_id) REFERENCES membership_plan(plan_id)
) 
RENAME TABLE members_membership TO member_memberships;
ALTER TABLE member_memberships
ADD COLUMN plan_price DECIMAL(10,2);


CREATE TABLE payments(
 payment_id INT PRIMARY KEY AUTO_INCREMENT,
 membership_id INT,
 amount DECIMAL(10,2),
 payment_date DATE,
 payment_method VARCHAR(20),
 FOREIGN KEY(membership_id) REFERENCES members_membership(membership_id)
)


CREATE TABLE attendance(
 attendance_id INT PRIMARY KEY AUTO_INCREMENT,
 member_id INT,
 check_in DATETIME,
 FOREIGN KEY (member_id) REFERENCES members(member_id)
)

ALTER TABLE attendance
ADD COLUMN check_out DATETIME NULL;


#ALTER MEMBERS TABLE 

ALTER TABLE members
ADD COLUMN join_date DATE,
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 
 
CREATE INDEX idx_member_id ON members_membership(member_id);
CREATE INDEX idx_plan_id ON members_membership(plan_id);
CREATE INDEX idx_membership_id ON payments(membership_id);
CREATE INDEX idx_attendance_member ON attendance(member_id);


ALTER TABLE members
MODIFY COLUMN status ENUM('active', 'inactive', 'suspended') 
NOT NULL DEFAULT 'active';



# member trainer table 

CREATE TABLE member_trainers (
    member_id INT,
    trainer_id INT,
    assigned_date DATE,
    PRIMARY KEY (member_id, trainer_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
)


# INVOICE TABLE

CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    membership_id INT,
    invoice_date DATE,
    total_amount DECIMAL(10,2),
    status ENUM('paid','unpaid','partial'),
    FOREIGN KEY (membership_id) REFERENCES member_memberships(membership_id)
)

#Refund Table
CREATE TABLE refunds (
    refund_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_id INT,
    refund_amount DECIMAL(10,2),
    refund_date DATE,
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
)

#Work Out Plan Table
CREATE TABLE workout_plans (
    workout_id INT PRIMARY KEY AUTO_INCREMENT,
    workout_name VARCHAR(100),
    difficulty_level ENUM('beginner','intermediate','advanced'),
    description TEXT
)