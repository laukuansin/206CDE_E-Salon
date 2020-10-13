
<?php
	class ControllerApiAppointment extends Controller{
		public function getAllAppointments(){
			$json = array();

			if(!$this->user->isLogged() || $this->user->getId() != 1){
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
				
				$data['appointments'] = array();
				$appointmentResults = $this->model_appointment_appointment->getAppointmentList($filteredData);
				foreach($appointmentResults as $appointmentResult){
					$data['appointments'][] = array(
						'appointment_id'	=> $appointmentResult['appointment_id'],	
						'customer_id'		=> $appointmentResult['customer_id'],
						'customer_name' 	=> $appointmentResult['customer_name'],
						'worker_id'			=> $appointmentResult['user_id'],
						'worker_name'		=> $appointmentResult['user_name'],
						'telephone'			=> $appointmentResult['telephone'],
						'address'			=> $appointmentResult['appointment_address'],
						'status'			=> $appointmentResult['status'],
						'status_id'			=> (int)$appointmentResult['status_id'],
						'appointment_date' 	=> date('Y-m-d g:ia', strtotime($appointmentResult['appointment_date'])),
						'services'			=> $appointmentResult['services'],	
						'services_id'		=> $appointmentResult['services_id'],	
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


        public function getAppointmentRequests(){
            $json = array();

            if(!$this->user->isLogged() || $this->user->getId() != 1){
                $json['response'] = array(
                    "status" => -1,
                    "msg"    => "Invalid token"
                );
            } else {
                $this->load->model('appointment/appointment');

                $filteredData = array();

                if(isset($this->request->get['worker'])){
                    $data['selectedWorker'] = $this->request->get['worker'];
                    $filteredData['filter_worker'] = $this->request->get['worker'];
                }

                if(isset($this->request->get['customer'])){
                    $data['selectedCustomer'] = $this->request->get['customer'];
                    $filteredData['filter_customer'] = $this->request->get['customer'];
                }
                
                $data['selectedStatus'] = 3;
                $filteredData['filter_status'] = 3;
                
                
                $data['appointments'] = array();
                $appointmentResults = $this->model_appointment_appointment->getAppointmentList($filteredData);
                foreach($appointmentResults as $appointmentResult){
                    $data['appointments'][] = array(
                        'appointment_id'    => $appointmentResult['appointment_id'],    
                        'customer_id'       => $appointmentResult['customer_id'],
                        'customer_name'     => $appointmentResult['customer_name'],
                        'worker_id'         => $appointmentResult['user_id'],
                        'worker_name'       => $appointmentResult['user_name'],
                        'telephone'         => $appointmentResult['telephone'],
                        'address'           => $appointmentResult['appointment_address'],
                        'status'            => $appointmentResult['status'],
                        'status_id'         => (int)$appointmentResult['status_id'],
                        'appointment_date'  => date('Y-m-d g:ia', strtotime($appointmentResult['appointment_date'])),
                        'services'          => $appointmentResult['services'],  
                        'services_id'       => $appointmentResult['services_id'],   
                    );
                }

                $json['response'] = array(
                    "status" => 1,
                    "msg"    => "Success"
                );
                $json['appointments'] = $data['appointments'];

            }

            $this->response->setOutput(json_encode($json));
        }


        public function updateAppointmentStatus()
        {
            $json = array();
            $this->load->model('appointment/appointment');

            
            if(isset($this->request->post['appointment_id']) && isset($this->request->post['status_id'])){
                if($this->request->post['status_id']=="1")
                {
                     $this->model_appointment_appointment->acceptAppointment($this->request->post['appointment_id']);
                }
                else{
                    $this->model_appointment_appointment->rejectAppointment($this->request->post['appointment_id']);

                }

                $json['response'] = [
                    'status' => 1,
                    'msg'   => 'Update Appointment successfully.'
                ];
            } else {
                $json['response'] = [
                    'status' => 0,
                    'msg'   => 'Paramter missing.'
                ];
            }
            $this->response->setOutput(json_encode($json));
        }

		public function getWorkerAppointments(){
			$json = array();

			if(!$this->user->isLogged()){
				$json['response'] = array(
					"status" => -1,
					"msg"	 => "Invalid token"
				);
			} else {
				$this->load->model('appointment/appointment');

				$filteredData = array(
					'not_status_id'=> 2
				);

				$filteredData['filter_worker'] = $this->user->getId();

				if(isset($this->request->get['customer'])){
					$data['selectedCustomer'] = $this->request->get['customer'];
					$filteredData['filter_customer'] = $this->request->get['customer'];
				}
				if(isset($this->request->get['status'])){
					$data['selectedStatus'] = $this->request->get['status'];
					$filteredData['filter_status'] = $this->request->get['status'];
				}
				
				$appointmentResults = $this->model_appointment_appointment->getAppointmentList($filteredData);

				$data['appointments'] = array();
				foreach($appointmentResults as $appointmentResult){
					$data['appointments'][] = array(
						'appointment_id'	=> $appointmentResult['appointment_id'],
						'customer_id'		=> $appointmentResult['customer_id'],	
						'customer_name' 	=> $appointmentResult['customer_name'],
						'worker_id'			=> $appointmentResult['user_id'],
						'worker_name'		=> $appointmentResult['user_name'],
						'telephone'			=> $appointmentResult['telephone'],
						'address'			=> $appointmentResult['appointment_address'],
						'status'			=> $appointmentResult['status'],
						'status_id'			=> (int)$appointmentResult['status_id'],
						'appointment_date' 	=> date('Y-m-d g:ia', strtotime($appointmentResult['appointment_date'])),
						'services'			=> $appointmentResult['services'],
						'services_id'		=> $appointmentResult['services_id']		
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

