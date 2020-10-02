<?php
	class ControllerServiceAppointment extends Controller{
		public function index(){

			$this->load->language('service/appointment');
			$this->load->model('service/service');
			$this->document->setTitle($this->language->get('heading_title'));

			$data = array();
			$data['header'] 		= $this->load->controller('common/header');
			$data['column_left'] 	= $this->load->controller('common/column_left');
			$data['breadcrumbs'] = array();
			$data['breadcrumbs'][] = array(
				'text' => $this->language->get('text_home'),
				'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
			);

			$data['breadcrumbs'][] = array(
				'text' => $this->language->get('text_appointment'),
				'href' => $this->url->link('service/appointment', 'user_token=' . $this->session->data['user_token'], true)
			);

			$this->response->setOutput($this->load->view('service/appointment', $data));
		}
	}
?>