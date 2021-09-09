CREATE TABLE IF NOT EXISTS domain_monitoring (
    `domain_monitoring_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `domain_name` VARCHAR(255) NOT NULL,
    `account_id` BIGINT UNSIGNED NOT NULL,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `schedule` VARCHAR(255) DEFAULT NULL,
    `enabled` TINYINT NOT NULL DEFAULT '0',
    `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_domain_monitoring PRIMARY KEY (domain_monitoring_id),
    INDEX index_domain_monitoring_domain_name (domain_name),
    INDEX index_domain_monitoring_account_id (account_id),
    INDEX index_domain_monitoring_project_id (project_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

DROP TABLE IF EXISTS cwe_cve;
DROP TABLE IF EXISTS cwes;
DROP TABLE IF EXISTS cves;
DROP TABLE IF EXISTS cve_exploits;
DROP TABLE IF EXISTS cve_remediation;
DROP TABLE IF EXISTS cve_references;
DROP TABLE IF EXISTS domains;
DROP TABLE IF EXISTS domain_stats;
DROP TABLE IF EXISTS dns_records;
DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS inventory_items;
DROP TABLE IF EXISTS known_ips;
