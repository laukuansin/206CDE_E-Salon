<?php
class ControllerApiLogin extends Controller {
	public function index() {
		$this->load->language('api/login');

		$json = array();

		$this->load->model('account/api');

		// Login with API Key
		if(isset($this->request->post['username'])) {
			$api_info = $this->model_account_api->login($this->request->post['username'], $this->request->post['key']);
		} else {
			$api_info = $this->model_account_api->login('Default', $this->request->post['key']);
		}

		if ($api_info) {
			// Check if IP is allowed
			$ip_data = array();
	
			$results = $this->model_account_api->getApiIps($api_info['api_id']);
	
			foreach ($results as $result) {
				$ip_data[] = trim($result['ip']);
			}
	
			if (!in_array($this->request->server['REMOTE_ADDR'], $ip_data)) {
				$json['error']['ip'] = sprintf($this->language->get('error_ip'), $this->request->server['REMOTE_ADDR']);
			}				
				
			if (!$json) {
				$json['success'] = $this->language->get('text_success');
				
				$session = new Session($this->config->get('session_engine'), $this->registry);
				
				$session->start();
				
				$this->model_account_api->addApiSession($api_info['api_id'], $session->getId(), $this->request->server['REMOTE_ADDR']);
				
				$session->data['api_id'] = $api_info['api_id'];
				
				// Create Token
				$json['api_token'] = $session->getId();
			} else {
				$json['error']['key'] = $this->language->get('error_key');
			}
		}
		
		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}
	public function login_worker()
	{
		$username = (isset($this->request->post['username'])) ? $this->request->post['username'] : false;
		$password = (isset($this->request->post['password'])) ? $this->request->post['password'] : false;

		$this->load->model('api/login');
		$this->load->library('obfuscate');
		$this->encryptData=new Obfuscate();
		
		if($username&&$password)
		{
			$checkUsernamePassword=$this->model_api_login->validateAccount($username,$password);

			if(!empty($checkUsernamePassword))
			{
				$userID=$checkUsernamePassword['user_id'];
				$authorization = array(
					'user_id'		=> $userID,
					'username' 		=> $username,
					'password' 		=> $password
				);
				$response= [
					'user_id'=>$userID,
					'key'=>$this->encryptData->encrypt($authorization)
				];
				$json['response']=$response;
				$json['error_code'] = [
					'error' => 0,
					'msj'   => 'Login success.'
				];
			}
			else{
				$json['response']=json_decode("{}");
				$json['error_code'] = [
					'error' => 1,
					'msj'   => 'username or password is wrong.'
				];
			}
		}
		else{
			$json['response']=json_decode("{}");
			$json['error_code'] = [
                'error' => 1,
                'msj'   => 'username and password cannot be empty.'
            ];
		}
		
		$this->response->setOutput(json_encode($json));
		//return $json;
	}
}
