<?php
class ControllerCommonContentTop extends Controller {
	public function index() {
		
		$data['name'] = $this->config->get('config_name');
		$data['action_appointment'] = $this->url->link('appointment/appointment');
		return $this->load->view('common/content_top', $data);
	}
}
