ALTER TABLE dns_records CHANGE COLUMN `answer` `answer` TEXT not null;
INSERT INTO service_types (`name`, `category`) VALUES ('metadata', 'crawler');
ALTER TABLE projects ADD COLUMN `tracking_id` VARCHAR(255) default null AFTER `name`;
ALTER TABLE findings ADD COLUMN `evidence` text default null AFTER `state`;
ALTER TABLE findings CHANGE COLUMN `detail_id` `finding_detail_id` VARCHAR(255) not null AFTER `finding_id`;
ALTER TABLE domains ADD COLUMN `parent_domain_id` bigint unsigned default null AFTER `domain_id`;