<?php
 	class ControllerAppointmentMakeAppointment extends Controller{


 		public function index(){
 			// if($this->customer->isLogged()){
 			// 	$this->response->redirect($this->url->link('account/account', '', true));
 			// }

 			$data = array();
 			$data["header"] = $this->load->controller('common/header_home');
 			$data["bg_image"] = DIR_IMAGE. "bg/hair-salon-bg.jpg";
 			$this->response->setOutput($this->load->view('appointment/make_appointment', $data));
 		}

 	}