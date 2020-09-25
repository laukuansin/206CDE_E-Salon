<?php $theme_options = $registry->get('theme_options');
$config = $registry->get('config'); ?>

<div id="popup-<?php echo $module_id; ?>" class="popup <?php if(!$ajax) { echo 'mfp-hide'; } ?>" style="<?php if($content_width > 100) { echo 'max-width: ' . $content_width . 'px;'; } if($background_color != '') { echo 'background-color: ' . $background_color . ';'; } if($background_image != '') { echo 'background-image: url(image/' . $background_image . ');background-position: ' . $background_image_position . ';background-repeat: ' . $background_image_repeat . ';'; } ?>">
     <?php 
          if($type == 1) {
               if($newsletter_popup_title != '') echo '<h4>' . $newsletter_popup_title . '</h4>';
               echo '<div class="content">' . $newsletter_popup_text . '</div>';
               echo '<div class="newsletter">';
               echo '     <input type="text" class="email" placeholder="' . $newsletter_input_placeholder . '" />';
               echo '     <a class="button subscribe">' . $newsletter_subscribe_button_text . '</a>';
               echo '</div>'; ?>
               
			<?php if($theme_options->get( 'rodo_status' ) == '1') { ?>
				<div style="padding: 15px 0px 0px 0px">
					<form id="agree_rodo_form">
						<input type="checkbox" name="agree_rodo" value="1" required="required">&nbsp;<?php echo html_entity_decode($theme_options->get( 'rodo_text', $config->get( 'config_language_id' ) )); ?>
						<input type="submit" class="submit hidden" value="Submit">
					</form>
				</div>
			<?php } ?>
          
               <script type="text/javascript">
               $(document).ready(function() {
               	function Subscribe() {
               		<?php if($theme_options->get( 'rodo_status' ) == '1') { ?>
               		if($('input[name="agree_rodo"]').is(':checked')) {
               		<?php } ?>
               		$.post('<?php echo $subscribe_url; ?>', 
               			{ 
               				email: $('#popup-<?php echo $module_id; ?> .email').val() 
               			}, function (e) {
               				if(e.error === 1) {
               					var r = confirm(e.message);
               					if (r == true) {
               					    $.post('<?php echo $unsubscribe_url; ?>', { 
               					    	email: $('#popup-<?php echo $module_id; ?> .email').val() 
               					    }, function (e) {
               					    	$('#popup-<?php echo $module_id; ?> .email').val('');
               					    	alert(e.message);
               					    }, 'json');
               					}
           					} else if(e.error === 0) {
           						$('#popup-<?php echo $module_id; ?> .email').val('');
           						alert(e.message);
           						$.magnificPopup.close();
               				} else {
               					$('#popup-<?php echo $module_id; ?> .email').val('');
               					alert(e.message);
               				}
               			}
               		, 'json');
               		<?php if($theme_options->get( 'rodo_status' ) == '1') { ?>
               		} else {
               			$('#agree_rodo_form .submit').click();
               		}
               		<?php } ?>
               	}
               	
               	$('#popup-<?php echo $module_id; ?> .subscribe').click(Subscribe);
               	$('#popup-<?php echo $module_id; ?> .email').keypress(function (e) {
               	    if (e.which == 13) {
               	        Subscribe();
               	    }
               	});
               });
               </script>     
     <?php
          } elseif($type == 2) {
               if($custom_popup_title != '') echo '<h4>' . $custom_popup_title . '</h4>';
               echo '<div class="content">' . $custom_popup_text . '</div>';
          } else {
               if($contact_form_popup_title != '') echo '<h4>' . $contact_form_popup_title . '</h4>'; ?>
               <form action="" method="post" enctype="multipart/form-data" id="contact" class="form-contact">
                    <?php if(isset($product_id)) { ?>
                    <input type="hidden" name="product_id" value="<?php echo $product_id; ?>" />
                    <?php } else if(isset($url)) { ?>
                    <input type="hidden" name="url" value="<?php echo $url; ?>" />
                    <?php } ?>
                    
                    <fieldset>
                      <div class="contact-label">
                        <label for="input-name">* <?php echo $entry_name; ?></label>
                        <div>
                          <input type="text" name="name" value="" id="input-name" class="form-control" />
                        </div>
                      </div>
                      <div class="contact-label">
                        <label for="input-email">* <?php echo $entry_email; ?></label>
                        <div>
                          <input type="text" name="email" value="" id="input-email" class="form-control" />
                        </div>
                      </div>
                      <div class="contact-label">
                        <label for="input-enquiry">* <?php echo $entry_enquiry; ?></label>
                        <div>
                          <textarea name="enquiry" rows="7" id="input-enquiry" class="form-control"></textarea>
                        </div>
                      </div>
                    </fieldset>
                    
					<?php if($theme_options->get( 'rodo_status' ) == '1') { ?>
						<div style="padding: 10px 0px 7px 0px"><input type="checkbox" name="agree_rodo" value="1" required="required">&nbsp;<?php echo html_entity_decode($theme_options->get( 'rodo_text', $config->get( 'config_language_id' ) )); ?></div>
					<?php } ?>
                    
                   <input class="btn btn-primary" type="submit" value="<?php echo $button_submit; ?>" />
               </form>
               
               <script type="text/javascript">
                    function IsEmail(email) {
                         var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                         return regex.test(email);
                    }
                    
                    $('#contact').bind('submit', function(){
                         var valid = true;
                         if($('#popup-<?php echo $module_id; ?> #input-name').val().length < 3 || $('#popup-<?php echo $module_id; ?> #input-name').val().length > 32){
                              $('#popup-<?php echo $module_id; ?> #input-name').addClass("error");
                              valid = false;
                         } else {
                              $('#popup-<?php echo $module_id; ?> #input-name').removeClass("error");
     
                         }
                         
                         if(IsEmail($('#popup-<?php echo $module_id; ?> #input-email').val())) {
                              $('#popup-<?php echo $module_id; ?> #input-email').removeClass("error");
                         } else {
                              $('#popup-<?php echo $module_id; ?> #input-email').addClass("error");
                              valid = false;
                         }
                         
                         if($('#popup-<?php echo $module_id; ?> #input-enquiry').val().length < 10 || $('#popup-<?php echo $module_id; ?> #input-enquiry').val().length > 3000){
                              $('#popup-<?php echo $module_id; ?> #input-enquiry').addClass("error");
                              valid = false;
                         } else {
                              $('#popup-<?php echo $module_id; ?> #input-enquiry').removeClass("error");
                         }
                         
                         if(valid) {
                              $.ajax({
                                     type: "POST",
                                     url: "<?php echo $contact_url; ?>",
                                     data: $("#popup-<?php echo $module_id; ?> #contact").serialize(), // serializes the form's elements.
                                     success: function(data)
                                     {
                                         alert(data); // show response from the php script.
                                         $.magnificPopup.close();
                                     }
                                   });
                                   
                              return false;
                         } else {
                              return false;
                         }
                    });
               </script>
     <?php                  
          }
     ?>
     
     <?php if($display_text_dont_show_again == 0 && !$ajax) { ?>
     <div class="dont-show-label">
         <label>
             <input type="checkbox" class="dont-show-me" />
             <span><?php echo $text_dont_show_again; ?></span>
         </label>
     </div>
     <?php } ?>
     
     <?php if($display_buttons_yes_no == 0 && !$ajax) { echo '<div class="buttons-yes-no"><a href="http://google.com" class="button btn-default">' . $no . '</a><a href="#" class="popup-modal-dismiss button">' . $yes . '</a></div>'; } ?>
