ALTER TABLE finding_details ADD COLUMN `cvss_vector` VARCHAR(255) default null AFTER `recommendation_url`;
