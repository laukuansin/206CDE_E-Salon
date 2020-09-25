<?php
class ControllerCommonContentTop extends Controller {
	public function index() {
		
		$data['name'] = $this->config->get('config_name');
		return $this->load->view('common/content_top', $data);
	}
}
