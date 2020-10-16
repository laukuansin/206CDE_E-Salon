<?php

class ControllerServiceSetting extends Controller{

	private $error = array();

	public function index(){
		$this->load->language('service/setting');
		$this->document->setTitle($this->language->get('heading_title'));
		$this->getView();		
	}

	public function save(){
		$this->load->language('service/setting');
		$this->document->setTitle($this->language->get('heading_title'));

		if($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validateForm()){
			$this->load->model('service/setting');

			$data = array('cancellation_time' => $this->request->post['cancellation_time']
				, 'business_hour' => $this->request->post['business_hour']
				, 'travel_time' => $this->request->post['travel_time']
				, 'appointment_interval' => $this->request->post['appointment_interval']);

			
			$this->model_service_setting->updateSetting(json_encode($data));
			$this->response->redirect($this->url->link('service/setting', 'user_token='.$this->session->data['user_token'].$url, true));
		}

		$this->getView();
	}


	protected function getView(){

		if(isset($this->error['warning'])){
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if(isset($this->error['business_hour'])){
			$data['error_business_hour'] = $this->error['business_hour'];
		} else {
			$data['error_business_hour'] = '';
		}

		if(isset($this->error['cancellation_time'])){
			$data['error_cancellation_time'] = $this->error['cancellation_time'];
		} else {
			$data['error_cancellation_time'] = '';
		}

		if(isset($this->error['travel_time'])){
			$data['error_travel_time'] = $this->error['travel_time'];	
		} else {
			$data['error_travel_time'] = '';
		}

		if(isset($this->error['appointment_interval'])){
			$data['error_appointment_interval'] = $this->error['appointment_interval'];	
		} else {
			$data['error_appointment_interval'] = '';
		}

		$data['breadcrumbs'] = array();
		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_service'),
			'href' => $this->url->link('service/setting', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['header'] 		= $this->load->controller('common/header');
		$data['column_left'] 	= $this->load->controller('common/column_left');
		$data['footer'] 		= $this->load->controller('common/footer');

		// Form action
		$data['action'] = $this->url->link('service/setting/save', 'user_token='.$this->session->data['user_token'], true);

		if($this->request->server['REQUEST_METHOD'] != 'POST'){
			$this->load->model('service/setting');
			$result = json_decode($this->model_service_setting->getSetting()['service_setting'], true);
		}

		if(isset($this->request->post['business_hour'])){
			$data['business_hour'] = $this->request->post['business_hour'];
		} else if(!empty($result)){
			$data['business_hour'] = $result['business_hour'];
		}

		if(isset($this->request->post['cancellation_time'])){
			$data['cancellation_time'] = $this->request->post['cancellation_time'];
		} else if(!empty($result)){
			$data['cancellation_time'] = $result['cancellation_time'];
		}

		if(isset($this->request->post['travel_time'])){
			$data['travel_time'] = $this->request->post['travel_time'];
		} else if(!empty($result)){
			$data['travel_time'] = $result['travel_time'];
		}

		if(isset($this->request->post['appointment_interval'])){
			$data['appointment_interval'] = $this->request->post['appointment_interval'];
		} else if(!empty($result)){
			$data['appointment_interval'] = $result['appointment_interval'];
		}


		$this->response->setOutput($this->load->view('service/setting', $data));
	}

	public function validateForm(){
		if(!$this->user->hasPermission('modify', 'service/setting')){
			$this->error['warning'] = $this->language->get('error_permission');
		}

		foreach($this->request->post['business_hour'] as $data){
			if($data['is_open'] == 1){
				if(empty($data['start_time']) || empty($data['end_time'])){
					$this->error['business_hour'] = $this->language->get('error_empty_business_hour');
				} else if(!is_numeric($data['start_time']) || !is_numeric($data['end_time'])){
					$this->error['business_hour'] = $this->language->get('error_business_hour');
				}
				else if((($data['start_time']) < 7) && (($data['start_meridiem']) == "AM")
					|| ($data['start_time']) < 1 
					|| ($data['start_time']) > 12.59){
					$this->error['business_hour'] = $this->language->get('error_business_hour_range');
				} else if((($data['end_time']) < 7) && (($data['end_meridiem']) == "AM")
					|| ($data['end_time']) < 1
					|| ($data['end_time']) > 12.59){
					$this->error['business_hour'] = $this->language->get('error_business_hour_range');
				}
			}
			
		}

		if(empty($this->request->post['cancellation_time'])){
			$this->error['cancellation_time'] = $this->language->get('error_empty_cancellation_time');
		} else if(!is_numeric($this->request->post['cancellation_time'])){
			$this->error['cancellation_time'] = $this->language->get('error_cancellation_time');
		}

		if(empty($this->request->post['travel_time'])){
			$this->error['travel_time'] = $this->language->get('error_empty_travel_time');
		} else if(!is_numeric($this->request->post['travel_time'])){
			$this->error['travel_time'] = $this->language->get('error_travel_time');
		}

		if(empty($this->request->post['appointment_interval'])){
			$this->error['appointment_interval'] = $this->language->get('error_empty_appointment_interval');
		} else if(!is_numeric($this->request->post['appointment_interval'])){
			$this->error['appointment_interval'] = $this->language->get('error_appointment_interval');
		}


		return !$this->error;
	}


}