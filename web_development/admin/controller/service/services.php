<?php

class ControllerServiceServices extends Controller{

// TODO 
	// alert owner if service is in appointment

	private $error = array();

	public function index(){

		$data = array();

		$this->load->language('service/services');
		$this->load->model('service/service');
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
			$sort = 'service_name';
		}

		if(isset($this->request->get['order'])){
			$order = $this->request->get['order'];
			$url .= '&order='.$this->request->get['order'];
		} else {
			$order = 'ASC';
		}

		
		$data['breadcrumbs'] = array();
		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_service'),
			'href' => $this->url->link('service/services', 'user_token=' . $this->session->data['user_token'].$url, true)
		);

		$data['header'] 		= $this->load->controller('common/header');
		$data['column_left'] 	= $this->load->controller('common/column_left');
		$data['footer'] 		= $this->load->controller('common/footer');
		$data['add']			= $this->url->link('service/services/add', 'user_token='.$this->session->data['user_token'].$url, true);
		$data['delete']			= $this->url->link('service/services/delete', 'user_token='.$this->session->data['user_token'].$url, true);


		$filter_data = array(
			'sort' => $sort
			,'order' => $order
		);

		$data['services'] = array();
		$results = $this->model_service_service->getServices($filter_data);

		foreach($results as $result){
			$data['services'][] = array(
				'service_id' => $result['service_id']
				,'service_name' => $result['service_name']
				,'service_price' => $result['service_price']
				,'edit' => $this->url->link('service/services/edit', 'user_token='.$this->session->data['user_token'].'&service_id='. $result['service_id'].$url, true)
			);
		}

		// Toggle 
		$url = '';
		if($order == 'ASC'){
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		$data['sort'] = $sort;
		$data['order'] = $order;
		$data['sort_service_name'] = $this->url->link('service/services', 'user_token='.$this->session->data['user_token'] . '&sort=service_name'.$url, true);
		$data['sort_service_price'] = $this->url->link('service/services', 'user_token='.$this->session->data['user_token']. '&sort=service_price'.$url, true);


		$this->response->setOutput($this->load->view('service/services', $data));
	}

	public function add(){
		$this->load->language('service/services');
		$this->document->setTitle($this->language->get('heading_title'));

		if(($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()){
			// Add service code
			$this->load->model('service/service');
			$this->model_service_service->addService($this->request->post);

			$url = '';

			if(isset($this->request->get['sort'])){
				$sort = $this->request->get['sort'];
				$url .= '&sort='.$this->request->get['sort'];
			}else{
				$sort = 'service_name';
			}

			if(isset($this->request->get['order'])){
				$order = $this->request->get['order'];
				$url .= '&order='.$this->request->get['order'];
			} else {
				$order = 'ASC';
			}


			$this->response->redirect($this->url->link('service/services', 'user_token='.$this->session->data['user_token'].$url, true));

		}

		$this->getForm();
	}

	public function validateForm(){
		if(!$this->user->hasPermission('modify', 'user/user')){
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if(empty($this->request->post['service_name'])){
			$this->error['service_name'] = $this->language->get('error_service_name');
		}

		if(empty($this->request->post['service_price'])){
			$this->error['service_price'] = $this->language->get('error_empty_service_price');
		} else if(!is_numeric($this->request->post['service_price'])){
			$this->error['service_price'] = $this->language->get('error_service_price');
		}

		if(empty($this->request->post['service_duration'])){
			$this->error['serivce_duration'] = $this->language->get('error_empty_service_duration');
		} else if(!is_numeric($this->request->post['service_duration']) 
			|| floor($this->request->post['service_duration']) != $this->request->post['service_duration']){
			$this->error['service_duration'] = $this->language->get('error_service_duration');
		}

		return !$this->error;
	}


	protected function getForm(){
		$data = array();

		if(isset($this->error['warning'])){
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		if(isset($this->error['service_name'])){
			$data['error_service_name'] = $this->error['service_name'];
		} else {
			$data['error_service_name'] = '';
		}

		if(isset($this->error['service_price'])){
			$data['error_service_price'] = $this->error['service_price'];
		} else {
			$data['error_service_price'] = '';
		}

		if(isset($this->error['service_duration'])){
			$data['error_service_duration'] = $this->error['service_duration'];
		} else {
			$data['error_service_duration'] = '';
		}

		$url = '';

		if(isset($this->request->get['sort'])){
			$sort = $this->request->get['sort'];
			$url .= '&sort='.$this->request->get['sort'];
		}else{
			$sort = 'service_name';
		}

		if(isset($this->request->get['order'])){
			$order = $this->request->get['order'];
			$url .= '&order='.$this->request->get['order'];
		} else {
			$order = 'ASC';
		}


		$data['header'] 		= $this->load->controller('common/header');
		$data['column_left'] 	= $this->load->controller('common/column_left');
		$data['footer'] 		= $this->load->controller('common/footer');
 		$data['cancel']			= $this->url->link('service/services', 'user_token='.$this->session->data['user_token']. $url, true);


		$data['breadcrumbs'] = array();
		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_service'),
			'href' => $this->url->link('service/services', 'user_token=' . $this->session->data['user_token']. $url, true)
		);



		$isEditForm = isset($this->request->get['service_id']);		if($isEditForm){
			$data['action'] = $this->url->link('service/services/edit', 'user_token='.$this->session->data['user_token'], true);
		}

		if($isEditForm){
			$data['action'] = $this->url->link('service/services/edit', 'user_token='.$this->session->data['user_token']. '&service_id='.$this->request->get['service_id']. $url, true);
		} else {
			$data['action'] = $this->url->link('service/services/add', 'user_token='.$this->session->data['user_token'] .$url, true);

		}


		$data['text_form'] = $isEditForm ? $this->language->get('text_edit_service') : $this->language->get('text_add_service');

		$service_info;
		if($isEditForm && $this->request->server['REQUEST_METHOD'] != 'POST'){
			$this->load->model('service/service');
			$service_info = $this->model_service_service->getService($this->request->get['service_id']);
		}
		

		if(isset($this->request->post['service_name'])){
			$data['service_name'] = $this->request->post['service_name'];
		} else if (!empty($service_info)){
			$data['service_name'] = $service_info['service_name'];
		} else {
			$data['service_name'] = '';
		}

		if(isset($this->request->post['service_description'])){
			$data['service_description'] = $this->request->post['service_description'];
		} else if (!empty($service_info)){
			$data['service_description'] = $service_info['service_description'];
		} else {
			$data['service_descriptoin'] = '';
		}

		if(isset($this->request->post['service_price'])){
			$data['service_price'] = $this->request->post['service_price'];
		} else if(!empty($service_info)){
			$data['service_price'] = $service_info['service_price'];
		} else {
			$data['service_price'] = '';
		}

		if(isset($this->request->post['service_duration'])){
			$data['service_duration'] = $this->request->post['service_duration'];
		} else if(!empty($service_info)){
			$data['service_duration'] = $service_info['service_duration'];
		} else {
			$data['service_duration'] = '';
		}

		$this->response->setOutput($this->load->view('service/services_form', $data));
	}

	public function edit(){
		$this->load->language('service/services');
		$this->document->setTitle($this->language->get('heading_title'));

		if(($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()){
			// Edit service 
			$this->load->model('service/service');
			$this->model_service_service->editService($this->request->get['service_id'], $this->request->post);

			$url = '';

			if(isset($this->request->get['sort'])){
				$sort = $this->request->get['sort'];
				$url .= '&sort='.$this->request->get['sort'];
			}else{
				$sort = 'service_name';
			}

			if(isset($this->request->get['order'])){
				$order = $this->request->get['order'];
				$url .= '&order='.$this->request->get['order'];
			} else {
				$order = 'ASC';
			}


			$this->response->redirect($this->url->link('service/services', 'user_token='.$this->session->data['user_token'].$url, true));

		}

		$this->getForm();
	}

	public function delete(){
		$this->load->language('service/services');
		$this->document->setTitle($this->language->get('heading_title'));

		if(($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateDelete()){
			// Edit service 
			$this->load->model('service/service');

			foreach($this->request->post['selected'] as $service_id){
				$this->model_service_service->deleteService($service_id);
			}

			$url = '';

			if(isset($this->request->get['sort'])){
				$sort = $this->request->get['sort'];
				$url .= '&sort='.$this->request->get['sort'];
			}else{
				$sort = 'service_name';
			}

			if(isset($this->request->get['order'])){
				$order = $this->request->get['order'];
				$url .= '&order='.$this->request->get['order'];
			} else {
				$order = 'ASC';
			}


			$this->response->redirect($this->url->link('service/services', 'user_token='.$this->session->data['user_token'].$url, true));
		}
		$this->getList();
	}

	public function validateDelete(){
		if(!$this->user->hasPermission('modify', 'service/services')){
			$this->error['warning'] = $this->language->get('error_permission');
		}

		return !$this->error;
	}


}