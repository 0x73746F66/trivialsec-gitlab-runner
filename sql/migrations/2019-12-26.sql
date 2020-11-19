USE trivialsec;
SET @dbname = DATABASE();

ALTER TABLE targets ADD COLUMN verification_hash VARCHAR(45) DEFAULT NULL AFTER headers;
ALTER TABLE targets ADD COLUMN verified TINYINT(1) NOT NULL DEFAULT '0' AFTER headers;
