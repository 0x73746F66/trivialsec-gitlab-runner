ALTER TABLE projects DROP COLUMN `enabled`;
ALTER TABLE projects ADD COLUMN `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP AFTER `tracking_id`;
ALTER TABLE programs ADD COLUMN `domain_id` bigint unsigned default null AFTER `account_id`;
ALTER TABLE findings CHANGE COLUMN `source_category` `source_description` TEXT default null;
ALTER TABLE findings ADD COLUMN `service_type_id` bigint unsigned not null AFTER `assignee_id`;
ALTER TABLE notifications CHANGE COLUMN `added` `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP;
ALTER TABLE programs CHANGE COLUMN `added` `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP;
ALTER TABLE security_alerts CHANGE COLUMN `added` `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP;