<?php 

$language_id = 2;
foreach($data['languages'] as $language) {
	if($language['language_id'] != 1) {
		$language_id = $language['language_id'];
	}
}

$output = array();
$output["advanced_grid_module"] = array (
  1 => 
  array (
    'custom_class' => 'font-size-14',
    'margin_top' => '0',
    'margin_right' => '0',
    'margin_bottom' => '0',
    'margin_left' => '0',
    'padding_top' => '0',
    'padding_right' => '0',
    'padding_bottom' => '0',
    'padding_left' => '0',
    'force_full_width' => '0',
    'background_color' => '',
    'background_image_type' => '0',
    'background_image' => '',
    'background_image_position' => 'top left',
    'background_image_repeat' => 'no-repeat',
    'background_image_attachment' => 'scroll',
    'layout_id' => '99999',
    'position' => 'footer',
    'status' => '1',
    'sort_order' => '',
    'disable_on_mobile' => '0',
    'column' => 
    array (
      1 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '1',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'links',
            'links' => 
            array (
              'module_layout' => 'default.tpl',
              'title' => 
              array (
                1 => 'Information',
                $language_id => 'Information',
              ),
              'limit' => '5',
              'array' => 
              array (
                1 => 
                array (
                  'name' => 
                  array (
                    1 => 'About Us',
                    $language_id => 'About Us',
                  ),
                  'url' => 'index.php?route=information/information&amp;information_id=4',
                  'sort' => '1',
                ),
                2 => 
                array (
                  'name' => 
                  array (
                    1 => 'Delivery Information',
                    $language_id => 'Delivery Information',
                  ),
                  'url' => 'index.php?route=information/information&amp;information_id=6',
                  'sort' => '2',
                ),
                3 => 
                array (
                  'name' => 
                  array (
                    1 => 'Privacy Policy',
                    $language_id => 'Privacy Policy',
                  ),
                  'url' => '/index.php?route=information/information&amp;information_id=3',
                  'sort' => '3',
                ),
                4 => 
                array (
                  'name' => 
                  array (
                    1 => 'Terms &amp; Conditions',
                    $language_id => 'Terms &amp; Conditions',
                  ),
                  'url' => 'index.php?route=information/information&amp;information_id=5',
                  'sort' => '4',
                ),
              ),
            ),
          ),
        ),
      ),
      2 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '2',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'links',
            'links' => 
            array (
              'module_layout' => 'default.tpl',
              'title' => 
              array (
                1 => 'Customer Service',
                $language_id => 'Customer Service',
              ),
              'limit' => '5',
              'array' => 
              array (
                5 => 
                array (
                  'name' => 
                  array (
                    1 => 'Contact Us',
                    $language_id => 'Contact Us',
                  ),
                  'url' => 'index.php?route=information/contact',
                  'sort' => '1',
                ),
                6 => 
                array (
                  'name' => 
                  array (
                    1 => 'Returns',
                    $language_id => 'Returns',
                  ),
                  'url' => 'index.php?route=account/return/add',
                  'sort' => '2',
                ),
                7 => 
                array (
                  'name' => 
                  array (
                    1 => 'Site Map',
                    $language_id => 'Site Map',
                  ),
                  'url' => 'index.php?route=information/sitemap',
                  'sort' => '3',
                ),
              ),
            ),
          ),
        ),
      ),
      3 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '3',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'links',
            'links' => 
            array (
              'module_layout' => 'default.tpl',
              'title' => 
              array (
                1 => 'Extras',
                $language_id => 'Extras',
              ),
              'limit' => '5',
              'array' => 
              array (
                8 => 
                array (
                  'name' => 
                  array (
                    1 => 'Brands',
                    $language_id => 'Brands',
                  ),
                  'url' => 'index.php?route=product/manufacturer',
                  'sort' => '1',
                ),
                9 => 
                array (
                  'name' => 
                  array (
                    1 => 'Gift Vouchers',
                    $language_id => 'Gift Vouchers',
                  ),
                  'url' => 'index.php?route=account/voucher',
                  'sort' => '2',
                ),
                10 => 
                array (
                  'name' => 
                  array (
                    1 => 'Affiliates',
                    $language_id => 'Affiliates',
                  ),
                  'url' => 'index.php?route=affiliate/login',
                  'sort' => '3',
                ),
                11 => 
                array (
                  'name' => 
                  array (
                    1 => 'Specials',
                    $language_id => 'Specials',
                  ),
                  'url' => 'index.php?route=product/special',
                  'sort' => '4',
                ),
              ),
            ),
          ),
        ),
      ),
      4 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '4',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'links',
            'links' => 
            array (
              'module_layout' => 'default.tpl',
              'title' => 
              array (
                1 => 'My Account',
                $language_id => 'My Account',
              ),
              'limit' => '5',
              'array' => 
              array (
                12 => 
                array (
                  'name' => 
                  array (
                    1 => 'My Account',
                    $language_id => 'My Account',
                  ),
                  'url' => 'index.php?route=account/login',
                  'sort' => '1',
                ),
                13 => 
                array (
                  'name' => 
                  array (
                    1 => 'Order History',
                    $language_id => 'Order History',
                  ),
                  'url' => 'index.php?route=account/login',
                  'sort' => '2',
                ),
                14 => 
                array (
                  'name' => 
                  array (
                    1 => 'Wish List',
                    $language_id => 'Wish List',
                  ),
                  'url' => 'index.php?route=account/login',
                  'sort' => '3',
                ),
                15 => 
                array (
                  'name' => 
                  array (
                    1 => 'Newsletter',
                    $language_id => 'Newsletter',
                  ),
                  'url' => 'index.php?route=account/login',
                  'sort' => '4',
                ),
              ),
            ),
          ),
        ),
      ),
      5 => 
      array (
        'status' => '1',
        'width' => '12',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '5',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'html',
            'html' => 
            array (
              1 => 'Powered By OpenCart. Your Store ?? 2015',
              $language_id => 'Powered By OpenCart. Your Store ?? 2015',
            ),
          ),
        ),
      ),
      6 => 
      array (
        'status' => '1',
        'width' => '12',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '0',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'html',
            'html' => 
            array (
              1 => '&lt;div class=&quot;sport-contact&quot;&gt;
     &lt;div class=&quot;row&quot;&gt;
          &lt;div class=&quot;col-sm-3&quot;&gt;
               &lt;img src=&quot;image/catalog/sport/icon-phone2.png&quot; alt=&quot;Phone&quot;&gt;
               &lt;div class=&quot;heading&quot; style=&quot;color: #30e502&quot;&gt;Call us&lt;/div&gt;
               &lt;p&gt;500-130-120&lt;/p&gt;
          &lt;/div&gt;
          
          &lt;div class=&quot;col-sm-4&quot;&gt;
               &lt;img src=&quot;image/catalog/sport/icon-mail.png&quot; alt=&quot;Mail&quot;&gt;
               &lt;div class=&quot;heading&quot; style=&quot;color: #da321c&quot;&gt;Send e-mail&lt;/div&gt;
               &lt;p&gt;contact@example.com&lt;/p&gt;
          &lt;/div&gt;
          
          &lt;div class=&quot;col-sm-5&quot; style=&quot;padding-left: 35px&quot;&gt;
               &lt;img src=&quot;image/catalog/sport/icon-support.png&quot; alt=&quot;Support&quot;&gt;
               &lt;div class=&quot;heading&quot; style=&quot;color: #025ab4&quot;&gt;NEED HELP WITH BUYING?&lt;/div&gt;
               &lt;p&gt;support@example.com&lt;/p&gt;
          &lt;/div&gt;
     &lt;/div&gt;
&lt;/div&gt;

&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/sport/banner-04.png&quot; style=&quot;margin-top: 44px;margin-bottom: 18px;display: block&quot; class=&quot;responsive-margin-top-30&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;',
              $language_id => '&lt;div class=&quot;sport-contact&quot;&gt;
     &lt;div class=&quot;row&quot;&gt;
          &lt;div class=&quot;col-sm-3&quot;&gt;
               &lt;img src=&quot;image/catalog/sport/icon-phone2.png&quot; alt=&quot;Phone&quot;&gt;
               &lt;div class=&quot;heading&quot; style=&quot;color: #30e502&quot;&gt;Call us&lt;/div&gt;
               &lt;p&gt;500-130-120&lt;/p&gt;
          &lt;/div&gt;
          
          &lt;div class=&quot;col-sm-4&quot;&gt;
               &lt;img src=&quot;image/catalog/sport/icon-mail.png&quot; alt=&quot;Mail&quot;&gt;
               &lt;div class=&quot;heading&quot; style=&quot;color: #da321c&quot;&gt;Send e-mail&lt;/div&gt;
               &lt;p&gt;contact@example.com&lt;/p&gt;
          &lt;/div&gt;
          
          &lt;div class=&quot;col-sm-5&quot; style=&quot;padding-left: 35px&quot;&gt;
               &lt;img src=&quot;image/catalog/sport/icon-support.png&quot; alt=&quot;Support&quot;&gt;
               &lt;div class=&quot;heading&quot; style=&quot;color: #025ab4&quot;&gt;NEED HELP WITH BUYING?&lt;/div&gt;
               &lt;p&gt;support@example.com&lt;/p&gt;
          &lt;/div&gt;
     &lt;/div&gt;
&lt;/div&gt;

&lt;a href=&quot;#&quot;&gt;&lt;img src=&quot;image/catalog/sport/banner-04.png&quot; style=&quot;margin-top: 44px;margin-bottom: 18px;display: block&quot; class=&quot;responsive-margin-top-30&quot; alt=&quot;Banner&quot;&gt;&lt;/a&gt;',
            ),
          ),
        ),
      ),
    ),
  ),
  2 => 
  array (
    'custom_class' => '',
    'margin_top' => '10',
    'margin_right' => '0',
    'margin_bottom' => '0',
    'margin_left' => '0',
    'padding_top' => '0',
    'padding_right' => '0',
    'padding_bottom' => '0',
    'padding_left' => '0',
    'force_full_width' => '1',
    'background_color' => '',
    'background_image_type' => '1',
    'background_image' => 'catalog/sport/bg-newsletter.png',
    'background_image_position' => 'top center',
    'background_image_repeat' => 'no-repeat',
    'background_image_attachment' => 'scroll',
    'layout_id' => '1',
    'position' => 'customfooter',
    'status' => '1',
    'sort_order' => '',
    'disable_on_mobile' => '0',
    'column' => 
    array (
      7 => 
      array (
        'status' => '1',
        'width' => '12',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '1',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'newsletter',
            'newsletter' => 
            array (
              'module_layout' => 'sport_newsletter.tpl',
              'title' => 
              array (
                1 => 'newsletter',
                $language_id => 'newsletter',
              ),
              'text' => 
              array (
                1 => 'Subscribe now
&lt;p&gt;Get -25% discount&lt;/p&gt;',
                $language_id => 'Subscribe now
&lt;p&gt;Get -25% discount&lt;/p&gt;',
              ),
              'input_placeholder' => 
              array (
                1 => 'E-mail address',
                $language_id => 'E-mail address',
              ),
              'subscribe_text' => 
              array (
                1 => 'Ok',
                $language_id => 'Ok',
              ),
              'unsubscribe_text' => 
              array (
                1 => '',
                $language_id => '',
              ),
            ),
          ),
        ),
      ),
    ),
  ),
  3 => 
  array (
    'custom_class' => '',
    'margin_top' => '0',
    'margin_right' => '0',
    'margin_bottom' => '0',
    'margin_left' => '0',
    'padding_top' => '0',
    'padding_right' => '0',
    'padding_bottom' => '0',
    'padding_left' => '0',
    'force_full_width' => '0',
    'background_color' => '',
    'background_image_type' => '0',
    'background_image' => '',
    'background_image_position' => 'top left',
    'background_image_repeat' => 'no-repeat',
    'background_image_attachment' => 'scroll',
    'layout_id' => '1',
    'position' => 'content_bottom',
    'status' => '1',
    'sort_order' => '1',
    'disable_on_mobile' => '0',
    'column' => 
    array (
      8 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '1',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'products',
            'products' => 
            array (
              'module_layout' => 'sport_products.tpl',
              'title' => 
              array (
                1 => '&lt;img src=&quot;image/catalog/sport/football.png&quot; alt=&quot;Football&quot;&gt;',
                $language_id => '&lt;img src=&quot;image/catalog/sport/football.png&quot; alt=&quot;Football&quot;&gt;',
              ),
              'get_products_from' => 'products',
              'product' => '',
              'products' => '46,41,40',
              'category' => '',
              'categories' => '',
              'width' => '83',
              'height' => '83',
              'limit' => '3',
            ),
          ),
        ),
      ),
      9 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '2',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'products',
            'products' => 
            array (
              'module_layout' => 'sport_products.tpl',
              'title' => 
              array (
                1 => '&lt;img src=&quot;image/catalog/sport/running.png&quot; alt=&quot;Running&quot;&gt;',
                $language_id => '&lt;img src=&quot;image/catalog/sport/running.png&quot; alt=&quot;Running&quot;&gt;',
              ),
              'get_products_from' => 'products',
              'product' => '',
              'products' => '43,45,29',
              'category' => '',
              'categories' => '',
              'width' => '83',
              'height' => '83',
              'limit' => '3',
            ),
          ),
        ),
      ),
      10 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '3',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'products',
            'products' => 
            array (
              'module_layout' => 'sport_products.tpl',
              'title' => 
              array (
                1 => '&lt;img src=&quot;image/catalog/sport/basketball.png&quot; alt=&quot;Basketball&quot;&gt;',
                $language_id => '&lt;img src=&quot;image/catalog/sport/basketball.png&quot; alt=&quot;Basketball&quot;&gt;',
              ),
              'get_products_from' => 'products',
              'product' => 's',
              'products' => '36,34,46',
              'category' => '',
              'categories' => '',
              'width' => '83',
              'height' => '83',
              'limit' => '3',
            ),
          ),
        ),
      ),
      11 => 
      array (
        'status' => '1',
        'width' => '3',
        'disable_on_mobile' => '0',
        'width_xs' => '1',
        'width_sm' => '1',
        'width_md' => '1',
        'width_lg' => '1',
        'sort' => '4',
        'module' => 
        array (
          1 => 
          array (
            'status' => '1',
            'sort' => '1',
            'type' => 'products',
            'products' => 
            array (
              'module_layout' => 'sport_products.tpl',
              'title' => 
              array (
                1 => '&lt;img src=&quot;image/catalog/sport/hockey.png&quot; alt=&quot;Hockey&quot;&gt;',
                $language_id => '&lt;img src=&quot;image/catalog/sport/hockey.png&quot; alt=&quot;Hockey&quot;&gt;',
              ),
              'get_products_from' => 'products',
              'product' => '',
              'products' => '46,43,29',
              'category' => '',
              'categories' => '',
              'width' => '83',
              'height' => '83',
              'limit' => '3',
            ),
          ),
        ),
      ),
    ),
  ),
); 

$output2 = array();
$output2["advanced_grid_module"] = $this->config->get('advanced_grid_module');

if(!is_array($output["advanced_grid_module"])) $output["advanced_grid_module"] = array();
if(!is_array($output2["advanced_grid_module"])) $output2["advanced_grid_module"] = array();
$output3 = array();
$output3["advanced_grid_module"] = array_merge($output["advanced_grid_module"], $output2["advanced_grid_module"]);

$this->model_setting_setting->editSetting( "advanced_grid", $output3 );		

?>