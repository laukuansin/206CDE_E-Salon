<?php
    class ModelApiStaff extends Model{
        public function validateUsername($username)
        {
            $check=false;
            $sql = "SELECT user_id
    		  FROM oc_user
    		  WHERE username='".$username."' 
            ";
            $query = $this->db->query($sql);
            if($query->row==null)
            {
                $check=true;
            }
            return $check;
        }
        public function validateEmail($email)
        {
            $check=false;
            $sql = "SELECT user_id
    		  FROM oc_user
    		  WHERE email='".$email."' 
            ";
            $query = $this->db->query($sql);
            if($query->row==null)
            {
                $check=true;
            }
            return $check;
        }
        public function addStaff($username,$userGroup,$firstname,$lastname,$email,$image,$password,$status)
        {
            $image_folder_name = DIR_IMAGE . 'catalog/';
            //create cert dir if not exists
            if (!file_exists($image_folder_name)) {
                mkdir($image_folder_name, 0777, true);
            }
            $data_url_image = false;
            if ($image['image']['name']) {

                $img_name = md5(rand(0, 1000) . rand(0, 1000) . rand(0, 1000)) . '.jpg';
                $upload_path_image = $image_folder_name . $img_name;
                $data_url_image = 'catalog/' . $img_name;
                move_uploaded_file($image['image']['tmp_name'], $upload_path_image);

            }

            $this->db->query("INSERT INTO `" . DB_PREFIX . "user` SET username = '" . $this->db->escape($username) . "', user_group_id = '" . (int)$userGroup . "', salt = '" . $this->db->escape($salt = token(9)) . "', password = '" . $this->db->escape(sha1($salt . sha1($salt . sha1($password)))) . "', firstname = '" . $this->db->escape($firstname) . "', lastname = '" . $this->db->escape($lastname) . "', email = '" . $this->db->escape($email) . "', image = '" . $this->db->escape($data_url_image) . "', status = '" . (int)$status . "', date_added = NOW()");
	
		    return $this->db->getLastId();
        }
        public function addAppToken($token,$userID)
        {
            $sql = "UPDATE oc_user
            SET app_token='".$token."'
            WHERE user_id='".(int)$userID."'
    	";
		    $query = $this->db->query($sql);
        }
    }
?>