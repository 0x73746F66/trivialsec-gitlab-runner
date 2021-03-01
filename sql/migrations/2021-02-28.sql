ALTER TABLE finding_details DROP COLUMN `confidence`;
ALTER TABLE finding_details DROP COLUMN `criticality`;
ALTER TABLE findings ADD COLUMN `cvss_vector` VARCHAR(255) DEFAULT NULL AFTER `is_passive`;
ALTER TABLE findings ADD COLUMN `confidence` INT(4) NOT NULL DEFAULT '0' AFTER `severity_normalized`;
