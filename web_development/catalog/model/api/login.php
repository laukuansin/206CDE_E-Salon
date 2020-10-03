<?php

    class ModelApiLogin extends Model{

        public function validateAccount($username,$password)
        {
            $sql = "SELECT user_id
    		  FROM oc_user
    		  WHERE username='".$username."' AND (password = SHA1(CONCAT(salt, SHA1(CONCAT(salt, SHA1('" . $this->db->escape($password) . "'))))) OR password = '" . $this->db->escape(md5($password)) . "')
            ";
            $query = $this->db->query($sql);
           return $query->row;
                
        }
    }
?>