<?php
	class ModelAppointmentAppointment extends Model{

		/*
			1
			ACCEPTED

			2
			REJECTED

			3
			PENDING

			4
			CANCELLED

			5
			CLOSE
		*/
		public function getAppointmentList($data = array()){
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

		public function getAppointmentById($appointment_id){
			$sql = "
					SELECT 
						oc_appointment.appointment_id, oc_appointment.appointment_date,oc_appointment_status.status, oc_user.user_id, oc_appointment.appointment_address, CONCAT(oc_user.firstname, ' ', oc_user.lastname) as user_name, CONCAT(oc_customer.firstname, ' ', oc_customer.lastname) as customer_name, oc_customer.telephone, GROUP_CONCAT(oc_service.service_name) as services
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

			$whereClause = "WHERE oc_appointment.appointment_id=$appointment_id";

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

			return $this->db->query($sql)->row;
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

		public function getAppointmentStatusList(){
			$sql = "SELECT * FROM ".DB_PREFIX."appointment_status";
			return $this->db->query($sql)->rows;
		}

		public function getServiceByAppointmentId($appointmentId){
			$sql = "SELECT *
					FROM oc_appointment_service
					LEFT JOIN oc_service ON oc_service.service_id = oc_appointment_service.service_id
					WHERE oc_appointment_service.appointment_id=".$this->db->escape($appointmentId);
				
			return $this->db->query($sql)->rows;
		}

		public function updateAppointmentInfo($data){
			$sql = sprintf("
					UPDATE oc_appointment
					SET 
						appointment_address='%s',
						appointment_date=str_to_date('%s', '%s'),
						user_id=%d
					WHERE
						appointment_id=%d
				"
				,$this->db->escape($data['appointment_address'])
				,$this->db->escape($data['appointment_date'])
				,'%Y-%m-%d %l:%i%p'
				,$this->db->escape($data['user_id'])
				,$this->db->escape($data['appointment_id']));

			$this->db->query($sql);

			$sql = "DELETE FROM oc_appointment_service WHERE appointment_id=".$this->db->escape($data['appointment_id']);
			$this->db->query($sql);

			$sql = "INSERT INTO oc_appointment_service(appointment_id, service_id, qty) VALUES ";
			foreach($data['services'] as $serviceId => $qty){
				$sql .= sprintf("(%d,%d,%d),"
								, $this->db->escape($data['appointment_id'])
								, $this->db->escape($serviceId)
								, $this->db->escape($qty));
			}
			$sql = rtrim($sql, ',');
			$this->db->query($sql);
		}

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

	}



?>