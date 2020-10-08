<?php 
	class ControllerApiAppointment extends Controller{
		public function getAppointments(){
			$json = array();

			if(!$this->user->isLogged()){
				$json['response'] = array(
					"status" => -1,
					"msg"	 => "Invalid token"
				);
			} else {
				$this->load->model('appointment/appointment');

				$filteredData = array(
					'not_status_id'=> 3
				);

				if(isset($this->request->get['worker'])){
					$data['selectedWorker'] = $this->request->get['worker'];
					$filteredData['filter_worker'] = $this->request->get['worker'];
				}

				if(isset($this->request->get['customer'])){
					$data['selectedCustomer'] = $this->request->get['customer'];
					$filteredData['filter_customer'] = $this->request->get['customer'];
				}
				if(isset($this->request->get['status'])){
					$data['selectedStatus'] = $this->request->get['status'];
					$filteredData['filter_status'] = $this->request->get['status'];
				}

				
				$appointmentResults = $this->model_appointment_appointment->getAppointmentList($filteredData);
				foreach($appointmentResults as $appointmentResult){
					$data['appointments'][] = array(
						'appointment_id'	=> $appointmentResult['appointment_id'],	
						'customer_name' 	=> $appointmentResult['customer_name'],
						'worker_name'		=> $appointmentResult['user_name'],
						'telephone'			=> $appointmentResult['telephone'],
						'address'			=> $appointmentResult['appointment_address'],
						'status'			=> $appointmentResult['status'],
						'appointment_date' 	=> date('Y-m-d g:ia', strtotime($appointmentResult['appointment_date'])),
						'services'			=> $appointmentResult['services'],		
					);
				}

				$json['response'] = array(
					"status" => 1,
					"msg"	 => "Success"
				);
				$json['appointments'] = $data['appointments'];

			}

			$this->response->setOutput(json_encode($json));
		}
	}
?>