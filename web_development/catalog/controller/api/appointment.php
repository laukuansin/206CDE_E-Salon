<?php
// <<<<<<< HEAD
// class ControllerApiAppointment extends Controller {

// 	public function getAppointmentListAccepted(){
//          //Must have function
//         // !!!!!!!!!!!!!!!!!!!
//         $json = array();
//         $list= array();
//         if(!$this->customer->isLogged()) {
//             $json['response'] = array(
//                 'status' => -1,
//                 'msg' => 'Invalid token'
//             );
//             $this->response->setOutput(json_encode($json));
//             return;
//         }
//         $this->load->model('appointment/appointment');
//         $appointmentList=$this->model_appointment_appointment->getAppointmentListAcceptedByCustomerID($this->customer->getId());
//         if(empty($appointmentList))
//         {
//             $json['list']=array();
//             $json['response'] = array(
//                 'status' => 1,
//                 'msg'   => 'Appointment is empty now'
//             );
//         }
//         else{
//             foreach($appointmentList as $appointment)
//             {
//                 $date=$appointment['appointment_date'];
//                 $formatDate=date("d-M-Y",strtotime($date));
//                 $arrayDate=explode('-', $formatDate);
//                 $year=$arrayDate[2];
//                 $month=$arrayDate[1];
//                 $day=$arrayDate[0];
//                 $list[]=[
//                     'appointment_id'=>(int)$appointment['appointment_id'],
//                     'date'=>$date,
//                     'year'=>$year,
//                     'month'=>$month,
//                     'day'=>$day,
//                     'status'=>$appointment['status'],
//                     'worker_name'=>$appointment['username']
//                 ];
//             }
//             $json['list']=$list;
//             $json['response'] = array(
//                 'status' => 1,
//                 'msg'   => 'Get Appointment Success'
//             );
//         }
        
        
//         $this->response->setOutput(json_encode($json));
//     }

//     public function getAppointmentList()
//     {
//            //Must have function
//         // !!!!!!!!!!!!!!!!!!!
//         $json = array();
//         $list= array();
//         if(!$this->customer->isLogged()) {
//             $json['response'] = array(
//                 'status' => -1,
//                 'msg' => 'Invalid token'
//             );
//             $this->response->setOutput(json_encode($json));
//             return;
//         }
//         $this->load->model('appointment/appointment');
//         $appointmentList=$this->model_appointment_appointment->getAppointmentListByCustomerID($this->customer->getId());
//         if(empty($appointmentList))
//         {
//             $json['list']=array();
//             $json['response'] = array(
//                 'status' => 1,
//                 'msg'   => 'Appointment is empty now'
//             );
//         }
//         else{
//             foreach($appointmentList as $appointment)
//             {
//                 $date=$appointment['appointment_date'];
//                 $formatDate=date("d-M-Y-",strtotime($date));
//                 $time=date('h:i a',strtotime($date));
//                 $arrayDate=explode('-', $formatDate);
//                 $year=$arrayDate[2];
//                 $month=$arrayDate[1];
//                 $day=$arrayDate[0];
//                 $list[]=[
//                     'appointment_id'=>(int)$appointment['appointment_id'],
//                     'date'=>$date,
//                     'year'=>$year,
//                     'month'=>$month,
//                     'time'=>$time,
//                     'day'=>$day,
//                     'status'=>$appointment['status'],
//                     'service_name'=>$appointment['service_name']
//                 ];
//             }
//             $json['list']=$list;
//             $json['response'] = array(
//                 'status' => 1,
//                 'msg'   => 'Get Appointment Success'
//             );
//         }
        
        
//         $this->response->setOutput(json_encode($json));
//     }
// }
// =======

	class ControllerApiAppointment extends Controller{

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
			$this->initServiceSetting($date, $startTime, $endTime,$appointmentInterval, $travelDuration);

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

			$this->response->addHeader('Content-Type: application/json');
			$this->response->setOutput(json_encode($json));
		}
	}

?>
