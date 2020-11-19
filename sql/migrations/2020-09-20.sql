USE trivialsec;

ALTER TABLE plans ADD COLUMN `stripe_customer_id` VARCHAR(255) default NULL AFTER `is_dedicated`;
ALTER TABLE plans ADD COLUMN `stripe_product_id` VARCHAR(255) default NULL AFTER `stripe_customer_id`;
ALTER TABLE plans ADD COLUMN `stripe_price_id` VARCHAR(255) default NULL AFTER `stripe_product_id`;
ALTER TABLE plans ADD COLUMN `stripe_subscription_id` VARCHAR(255) default NULL AFTER `stripe_price_id`;
ALTER TABLE plans ADD COLUMN `stripe_payment_method_id` VARCHAR(255) default NULL AFTER `stripe_subscription_id`;
ALTER TABLE plans ADD COLUMN `stripe_card_brand` VARCHAR(255) default NULL AFTER `stripe_payment_method_id`;
ALTER TABLE plans ADD COLUMN `stripe_card_last4` INT(4) default NULL AFTER `stripe_card_brand`;
ALTER TABLE plans ADD COLUMN `stripe_card_expiry_month` INT(2) default NULL AFTER `stripe_card_last4`;
ALTER TABLE plans ADD COLUMN `stripe_card_expiry_year` INT(4) default NULL AFTER `stripe_card_expiry_month`;

UPDATE plans SET stripe_customer_id = 'cus_I3nKApncfIPCkf' WHERE account_id = 1;
