<?php
class ModelSettingHoliday extends Model {
    public function getHoliday()
    {
        $sql = "SELECT * FROM oc_holiday";
		return $this->db->query($sql)->rows;
    }

    public function addHoliday($date)
    {
        $this->db->query("INSERT INTO `" . DB_PREFIX . "holiday` SET `holiday_date` = '" . $this->db->escape($date) . "'");
    }
    
    public function removeHoliday($date)
    {
        $this->db->query("DELETE FROM `" . DB_PREFIX . "holiday` WHERE `holiday_date` = '" . $this->db->escape($date) . "'");
    }
}
?>