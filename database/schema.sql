-- ============================================================================
-- ENTERPRISE ELECTRONICS STORE & MARKETPLACE DATABASE SCHEMA
-- ============================================================================
-- Database: electronics_store
-- Charset: utf8mb4
-- Collation: utf8mb4_unicode_ci
-- ============================================================================

-- ============================================================================
-- 1. USERS & AUTHENTICATION
-- ============================================================================

CREATE TABLE `es_users` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(100),
  `last_name` VARCHAR(100),
  `phone` VARCHAR(20),
  `avatar` VARCHAR(255),
  `bio` TEXT,
  `role` ENUM('admin', 'staff', 'customer', 'vendor') DEFAULT 'customer',
  `status` ENUM('active', 'inactive', 'suspended', 'deleted') DEFAULT 'active',
  `email_verified` BOOLEAN DEFAULT FALSE,
  `email_verified_at` TIMESTAMP NULL,
  `phone_verified` BOOLEAN DEFAULT FALSE,
  `phone_verified_at` TIMESTAMP NULL,
  `two_factor_enabled` BOOLEAN DEFAULT FALSE,
  `two_factor_secret` VARCHAR(255),
  `two_factor_backup_codes` TEXT,
  `last_login` TIMESTAMP NULL,
  `last_login_ip` VARCHAR(45),
  `login_attempts` INT DEFAULT 0,
  `locked_until` TIMESTAMP NULL,
  `remember_token` VARCHAR(255),
  `remember_token_expires_at` TIMESTAMP NULL,
  `password_reset_token` VARCHAR(255),
  `password_reset_expires_at` TIMESTAMP NULL,
  `language` VARCHAR(10) DEFAULT 'en',
  `currency` VARCHAR(3) DEFAULT 'NGN',
  `timezone` VARCHAR(50) DEFAULT 'Africa/Lagos',
  `newsletter_subscription` BOOLEAN DEFAULT FALSE,
  `marketing_consent` BOOLEAN DEFAULT FALSE,
  `data_deletion_requested` BOOLEAN DEFAULT FALSE,
  `data_deletion_requested_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` TIMESTAMP NULL,
  INDEX `idx_email` (`email`),
  INDEX `idx_username` (`username`),
  INDEX `idx_role` (`role`),
  INDEX `idx_status` (`status`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_user_addresses` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `type` ENUM('billing', 'shipping', 'both') DEFAULT 'shipping',
  `full_name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `email` VARCHAR(255),
  `street_address` VARCHAR(255) NOT NULL,
  `apartment_suite` VARCHAR(255),
  `city` VARCHAR(100) NOT NULL,
  `state_province` VARCHAR(100) NOT NULL,
  `postal_code` VARCHAR(20) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  `country_code` VARCHAR(2) NOT NULL,
  `is_default` BOOLEAN DEFAULT FALSE,
  `latitude` DECIMAL(10, 8),
  `longitude` DECIMAL(11, 8),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_is_default` (`is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_login_history` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `ip_address` VARCHAR(45) NOT NULL,
  `user_agent` TEXT,
  `device_type` VARCHAR(50),
  `browser` VARCHAR(100),
  `os` VARCHAR(100),
  `country` VARCHAR(100),
  `city` VARCHAR(100),
  `status` ENUM('success', 'failed', 'locked') DEFAULT 'success',
  `reason` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_activity_logs` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED,
  `action` VARCHAR(100) NOT NULL,
  `description` TEXT,
  `entity_type` VARCHAR(50),
  `entity_id` BIGINT UNSIGNED,
  `ip_address` VARCHAR(45),
  `user_agent` TEXT,
  `changes` JSON,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_action` (`action`),
  INDEX `idx_entity` (`entity_type`, `entity_id`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 2. CATEGORIES & BRANDS
-- ============================================================================

CREATE TABLE `es_categories` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `parent_id` BIGINT UNSIGNED,
  `name` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `description` TEXT,
  `icon` VARCHAR(255),
  `image` VARCHAR(255),
  `meta_title` VARCHAR(255),
  `meta_description` TEXT,
  `meta_keywords` TEXT,
  `display_order` INT DEFAULT 0,
  `is_active` BOOLEAN DEFAULT TRUE,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`parent_id`) REFERENCES `es_categories`(`id`) ON DELETE SET NULL,
  UNIQUE KEY `uq_slug` (`slug`),
  INDEX `idx_parent_id` (`parent_id`),
  INDEX `idx_is_active` (`is_active`),
  INDEX `idx_display_order` (`display_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_brands` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL UNIQUE,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `description` TEXT,
  `logo` VARCHAR(255),
  `banner` VARCHAR(255),
  `website` VARCHAR(255),
  `is_active` BOOLEAN DEFAULT TRUE,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `meta_title` VARCHAR(255),
  `meta_description` TEXT,
  `meta_keywords` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_is_active` (`is_active`),
  INDEX `idx_is_featured` (`is_featured`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 3. PRODUCTS
-- ============================================================================

CREATE TABLE `es_products` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `sku` VARCHAR(100) NOT NULL UNIQUE,
  `name` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `description` LONGTEXT,
  `short_description` TEXT,
  `category_id` BIGINT UNSIGNED NOT NULL,
  `brand_id` BIGINT UNSIGNED,
  `price` DECIMAL(15, 2) NOT NULL,
  `cost_price` DECIMAL(15, 2),
  `compare_price` DECIMAL(15, 2),
  `discount_percentage` DECIMAL(5, 2) DEFAULT 0,
  `discount_fixed` DECIMAL(15, 2),
  `type` ENUM('simple', 'variable', 'digital', 'bundle') DEFAULT 'simple',
  `status` ENUM('draft', 'active', 'inactive', 'discontinued', 'pending_approval') DEFAULT 'active',
  `visibility` ENUM('visible', 'hidden', 'private') DEFAULT 'visible',
  `quantity` INT DEFAULT 0,
  `low_stock_threshold` INT DEFAULT 10,
  `model_number` VARCHAR(100),
  `barcode` VARCHAR(100),
  `qr_code` VARCHAR(255),
  `weight` DECIMAL(8, 3),
  `dimensions` VARCHAR(100),
  `color_options` JSON,
  `storage_options` JSON,
  `ram_options` JSON,
  `warranty_type` VARCHAR(50),
  `warranty_duration_months` INT,
  `warranty_coverage` TEXT,
  `is_featured` BOOLEAN DEFAULT FALSE,
  `is_best_seller` BOOLEAN DEFAULT FALSE,
  `is_flash_sale` BOOLEAN DEFAULT FALSE,
  `flash_sale_price` DECIMAL(15, 2),
  `flash_sale_start` TIMESTAMP NULL,
  `flash_sale_end` TIMESTAMP NULL,
  `is_new` BOOLEAN DEFAULT FALSE,
  `new_until` TIMESTAMP NULL,
  `rating_average` DECIMAL(3, 2) DEFAULT 0,
  `rating_count` INT DEFAULT 0,
  `view_count` BIGINT DEFAULT 0,
  `meta_title` VARCHAR(255),
  `meta_description` TEXT,
  `meta_keywords` TEXT,
  `canonical_url` VARCHAR(255),
  `created_by` BIGINT UNSIGNED,
  `approved_by` BIGINT UNSIGNED,
  `approved_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`category_id`) REFERENCES `es_categories`(`id`),
  FOREIGN KEY (`brand_id`) REFERENCES `es_brands`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`created_by`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`approved_by`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  UNIQUE KEY `uq_sku` (`sku`),
  UNIQUE KEY `uq_slug` (`slug`),
  INDEX `idx_category_id` (`category_id`),
  INDEX `idx_brand_id` (`brand_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_is_featured` (`is_featured`),
  INDEX `idx_is_new` (`is_new`),
  INDEX `idx_created_at` (`created_at`),
  FULLTEXT INDEX `ft_search` (`name`, `description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_product_images` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `thumbnail_url` VARCHAR(255),
  `alt_text` VARCHAR(255),
  `is_primary` BOOLEAN DEFAULT FALSE,
  `display_order` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  INDEX `idx_product_id` (`product_id`),
  INDEX `idx_is_primary` (`is_primary`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_product_specifications` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `specification_name` VARCHAR(255) NOT NULL,
  `specification_value` TEXT NOT NULL,
  `display_order` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_product_videos` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `video_url` VARCHAR(255) NOT NULL,
  `video_type` ENUM('youtube', 'vimeo', 'upload') DEFAULT 'youtube',
  `title` VARCHAR(255),
  `description` TEXT,
  `thumbnail_url` VARCHAR(255),
  `duration_seconds` INT,
  `display_order` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_product_attachments` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_path` VARCHAR(255) NOT NULL,
  `file_type` VARCHAR(50),
  `file_size` INT,
  `attachment_type` ENUM('manual', 'warranty_document', 'certificate', 'other') DEFAULT 'manual',
  `display_order` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_product_variations` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `sku` VARCHAR(100) NOT NULL UNIQUE,
  `color` VARCHAR(100),
  `storage` VARCHAR(100),
  `ram` VARCHAR(100),
  `size` VARCHAR(100),
  `other_attribute` VARCHAR(255),
  `price` DECIMAL(15, 2),
  `compare_price` DECIMAL(15, 2),
  `cost_price` DECIMAL(15, 2),
  `quantity` INT DEFAULT 0,
  `image_id` BIGINT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`image_id`) REFERENCES `es_product_images`(`id`) ON DELETE SET NULL,
  UNIQUE KEY `uq_sku` (`sku`),
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_related_products` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `related_product_id` BIGINT UNSIGNED NOT NULL,
  `relation_type` ENUM('related', 'accessory', 'frequently_bought_together') DEFAULT 'related',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`related_product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_relation` (`product_id`, `related_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 4. REVIEWS & RATINGS
-- ============================================================================

CREATE TABLE `es_product_reviews` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `order_id` BIGINT UNSIGNED,
  `rating` INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  `title` VARCHAR(255) NOT NULL,
  `content` TEXT NOT NULL,
  `status` ENUM('pending', 'approved', 'rejected', 'spam') DEFAULT 'pending',
  `verified_purchase` BOOLEAN DEFAULT FALSE,
  `helpful_count` INT DEFAULT 0,
  `unhelpful_count` INT DEFAULT 0,
  `response` TEXT,
  `response_by` BIGINT UNSIGNED,
  `response_date` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`response_by`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  INDEX `idx_product_id` (`product_id`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_rating` (`rating`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_product_questions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `question` TEXT NOT NULL,
  `status` ENUM('pending', 'answered', 'rejected') DEFAULT 'pending',
  `answer` TEXT,
  `answered_by` BIGINT UNSIGNED,
  `answered_at` TIMESTAMP NULL,
  `helpful_count` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`answered_by`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  INDEX `idx_product_id` (`product_id`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 5. SHOPPING CART & WISHLIST
-- ============================================================================

CREATE TABLE `es_shopping_carts` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED,
  `session_id` VARCHAR(255),
  `token` VARCHAR(255) UNIQUE,
  `status` ENUM('active', 'abandoned', 'converted') DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `abandoned_at` TIMESTAMP NULL,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_token` (`token`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_cart_items` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `cart_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `variation_id` BIGINT UNSIGNED,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(15, 2) NOT NULL,
  `discount_amount` DECIMAL(15, 2) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`cart_id`) REFERENCES `es_shopping_carts`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`variation_id`) REFERENCES `es_product_variations`(`id`) ON DELETE SET NULL,
  INDEX `idx_cart_id` (`cart_id`),
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_wishlists` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_wishlist` (`user_id`, `product_id`),
  INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_product_comparisons` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED,
  `session_id` VARCHAR(255),
  `token` VARCHAR(255) UNIQUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_comparison_items` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `comparison_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`comparison_id`) REFERENCES `es_product_comparisons`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_comparison_item` (`comparison_id`, `product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 6. ORDERS & PAYMENTS
-- ============================================================================

CREATE TABLE `es_orders` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_number` VARCHAR(50) NOT NULL UNIQUE,
  `user_id` BIGINT UNSIGNED,
  `guest_email` VARCHAR(255),
  `status` ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'returned', 'refunded') DEFAULT 'pending',
  `payment_status` ENUM('pending', 'completed', 'failed', 'cancelled', 'refunded', 'partially_refunded') DEFAULT 'pending',
  `fulfillment_status` ENUM('pending', 'processing', 'shipped', 'delivered', 'returned', 'cancelled') DEFAULT 'pending',
  `subtotal` DECIMAL(15, 2) NOT NULL,
  `discount_amount` DECIMAL(15, 2) DEFAULT 0,
  `coupon_code` VARCHAR(100),
  `tax_amount` DECIMAL(15, 2) DEFAULT 0,
  `shipping_cost` DECIMAL(15, 2) DEFAULT 0,
  `total` DECIMAL(15, 2) NOT NULL,
  `currency` VARCHAR(3) DEFAULT 'NGN',
  `shipping_address_id` BIGINT UNSIGNED,
  `billing_address_id` BIGINT UNSIGNED,
  `shipping_method` VARCHAR(100),
  `tracking_number` VARCHAR(100),
  `payment_method` VARCHAR(100),
  `payment_gateway` VARCHAR(100),
  `transaction_id` VARCHAR(255),
  `notes` TEXT,
  `admin_notes` TEXT,
  `customer_ip` VARCHAR(45),
  `customer_user_agent` TEXT,
  `cancelled_at` TIMESTAMP NULL,
  `cancelled_reason` TEXT,
  `shipped_at` TIMESTAMP NULL,
  `delivered_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`shipping_address_id`) REFERENCES `es_user_addresses`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`billing_address_id`) REFERENCES `es_user_addresses`(`id`) ON DELETE SET NULL,
  UNIQUE KEY `uq_order_number` (`order_number`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_payment_status` (`payment_status`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_order_items` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `variation_id` BIGINT UNSIGNED,
  `product_name` VARCHAR(255) NOT NULL,
  `product_sku` VARCHAR(100),
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(15, 2) NOT NULL,
  `discount_amount` DECIMAL(15, 2) DEFAULT 0,
  `tax_amount` DECIMAL(15, 2) DEFAULT 0,
  `total_price` DECIMAL(15, 2) NOT NULL,
  `warranty_months` INT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`order_id`) REFERENCES `es_orders`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE RESTRICT,
  FOREIGN KEY (`variation_id`) REFERENCES `es_product_variations`(`id`) ON DELETE SET NULL,
  INDEX `idx_order_id` (`order_id`),
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_payments` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED,
  `payment_method` VARCHAR(100) NOT NULL,
  `gateway` VARCHAR(100) NOT NULL,
  `transaction_id` VARCHAR(255) UNIQUE,
  `amount` DECIMAL(15, 2) NOT NULL,
  `currency` VARCHAR(3) DEFAULT 'NGN',
  `status` ENUM('pending', 'completed', 'failed', 'cancelled', 'refunded') DEFAULT 'pending',
  `payment_date` TIMESTAMP NULL,
  `reference_number` VARCHAR(255),
  `response_data` JSON,
  `error_message` TEXT,
  `retry_count` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`order_id`) REFERENCES `es_orders`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  INDEX `idx_order_id` (`order_id`),
  INDEX `idx_transaction_id` (`transaction_id`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_refunds` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `payment_id` BIGINT UNSIGNED,
  `amount` DECIMAL(15, 2) NOT NULL,
  `reason` TEXT NOT NULL,
  `status` ENUM('pending', 'completed', 'failed', 'cancelled') DEFAULT 'pending',
  `transaction_id` VARCHAR(255),
  `processed_by` BIGINT UNSIGNED,
  `processed_at` TIMESTAMP NULL,
  `notes` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`order_id`) REFERENCES `es_orders`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`payment_id`) REFERENCES `es_payments`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`processed_by`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  INDEX `idx_order_id` (`order_id`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 7. COUPONS & DISCOUNTS
-- ============================================================================

CREATE TABLE `es_coupons` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(100) NOT NULL UNIQUE,
  `description` TEXT,
  `discount_type` ENUM('percentage', 'fixed_amount', 'free_shipping', 'bundle') DEFAULT 'percentage',
  `discount_value` DECIMAL(15, 2) NOT NULL,
  `minimum_purchase` DECIMAL(15, 2),
  `maximum_discount` DECIMAL(15, 2),
  `max_uses` INT,
  `usage_count` INT DEFAULT 0,
  `max_uses_per_user` INT DEFAULT 1,
  `start_date` TIMESTAMP,
  `end_date` TIMESTAMP,
  `applicable_categories` JSON,
  `applicable_brands` JSON,
  `excluded_products` JSON,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_by` BIGINT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`created_by`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  UNIQUE KEY `uq_code` (`code`),
  INDEX `idx_is_active` (`is_active`),
  INDEX `idx_start_date` (`start_date`),
  INDEX `idx_end_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 8. INVENTORY & WAREHOUSE
-- ============================================================================

CREATE TABLE `es_warehouses` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `location` VARCHAR(255),
  `address` TEXT,
  `city` VARCHAR(100),
  `state` VARCHAR(100),
  `country` VARCHAR(100),
  `postal_code` VARCHAR(20),
  `is_default` BOOLEAN DEFAULT FALSE,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_is_default` (`is_default`),
  INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_inventory` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `warehouse_id` BIGINT UNSIGNED NOT NULL,
  `quantity` INT DEFAULT 0,
  `reserved_quantity` INT DEFAULT 0,
  `damaged_quantity` INT DEFAULT 0,
  `last_counted_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `es_products`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`warehouse_id`) REFERENCES `es_warehouses`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uq_product_warehouse` (`product_id`, `warehouse_id`),
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 9. LOYALTY & REWARDS
-- ============================================================================

CREATE TABLE `es_loyalty_points` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL UNIQUE,
  `total_points` INT DEFAULT 0,
  `available_points` INT DEFAULT 0,
  `loyalty_tier` ENUM('bronze', 'silver', 'gold', 'platinum') DEFAULT 'bronze',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_loyalty_tier` (`loyalty_tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 10. GIFT CARDS
-- ============================================================================

CREATE TABLE `es_gift_cards` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(50) NOT NULL UNIQUE,
  `balance` DECIMAL(15, 2) NOT NULL,
  `original_balance` DECIMAL(15, 2) NOT NULL,
  `recipient_email` VARCHAR(255),
  `purchaser_id` BIGINT UNSIGNED,
  `used_by_user_id` BIGINT UNSIGNED,
  `activated_at` TIMESTAMP NULL,
  `expires_at` TIMESTAMP NULL,
  `is_active` BOOLEAN DEFAULT TRUE,
  `status` ENUM('inactive', 'active', 'used', 'expired') DEFAULT 'inactive',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`purchaser_id`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`used_by_user_id`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  UNIQUE KEY `uq_code` (`code`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 11. BLOG & CONTENT
-- ============================================================================

CREATE TABLE `es_blog_categories` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `description` TEXT,
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_blog_posts` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `content` LONGTEXT NOT NULL,
  `excerpt` TEXT,
  `featured_image` VARCHAR(255),
  `category_id` BIGINT UNSIGNED,
  `author_id` BIGINT UNSIGNED NOT NULL,
  `status` ENUM('draft', 'published', 'scheduled', 'archived') DEFAULT 'draft',
  `featured` BOOLEAN DEFAULT FALSE,
  `view_count` BIGINT DEFAULT 0,
  `published_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`category_id`) REFERENCES `es_blog_categories`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`author_id`) REFERENCES `es_users`(`id`) ON DELETE RESTRICT,
  UNIQUE KEY `uq_slug` (`slug`),
  INDEX `idx_status` (`status`),
  INDEX `idx_category_id` (`category_id`),
  FULLTEXT INDEX `ft_search` (`title`, `content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 12. SUPPORT & COMMUNICATION
-- ============================================================================

CREATE TABLE `es_support_tickets` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `ticket_number` VARCHAR(50) NOT NULL UNIQUE,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `subject` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `category` VARCHAR(100),
  `priority` ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
  `status` ENUM('open', 'in_progress', 'on_hold', 'resolved', 'closed') DEFAULT 'open',
  `assigned_to` BIGINT UNSIGNED,
  `order_id` BIGINT UNSIGNED,
  `resolved_at` TIMESTAMP NULL,
  `closed_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`assigned_to`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`order_id`) REFERENCES `es_orders`(`id`) ON DELETE SET NULL,
  UNIQUE KEY `uq_ticket_number` (`ticket_number`),
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 13. EMAIL & NEWSLETTERS
-- ============================================================================

CREATE TABLE `es_newsletters` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `status` ENUM('subscribed', 'unsubscribed', 'bounced') DEFAULT 'subscribed',
  `subscription_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `unsubscribe_date` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_email` (`email`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 14. SYSTEM & CONFIGURATION
-- ============================================================================

CREATE TABLE `es_settings` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `setting_key` VARCHAR(255) NOT NULL UNIQUE,
  `setting_value` LONGTEXT,
  `setting_type` VARCHAR(50),
  `category` VARCHAR(100),
  `description` TEXT,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uq_setting_key` (`setting_key`),
  INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_system_logs` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `level` ENUM('debug', 'info', 'warning', 'error', 'critical') DEFAULT 'info',
  `message` TEXT NOT NULL,
  `context` JSON,
  `file` VARCHAR(255),
  `line` INT,
  `user_id` BIGINT UNSIGNED,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE SET NULL,
  INDEX `idx_level` (`level`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `es_audit_logs` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `action` VARCHAR(100) NOT NULL,
  `entity_type` VARCHAR(100),
  `entity_id` BIGINT UNSIGNED,
  `old_values` JSON,
  `new_values` JSON,
  `ip_address` VARCHAR(45),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `es_users`(`id`) ON DELETE CASCADE,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_action` (`action`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
