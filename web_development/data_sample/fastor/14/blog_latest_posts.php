<?php 

$language_id = 2;
foreach($data['languages'] as $language) {
	if($language['language_id'] != 1) {
		$language_id = $language['language_id'];
	}
}

$output = array();
$output["blog_latest_module"] = array (
  1 => 
  array (
    'heading_title' => 
    array (
      1 => 'News',
      $language_id => 'News',
    ),
    'layout_id' => '1',
    'position' => 'content_bottom',
    'template' => 'wine_home_page.tpl',
    'status' => '1',
    'thumb_width' => '262',
    'thumb_height' => '165',
    'articles_limit' => '3',
    'sort_order' => '5',
  ),
); 

$output2 = array();
$output2["blog_latest_module"] = $this->config->get('blog_latest_module');

if(!is_array($output["blog_latest_module"])) $output["blog_latest_module"] = array();
if(!is_array($output2["blog_latest_module"])) $output2["blog_latest_module"] = array();
$output3 = array();
$output3["blog_latest_module"] = array_merge($output["blog_latest_module"], $output2["blog_latest_module"]);

$this->model_setting_setting->editSetting( "blog_latest", $output3 );	

?>