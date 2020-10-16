<?php
	class ControllerAppointmentAppointmentRequest extends Controller{
		private $error = array();

		public function index(){
			$this->load->language('appointment/appointment_request');
			$this->load->model('service/service');
			$this->load->model('appointment/appointment');
			$this->load->model('customer/customer');
			$this->load->model('user/user');
			$this->document->setTitle($this->language->get('heading_title'));
			$this->getList();
		}

		public function getList(){
			$data = array();


			if(isset($this->request->post['selected'])){
				$data['selected'] = $this->request->post['selected'];
			} else {
				$data['selected'] = array();
			}

			$url = '';

			if(isset($this->request->get['sort'])){
				$sort = $this->request->get['sort'];
				$url .= '&sort='.$this->request->get['sort'];
			}else{
				$sort = 'appointment_date';
			}

			if(isset($this->request->get['order'])){
				$order = $this->request->get['order'];
				$url .= '&order='.$this->request->get['order'];
			} else {
				$order = 'ASC';
			}

			$data['header'] 		= $this->load->controller('common/header');
			$data['column_left'] 	= $this->load->controller('common/column_left');
			$data['breadcrumbs'] = array();
			$data['breadcrumbs'][] = array(
				'text' => $this->language->get('text_home'),
				'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
			);

			$data['breadcrumbs'][] = array(
				'text' => $this->language->get('text_appointment_request'),
				'href' => $this->url->link('appointment/appointment_request', 'user_token=' . $this->session->data['user_token'], true)
			);

			$data['appointments'] = array();
			$data['accept_all']			= $this->url->link('appointment/appointment_request/acceptAll', 'user_token='.$this->session->data['user_token'].$url, true);
			$data['reject_all']			= $this->url->link('appointment/appointment_request/rejectAll', 'user_token='.$this->session->data['user_token'].$url, true);
			$data['filter'] = $this->url->link('appointment/appointment_request', 'user_token='.$this->session->data['user_token'].$url, true);

			$filteredData = array(
				'sort'	 		=> $sort
				,'order' 		=> $order
				,'filter_status' 	=> 3
			);

			if(isset($this->request->get['worker'])){
				$data['selectedWorker'] = $this->request->get['worker'];
				$filteredData['filter_worker'] = $this->request->get['worker'];
			}

			if(isset($this->request->get['customer'])){
				$data['selectedCustomer'] = $this->request->get['customer'];
				$filteredData['filter_customer'] = $this->request->get['customer'];
			}

			
			$appointmentResults = $this->model_appointment_appointment->getAppointmentList($filteredData);
			foreach($appointmentResults as $appointmentResult){
				$data['appointments'][] = array(
					'appointment_id'	=> $appointmentResult['appointment_id'],	
					'customer_name' 	=> $appointmentResult['customer_name'],
					'worker_name'		=> $appointmentResult['user_name'],
					'telephone'			=> $appointmentResult['telephone'],
					'address'			=> $appointmentResult['appointment_address'],
					'appointment_date' 	=> date('Y-m-d g:ia', strtotime($appointmentResult['appointment_date'])),
					'services'			=> $appointmentResult['services'],
					'accept'			=> $this->url->link('appointment/appointment_request/acceptAppointment', 'user_token='.$this->session->data['user_token'].'&appointment_id='.$appointmentResult['appointment_id'].$url, true),
					'reject'			=> $this->url->link('appointment/appointment_request/rejectAppointment', 'user_token='.$this->session->data['user_token'].'&appointment_id='.$appointmentResult['appointment_id'].$url, true),
					'edit'				=> $this->url->link('appointment/appointment_request/editAppointment', 'user_token='.$this->session->data['user_token'].'&appointment_id='.$appointmentResult['appointment_id'].$url, true),			
				);
			}

			$data['workers'] = array();
			$data['customers'] = array();

			$data['customers'][] = array(
				'customer_id' 	=> '-1',
				'customer_name' => 'All'
			);

			$data['workers'][] = array(
				'user_id' 	=> '-1',
				'user_name' => 'All'
			);

			$workerResults = $this->model_user_user->getEnableUsersByGroupId(10);
			foreach($workerResults as $workerResult){
				$data['workers'][] = array(
					'user_id' 	=> $workerResult['user_id'],
					'user_name' => $workerResult['firstname'].' '.$workerResult['lastname']
				);
			}

			$customerResults = $this->model_customer_customer->getCustomers(array('sort'=>'name'));
			foreach ($customerResults as $customerResult) {
				$data['customers'][] = array(
					'customer_id' => $customerResult['customer_id'],
					'customer_name' => $customerResult['firstname'].' '.$customerResult['lastname']
				);
			}


			$url = '';
			if($order == 'ASC'){
				$url .= '&order=DESC';
			} else {
				$url .= '&order=ASC';
			}
			
			$data['sort'] = $sort;
			$data['order'] = $order;

			$data['sort_cust_name'] = $this->url->link('appointment/appointment_request', 'user_token='.$this->session->data['user_token'] . '&sort=customer_name'.$url, true);
			$data['sort_date'] = $this->url->link('appointment/appointment_request', 'user_token='.$this->session->data['user_token']. '&sort=appointment_date'.$url, true);


			$this->response->setOutput($this->load->view('appointment/appointment_request', $data));
		}

		public function editAppointment(){
			$this->load->language('appointment/appointment_request');
			$this->load->model('service/service');
			$this->load->model('appointment/appointment');
			$this->document->setTitle($this->language->get('heading_title'));
			$this->getForm();
		}

		public function acceptAppointment(){
			$this->load->model('appointment/appointment');
			$this->model_appointment_appointment->acceptAppointment($this->request->get['appointment_id']);
			$this->refresh();
		}
		public function rejectAppointment(){
			$this->load->model('appointment/appointment');
			$this->model_appointment_appointment->rejectAppointment($this->request->get['appointment_id']);
			$this->refresh();
		}

		private function refresh(){
			$url = '';

			if(isset($this->request->get['sort'])){
				$sort = $this->request->get['sort'];
				$url .= '&sort='.$this->request->get['sort'];
			}else{
				$sort = 'appointment_date';
			}

			if(isset($this->request->get['order'])){
				$order = $this->request->get['order'];
				$url .= '&order='.$this->request->get['order'];
			} else {
				$order = 'ASC';
			}


			$this->response->redirect($this->url->link('appointment/appointment_request', 'user_token='.$this->session->data['user_token'].$url, true));
		}

		public function acceptAll(){
			$this->load->model('appointment/appointment_request');
			foreach($this->request->post['selected'] as $appointment_id){
				$this->model_appointment_appointment->acceptAppointment($appointment_id);
			}
			$this->refresh();
		}

		public function rejectAll(){
			$this->load->model('appointment/appointment_request');
			foreach($this->request->post['selected'] as $appointment_id){
				$this->model_appointment_appointment->rejectAppointment($appointment_id);
			}
			$this->refresh();
		}

		public function save(){

			// TODO valiate
			if($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validateForm()){
				$this->load->model('appointment/appointment');

				
				$data = array(
					'appointment_id'		=>$this->request->post['appointment_id'],
					'appointment_date'		=>date('Y-m-d g:ia', strtotime($this->request->post['appointment_date'].' '.$this->request->post['appointment_time'])),
					'user_id'				=>$this->request->post['worker'],
					'appointment_address'	=>$this->request->post['appointment_address'],
					'services'				=>$this->request->post['service']
				);

				$this->model_appointment_appointment->updateAppointmentInfo($data);				
				$this->response->redirect($this->url->link('appointment/appointment_request', 'user_token='.$this->session->data['user_token'].$url, true));
			}

			$this->getForm();
		}

		private function validateForm(){
			$this->load->language('appointment/appointment_form');

			if(empty($this->request->post['appointment_address'])){
				$this->error['appointment_address'] = $this->language->get('error_appointment_address');
			} 

			foreach ($this->request->post['service'] as $data) {
				if(empty($data)){
					$this->error['pax'] = $this->language->get('error_empty_pax');
				} else if(!is_numeric($data)){
					$this->error['pax'] = $this->language->get('error_pax');
				} else if($data < 1){
					$this->error['pax'] = $this->language->get('error_pax_range');
				}
				
			}

			if(empty($this->request->post['appointment_date'])){
				$this->error['appointment_date'] = $this->language->get('error_empty_datepicker');
			} else if ($this->request->post['appointment_date'] < date('Y-m-d')){
				$this->error['appointment_date'] = $this->language->get('error_datepicker');
			}

			if(empty($this->request->post['appointment_time'])){
				$this->error['appointment_time'] = $this->language->get('error_empty_time');
			} 

			//TODO
			return !$this->error;
		}


		public function getForm(){
			$data = array();
			$this->load->language('appointment/appointment_form');
			$appointmentId = $this->request->get['appointment_id'];

			if(isset($this->error['appointment_address'])){
				$data['error_appointment_address'] = $this->error['appointment_address'];
			} else {
				$data['error_appointment_address'] = '';
			}

			if (isset($this->error['pax'])) {
				$data['error_pax'] = $this->error['pax'];
			} else {
				$data['error_pax'] = '';
			}

			if (isset($this->error['appointment_date'])) {
				$data['error_datepicker'] = $this->error['appointment_date'];
			} else {
				$data['error_datepicker'] = '';
			}

			if (isset($this->error['appointment_time'])) {
				$data['error_empty_time'] = $this->error['appointment_time'];
			} else {
				$data['error_empty_time'] = '';
			}

			// Sort
			$url = '&appointment_id='.$this->request->get['appointment_id'];
			if(isset($this->request->get['sort'])){
				$sort = $this->request->get['sort'];
				$url .= '&sort='.$this->request->get['sort'];
			}else{
				$sort = 'appointment_date';
			}

			if(isset($this->request->get['order'])){
				$order = $this->request->get['order'];
				$url .= '&order='.$this->request->get['order'];
			} else {
				$order = 'ASC';
			}

			// View
			$data['header'] 		= $this->load->controller('common/header');
			$data['column_left'] 	= $this->load->controller('common/column_left');
			$data['footer'] 		= $this->load->controller('common/footer');
	 		$data['cancel']			= $this->url->link('appointment/appointment_request', 'user_token='.$this->session->data['user_token']. $url, true);
			$data['breadcrumbs'] = array();
			$data['breadcrumbs'][] = array(
				'text' => $this->language->get('text_home'),
				'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
			);
			$data['breadcrumbs'][] = array(
				'text' => $this->language->get('text_appointment_request'),
				'href' => $this->url->link('appointment/appointment_request', 'user_token=' . $this->session->data['user_token']. $url, true)
			);

			// Get appointment data
			$this->load->model('appointment/appointment');
			$appointmentResult = $this->model_appointment_appointment->getAppointmentById($appointmentId);

			if(isset($this->request->post['appointment_address'])){
				$address = $this->request->post['appointment_address'];
				//echo $this->request->post[$service[0]];
			} else if (!empty($appointmentResult)){
				$address = $appointmentResult['appointment_address'];
			} else {
				$address = '';
			}

			if(isset($this->request->post['appointment_date'])){
				$datepicker = $this->request->post['appointment_date'];
			} else if (!empty($appointmentResult)){
				$datepicker = date('Y-m-d', strtotime($appointmentResult['appointment_date']));
			} else {
				$datepicker = '';
			}

			$this->load->model('service/service');
			$serviceList = array();
			$serviceResults = $this->model_service_service->getServices();
			foreach($serviceResults as $serviceResult){
				$serviceList[$serviceResult['service_id']] = array(
					'service_price' => $serviceResult['service_price'],
					'service_name'	=> $serviceResult['service_name']
				);
			}
			$data['serviceList'] = json_encode($serviceList);

			$current_service = array();
			$serviceResults = $this->model_appointment_appointment->getServiceByAppointmentId($appointmentId);
			foreach($serviceResults as $serviceResult){
				$current_service[$serviceResult['service_id']] = $serviceResult['qty'];
			}
			
			$data['user_token']		= $this->session->data['user_token'];
			$data['appointment'] = array(
				'appointment_id'	=> $appointmentResult['appointment_id'],	
				'customer_name' 	=> $appointmentResult['customer_name'],
				'worker_name'		=> $appointmentResult['user_name'],
				'worker_id'			=> $appointmentResult['user_id'],
				'telephone'			=> $appointmentResult['telephone'],
				'address'			=> $address,
				'appointment_date' 	=> $datepicker,
				'appointment_time'	=> date('g:ia', strtotime($appointmentResult['appointment_date'])),
				'services'			=> json_encode($current_service)
			);

			$data['action_save'] = $this->url->link('appointment/appointment_request/save', 'user_token='.$this->session->data['user_token'].$url, true);	

			$this->load->model('user/user');
			$userResults = $this->model_user_user->getEnableUsersByGroupId(10);
			
			$worker = array();
			foreach($userResults as $userResult){
				$worker[$userResult['user_id']] = $userResult['firstname']." ".$userResult['lastname'];
			}

			$data['worker'] = json_encode($worker);
			
			$this->response->setOutput($this->load->view('appointment/appointment_form', $data));
		}


		private function getServiceDurationMap(){
			$this->load->model('service/service');
			$serviceDurationMap			 	= array();
			$serviceList 					= $this->model_service_service->getServices();

			foreach($serviceList as $service)
				$serviceDurationMap[$service['service_id']] = $service['service_duration'];
			
			return $serviceDurationMap;
		}

		public function getWorkerTimetable(){
			
			$postData 				= json_decode(file_get_contents('php://input'),true);
			$date 					= $postData['date'];
			$workerId				= $postData['worker_id'];
			$appointment_id			= $postData['appointment_id'];
			$services  				= $postData['services'];

			$startTime 				= '';
			$endTime 				= '';
			$appointmentInterval 	= 0;
			$travelDuration  	 	= 0;
			$timetable 				= array();
			
			$this->load->model('user/user');
			$this->load->model('appointment/appointment');
			

			$worker 		= array();
			if($this->initServiceSetting($date, $startTime, $endTime,$appointmentInterval, $travelDuration))
			{
				$appointments 	= $this->model_appointment_appointment->getAllAppointmentByDate($date);
				$user 			= $this->model_user_user->getUser($workerId);

				// Init workers timetable to false 
				$worker[$user['user_id']] = array();
				for($time = $startTime; $time <= $endTime; $time+=($appointmentInterval * 60)){
					$timetable[date('g:ia', $time)] = true;
				}

				// Set workers unavailable slot to false
				foreach ($appointments as $appointment) {
					// If not that worker appointment, ignore
					if($appointment['user_id'] != $user['user_id'] || $appointment['appointment_id'] == $appointment_id) continue;


					// Remove date, need only time
					$appointmentDate = strtotime(date('g:ia', strtotime($appointment['appointment_date'])));
					$totalDuration   = $appointment['total_duration'] * 60;

					for($time = $appointmentDate - ($travelDuration - $appointmentInterval) * 60; $time < $appointmentDate + $totalDuration + $travelDuration * 60; $time +=($appointmentInterval * 60))
					{
						if($time < $startTime || $time > $endTime){
							continue;
						}
						$timetable[date('g:ia', $time)] = false;
					}	
				}

				$serviceDurationMap = $this->getServiceDurationMap();
				$durationForCurrentAppointment = 0;
				foreach ($services as $serviceId => $qty) {
					$durationForCurrentAppointment += $qty * $serviceDurationMap[$serviceId];
				}

				

				// Match with current appointment
				{
					$counter 	= 0;
					foreach($timetable as $time => $isAvailable){
						if($isAvailable){
							$counter+=$appointmentInterval;
						}
						else{
							$counter = 0;
						}

						if($counter > $durationForCurrentAppointment){
							$durationForCurrentAppointmentInSec = $durationForCurrentAppointment * 60;
							$worker[$user['user_id']][strtotime($time) - $durationForCurrentAppointmentInSec] = true;
						}
					}

					// Sort time by using second, then convert back to readable string format
					ksort($worker[$user['user_id']]);
					foreach ($worker[$user['user_id']] as $time => $value) {
						$worker[$user['user_id']][date('g:ia', $time)] = $worker[$user['user_id']][$time];
						unset($worker[$user['user_id']][$time]);
					}
				}
			}
			else
			{
				$worker[$user['user_id']] = array();
				for($time = $startTime; $time <= $endTime; $time+=($appointmentInterval * 60)){
					$worker[$user['user_id']][date('g:ia', $time)] = false;
				}
			}
			$this->response->setOutput(json_encode($worker));
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
	}
?>