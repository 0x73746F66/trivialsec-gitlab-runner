USE trivialsec;

ALTER TABLE accounts ADD COLUMN `billing_email` VARCHAR(255) NOT NULL AFTER `plan_id`;
