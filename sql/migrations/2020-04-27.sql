
CREATE TABLE IF NOT EXISTS finding_details (
    `lookup_id` VARCHAR(255) not null,
    `title` VARCHAR(255) not null,
    `description` text default null,
    `type_namespace` VARCHAR(255) null default null,
    `type_category` VARCHAR(255) null default null,
    `type_classifier` VARCHAR(255) null default null,
    `criticality` int(4) not null default '0',
    `confidence` int(4) not null default '0',
    `severity_product` int(4) not null default '0',
    `recommendation` text default null,
    `recommendation_url` VARCHAR(255) default null,
    `created_at` TIMESTAMP not null default CURRENT_TIMESTAMP,
    `review` tinyint not null default '1',
    `updated_at` datetime default null,
    `modified_by_id` bigint unsigned default null,
    constraint pk_finding_details primary key (lookup_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE findings DROP COLUMN title;
ALTER TABLE findings DROP COLUMN description;
ALTER TABLE findings DROP COLUMN type_namespace;
ALTER TABLE findings DROP COLUMN type_category;
ALTER TABLE findings DROP COLUMN type_classifier;
ALTER TABLE findings DROP COLUMN criticality;
ALTER TABLE findings DROP COLUMN confidence;
ALTER TABLE findings DROP COLUMN severity_product;
ALTER TABLE findings DROP COLUMN recommendation;
ALTER TABLE findings DROP COLUMN recommendation_url;
ALTER TABLE findings ADD COLUMN detail_id VARCHAR(255) DEFAULT NULL AFTER assignee_id;
ALTER TABLE findings CHANGE COLUMN severity_normalized severity_normalized int(4) not null default '0';
RENAME TABLE keyvalues TO key_values;