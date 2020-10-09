<?php
class ModelApiCredit extends Model{

    public function checkCustomer($customerID)
    {
        $check=true;
        $sql = "SELECT email
    		  FROM oc_customer
    		  WHERE customer_id='" . (int) $customerID . "' 
    	";
		$query = $this->db->query($sql);
        if($query->row==null)
        {
            $check=false;
        }
        return $check;
    }
    public function topUp($customerID,$credit,$description,$reference)
    {
        $this->db->query("INSERT INTO `" . DB_PREFIX . "customer_credit` SET customer_id = '" . (int)$customerID . "', credit = '" . (float)$credit . "', date_added = NOW(),reference='".(int)$reference."',description='".$this->db->escape($description)."'");
	
		return $this->db->getLastId();
    }

    public function getCreditById($customerID)
    {
        $sql = "SELECT SUM(credit)AS total
        FROM oc_customer_credit
        WHERE customer_id='" . (int) $customerID . "' 
        ";
        $query = $this->db->query($sql);
        return $query->row;
    }
}
?>