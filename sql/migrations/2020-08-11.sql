USE trivialsec;

DROP TABLE workers;
DROP TABLE services;
RENAME TABLE activities TO activity_logs;
RENAME TABLE dnsrecords TO dns_records;
RENAME TABLE knownips TO known_ips;

ALTER TABLE job_runs ADD COLUMN `service_type_id` bigint unsigned NOT NULL AFTER `tracking_id`;
ALTER TABLE job_runs ADD COLUMN `node_id` VARCHAR(255) default NULL AFTER `service_type_id`;
ALTER TABLE job_runs ADD COLUMN `worker_id` VARCHAR(255) default NULL AFTER `node_id`;
ALTER TABLE job_runs ADD COLUMN `updated_at` datetime default NULL AFTER `started_at`;