</div>

<?php if(!$ajax) { ?>
<script type="text/javascript">
$(document).ready(function() {

<?php if($disable_on_desktop == 0) { ?>
if($(window).width() > 992) {
<?php } ?>

     <?php if($display_text_dont_show_again == 0 || $show_only_once == 0) { ?>
     $('#popup-<?php echo $module_id; ?> .dont-show-me').change(function () {
          if ($(this).is(':checked')) {
               localStorage.setItem('popup-module-<?php echo $module_id; ?>', 'yes');
          } else {
               localStorage.setItem('popup-module-<?php echo $module_id; ?>', 'no');
          }
     });
     
     if (localStorage.getItem('popup-module-<?php echo $module_id; ?>') != 'yes') {
          <?php if($show_only_once == 0) { ?>
          localStorage.setItem('popup-module-<?php echo $module_id; ?>', 'yes');
          <?php } ?>
     <?php } ?>

          var show_after = parseInt('<?php echo $show_after; ?>', 20);
          var autoclose_after = parseInt('<?php echo $autoclose_after; ?>', 20);
          setTimeout(function () {
            $.magnificPopup.open({
                items: {
                    src: '#popup-<?php echo $module_id; ?>',
                    type: 'inline'
                },
                tLoading: '',
                mainClass: 'popup-module mfp-with-zoom popup-type-<?php echo $type; ?>',
                removalDelay: 200,
                <?php if($display_buttons_yes_no == 0) { echo 'modal: true'; } ?>
            });
     
            if (autoclose_after > 0) {
                setTimeout(function () {
                    $.magnificPopup.close();
                }, autoclose_after);
            }
          }, show_after);
          
          <?php if($display_buttons_yes_no == 0) { ?>
          $(document).on('click', '.popup-modal-dismiss', function (e) {
               e.preventDefault();
               $.magnificPopup.close();
          });
          <?php } ?>
     
     <?php if($display_text_dont_show_again == 0 || $show_only_once == 0) { ?>
     }
     <?php } ?>

<?php if($disable_on_desktop == 0) { ?>
}
<?php } ?>

});
</script>
<?php } ?>