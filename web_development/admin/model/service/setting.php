<?php
	class ModelServiceSetting extends Model{

		// service_setting_id	service_setting	

		private $mdb = DB_PREFIX.'service_setting';
		private $defaultSetting = array(
			"cancellation_time" => 12,
			"business_hour" => array(
				"Monday" 		=> array(
					 "is_open"			=> 1
					, "start_time" 		=> "8.00"
					, "start_meridiem" 	=> "AM"
					, "end_time"        => "10.00"
					, "end_meridiem"	=> "PM"
				)
				,"Tuesday" 		=> array(
					 "is_open"			=> 1
					, "start_time" 		=> "8.00"
					, "start_meridiem" 	=> "AM"
					, "end_time"        => "10.00"
					, "end_meridiem"	=> "PM"
				)
				,"Wednesday" 	=> array(
					 "is_open"			=> 1
					, "start_time" 		=> "8.00"
					, "start_meridiem" 	=> "AM"
					, "end_time"        => "10.00"
					, "end_meridiem"	=> "PM"
				)
				,"Thursday" 	=> array(
					 "is_open"			=> 1
					, "start_time" 		=> "8.00"
					, "start_meridiem" 	=> "AM"
					, "end_time"        => "10.00"
					, "end_meridiem"	=> "PM"
				)
				,"Friday" 		=> array(
					 "is_open"			=> 1
					, "start_time" 		=> "8.00"
					, "start_meridiem" 	=> "AM"
					, "end_time"        => "10.00"
					, "end_meridiem"	=> "PM"
				)
				,"Saturday" 	=> array(
					 "is_open"			=> 0
					, "start_time" 		=> "8.00"
					, "start_meridiem" 	=> "AM"
					, "end_time"        => "10.00"
					, "end_meridiem"	=> "PM"
				)
				,"Sunday" 		=> array(
					 "is_open"			=> 0
					, "start_time" 		=> "8.00"
					, "start_meridiem" 	=> "AM"
					, "end_time"        => "10.00"
					, "end_meridiem"	=> "PM"
				)
			)
		);

		public function updateSetting($data){
			$sql = sprintf("
					UPDATE %s
					SET 
						service_setting='%s';
				"
				, $this->mdb
				, $this->db->escape($data));
			$this->db->query($sql);	
		}

		private function restoreDefaultSettings(){
			$this->db->query('DELETE FROM '.$this->mdb);
			$sql = sprintf("
					INSERT INTO %s
					SET
						service_setting='%s'
				"
				, $this->mdb
				, json_encode($this->defaultSetting));
			$this->db->query($sql);
		}

		public function getSetting(){
			$sql = "SELECT service_setting FROM ". $this->mdb;
			$rows = $this->db->query($sql)->rows;

			if(count($rows) != 1){
				$this->restoreDefaultSettings();
				return $this->db->query($sql)->row;
			} else{
				return $rows[0];
			}
		}
	}
?>