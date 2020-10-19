<?php

class ModelAppointmentAppointment extends Model{

	public function getAllAppointmentByDate($date){
		$sql = sprintf("
			SELECT 
				oc_a.*, SUM(oc_s.service_duration * oc_as.qty) as total_duration
			FROM 
				%1\$sappointment oc_a, %1\$sappointment_service oc_as, %1\$sservice oc_s
			WHERE 
				YEAR(appointment_date) = YEAR('%2\$s')
			AND
				MONTH(appointment_date) = MONTH('%2\$s')
			AND 
				DAY(appointment_date) = DAY('%2\$s')
            AND
             	oc_a.appointment_id = oc_as.appointment_id
            AND
              	oc_as.service_id = oc_s.service_id
            GROUP BY 
            	appointment_id
		"
		, DB_PREFIX
		, $this->db->escape($date)
		);

		return $this->db->query($sql)->rows;
	}

	public function insertAppointment($data){
		$sql = sprintf("
			INSERT INTO 
				%1\$sappointment
			SET
				customer_id='%2\$s',
				appointment_note=' ',
				appointment_address='%3\$s',
				appointment_date=str_to_date('%4\$s', '%5\$s'),
				status_id=3,
				user_id='%6\$s'
		"
		, DB_PREFIX
		, $this->db->escape($data['customer_id'])
		, $this->db->escape($data['appointment_address'])
		, $this->db->escape($data['appointment_date'])
		, '%Y-%m-%d %l:%i%p' // Format
		, $this->db->escape($data['user_id'])
		);

		$this->db->query($sql);
		$appointmentId = $this->db->getLastId();
		$this->insertAppointmentService($appointmentId, $data['services']);
	}

	private function insertAppointmentService($appointmentId, $data){
		$sql = "INSERT INTO ".DB_PREFIX."appointment_service(appointment_id, service_id, qty) VALUES ";

		foreach($data as $service_id => $qty)
			$sql .= '('. $appointmentId.','.$service_id.','.$qty.'),';
		
		$sql = rtrim($sql, ',');		
		$this->db->query($sql);
	}

	public function getCustomerAppointmentList($data = array()){
		$sql = "
				SELECT 
					oc_appointment.appointment_id, oc_appointment.appointment_date,oc_appointment_status.status,oc_appointment_status.status_id, oc_appointment.appointment_address, oc_user.user_id, oc_user.image, oc_user.telephone AS worker_telephone ,CONCAT(oc_user.firstname, ' ', oc_user.lastname) as user_name, oc_customer.customer_id, CONCAT(oc_customer.firstname, ' ', oc_customer.lastname) as customer_name, oc_customer.telephone, GROUP_CONCAT(oc_service.service_name) as services, GROUP_CONCAT(oc_service.service_id) as services_id
				FROM 
					oc_appointment
				LEFT JOIN oc_appointment_status ON oc_appointment.status_id = oc_appointment_status.status_id
				LEFT JOIN oc_appointment_service ON oc_appointment.appointment_id = oc_appointment_service.appointment_id
				LEFT JOIN oc_customer ON oc_customer.customer_id = oc_appointment.customer_id
				LEFT JOIN oc_service ON oc_service.service_id = oc_appointment_service.service_id
                LEFT JOIN oc_user ON oc_user.user_id = oc_appointment.user_id
				%s
				GROUP BY oc_appointment_service.appointment_id
			";

		$whereClause = 'WHERE true ';


		if(isset($data['filter_status']) && $data['filter_status'] != -1){
			$whereClause .=" AND oc_appointment.status_id IN(".$data['filter_status'].")";	
		} 

		if(isset($data['not_status_id'])){
			$whereClause .=" AND NOT oc_appointment.status_id=".$data['not_status_id'];	
		} 

		if(isset($data['filter_worker']) && $data['filter_worker'] != -1){
			$whereClause .=" AND oc_user.user_id=".$data['filter_worker'];
		}
		if(isset($data['filter_customer']) && $data['filter_customer'] != -1){
			$whereClause .=" AND oc_customer.customer_id=".$data['filter_customer'];
		}

		$sql = sprintf($sql, $whereClause);

		$sort_data = array(
			'customer_name'
			,'date'
		);

		if(isset($data['sort']) && in_array($data['sort'], $sort_data)){
			$sql .= ' ORDER BY '.$data['sort'];
		} else {
			$sql .= ' ORDER BY appointment_date';
		}

		if(isset($data['order']) && $data['order'] == 'DESC'){
			$sql .= ' DESC';
		} else {
			$sql .= ' ASC';
		}

		return $this->db->query($sql)->rows;
	}

	public function getCustomerAppointmentSales($customerId){
		return $this->db->query("SELECT * FROM oc_appointment_sales WHERE customer_id = $customerId")->rows;
	}

	public function acceptAppointment($appointmentId){
		$this->udpateAppointmentStatus($appointmentId, 1);
	}

	public function rejectAppointment($appointmentId){
		$this->udpateAppointmentStatus($appointmentId, 2);
	}

	public function cancelAppointment($appointmentId){
		$this->udpateAppointmentStatus($appointmentId, 4);
	}

	public function closeAppointment($appointmentId){
		$this->udpateAppointmentStatus($appointmentId, 5);
	}


	private function udpateAppointmentStatus($appointmentId, $statusId){
		$sql = sprintf("
			UPDATE %sappointment 
			SET status_id=%d
			WHERE appointment_id=%d
			"
			, DB_PREFIX
			, $this->db->escape($statusId)
			, $this->db->escape($appointmentId)
		);

		$this->db->query($sql);
	}


}

?>