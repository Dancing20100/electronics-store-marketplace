<?php
/**
 * Application Configuration File
 * 
 * Copy this file to config.php and update with your settings.
 * This file contains all configuration constants for the application.
 * 
 * @package ElectronicsStore
 * @version 1.0.0
 */

// ============================================================================
// APPLICATION SETTINGS
// ============================================================================

define('APP_NAME', 'Electronics Store & Marketplace');
define('APP_DESCRIPTION', 'Enterprise-grade e-commerce platform');
define('APP_VERSION', '1.0.0');
define('APP_AUTHOR', 'Dancing20100');
define('APP_ENVIRONMENT', 'production'); // production, staging, development

// ============================================================================
// DOMAIN & URL SETTINGS
// ============================================================================

define('DOMAIN', 'electronics-store.local');
define('PROTOCOL', 'https://'); // https:// or http://
define('BASE_URL', PROTOCOL . DOMAIN . '/');
define('ADMIN_URL', BASE_URL . 'admin/');
define('API_URL', BASE_URL . 'api/');

// ============================================================================
// DATABASE CONFIGURATION
// ============================================================================

define('DB_HOST', 'localhost');
define('DB_PORT', 3306);
define('DB_NAME', 'electronics_store');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');
define('DB_PREFIX', 'es_'); // Table prefix

// ============================================================================
// SECURITY SETTINGS
// ============================================================================

define('SECRET_KEY', 'generate-a-random-secure-key-here-minimum-32-characters');
define('JWT_SECRET', 'generate-another-random-secure-key-for-jwt-minimum-32-characters');
define('HASH_ALGORITHM', 'bcrypt');
define('HASH_COST', 12); // bcrypt cost factor (10-12)

// Two-Factor Authentication
define('2FA_ENABLED', true);
define('2FA_WINDOW', 1); // Time window in steps

// Session Settings
define('SESSION_NAME', 'ELECTROSTORE_SESS');
define('SESSION_LIFETIME', 86400 * 7); // 7 days
define('SESSION_PATH', __DIR__ . '/../../sessions/');
define('SESSION_SECURE', true); // HTTPS only
define('SESSION_HTTPONLY', true); // No JavaScript access
define('SESSION_SAMESITE', 'Strict'); // CSRF protection

// CSRF Protection
define('CSRF_ENABLED', true);
define('CSRF_TOKEN_LENGTH', 64);
define('CSRF_TOKEN_LIFETIME', 3600); // 1 hour

// ============================================================================
// PAYMENT GATEWAY SETTINGS
// ============================================================================

// Paystack
define('PAYSTACK_ENABLED', true);
define('PAYSTACK_PUBLIC_KEY', 'pk_test_xxxxxxxxxxxxx');
define('PAYSTACK_SECRET_KEY', 'sk_test_xxxxxxxxxxxxx');

// Flutterwave
define('FLUTTERWAVE_ENABLED', true);
define('FLUTTERWAVE_PUBLIC_KEY', 'FLWPUBK_TEST_xxxxxxxxxxxxx');
define('FLUTTERWAVE_SECRET_KEY', 'FLWSECK_TEST_xxxxxxxxxxxxx');

// Stripe
define('STRIPE_ENABLED', true);
define('STRIPE_PUBLIC_KEY', 'pk_test_xxxxxxxxxxxxx');
define('STRIPE_SECRET_KEY', 'sk_test_xxxxxxxxxxxxx');

// PayPal
define('PAYPAL_ENABLED', true);
define('PAYPAL_MODE', 'sandbox'); // sandbox or live
define('PAYPAL_CLIENT_ID', 'your_client_id');
define('PAYPAL_CLIENT_SECRET', 'your_client_secret');

// ============================================================================
// SHIPPING INTEGRATION SETTINGS
// ============================================================================

// DHL
define('DHL_ENABLED', true);
define('DHL_API_KEY', 'your_dhl_api_key');
define('DHL_ACCOUNT_NUMBER', 'your_account_number');

// FedEx
define('FEDEX_ENABLED', true);
define('FEDEX_ACCOUNT_NUMBER', 'your_account_number');
define('FEDEX_METER_NUMBER', 'your_meter_number');
define('FEDEX_API_KEY', 'your_api_key');

// UPS
define('UPS_ENABLED', true);
define('UPS_ACCOUNT_NUMBER', 'your_account_number');
define('UPS_API_KEY', 'your_api_key');

// ============================================================================
// GOOGLE SERVICES
// ============================================================================

define('GOOGLE_RECAPTCHA_ENABLED', true);
define('GOOGLE_RECAPTCHA_SITE_KEY', 'your_site_key');
define('GOOGLE_RECAPTCHA_SECRET_KEY', 'your_secret_key');

define('GOOGLE_ANALYTICS_ID', 'G-XXXXXXXXXX');
define('GOOGLE_ANALYTICS_ENABLED', true);

