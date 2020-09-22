<?php
class ControllerCommonHome extends Controller {
	public function index() {
		$this->document->setTitle($this->config->get('config_meta_title'));
		$this->document->setDescription($this->config->get('config_meta_description'));
		$this->document->setKeywords($this->config->get('config_meta_keyword'));

		if (isset($this->request->get['route'])) {
			$this->document->addLink($this->config->get('config_url'), 'canonical');
		}

		$data['hairService'] = DIR_IMAGE."services/hairService.jpg";
		// $data['column_left'] = $this->load->controller('common/column_left');
		// $data['column_right'] = $this->load->controller('common/column_right');
		// $data['content_top'] = $this->load->controller('common/content_top');
		// $data['content_bottom'] = $this->load->controller('common/content_bottom');
		$data['footer'] = $this->load->controller('common/footer');
		$data['header'] = $this->load->controller('common/header_home');
		$data['img_hair_service'] = DIR_IMAGE."services/hairService.jpg";
		$data['img_scalp_service'] = DIR_IMAGE."services/scalpservices.png";
		$data['img_nail_service'] = DIR_IMAGE."services/nailservice.jpeg";
		$data['appointment'] = $this->url->link('appointment/make_appointment', '', true);
		$this->response->setOutput($this->load->view('common/home', $data));
	}
}
