<?php

	class ControllerAppointmentAppointmentAll extends Controller{
		public function index(){
			$this->load->language('appointment/appointment_all');
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
				'text' => $this->language->get('text_appointment_all'),
				'href' => $this->url->link('appointment/appointment', 'user_token=' . $this->session->data['user_token'], true)
			);

			$data['appointments'] = array();
			$data['accept_all']			= $this->url->link('appointment/appointment_all/acceptAll', 'user_token='.$this->session->data['user_token'].$url, true);
			$data['reject_all']			= $this->url->link('appointment/appointment_all/rejectAll', 'user_token='.$this->session->data['user_token'].$url, true);
			$data['filter'] = $this->url->link('appointment/appointment_all', 'user_token='.$this->session->data['user_token'].$url, true);

			$filteredData = array(
				'sort'	 		=> $sort
				,'order' 		=> $order
				,'not_status_id'=> 3
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
					'accept'			=> $this->url->link('appointment/appointment_all/acceptAppointment', 'user_token='.$this->session->data['user_token'].'&appointment_id='.$appointmentResult['appointment_id'].$url, true),
					'reject'			=> $this->url->link('appointment/appointment_all/rejectAppointment', 'user_token='.$this->session->data['user_token'].'&appointment_id='.$appointmentResult['appointment_id'].$url, true),
					'edit'				=> $this->url->link('appointment/appointment_all/editAppointment', 'user_token='.$this->session->data['user_token'].'&appointment_id='.$appointmentResult['appointment_id'].$url, true),			
				);
			}

			$data['workers'] = array();
			$data['customers'] = array();
			$data['status']	= array();

			$data['customers'][] = array(
				'customer_id' 	=> '-1',
				'customer_name' => 'All'
			);

			$data['workers'][] = array(
				'user_id' 	=> '-1',
				'user_name' => 'All'
			);

			$data['status'][] = array(
				'status_id'	=> '-1',
				'status'	=> 'All',
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

			$statusResults = $this->model_appointment_appointment->getAppointmentStatusList();
			foreach($statusResults as $statusResult){
				if($statusResult['status_id'] == 3) continue;
				$data['status'][] = array(
					'status_id'	=> $statusResult['status_id'],
					'status'	=> $statusResult['status']
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

			$data['sort_cust_name'] = $this->url->link('appointment/appointment_all', 'user_token='.$this->session->data['user_token'] . '&sort=customer_name'.$url, true);
			$data['sort_date'] = $this->url->link('appointment/appointment_all', 'user_token='.$this->session->data['user_token']. '&sort=appointment_date'.$url, true);


			$this->response->setOutput($this->load->view('appointment/appointment_all', $data));
		}
	}

?>