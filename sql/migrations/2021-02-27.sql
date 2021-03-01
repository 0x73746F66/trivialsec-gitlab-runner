DROP TABLE programs;

CREATE TABLE IF NOT EXISTS programs (
    `program_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `external_url` VARCHAR(255) DEFAULT NULL,
    `icon_url` VARCHAR(255) DEFAULT NULL,
    `category` VARCHAR(255) NOT NULL,
    CONSTRAINT pk_programs PRIMARY KEY (program_id),
    INDEX index_programs_name (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS inventory_items (
    `inventory_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `program_id` BIGINT UNSIGNED NOT NULL,
    `project_id` BIGINT UNSIGNED NOT NULL,
    `domain_id` BIGINT UNSIGNED DEFAULT NULL,
    `version` VARCHAR(255) DEFAULT NULL,
    `source_description` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_checked` DATETIME DEFAULT NULL,
    CONSTRAINT pk_inventory PRIMARY KEY (inventory_item_id),
    INDEX index_inventory_project_id (project_id),
    INDEX index_inventory_domain_id (domain_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
