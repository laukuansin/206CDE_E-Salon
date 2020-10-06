<?php
/**
 * @package		OpenCart
 * @author		Daniel Kerr
 * @copyright	Copyright (c) 2005 - 2017, OpenCart, Ltd. (https://www.opencart.com/)
 * @license		https://opensource.org/licenses/GPL-3.0
 * @link		https://www.opencart.com
*/

/**
* Encryption class
*/
final class Obfuscate {
	
	public function encrypt ($value) {
		return base64_encode(serialize($value));	}
	

	public function decrypt($value) {
		return unserialize(base64_decode($value));
	}
}