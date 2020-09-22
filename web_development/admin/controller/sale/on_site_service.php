<?php
class ControllerSaleOnSiteService extends Controller{

	public function index(){
		$data = array();
		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$this->response->setOutput($this->load->view('sale/on_site_service', $data));
	}
}
?>