<?php $theme_options = $registry->get('theme_options');
$config = $registry->get('config'); ?>
<?php 
if($position == 'footer_bottom' || $position == 'footer' || $position == 'footer_top' || $position == 'footer_left' || $position == 'footer_right' || $position == 'customfooter_top' || $position == 'customfooter_bottom' || $position == 'customfooter') {
	echo '<h4>'.$module['content']['title'].'</h4>';
	echo '<div class="strip-line"></div>';
	
	echo '<div class="clearfix default-newsletter" style="clear: both" id="newsletter' . $id .'">';
          if($module['content']['text'] != '') echo '<p>' . $module['content']['text'] . '</p>';
          echo '<input type="text" class="email" placeholder="' . $module['content']['input_placeholder'] . '" />';
          echo '<a class="button subscribe">' . $module['content']['subscribe_text'] . '</a>';
          if($module['content']['unsubscribe_text'] != '') {
          	echo '<a class="button unsubscribe">' . $module['content']['unsubscribe_text'] . '</a>';
          }
     echo '</div>';
} else {
	echo '<div class="box">';
		echo '<div class="box-heading">';
			echo $module['content']['title'];
		echo '</div>';
		echo '<div class="strip-line"></div>';
		echo '<div class="box-content">';
               echo '<div class="clearfix" style="clear: both" id="newsletter' . $id . '">';
                    if($module['content']['text'] != '') echo '<p>' . $module['content']['text'] . '</p>';
                    echo '<input type="text" class="email" placeholder="' . $module['content']['input_placeholder'] . '" style="margin: 5px 5px 5px 0px;height: 33px;vertical-align: top" />';
                    echo '<a class="button subscribe" style="margin: 5px 0px">' . $module['content']['subscribe_text'] . '</a>';
                    if($module['content']['unsubscribe_text'] != '') {
                    	echo '<a class="button unsubscribe" style="margin: 5px 0px 5px 20px">' . $module['content']['unsubscribe_text'] . '</a>';
                    }
               echo '</div>';
		echo '</div>';
	echo '</div>';	
} ?>

<?php if($theme_options->get( 'rodo_status' ) == '1') { ?>
	<div class="newsletter_rodo2">
		<form id="agree_rodo_form2">
			<input type="checkbox" name="agree_rodo2" value="1" required="required">&nbsp;<?php echo html_entity_decode($theme_options->get( 'rodo_text', $config->get( 'config_language_id' ) )); ?>
			<input type="submit" class="submit hidden" value="Submit">
		</form>
	</div>
<?php } ?>

<script type="text/javascript">
$(document).ready(function() {
	function Unsubscribe() {
		$.post('<?php echo $module['content']['unsubscribe_url']; ?>', 
			{ 
				email: $('#newsletter<?php echo $id; ?> .email').val() 
			}, function (e) {
				$('#newsletter<?php echo $id; ?> .email').val('');
				alert(e.message);
			}
		, 'json');
	}
	
	function Subscribe() {
		<?php if($theme_options->get( 'rodo_status' ) == '1') { ?>
		if($('input[name="agree_rodo2"]').is(':checked')) {
		<?php } ?>
		$.post('<?php echo $module['content']['subscribe_url']; ?>', 
			{ 
				email: $('#newsletter<?php echo $id; ?> .email').val() 
			}, function (e) {
				if(e.error === 1) {
					var r = confirm(e.message);
					if (r == true) {
					    $.post('<?php echo $module['content']['unsubscribe_url']; ?>', { 
					    	email: $('#newsletter<?php echo $id; ?> .email').val() 
					    }, function (e) {
					    	$('#newsletter<?php echo $id; ?> .email').val('');
					    	alert(e.message);
					    }, 'json');
					}
				} else {
					$('#newsletter<?php echo $id; ?> .email').val('');
					alert(e.message);
				}
			}
		, 'json');
		<?php if($theme_options->get( 'rodo_status' ) == '1') { ?>
		} else {
			$('#agree_rodo_form2 .submit').click();
		}
		<?php } ?>
	}
	
	$('#newsletter<?php echo $id; ?> .subscribe').click(Subscribe);
	$('#newsletter<?php echo $id; ?> .unsubscribe').click(Unsubscribe);
	$('#newsletter<?php echo $id; ?> .email').keypress(function (e) {
	    if (e.which == 13) {
	        Subscribe();
	    }
	});
});
</script>