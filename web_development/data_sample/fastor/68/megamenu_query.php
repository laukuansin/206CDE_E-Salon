<?php 

$language_id = 2;
foreach($data['languages'] as $language) {
	if($language['language_id'] != 1) {
		$language_id = $language['language_id'];
	}
}

$output = array();
$output["megamenu_module"] = array (
  0 => 
  array (
    'module_id' => 0,
    'layout_id' => '99999',
    'position' => 'menu',
    'status' => '1',
    'display_on_mobile' => '0',
    'sort_order' => 1,
    'orientation' => '0',
    'search_bar' => 0,
    'navigation_text' => 
    array (
      1 => '',
      2 => '',
    ),
    'home_text' => 
    array (
      1 => '',
      2 => '',
    ),
    'full_width' => '1',
    'home_item' => 'disabled',
    'animation' => 'shift-up',
    'animation_time' => 200,
    'status_cache' => 0,
    'cache_time' => 1,
  ),
);
 
$this->model_setting_setting->editSetting( "megamenu", $output );

$query = $this->db->query("
	DROP TABLE IF EXISTS `".DB_PREFIX ."mega_menu`
");

$query = $this->db->query("
	DROP TABLE IF EXISTS `".DB_PREFIX ."mega_menu_modules`
");

$query = $this->db->query("
	DROP TABLE IF EXISTS `".DB_PREFIX ."mega_menu_links`
");

$query = $this->db->query("
	CREATE TABLE IF NOT EXISTS `".DB_PREFIX."mega_menu` (
		`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
		`module_id` int(11) NOT NULL DEFAULT '0',
		`parent_id` int(11) NOT NULL,
		`rang` int(11) NOT NULL,
		`icon` varchar(255) NOT NULL DEFAULT '',
		`name` text,
		`link` text,
		`description` text,
		`label` text,
		`label_text_color` text,
		`label_background_color` text,
		`custom_class` text,
		`new_window` int(11) NOT NULL DEFAULT '0',
		`status` int(11) NOT NULL DEFAULT '0',
		`display_on_mobile` int(11) NOT NULL DEFAULT '0',
		`position` int(11) NOT NULL DEFAULT '0',
		`submenu_width` text,
		`submenu_type` int(11) NOT NULL DEFAULT '0',
		`submenu_background` text,
		`submenu_background_position` text,
		`submenu_background_repeat` text,
		`content_width` int(11) NOT NULL DEFAULT '12',
		`content_type` int(11) NOT NULL DEFAULT '0',
		`content` text,
		PRIMARY KEY (`id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1
");

$query = $this->db->query("
	CREATE TABLE IF NOT EXISTS `".DB_PREFIX."mega_menu_modules` (
		`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
		`name` text,
		PRIMARY KEY (`id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1
");

$query = $this->db->query("
	CREATE TABLE IF NOT EXISTS `".DB_PREFIX."mega_menu_links` (
		`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
		`name` text,
		`name_for_autocomplete` text,
		`url` text,
		`label` text,
		`label_text` text,
		`label_background` text,
		`image` text,
		PRIMARY KEY (`id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1
");

$query = $this->db->query("
     INSERT INTO `".DB_PREFIX."mega_menu` (`id`, `module_id`, `parent_id`, `rang`, `icon`, `name`, `link`, `description`, `label`, `label_text_color`, `label_background_color`, `custom_class`, `new_window`, `status`, `display_on_mobile`, `position`, `submenu_width`, `submenu_type`, `submenu_background`, `submenu_background_position`, `submenu_background_repeat`, `content_width`, `content_type`, `content`) VALUES
     (1, 0, 0, 1, '', 'a:2:{i:1;s:10:\"Categories\";i:" . $language_id . ";s:10:\"Categories\";}', 'index.php?route=product/category&amp;path=20', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', '', 0, 0, 0, 0, '200px', 0, '', 'top left', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";i:" . $language_id . ";s:0:\"\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (2, 0, 0, 3, '', 'a:2:{i:1;s:11:\"Collections\";i:" . $language_id . ";s:11:\"Collections\";}', 'index.php?route=product/category&amp;path=18', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', '', 0, 0, 0, 0, '100%', 0, '', 'top right', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";i:" . $language_id . ";s:0:\"\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (31, 0, 2, 4, '', 'a:2:{i:1;s:11:\"Collections\";i:" . $language_id . ";s:11:\"Collections\";}', '', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', '', 0, 0, 0, 0, '100%', 0, '', 'top left', 'no-repeat', 12, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:2413:\"&lt;div class=&quot;row&quot;&gt;\r\n	&lt;div class=&quot;col-sm-4&quot;&gt;\r\n		&lt;div class=&quot;fashion6-megamenu&quot;&gt;\r\n			&lt;img src=&quot;image/catalog/fashion6/first-category.jpg&quot; alt=&quot;&quot;&gt;\r\n			&lt;ul&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Dresses&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Long dresses&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Short dresses&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Medium dresses&lt;/a&gt;&lt;/li&gt;\r\n			&lt;/ul&gt;\r\n		&lt;/div&gt;\r\n	&lt;/div&gt;\r\n	\r\n	&lt;div class=&quot;col-sm-4&quot;&gt;\r\n		&lt;div class=&quot;fashion6-megamenu&quot;&gt;\r\n			&lt;img src=&quot;image/catalog/fashion6/second-category.jpg&quot; alt=&quot;&quot;&gt;\r\n			&lt;ul&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;T-shirts&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Tank Tops&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Man&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Woman&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Trousers&lt;/a&gt;&lt;/li&gt;\r\n			&lt;/ul&gt;\r\n		&lt;/div&gt;\r\n	&lt;/div&gt;\r\n	\r\n	&lt;div class=&quot;col-sm-4&quot;&gt;\r\n		&lt;div class=&quot;fashion6-megamenu&quot;&gt;\r\n			&lt;img src=&quot;image/catalog/fashion6/third-category.jpg&quot; alt=&quot;&quot;&gt;\r\n			&lt;ul&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;T-shirts&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Tank Tops&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Man&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Woman&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Trousers&lt;/a&gt;&lt;/li&gt;\r\n			&lt;/ul&gt;\r\n		&lt;/div&gt;\r\n	&lt;/div&gt;\r\n&lt;/div&gt;\";i:" . $language_id . ";s:2413:\"&lt;div class=&quot;row&quot;&gt;\r\n	&lt;div class=&quot;col-sm-4&quot;&gt;\r\n		&lt;div class=&quot;fashion6-megamenu&quot;&gt;\r\n			&lt;img src=&quot;image/catalog/fashion6/first-category.jpg&quot; alt=&quot;&quot;&gt;\r\n			&lt;ul&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Dresses&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Long dresses&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Short dresses&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Medium dresses&lt;/a&gt;&lt;/li&gt;\r\n			&lt;/ul&gt;\r\n		&lt;/div&gt;\r\n	&lt;/div&gt;\r\n	\r\n	&lt;div class=&quot;col-sm-4&quot;&gt;\r\n		&lt;div class=&quot;fashion6-megamenu&quot;&gt;\r\n			&lt;img src=&quot;image/catalog/fashion6/second-category.jpg&quot; alt=&quot;&quot;&gt;\r\n			&lt;ul&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;T-shirts&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Tank Tops&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Man&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Woman&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Trousers&lt;/a&gt;&lt;/li&gt;\r\n			&lt;/ul&gt;\r\n		&lt;/div&gt;\r\n	&lt;/div&gt;\r\n	\r\n	&lt;div class=&quot;col-sm-4&quot;&gt;\r\n		&lt;div class=&quot;fashion6-megamenu&quot;&gt;\r\n			&lt;img src=&quot;image/catalog/fashion6/third-category.jpg&quot; alt=&quot;&quot;&gt;\r\n			&lt;ul&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;T-shirts&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Tank Tops&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Man&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Woman&lt;/a&gt;&lt;/li&gt;\r\n				&lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=20&quot;&gt;Trousers&lt;/a&gt;&lt;/li&gt;\r\n			&lt;/ul&gt;\r\n		&lt;/div&gt;\r\n	&lt;/div&gt;\r\n&lt;/div&gt;\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (3, 0, 0, 6, '', 'a:2:{i:1;s:7:\"Contact\";i:" . $language_id . ";s:7:\"Contact\";}', 'index.php?route=information/contact', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', '', 0, 0, 0, 0, '100%', 0, '', 'top right', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";i:" . $language_id . ";s:0:\"\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (4, 0, 0, 5, '', 'a:2:{i:1;s:4:\"Sale\";i:" . $language_id . ";s:4:\"Sale\";}', 'index.php?route=product/special', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', '', 0, 0, 0, 0, '100%', 0, '', 'top left', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";i:" . $language_id . ";s:0:\"\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (30, 0, 1, 2, '', 'a:2:{i:1;s:5:\"Links\";i:" . $language_id . ";s:5:\"Links\";}', '', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', '', 0, 0, 0, 0, '100%', 0, '', 'top left', 'no-repeat', 12, 2, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:5:{i:0;a:2:{s:4:\"name\";s:7:\"Cameras\";s:2:\"id\";i:33;}i:1;a:2:{s:4:\"name\";s:27:\"Components????>????Monitors\";s:2:\"id\";i:28;}i:2;a:2:{s:4:\"name\";s:8:\"Software\";s:2:\"id\";i:17;}i:3;a:2:{s:4:\"name\";s:11:\"MP3 Players\";s:2:\"id\";i:34;}i:4;a:2:{s:4:\"name\";s:23:\"Laptops????>????Windows\";s:2:\"id\";i:45;}}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (29, 0, 0, 0, '', 'a:2:{i:1;s:30:\"&amp;nbsp;&amp;nbsp;&amp;nbsp;\";i:" . $language_id . ";s:30:\"&amp;nbsp;&amp;nbsp;&amp;nbsp;\";}', '', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', '', 0, 0, 1, 0, '100%', 0, '', 'top left', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}');
");

?>