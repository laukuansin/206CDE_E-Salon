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
      1 => '<p><br></p>',
      $language_id => '<p><br></p>',
    ),
    'html' => 
    array (
      1 => '<div class="lingerie2-columns computer6-columns responsive-margin-top-45" style="margin-top: 77px;margin-bottom: 10px;background: url(image/catalog/petshop/bg-columns.png) top center repeat;">
     <div class="row">
          <div class="col-sm-4">
               <img src="image/catalog/petshop/icon-free-shipping.png" alt="Free shipping">
               <p>Free Shipping & Returns</p>
          </div>
          
          <div class="col-sm-4">
               <img src="image/catalog/petshop/icon-money.png" alt="Money">
               <p>100% Money refund</p>
          </div>
          
          <div class="col-sm-4">
               <img src="image/catalog/petshop/icon-time.png" alt="Delivery">
               <p>Fast send and delivery</p>
          </div>
     </div>
</div>',
      $language_id => '<div class="lingerie2-columns computer6-columns responsive-margin-top-45" style="margin-top: 77px;margin-bottom: 10px;background: url(image/catalog/petshop/bg-columns.png) top center repeat;">
     <div class="row">
          <div class="col-sm-4">
               <img src="image/catalog/petshop/icon-free-shipping.png" alt="Free shipping">
               <p>Free Shipping & Returns</p>
          </div>
          
          <div class="col-sm-4">
               <img src="image/catalog/petshop/icon-money.png" alt="Money">
               <p>100% Money refund</p>
          </div>
          
          <div class="col-sm-4">
               <img src="image/catalog/petshop/icon-time.png" alt="Delivery">
               <p>Fast send and delivery</p>
          </div>
     </div>
</div>',
    ),
    'layout_id' => '1',
    'position' => 'content_bottom',
    'status' => '1',
    'sort_order' => '10',
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
      1 => '<p><br></p>',
      $language_id => '<p><br></p>',
    ),
    'html' => 
    array (
      1 => '<div class="shoes2-phone hidden-md hidden-sm">
     <img src="image/catalog/petshop/icon-phone.png" alt="Phone">
     <div class="heading" style="color: #000">Need<br>help?</div>
     <p>500-500-500</p>
</div>',
      $language_id => '<div class="shoes2-phone hidden-md hidden-sm">
     <img src="image/catalog/petshop/icon-phone.png" alt="Phone">
     <div class="heading" style="color: #000">Need<br>help?</div>
     <p>500-500-500</p>
</div>',
    ),
    'layout_id' => '99999',
    'position' => 'top_block',
    'status' => '1',
    'sort_order' => '',
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
      1 => '<p><br></p>',
      $language_id => '<p><br></p>',
    ),
    'html' => 
    array (
      1 => '<div class="row banners banners-with-padding-0">
     <div class="col-sm-6"><a href="#"><img src="image/catalog/petshop/banner-01.png" alt="Banner"></a></div>
     <div class="col-sm-6"><a href="#"><img src="image/catalog/petshop/banner-02.png" alt="Banner"></a></div>
</div>',
      $language_id => '<div class="row banners banners-with-padding-0">
     <div class="col-sm-6"><a href="#"><img src="image/catalog/petshop/banner-01.png" alt="Banner"></a></div>
     <div class="col-sm-6"><a href="#"><img src="image/catalog/petshop/banner-02.png" alt="Banner"></a></div>
</div>',
    ),
    'layout_id' => '1',
    'position' => 'preface_fullwidth',
    'status' => '1',
    'sort_order' => '0',
  ),
  4 => 
  array (
    'type' => '2',
    'block_heading' => 
    array (
      1 => '',
      $language_id => '',
    ),
    'block_content' => 
    array (
      1 => '<p><br></p>',
      $language_id => '<p><br></p>',
    ),
    'html' => 
    array (
      1 => '<a href="#"><img src="image/catalog/petshop/banner-03.png" alt="Banner" style="margin: 77px auto 0px auto;display: block" class="responsive-margin-top-45"></a>',
      $language_id => '<a href="#"><img src="image/catalog/petshop/banner-03.png" alt="Banner" style="margin: 77px auto 0px auto;display: block" class="responsive-margin-top-45"></a>',
    ),
    'layout_id' => '1',
    'position' => 'preface_fullwidth',
    'status' => '1',
    'sort_order' => '3',
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