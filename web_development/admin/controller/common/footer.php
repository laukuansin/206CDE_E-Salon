<?php
class ControllerCommonFooter extends Controller {
	public function index() {
		$this->load->language('common/footer');

		if ($this->user->isLogged() && isset($this->request->get['user_token']) && ($this->request->get['user_token'] == $this->session->data['user_token'])) {
			$data['text_version'] = sprintf($this->language->get('text_footer'), $this->config->get('config_name'), date('Y', time()));
		} else {
			$data['text_version'] = '';
		}
		
		return $this->load->view('common/footer', $data);
	}
}
