<?php
class ControllerApiLogin extends Controller {
	private $error;

	public function index()
	{
		$json = array();
		$this->language->load('common/login');
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			
			$this->load->model('user/user');
			$token  = $this->model_user_user->getUserTokenById($this->user->getId())['user_token'];

			$json['user_token'] = $token;
			$json['user_group_id'] = (int)$this->user->getGroupId();
			$json['email'] = $this->user->getEmail();
			$json['username'] = $this->user->getUserName();
			$json['response']   = array(
				'status' => 1,
				'msg'	 => $this->language->get('text_login_success'),
				);
		}
		else{
			$json['response'] = array(
				'status' => 0,
				'msg'	 => $this->language->get('error_login')
			);
		}
		
		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}


	protected function validate() {
		if(isset($this->request->post['api_key'])){
			if(!$this->user->loginByApiKey($this->request->post['api_key']))
				$this->error['warning'] = $this->language->get('error_login');
		}
		else if (!isset($this->request->post['username']) || !isset($this->request->post['password']) || !$this->user->login($this->request->post['username'], html_entity_decode($this->request->post['password'], ENT_QUOTES, 'UTF-8'))) {
			$this->error['warning'] = $this->language->get('error_login');
		}

		return !$this->error;
	}
}
