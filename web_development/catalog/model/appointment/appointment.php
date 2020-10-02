<?php

class ModelAppointmentAppointment extends Model{

	public function getAllAppointmentByDate($date){
		$sql = sprintf("
			SELECT 
				oc_a.*, SUM(oc_s.service_duration * oc_as.qty) as total_duration
			FROM 
				oc_appointment oc_a, oc_appointment_service oc_as, oc_service oc_s
			WHERE 
				YEAR(appointment_date) = YEAR('%1\$s')
			AND
				MONTH(appointment_date) = MONTH('%1\$s')
			AND 
				DAY(appointment_date) = DAY('%1\$s')
            AND
             	oc_a.appointment_id = oc_as.appointment_id
            AND
              	oc_as.service_id = oc_s.service_id
		"
		, $this->db->escape($date)
		);

		return $this->db->query($sql)->rows;
	}
}

?>