define('GOOGLE_ADSENSE_ENABLED', false);
define('GOOGLE_ADSENSE_PUBLISHER_ID', 'ca-pub-xxxxxxxxxxxxxxxx');

// ============================================================================
// MAIL CONFIGURATION
// ============================================================================

define('MAIL_DRIVER', 'smtp'); // smtp or sendmail
define('MAIL_FROM_ADDRESS', 'noreply@electronics-store.local');
define('MAIL_FROM_NAME', 'Electronics Store');

// SMTP Configuration
define('SMTP_HOST', 'smtp.mailtrap.io');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'your_username');
define('SMTP_PASSWORD', 'your_password');
define('SMTP_ENCRYPTION', 'tls'); // tls or ssl

// ============================================================================
// STORAGE SETTINGS
// ============================================================================

define('UPLOAD_PATH', __DIR__ . '/../../public/uploads/');
define('MAX_UPLOAD_SIZE', 50 * 1024 * 1024); // 50MB
define('ALLOWED_IMAGE_TYPES', ['image/jpeg', 'image/png', 'image/webp', 'image/gif']);
define('ALLOWED_IMAGE_EXTENSIONS', ['jpg', 'jpeg', 'png', 'webp', 'gif']);
define('ALLOWED_DOCUMENT_TYPES', ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']);
define('ALLOWED_DOCUMENT_EXTENSIONS', ['pdf', 'doc', 'docx']);

// ============================================================================
// CACHE SETTINGS
// ============================================================================

define('CACHE_ENABLED', true);
define('CACHE_DRIVER', 'file'); // file or memcache
define('CACHE_PATH', __DIR__ . '/../../cache/');
define('CACHE_TTL', 3600); // 1 hour
define('CACHE_PRODUCT_TTL', 7200); // 2 hours

// ============================================================================
// LOGGING SETTINGS
// ============================================================================

define('LOG_ENABLED', true);
define('LOG_LEVEL', 'debug'); // debug, info, warning, error
define('LOG_PATH', __DIR__ . '/../../logs/');
define('LOG_MAX_SIZE', 10 * 1024 * 1024); // 10MB

// ============================================================================
// BUSINESS SETTINGS
// ============================================================================

define('BUSINESS_NAME', 'Electronics Store Nigeria');
define('BUSINESS_EMAIL', 'info@electronics-store.local');
define('BUSINESS_PHONE', '+234 (0) 123 456 7890');
define('BUSINESS_ADDRESS', 'Lagos, Nigeria');
define('BUSINESS_COUNTRY', 'NG');
define('BUSINESS_CURRENCY', 'NGN');
define('BUSINESS_CURRENCY_SYMBOL', '₦');
define('BUSINESS_LANGUAGE', 'en');
define('BUSINESS_TIMEZONE', 'Africa/Lagos');

// ============================================================================
// FEATURES SETTINGS
// ============================================================================

define('FEATURE_2FA', true);
define('FEATURE_WISHLIST', true);
define('FEATURE_COMPARISON', true);
define('FEATURE_REVIEWS', true);
define('FEATURE_LOYALTY', true);
define('FEATURE_REFERRAL', true);
define('FEATURE_GIFT_CARDS', true);
define('FEATURE_LIVE_CHAT', true);
define('FEATURE_AFFILIATES', true);
define('FEATURE_BLOG', true);
define('FEATURE_FAQ', true);
define('FEATURE_NEWSLETTER', true);
define('FEATURE_SMS_NOTIFICATIONS', true);
define('FEATURE_PUSH_NOTIFICATIONS', true);

// ============================================================================
// PAGINATION SETTINGS
// ============================================================================

define('PRODUCTS_PER_PAGE', 20);
define('ORDERS_PER_PAGE', 25);
define('CUSTOMERS_PER_PAGE', 50);
define('COMMENTS_PER_PAGE', 10);

// ============================================================================
// API SETTINGS
// ============================================================================

define('API_RATE_LIMIT', 1000); // requests per hour
define('API_TIMEOUT', 30); // seconds
define('API_VERSION', 'v1');
define('API_TOKEN_EXPIRY', 3600 * 24); // 24 hours

// ============================================================================
// MULTITENANCY SETTINGS
// ============================================================================

define('MULTITENANCY_ENABLED', false);
define('MULTITENANCY_TYPE', 'database'); // database or schema

// ============================================================================
// DEBUGGING
// ============================================================================

define('DEBUG_MODE', false); // Set to false in production
define('DEBUG_ERROR_REPORTING', DEBUG_MODE ? E_ALL : E_ERROR | E_WARNING);
define('DEBUG_DISPLAY_ERRORS', DEBUG_MODE ? 1 : 0);
define('DEBUG_LOG_ERRORS', true);

// ============================================================================
// END OF CONFIGURATION
// ============================================================================
