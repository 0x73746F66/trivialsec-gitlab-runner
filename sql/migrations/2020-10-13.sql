ALTER TABLE domains CHANGE COLUMN `http_last_checked` `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP;
ALTER TABLE domains DROP COLUMN `http_proto`;
ALTER TABLE domains DROP COLUMN `http_negotiated_cipher`;
ALTER TABLE domains DROP COLUMN `http_signature_algorithm`;
ALTER TABLE domains DROP COLUMN `http_server_key_size`;
ALTER TABLE domains DROP COLUMN `http_certificate_issuer`;
ALTER TABLE domains DROP COLUMN `http_certificate_expiry`;
ALTER TABLE domains DROP COLUMN `http_code`;
ALTER TABLE domains DROP COLUMN `http_headers`;
ALTER TABLE domains DROP COLUMN `html_title`;
ALTER TABLE domains DROP COLUMN `html_size`;
CREATE TABLE IF NOT EXISTS domain_stats (
    `domain_stats_id` bigint unsigned not null auto_increment,
    `domain_id` bigint unsigned not null,
    `domain_stat` VARCHAR(255) not null,
    `domain_value` VARCHAR(255) default null,
    `domain_data` text default null,
    `created_at`  TIMESTAMP not null default CURRENT_TIMESTAMP,
    constraint pk_domain_stats primary key (domain_stats_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE programs DROP COLUMN `account_id`;
ALTER TABLE known_ips CHANGE COLUMN `project_id` `project_id` bigint unsigned default null;
ALTER TABLE known_ips ADD COLUMN `domain_id` bigint unsigned default null AFTER `project_id`;
ALTER TABLE domains DROP COLUMN `verified`;