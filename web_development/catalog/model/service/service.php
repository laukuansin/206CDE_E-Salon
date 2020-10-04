<?php 

class ModelServiceService extends Model{

	// Table column
	// service_id	service_name	service_description	service_duration	service_price is_deleted
	private $mdb = DB_PREFIX."service";

	public function addService($data){
		$sql = "
			INSERT INTO 
				%s
			SET 
				service_name = '%s',
				service_description = '%s',
				service_duration =%d,
				service_price=%f,
				is_deleted=%d
			";

		$sql = sprintf($sql
			,$this->mdb
			,$this->db->escape($data['service_name'])
			,$this->db->escape($data['service_description'])
			,$this->db->escape($data['service_duration'])
			,$this->db->escape($data['service_price'])
			,0);

		$this->db->query($sql);
		return $this->db->getLastId();
	}

	public function getServices($data = array()){
		$sql = sprintf("SELECT * FROM  %s WHERE is_deleted=0 ", $this->mdb);
		$sort_data = array(
			'service_name'
			,'service_price'
		);

		if(isset($data['sort']) && in_array($data['sort'], $sort_data)){
			$sql .= 'ORDER BY '.$data['sort'];
		} else {
			$sql .= 'ORDER BY service_name';
		}

		if(isset($data['order']) && $data['order'] == 'DESC'){
			$sql .= ' DESC';
		} else {
			$sql .= ' ASC';
		}

		return $this->db->query($sql)->rows;
	}

	public function getService($service_id){
		$sql = sprintf("SELECT * FROM %s WHERE service_id = %d AND is_deleted=0"
				, $this->mdb
				, $this->db->escape($service_id));

		return $this->db->query($sql)->row;
	}

	public function editService($service_id, $data){
		$sql = sprintf("
			UPDATE %s
			SET 
				is_deleted=1
			WHERE 
				service_id=%d
		"
		, $this->mdb
		, $this->db->escape($service_id));

		$this->db->query($sql);
		$this->addService($data);
	}

	public function deleteService($service_id){
		$sql = sprintf("
			UPDATE %s
			SET 
				is_deleted=1
			WHERE 
				service_id=%d
		"
		, $this->mdb
		, $this->db->escape($service_id));
		
		$this->db->query($sql);
	}

}