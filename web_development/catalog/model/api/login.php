<?php

class ModelApiLogin extends Model{
	public function validateCustomerAccount ($email,$password){
		$query = $this->db->query("SELECT customer_id FROM oc_customer WHERE LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "' AND (password = SHA1(CONCAT(salt, SHA1(CONCAT(salt, SHA1('" . $this->db->escape($password) . "'))))) OR password = '" . $this->db->escape(md5($password)) . "')");

		return $query->row;
	}
}

?>