<?php

final class Obfuscate {
	
	public function encrypt ($value) {
		return base64_encode(serialize($value));	}
	

	public function decrypt($value) {
		return unserialize(base64_decode($value));
	}
}

?>