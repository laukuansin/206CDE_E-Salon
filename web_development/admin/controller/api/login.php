<?php
class ControllerApiLogin extends Controller {
	private $error;

	public function index()
	{
		$json = array();
		$this->language->load('common/login');
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->session->data['user_token'] = token(32);
				
			$json['user_token'] = $this->session->data['user_token'];
			$json['response']   = array(
				'status' => 1,
				'msj'	 => $this->language->get('text_login_success')
				);
		}
		else{
			$json['response'] = array(
				'status' => 0,
				'msj'	 => $this->language->get('error_login')
			);
		}
		
		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	protected function validate() {
		if (!isset($this->request->post['username']) || !isset($this->request->post['password']) || !$this->user->login($this->request->post['username'], html_entity_decode($this->request->post['password'], ENT_QUOTES, 'UTF-8'))) {
			$this->error['warning'] = $this->language->get('error_login');
		}

		return !$this->error;
	}
}
