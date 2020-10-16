<?php

	class ControllerApiAppointment extends Controller{

		public function getCustomerAppointments(){
			$json = array();
	        if(!$this->customer->isLogged()) {
	            $json['response'] = array(
	                'status' => -1,
	                'msg' => 'Invalid token'
	            );
	            $this->response->setOutput(json_encode($json));
	            return;
	        } else{
				$this->load->model('appointment/appointment');


				$filteredData = array();

				if(isset($this->request->get['not_status_id'])){
					$filteredData['not_status_id'] = $this->request->get['not_status_id'];
				} else {
					$filteredData['not_status_id'] = -1;
				}

				if(isset($this->request->get['worker'])){
					$data['selectedWorker'] = $this->request->get['worker'];
					$filteredData['filter_worker'] = $this->request->get['worker'];
				}

				$data['selectedCustomer'] = $this->customer->getId();
				$filteredData['filter_customer'] = $this->customer->getId();

				if(isset($this->request->get['status_id'])){
					$data['selectedStatus'] = $this->request->get['status_id'];
					$filteredData['filter_status'] = $this->request->get['status_id'];
				}
				
				$data['appointments'] = array();
				$appointmentResults = $this->model_appointment_appointment->getCustomerAppointmentList($filteredData);

				$this->load->model('tool/image');
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



		public function makeAppointment(){
			$json = array();
	        if(!$this->customer->isLogged()) {
	            $json['response'] = array(
	                'status' => -1,
	                'msg' => 'Invalid token'
	            );
	            $this->response->setOutput(json_encode($json));
	            return;
	        }  

			
			if($this->request->server['REQUEST_METHOD'] != 'POST')
				return;

			$postData 			= json_decode(file_get_contents('php://input'),true);
			$data  				= array();

			// TODO Validation
			$date 					= date('Y/m/d', strtotime($postData['appointment_date'])); 

			// Get business hour of the day
			$travelDuration 		= 0;
			$appointmentInterval 	= 0;
			$startTime      		= '';
			$endTime 				= '';
			$this->initServiceSetting($date, $startTime, $endTime,$appointmentInterval, $travelDuration);

			$data['customer_id'] 		= $this->customer->getId();
			$data['user_id']			= 0;
			$data['appointment_date'] 	= date('Y-m-d g:ia', strtotime($postData['appointment_date'].$postData['appointment_time']));
			$data['appointment_address']= $postData['address'];
			$data['services']			= array();

			foreach($postData['services'] as $service){
				$data['services'][$service['service_id']] = $service['qty'];
			}

			
			$workers = $this->getWorkersTimetable(
				10
				, $date
				, $startTime
				, $endTime
				, $appointmentInterval
				, $travelDuration);

			// Assign worker to the appointment
			foreach($workers as $workerId => $timeTable){
				if($timeTable[$postData['appointment_time']]){
					$data['user_id'] = $workerId;
					break;
				}
			}

			$this->load->model('appointment/appointment');
			$this->model_appointment_appointment->insertAppointment($data);

            $json['response'] = array(
                'status' => 1,
                'msg' => 'Make appointment successfully'
            );

            $this->response->setOutput(json_encode($json));
		}

		private function getServiceDurationMap(){
			$this->load->model('service/service');
			$serviceDurationMap			 	= array();
			$serviceList 					= $this->model_service_service->getServices();

			foreach($serviceList as $service)
				$serviceDurationMap[$service['service_id']] = $service['service_duration'];
			
			return $serviceDurationMap;
		}

		private function getWorkersTimetable($workerGroupId,$date, $startTime, $endTime, $appointmentInterval, $travelDuration){
			$this->load->model('user/user');
			$this->load->model('appointment/appointment');

			$workers 		= array();
			$appointments 	= $this->model_appointment_appointment->getAllAppointmentByDate($date);
			$users 			= $this->model_user_user->getEnableUsersByGroupId($workerGroupId);

			// Init workers timetable to true 
			foreach ($users as $user) {
				$workers[$user['user_id']] = array();
				for($time = $startTime; $time <= $endTime; $time+=($appointmentInterval * 60)){
					$workers[$user['user_id']][date('g:ia', $time)] = true;
				}
			}

			// Set workers unavailable slot to false
			foreach ($appointments as $appointment) {
				$appointmentDate = strtotime($appointment['appointment_date']);
				$totalDuration   = $appointment['total_duration'] * 60;
				for($time = $appointmentDate - ($travelDuration - $appointmentInterval) * 60; $time < $appointmentDate + $totalDuration + $travelDuration * 60; $time +=($appointmentInterval * 60))
				{
					if($time < $startTime)
						continue;
					$workers[$appointment['user_id']][date('g:ia', $time)] = false;
				}	
			}

			return $workers;
		}

		private function initServiceSetting($date, &$startTime, &$endTime,&$appointmentInterval, &$travelDuration){
			$this->load->model('service/setting');
			$serviceSetting 		= json_decode($this->model_service_setting->getSetting()['service_setting'], true);
			$businessHour			= $serviceSetting['business_hour'][date('l', strtotime($date))];
			$travelDuration 		= $serviceSetting['travel_time'];
			$appointmentInterval 	= $serviceSetting['appointment_interval'];
			$startTime      		= strtotime($businessHour['start_time'].$businessHour['start_meridiem']);
			$endTime 				= strtotime($businessHour['end_time'].$businessHour['end_meridiem']);
			return $businessHour['is_open'];
		}

		public function getAvailableTimeSlot(){
			$json = array();
	        if(!$this->customer->isLogged()) {
	            $json['response'] = array(
	                'status' => -1,
	                'msg' => 'Invalid token'
	            );
	            $this->response->setOutput(json_encode($json));
	            return;
	        }  

			$workerGroupId 					= 10;
			$durationForCurrentAppointment 	= 0;
			
			$this->load->model('user/user');			
			// Process post data
			$data 							= json_decode(file_get_contents('php://input'),true);
			$date 							= date('Y-m-d', strtotime($data['appointment_date']));
			$serviceDurationMap 			= $this->getServiceDurationMap();
			
			foreach ($data['services'] as $service) 
				$durationForCurrentAppointment += $service['qty'] * $serviceDurationMap[$service['service_id']];
			

			// Get business hour of the day
			$travelDuration 		= 0;
			$appointmentInterval 	= 0;
			$startTime      		= '';
			$endTime 				= '';
			if($this->initServiceSetting($date, $startTime, $endTime,$appointmentInterval, $travelDuration)){

				$timeline 		= array();
				$workers 		= $this->getWorkersTimetable($workerGroupId,$date, $startTime, $endTime, $appointmentInterval, $travelDuration);

				// Find time slot which allow for curent appointment duration 
				foreach($workers as $workerId => $workerTimetable){
					$counter 	= 0;
					foreach($workerTimetable as $time => $isAvailable){
						if($isAvailable){
							$counter+=$appointmentInterval;
						}
						else{
							$counter = 0;
						}

						if($counter > $durationForCurrentAppointment){
							$durationForCurrentAppointmentInSec = $durationForCurrentAppointment * 60;
							$timeline[strtotime($time) - $durationForCurrentAppointmentInSec] = true;
						}
					}
				}

				// Sort time by using second, then convert back to readable string format
				ksort($timeline);
				foreach ($timeline as $time => $value) {
					$timeline[date('g:ia', $time)] = $timeline[$time];
					unset($timeline[$time]);
				}

				// Previously using associative array to remove duplicate value, so need convert back to normal array
				$json['timeline'] = array_keys($timeline);
	            $json['response'] = array(
	                'status' => 1,
	                'msg' => 'Get time slot successfully'
	            );
	        } else {
	        	$json['timeline'] = array();
	            $json['response'] = array(
	                'status' => 1,
	                'msg' => 'Get time slot successfully'
	            );
	        }

			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode($json));
		}

		public function cancelAppointment()
        {
            $json = array();
            $this->load->model('appointment/appointment');

            
            if(isset($this->request->post['appointment_id'])){
             	$this->model_appointment_appointment->cancelAppointment($this->request->post['appointment_id']);
      
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

	}
?>

