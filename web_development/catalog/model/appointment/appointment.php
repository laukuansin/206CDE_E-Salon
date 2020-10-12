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

	public function getAppointmentListAcceptedByCustomerID($customerId)
	{
		$sql ="
			SELECT 
				oc_a.appointment_id,oc_a.appointment_date,oc_a_s.status,oc_u.username
			FROM 
				oc_appointment oc_a
			LEFT JOIN oc_user oc_u
			ON	(oc_a.user_id=oc_u.user_id)
			LEFT JOIN oc_appointment_status oc_a_s
			ON (oc_a_s.status_id=oc_a.status_id)
			WHERE 
				oc_a.customer_id = '".(int)$customerId."' AND oc_a.status_id=1
			ORDER BY
				oc_a.appointment_date DESC
			
		"
		;
		return $this->db->query($sql)->rows;
	}
	
	public function getAppointmentListByCustomerID($customerId)
	{
		$sql ="
			SELECT 
				oc_a.appointment_id,oc_a.appointment_date,oc_a_s.status,oc_s.service_name
			FROM 
				oc_appointment oc_a
			LEFT JOIN oc_appointment_service oc_a_ser
			ON (oc_a.appointment_id=oc_a_ser.appointment_id)
			LEFT JOIN oc_service oc_s
			ON (oc_s.service_id=oc_a_ser.service_id)

			LEFT JOIN oc_appointment_status oc_a_s
			ON (oc_a_s.status_id=oc_a.status_id)
			WHERE 
				oc_a.customer_id = '".(int)$customerId."'
			ORDER BY
				oc_a.appointment_date DESC
			
		"
		;
		return $this->db->query($sql)->rows;
	}
}

?>