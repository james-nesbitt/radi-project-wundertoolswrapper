<?php

/**
 * INSTALLATION SETTINGS
 *
 * You will want to comment these out if you need to install again
 */

$databases = array (
  'default' => 
  array (
    'default' => 
    array (
      'database' => 'app',
      'username' => 'app',
      'password' => 'app',
      'host'     => 'db.app',
      'port'     => '',
      'driver'   => 'mysql',
      'prefix'   => '',
    ),
  ),
);

// We assume that you performed a standard or config-import install
$settings['install_profile'] = 'standard';

// We assume that the sync folder is mounted at /app/config
$config_directories['sync'] = '/app/config';

/**
 * General settings for developers
 */

// Use this to get rid of those warnings
// $settings['trusted_host_patterns'] = array(
//   '\.docker$',
// );

$settings['file_temporary_path'] = '/tmp';

/**
 * Assertions.
 *
 * The Drupal project primarily uses runtime assertions to enforce the
 * expectations of the API by failing when incorrect calls are made by code
 * under development.
 *
 * @see http://php.net/assert
 * @see https://www.drupal.org/node/2492225
 *
 * If you are using PHP 7.0 it is strongly recommended that you set
 * zend.assertions=1 in the PHP.ini file (It cannot be changed from .htaccess
 * or runtime) on development machines and to 0 in production.
 *
 * @see https://wiki.php.net/rfc/expectations
 */
assert_options(ASSERT_ACTIVE, TRUE);
\Drupal\Component\Assertion\Handle::register();

/**
 * Enable local development services.
 */
if (file_exists(__DIR__.'/local.services.yml')) {
  $settings['container_yamls'][] = __DIR__.'/local.services.yml';
}

/**
 * Show all error messages, with backtrace information.
 *
 * In case the error level could not be fetched from the database, as for
 * example the database connection failed, we rely only on this value.
 */
$config['system.logging']['error_level'] = 'verbose';

/**
 * Disable CSS and JS aggregation.
 */
$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;

/**
 * Disable some caching if needed.
 */
//$settings['cache']['bins']['default'] = 'cache.backend.null';
//$settings['cache']['bins']['render'] = 'cache.backend.null';
//$settings['cache']['bins']['dynamic_page_cache'] = 'cache.backend.null';

/**
 * Allow test modules and themes to be installed.
 */
$settings['extension_discovery_scan_tests'] = TRUE;

/**
 * Enable access to rebuild.php.
 */
$settings['rebuild_access'] = TRUE;

/**
 * Skip file system permissions hardening.
 */
$settings['skip_permissions_hardening'] = TRUE;
    
