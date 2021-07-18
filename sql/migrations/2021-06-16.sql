DROP TABLE IF EXISTS subscribers;
ALTER TABLE members CHANGE COLUMN `password` scratch_code VARCHAR(255) DEFAULT NULL;

CREATE TABLE IF NOT EXISTS member_mfa (
    `mfa_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `member_id` BIGINT UNSIGNED NOT NULL,
    `type` VARCHAR(16) NOT NULL,
    `name` VARCHAR(255) DEFAULT NULL,
    `active` TINYINT NOT NULL DEFAULT '0',
    `totp_code` VARCHAR(32) DEFAULT NULL,
    `webauthn_id` TEXT DEFAULT NULL,
    `webauthn_public_key` TEXT DEFAULT NULL,
    `webauthn_challenge` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX index_member_mfa_member_id_type (`member_id`, `type`),
    CONSTRAINT pk_member_mfa PRIMARY KEY (mfa_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;
