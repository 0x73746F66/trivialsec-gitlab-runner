ALTER TABLE plan_invoices ADD COLUMN `coupon_code` VARCHAR(16) DEFAULT NULL AFTER `currency`;
ALTER TABLE plan_invoices ADD COLUMN `coupon_desc` VARCHAR(255) DEFAULT NULL AFTER `coupon_code`;
ALTER TABLE plan_invoices ADD COLUMN `stripe_promotion_id` VARCHAR(255) DEFAULT NULL AFTER `coupon_desc`;