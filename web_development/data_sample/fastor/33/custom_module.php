<?php 

$language_id = 2;
foreach($data['languages'] as $language) {
	if($language['language_id'] != 1) {
		$language_id = $language['language_id'];
	}
}

$output = array();
$output["custom_module_module"] = array (
  1 => 
  array (
    'type' => '2',
    'block_heading' => 
    array (
      1 => '',
      $language_id => '',
    ),
    'block_content' => 
    array (
      1 => '&lt;p&gt;&lt;br&gt;&lt;/p&gt;',
      $language_id => '&lt;p&gt;&lt;br&gt;&lt;/p&gt;',
    ),
    'html' => 
    array (
      1 => '&lt;div style=&quot;background: #f9f9f9 url(image/catalog/grocery/bg-top-bar.png) bottom left repeat-x&quot;&gt;
     &lt;div class=&quot;standard-body&quot;&gt;
          &lt;div class=&quot;full-width&quot;&gt;
               &lt;div class=&quot;container&quot;&gt;
                    &lt;div class=&quot;grocery-top-bar row&quot;&gt;
                         &lt;div class=&quot;col-sm-4&quot;&gt;
                              &lt;div class=&quot;background&quot;&gt;
                                   &lt;img src=&quot;image/catalog/grocery/icon-free-shipping.png&quot; alt=&quot;Free shipping&quot;&gt;
                                   &lt;p&gt;Free shipping &amp; Return&lt;/p&gt;
                              &lt;/div&gt;
                         &lt;/div&gt;
                         
                         &lt;div class=&quot;col-sm-4 text-center&quot;&gt;
                              &lt;div class=&quot;background&quot;&gt;
                                   &lt;img src=&quot;image/catalog/grocery/icon-money.png&quot; alt=&quot;Money back&quot;&gt;
                                   &lt;p&gt;Money back guarantee&lt;/p&gt;
                              &lt;/div&gt;
                         &lt;/div&gt;
                         
                         &lt;div class=&quot;col-sm-4 text-right&quot;&gt;
                              &lt;div class=&quot;background&quot;&gt;
                                   &lt;img src=&quot;image/catalog/grocery/icon-support2.png&quot; alt=&quot;Support&quot;&gt;
                                   &lt;p&gt;Support 24/7&lt;/p&gt;
                              &lt;/div&gt;
                         &lt;/div&gt;
                    &lt;/div&gt;
               &lt;/div&gt;
          &lt;/div&gt;
     &lt;/div&gt;
&lt;/div&gt;',
      $language_id => '&lt;div style=&quot;background: #f9f9f9 url(image/catalog/grocery/bg-top-bar.png) bottom left repeat-x&quot;&gt;
     &lt;div class=&quot;standard-body&quot;&gt;
          &lt;div class=&quot;full-width&quot;&gt;
               &lt;div class=&quot;container&quot;&gt;
                    &lt;div class=&quot;grocery-top-bar row&quot;&gt;
                         &lt;div class=&quot;col-sm-4&quot;&gt;
                              &lt;div class=&quot;background&quot;&gt;
                                   &lt;img src=&quot;image/catalog/grocery/icon-free-shipping.png&quot; alt=&quot;Free shipping&quot;&gt;
                                   &lt;p&gt;Free shipping &amp; Return&lt;/p&gt;
                              &lt;/div&gt;
                         &lt;/div&gt;
                         
                         &lt;div class=&quot;col-sm-4 text-center&quot;&gt;
                              &lt;div class=&quot;background&quot;&gt;
                                   &lt;img src=&quot;image/catalog/grocery/icon-money.png&quot; alt=&quot;Money back&quot;&gt;
                                   &lt;p&gt;Money back guarantee&lt;/p&gt;
                              &lt;/div&gt;
                         &lt;/div&gt;
                         
                         &lt;div class=&quot;col-sm-4 text-right&quot;&gt;
                              &lt;div class=&quot;background&quot;&gt;
                                   &lt;img src=&quot;image/catalog/grocery/icon-support2.png&quot; alt=&quot;Support&quot;&gt;
                                   &lt;p&gt;Support 24/7&lt;/p&gt;
                              &lt;/div&gt;
                         &lt;/div&gt;
                    &lt;/div&gt;
               &lt;/div&gt;
          &lt;/div&gt;
     &lt;/div&gt;
&lt;/div&gt;',
    ),
    'layout_id' => '99999',
    'position' => 'header_notice',
    'status' => '1',
    'sort_order' => '',
  ),
  2 => 
  array (
    'type' => '2',
    'block_heading' => 
    array (
      1 => '',
      $language_id => '',
    ),
    'block_content' => 
    array (
      1 => '&lt;p&gt;&lt;br&gt;&lt;/p&gt;',
      $language_id => '&lt;p&gt;&lt;br&gt;&lt;/p&gt;',
    ),
    'html' => 
    array (
      1 => '&lt;div class=&quot;row banners&quot;&gt;
     &lt;div class=&quot;col-sm-12&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-07.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
&lt;/div&gt;

&lt;div class=&quot;row banners&quot;&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-08.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-09.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-10.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-11.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
&lt;/div&gt;

&lt;div style=&quot;height: 10px&quot; class=&quot;hidden-xs&quot;&gt;&lt;/div&gt;',
      $language_id => '&lt;div class=&quot;row banners&quot;&gt;
     &lt;div class=&quot;col-sm-12&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-07.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
&lt;/div&gt;

&lt;div class=&quot;row banners&quot;&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-08.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-09.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-10.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
     &lt;div class=&quot;col-sm-3&quot;&gt;&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/grocery/banner-11.png&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;&lt;/div&gt;
&lt;/div&gt;

&lt;div style=&quot;height: 10px&quot; class=&quot;hidden-xs&quot;&gt;&lt;/div&gt;',
    ),
    'layout_id' => '1',
    'position' => 'content_bottom',
    'status' => '1',
    'sort_order' => '5',
  ),
  3 => 
  array (
    'type' => '2',
    'block_heading' => 
    array (
      1 => '',
      $language_id => '',
    ),
    'block_content' => 
    array (
      1 => '&lt;p&gt;&lt;br&gt;&lt;/p&gt;',
      $language_id => '&lt;p&gt;&lt;br&gt;&lt;/p&gt;',
    ),
    'html' => 
    array (
      1 => '&lt;div style=&quot;height: 406px&quot; class=&quot;hidden-xs hidden-sm&quot;&gt;&lt;/div&gt;',
      $language_id => '&lt;div style=&quot;height: 406px&quot; class=&quot;hidden-xs hidden-sm&quot;&gt;&lt;/div&gt;',
    ),
    'layout_id' => '3',
    'position' => 'column_left',
    'status' => '1',
    'sort_order' => '0',
  ),
); 

$output2 = array();
$output2["custom_module_module"] = $this->config->get('custom_module_module');

if(!is_array($output["custom_module_module"])) $output["custom_module_module"] = array();
if(!is_array($output2["custom_module_module"])) $output2["custom_module_module"] = array();
$output3 = array();
$output3["custom_module_module"] = array_merge($output["custom_module_module"], $output2["custom_module_module"]);

$this->model_setting_setting->editSetting( "custom_module", $output3 );	

?>