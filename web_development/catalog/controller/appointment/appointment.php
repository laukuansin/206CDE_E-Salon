<?php

	class ControllerAppointmentAppointment extends Controller{

		public function index(){
			$this->load->language('appointment/appointment');
			$this->load->model('service/service');
			$results = $this->model_service_service->getServices();

			foreach($results as $result){
				$data['services'][] = array(
					'service_id' => $result['service_id']
					,'service_name' => $result['service_name']
					,'service_price' => $result['service_price']
				);
			}

			$data['footer'] = $this->load->controller('common/footer');
			$data['header'] = $this->load->controller('common/header');
			$this->response->setOutput($this->load->view('appointment/appointment', $data));
		}

		public function getAvailableTimeSlot(){
			if($this->request->server['REQUEST_METHOD'] != 'POST')
				return;

			$workerGroupId 					= 10;
			$durationForCurrentAppointment 	= 0;
			
			$this->load->model('user/user');
			$this->load->model('appointment/appointment');
			$this->load->model('service/setting');
			$this->load->model('service/service');

			$serviceList 					= $this->model_service_service->getServices();
			$data 							= json_decode(file_get_contents('php://input'),true);
			$date 							= date('Y/m/d', strtotime($data['appointment_date']));
			$serviceDurationMap			 	= array();

			foreach($serviceList as $service){
				$serviceDurationMap[$service['service_id']] = $service['service_duration'];
			}

			foreach ($data['services'] as $service) {
				$durationForCurrentAppointment += $service['qty'] * $serviceDurationMap[$service['service_id']];
			}

			// Remember do open and close
			$users 			= $this->model_user_user->getEnableUsersByGroupId($workerGroupId);
			$appointments 	= $this->model_appointment_appointment->getAllAppointmentByDate($date);


			// Get day of appointment
			$appointmentDay = date('l', strtotime($date));

			// Get business hour of the day
			$serviceSetting 		= json_decode($this->model_service_setting->getSetting()['service_setting'], true);
			$businessHour			= $serviceSetting['business_hour'][$appointmentDay];
			$travelDuration 		= $serviceSetting['travel_time'];
			$appointmentInterval 	= $serviceSetting['appointment_interval'];
			$startTime      		= strtotime($businessHour['start_time'].$businessHour['start_meridiem']);
			$endTime 				= strtotime($businessHour['end_time'].$businessHour['end_meridiem']);

			$timeline 		= array();
			$workers 		= array();

			if(!$businessHour['is_open'])
				return array();

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


			// Find time slot which allow for curent appointment duration 
			foreach($workers as $workerId => $workerTimetable){
				$counter 	= 0;
				$timeSlot 	= array_keys($workerTimetable);
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
			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode(array_keys($timeline)));
		}
	}

?>