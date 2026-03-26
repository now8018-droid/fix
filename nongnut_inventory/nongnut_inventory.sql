-- nongnut_inventory required tables
-- Import this SQL into the same database used by es_extended.

CREATE TABLE IF NOT EXISTS `trunk_inventory` (
    `plate` VARCHAR(20) NOT NULL,
    `data` LONGTEXT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_accessories` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `skin` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_accessories_identifier` (`identifier`),
    KEY `idx_user_accessories_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vault_inventory` (
    `vault_name` VARCHAR(100) NOT NULL,
    `data` LONGTEXT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`vault_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
