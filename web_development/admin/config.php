<?php
// HTTP
define('HTTP_SERVER', 'http://localhost/admin/');
// define('HTTP_SERVER', '');
// define('HTTP_CATALOG', '');
define('HTTP_CATALOG', 'http://localhost/');

// HTTPS
define('HTTPS_SERVER', 'http://localhost/admin/');
define('HTTPS_CATALOG', 'http://localhost/');
// define('HTTPS_SERVER', '');
// define('HTTPS_CATALOG', '');


// DIR
// define('DIR_APPLICATION', '/opt/lampp/htdocs/upload/admin/');
define('DIR_APPLICATION', 'C:/Users/Jeffrey Tan/Desktop/GPSTracker/RealWorldProject/web_development/admin/');
// define('DIR_SYSTEM', '/opt/lampp/htdocs/upload/system/');
define('DIR_SYSTEM', 'C:/Users/Jeffrey Tan/Desktop/GPSTracker/RealWorldProject/web_development/system/');
define('DIR_IMAGE', 'C:/Users/Jeffrey Tan/Desktop/GPSTracker/RealWorldProject/web_development/image/');
// define('DIR_IMAGE', '/opt/lampp/htdocs/upload/image/');
define('DIR_STORAGE', DIR_SYSTEM . 'storage/');
// define('DIR_CATALOG', '/opt/lampp/htdocs/upload/catalog/');
define('DIR_CATALOG', '../catalog/');
define('DIR_LANGUAGE', DIR_APPLICATION . 'language/');
define('DIR_TEMPLATE', DIR_APPLICATION . 'view/template/');
define('DIR_CONFIG', DIR_SYSTEM . 'config/');
define('DIR_CACHE', DIR_STORAGE . 'cache/');
define('DIR_DOWNLOAD', DIR_STORAGE . 'download/');
define('DIR_LOGS', DIR_STORAGE . 'logs/');
define('DIR_MODIFICATION', DIR_STORAGE . 'modification/');
define('DIR_SESSION', DIR_STORAGE . 'session/');
define('DIR_UPLOAD', DIR_STORAGE . 'upload/');

// DB
define('DB_DRIVER', 'mysqli');
define('DB_HOSTNAME', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_DATABASE', 'opencart');
define('DB_PORT', '3306');
define('DB_PREFIX', 'oc_');

// OpenCart API
define('OPENCART_SERVER', 'https://www.opencart.com/');
