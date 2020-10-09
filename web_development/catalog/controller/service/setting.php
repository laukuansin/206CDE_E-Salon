<?php
	class ModelServiceSetting extends Model{

		// service_setting_id	service_setting	

		private $mdb = DB_PREFIX.'service_setting';
		
		public function getSetting(){
			$sql = "SELECT service_setting FROM ". $this->mdb;
			return $this->db->query($sql)->rows;
		}
	}
?>