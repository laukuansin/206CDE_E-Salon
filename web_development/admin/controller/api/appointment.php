
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

				$filteredData = array();

				if(isset($this->request->get['not_status_id'])){
					$filteredData['not_status_id'] = $this->request->get['not_status_id'];
				}


				if(isset($this->request->get['worker'])){
					$data['selectedWorker'] = $this->request->get['worker'];
					$filteredData['filter_worker'] = $this->request->get['worker'];
				}

				if(isset($this->request->get['customer'])){
					$data['selectedCustomer'] = $this->request->get['customer'];
					$filteredData['filter_customer'] = $this->request->get['customer'];
				}
				if(isset($this->request->get['status_id'])){
					$data['selectedStatus'] = $this->request->get['status_id'];
					$filteredData['filter_status'] = $this->request->get['status_id'];
				}
				
				$data['appointments'] = array();

				$this->load->model('tool/image');
				$appointmentResults = $this->model_appointment_appointment->getAppointmentList($filteredData);
				foreach($appointmentResults as $appointmentResult){
					if (is_file(DIR_IMAGE . $appointmentResult['image'])) {
						$image = $this->model_tool_image->resize($appointmentResult['image'], 250, 250);
					} else {
						$image = $this->model_tool_image->resize('profile.png', 250, 250);
					}
					$data['appointments'][] = array(
						'appointment_id'	=> $appointmentResult['appointment_id'],	
						'customer_id'		=> $appointmentResult['customer_id'],
						'customer_name' 	=> $appointmentResult['customer_name'],
						'worker_id'			=> $appointmentResult['user_id'],
						'worker_name'		=> $appointmentResult['user_name'],
						'worker_image'		=> $image,
						'worker_telephone'  => $appointmentResult['worker_telephone'],
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

		public function getAppointmentServices(){
	       
	       if(!$this->user->isLogged()){
				$json['response'] = array(
					"status" => -1,
					"msg"	 => "Invalid token"
				);
				$this->response->setOutput(json_encode($json));
	            return;
			} 

	        if(!isset($this->request->get) || !isset($this->request->get['appointment_id'])){
	            $json['response'] = array(
	                'status' => 0,
	                'msg' => 'Parameter missing'
	            );
	            $this->response->setOutput(json_encode($json));
	            return;
	        }


			$json = array();
			$this->load->model('service/service');
			$results = $this->model_service_service->getAppointmentServices($this->request->get['appointment_id']);
			foreach($results as $result){
				$json['services'][] = array(
					'service_id' => (int)$result['service_id']
					,'service_name' => $result['service_name']
					,'service_price' => (float)$result['service_price']
					,'quantity'		=> (int)$result['qty']				
				);
			}
			 $json['response'] = [
		            'status' => 1,
		            'msg'   => 'Get services successfully.'
		        ];
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
						'appointment_id'	=> $appointmentResult['appointment_id'],	
						'customer_id'		=> $appointmentResult['customer_id'],
						'customer_name' 	=> $appointmentResult['customer_name'],
						'worker_id'			=> $appointmentResult['user_id'],
						'worker_name'		=> $appointmentResult['user_name'],
						'worker_image'		=> 'image/'.$appointmentResult['image'],
						'worker_telephone'  => $appointmentResult['worker_telephone'],
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
                    "msg"    => "Success"
                );
                $json['appointments'] = $data['appointments'];

            }

            $this->response->setOutput(json_encode($json));
        }

        private function updateAppointmentLog($appointmentId, $activity){
    	 	$json = array();
            $this->model_appointment_appointment->insertAppointmentLog($appointmentId, $activity);
        }

        public function updateAppointmentStatus()
        {
            $json = array();
            $this->load->model('appointment/appointment');

            
            if(isset($this->request->post['appointment_id']) && isset($this->request->post['status_id'])){

            	switch ($this->request->post['status_id']) {
            		case "1": $this->model_appointment_appointment->acceptAppointment($this->request->post['appointment_id']); break;
            		case "2": $this->model_appointment_appointment->rejectAppointment($this->request->post['appointment_id']); break;
            		case "4": $this->model_appointment_appointment->cancelAppointment($this->request->post['appointment_id']); break;
            		case "5": $this->model_appointment_appointment->completeAppointment($this->request->post['appointment_id']); break;
					case "6": $this->model_appointment_appointment->ongoingAppointment($this->request->post['appointment_id']); break;
					case "7": $this->model_appointment_appointment->servicingAppointment($this->request->post['appointment_id']); break;
            	}

            	if(isset($this->request->post['activity']))
            		$this->updateAppointmentLog($this->request->post['appointment_id'], $this->request->post['activity']);

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

        public function insertAppointmentRoute(){
        	$json = array();

			if(!$this->user->isLogged()){
				$json['response'] = array(
					"status" => -1,
					"msg"	 => "Invalid token"
				);
			} else {
				$this->load->model('appointment/appointment');
	        	$postData = json_decode(file_get_contents('php://input'),true);

	        	$this->model_appointment_appointment->insertAppointmentRoute($postData['appointment_id'], $postData['route_taken']);
				$json['response'] = array(
					"status" => 1,
					"msg"	 => "Route insert successfully"
				);
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

				$filteredData['filter_worker'] = $this->user->getId();


				if(isset($this->request->get['not_status_id'])){
					$filteredData['not_status_id'] = $this->request->get['not_status_id'];
				}

				if(isset($this->request->get['customer'])){
					$data['selectedCustomer'] = $this->request->get['customer'];
					$filteredData['filter_customer'] = $this->request->get['customer'];
				}
				if(isset($this->request->get['status_id'])){
					$data['selectedStatus'] = $this->request->get['status_id'];
					$filteredData['filter_status'] = $this->request->get['status_id'];
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
						'worker_image'		=> 'image/'.$appointmentResult['image'],
						'worker_telephone'  => $appointmentResult['worker_telephone'],
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
	}
?>

