<?php
/*
 * File: app/public/index_silex.php
 * 
 * By: Daniel Morales <daniminas@gmail.com>
 *
 * Web: https://github.com/danielm/vagrant-php
 *
 * Licence: GPL/MIT
 *
 * This is a simple Silex project index file. You will need to install
 * the required libraries first using the composer.json file provided.
 */

require_once __DIR__ . '/../vendor/autoload.php';

$app = new Silex\Application();

$app->get('/', function() use($app) {
  return 'Hello Silex World';
});

$app->run();