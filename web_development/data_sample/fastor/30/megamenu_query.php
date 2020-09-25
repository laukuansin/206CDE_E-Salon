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
      $language_id => '',
    ),
    'home_text' => 
    array (
      1 => '',
      $language_id => '',
    ),
    'full_width' => '1',
    'home_item' => 'icon',
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
     INSERT INTO `".DB_PREFIX."mega_menu` (`id`, `module_id`, `parent_id`, `rang`, `icon`, `name`, `link`, `description`, `label`, `label_text_color`, `label_background_color`, `new_window`, `status`, `display_on_mobile`, `position`, `submenu_width`, `submenu_type`, `submenu_background`, `submenu_background_position`, `submenu_background_repeat`, `content_width`, `content_type`, `content`) VALUES
     (1, 0, 0, 0, 'catalog/jewelry2/watches.png', 'a:2:{i:1;s:7:\"Watches\";i:" . $language_id . ";s:7:\"Watches\";}', 'index.php?route=product/category&amp;path=20', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', 0, 0, 0, 0, '100%', 0, 'catalog/jewelry2/bg-megamenu-watches.png', 'top right', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";i:" . $language_id . ";s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (2, 0, 0, 2, 'catalog/jewelry2/jewelry.png', 'a:2:{i:1;s:7:\"Jewelry\";i:" . $language_id . ";s:7:\"Jewelry\";}', 'index.php?route=product/category&amp;path=20', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', 0, 0, 0, 0, '100%', 0, 'catalog/jewelry2/bg-megamenu-jewelry.png', 'top right', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";i:" . $language_id . ";s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (9, 0, 0, 5, 'catalog/jewelry2/phone.png', 'a:2:{i:1;s:20:\"Call us: 500-500-110\";i:" . $language_id . ";s:20:\"Call us: 500-500-110\";}', '', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', 0, 0, 1, 1, '100%', 0, '', 'top left', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (6, 0, 0, 4, '', 'a:2:{i:1;s:5:\"Sales\";i:" . $language_id . ";s:5:\"Sales\";}', 'index.php?route=information/contact', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', 0, 0, 0, 0, '100%', 0, '', 'top left', 'no-repeat', 4, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";i:" . $language_id . ";s:29:\"&lt;p&gt;&lt;br&gt;&lt;/p&gt;\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (10, 0, 1, 1, '', 'a:2:{i:1;s:15:\"Watches submenu\";i:" . $language_id . ";s:15:\"Watches submenu\";}', '', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', 0, 0, 0, 0, '100%', 0, '', 'top left', 'no-repeat', 8, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:4256:\"&lt;div class=&quot;static-menu&quot;&gt;\r\n     &lt;div class=&quot;menu&quot;&gt;\r\n          &lt;ul&gt;\r\n               &lt;li&gt;\r\n                    &lt;a href=&quot;index.php?route=product/category&amp;path=25&quot; class=&quot;main-menu with-submenu&quot;&gt;Watches&lt;/a&gt;\r\n                    &lt;div class=&quot;open-categories&quot;&gt;&lt;/div&gt;\r\n                    &lt;div class=&quot;close-categories&quot;&gt;&lt;/div&gt;\r\n                    \r\n                    &lt;div class=&quot;row visible&quot;&gt;\r\n                         &lt;div class=&quot;col-sm-4&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;New Watches&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Watches $750 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Watches $500 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Watches $250 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                              \r\n                              &lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot; class=&quot;footer-button mobile-disabled&quot; style=&quot;margin-top: 12px&quot;&gt;All watches&lt;/a&gt;\r\n                         &lt;/div&gt;\r\n                         \r\n                         &lt;div class=&quot;col-sm-4&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Automatic&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Luxury&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Dress&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Sports&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Casual&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Diving&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Chronographic&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Digital&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                         &lt;/div&gt;\r\n                         \r\n                         &lt;div class=&quot;col-sm-4&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Baume &amp; Mercier&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Breitling&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Cartier&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Casio&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Citizen&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Gucci&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                         &lt;/div&gt;\r\n                    &lt;/div&gt;\r\n               &lt;/li&gt;\r\n          &lt;/ul&gt;\r\n     &lt;/div&gt;\r\n&lt;/div&gt;\";i:" . $language_id . ";s:4256:\"&lt;div class=&quot;static-menu&quot;&gt;\r\n     &lt;div class=&quot;menu&quot;&gt;\r\n          &lt;ul&gt;\r\n               &lt;li&gt;\r\n                    &lt;a href=&quot;index.php?route=product/category&amp;path=25&quot; class=&quot;main-menu with-submenu&quot;&gt;Watches&lt;/a&gt;\r\n                    &lt;div class=&quot;open-categories&quot;&gt;&lt;/div&gt;\r\n                    &lt;div class=&quot;close-categories&quot;&gt;&lt;/div&gt;\r\n                    \r\n                    &lt;div class=&quot;row visible&quot;&gt;\r\n                         &lt;div class=&quot;col-sm-4&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;New Watches&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Watches $750 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Watches $500 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Watches $250 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                              \r\n                              &lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot; class=&quot;footer-button mobile-disabled&quot; style=&quot;margin-top: 12px&quot;&gt;All watches&lt;/a&gt;\r\n                         &lt;/div&gt;\r\n                         \r\n                         &lt;div class=&quot;col-sm-4&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Automatic&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Luxury&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Dress&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Sports&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Casual&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Diving&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Chronographic&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Digital&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                         &lt;/div&gt;\r\n                         \r\n                         &lt;div class=&quot;col-sm-4&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Baume &amp; Mercier&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Breitling&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Cartier&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Casio&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Citizen&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Gucci&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                         &lt;/div&gt;\r\n                    &lt;/div&gt;\r\n               &lt;/li&gt;\r\n          &lt;/ul&gt;\r\n     &lt;/div&gt;\r\n&lt;/div&gt;\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}'),
     (11, 0, 2, 3, '', 'a:2:{i:1;s:15:\"Jewelry submenu\";i:" . $language_id . ";s:15:\"Jewelry submenu\";}', '', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', 'a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}', '', '', 0, 0, 0, 0, '100%', 0, '', 'top left', 'no-repeat', 6, 0, 'a:4:{s:4:\"html\";a:1:{s:4:\"text\";a:2:{i:1;s:3166:\"&lt;div class=&quot;static-menu&quot;&gt;\r\n     &lt;div class=&quot;menu&quot;&gt;\r\n          &lt;ul&gt;\r\n               &lt;li&gt;\r\n                    &lt;a href=&quot;index.php?route=product/category&amp;path=25&quot; class=&quot;main-menu with-submenu&quot;&gt;Jewelry&lt;/a&gt;\r\n                    &lt;div class=&quot;open-categories&quot;&gt;&lt;/div&gt;\r\n                    &lt;div class=&quot;close-categories&quot;&gt;&lt;/div&gt;\r\n                    \r\n                    &lt;div class=&quot;row visible&quot;&gt;\r\n                         &lt;div class=&quot;col-sm-6&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;New Jewelry&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Jewelry $1,500 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Jewelry $500 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Jewelry $250 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                              \r\n                              &lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot; class=&quot;footer-button mobile-disabled&quot; style=&quot;margin-top: 12px&quot;&gt;All jewelry&lt;/a&gt;\r\n                         &lt;/div&gt;\r\n                         \r\n                         &lt;div class=&quot;col-sm-6&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Necklaces &amp; Pendants&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Bracelets&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Rings&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Earrings&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Wedding Bands&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Charms&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Brooches&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Men''s Jewelry&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                         &lt;/div&gt;\r\n                    &lt;/div&gt;\r\n               &lt;/li&gt;\r\n          &lt;/ul&gt;\r\n     &lt;/div&gt;\r\n&lt;/div&gt;\";i:" . $language_id . ";s:3166:\"&lt;div class=&quot;static-menu&quot;&gt;\r\n     &lt;div class=&quot;menu&quot;&gt;\r\n          &lt;ul&gt;\r\n               &lt;li&gt;\r\n                    &lt;a href=&quot;index.php?route=product/category&amp;path=25&quot; class=&quot;main-menu with-submenu&quot;&gt;Jewelry&lt;/a&gt;\r\n                    &lt;div class=&quot;open-categories&quot;&gt;&lt;/div&gt;\r\n                    &lt;div class=&quot;close-categories&quot;&gt;&lt;/div&gt;\r\n                    \r\n                    &lt;div class=&quot;row visible&quot;&gt;\r\n                         &lt;div class=&quot;col-sm-6&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;New Jewelry&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Jewelry $1,500 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Jewelry $500 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Jewelry $250 &amp; Under&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                              \r\n                              &lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot; class=&quot;footer-button mobile-disabled&quot; style=&quot;margin-top: 12px&quot;&gt;All jewelry&lt;/a&gt;\r\n                         &lt;/div&gt;\r\n                         \r\n                         &lt;div class=&quot;col-sm-6&quot;&gt;\r\n                              &lt;ul&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Necklaces &amp; Pendants&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Bracelets&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Rings&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Earrings&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Wedding Bands&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Charms&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Brooches&lt;/a&gt;&lt;/li&gt;\r\n                                   &lt;li&gt;&lt;a href=&quot;index.php?route=product/category&amp;path=25_29&quot;&gt;Men''s Jewelry&lt;/a&gt;&lt;/li&gt;\r\n                              &lt;/ul&gt;\r\n                         &lt;/div&gt;\r\n                    &lt;/div&gt;\r\n               &lt;/li&gt;\r\n          &lt;/ul&gt;\r\n     &lt;/div&gt;\r\n&lt;/div&gt;\";}}s:7:\"product\";a:4:{s:2:\"id\";s:0:\"\";s:4:\"name\";s:0:\"\";s:5:\"width\";s:3:\"400\";s:6:\"height\";s:3:\"400\";}s:10:\"categories\";a:7:{s:10:\"categories\";a:0:{}s:7:\"columns\";s:1:\"1\";s:7:\"submenu\";s:1:\"1\";s:14:\"image_position\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";s:15:\"submenu_columns\";s:1:\"1\";}s:8:\"products\";a:5:{s:7:\"heading\";a:2:{i:1;s:0:\"\";i:" . $language_id . ";s:0:\"\";}s:8:\"products\";a:0:{}s:7:\"columns\";s:1:\"1\";s:11:\"image_width\";s:0:\"\";s:12:\"image_height\";s:0:\"\";}}')
");

?>