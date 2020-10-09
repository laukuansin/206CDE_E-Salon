<?php
class ControllerApiLogin extends Controller {
	// public function index() {
	// 	$this->load->language('api/login');

	// 	$json = array();

	// 	$this->load->model('account/api');

	// 	// Login with API Key
	// 	if(isset($this->request->post['username'])) {
	// 		$api_info = $this->model_account_api->login($this->request->post['username'], $this->request->post['key']);
	// 	} else {
	// 		$api_info = $this->model_account_api->login('Default', $this->request->post['key']);
	// 	}

	// 	if ($api_info) {
	// 		// Check if IP is allowed
	// 		$ip_data = array();
	
	// 		$results = $this->model_account_api->getApiIps($api_info['api_id']);
	
	// 		foreach ($results as $result) {
	// 			$ip_data[] = trim($result['ip']);
	// 		}
	
	// 		if (!in_array($this->request->server['REMOTE_ADDR'], $ip_data)) {
	// 			$json['error']['ip'] = sprintf($this->language->get('error_ip'), $this->request->server['REMOTE_ADDR']);
	// 		}				
				
	// 		if (!$json) {
	// 			$json['success'] = $this->language->get('text_success');
				
	// 			$session = new Session($this->config->get('session_engine'), $this->registry);
				
	// 			$session->start();
				
	// 			$this->model_account_api->addApiSession($api_info['api_id'], $session->getId(), $this->request->server['REMOTE_ADDR']);
				
	// 			$session->data['api_id'] = $api_info['api_id'];
				
	// 			// Create Token
	// 			$json['api_token'] = $session->getId();
	// 		} else {
	// 			$json['error']['key'] = $this->language->get('error_key');
	// 		}
	// 	}
		
	// 	$this->response->addHeader('Content-Type: application/json');
	// 	$this->response->setOutput(json_encode($json));
	// }

	public function index(){

		$this->load->model('account/customer');
		$this->load->language('account/login');
		$json = array();
		$error = array();

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate($error)) {
			// Unset guest
			unset($this->session->data['guest']);

			// Default Shipping Address
			$this->load->model('account/address');

			if ($this->config->get('config_tax_customer') == 'payment') {
				$this->session->data['payment_address'] = $this->model_account_address->getAddress($this->customer->getAddressId());
			}

			if ($this->config->get('config_tax_customer') == 'shipping') {
				$this->session->data['shipping_address'] = $this->model_account_address->getAddress($this->customer->getAddressId());
			}

			// Wishlist
			if (isset($this->session->data['wishlist']) && is_array($this->session->data['wishlist'])) {
				$this->load->model('account/wishlist');

				foreach ($this->session->data['wishlist'] as $key => $product_id) {
					$this->model_account_wishlist->addWishlist($product_id);

					unset($this->session->data['wishlist'][$key]);
				}
			}

			$this->load->model('account/customer');
			$token  = $this->model_account_customer->getCustomerTokenById($this->customer->getId())['customer_token'];


			$json['token']	  = $token; 	
			$json['response'] = array(
				'status' => 1,
				'msg' => $this->language->get('text_success')
			);

		} else{

			$json['response'] = array(
				'status' => 0,
				'msg'	 => $error['warning']
			);
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	protected function validate(&$error) {
		if(isset($this->request->post['api_key']))
		{
			// Check how many login attempts have been made.
			$login_info = $this->model_account_customer->getLoginAttemptsByApiKey($this->request->post['api_key']);
			$email 		= $this->model_account_customer->getCustomerByApiKey($this->request->post['api_key']);

			if(!empty($email)){
				$email = $email['email'];
				if ($login_info && ($login_info['total'] >= $this->config->get('config_login_attempts')) && strtotime('-1 hour') < strtotime($login_info['date_modified'])) {
				$error['warning'] = $this->language->get('error_attempts');
				}

				// Check if customer has been approved.
				$customer_info = $this->model_account_customer->getCustomerByEmail($email);
				if ($customer_info && !$customer_info['status']) {
					$error['warning'] = $this->language->get('error_approved');
				}

				if (!$error) {
					if (!$this->customer->loginByApiKey($this->request->post['api_key'])) {
						$error['warning'] = $this->language->get('error_login');

						$this->model_account_customer->addLoginAttempt($email);
					} else {
						$this->model_account_customer->deleteLoginAttempts($email);
					}
				}
			} else {
				$error['warning'] =  $this->language->get("error_token");
			}

			return !$error;
		} else {
			$login_info = $this->model_account_customer->getLoginAttempts($this->request->post['email']);

			if ($login_info && ($login_info['total'] >= $this->config->get('config_login_attempts')) && strtotime('-1 hour') < strtotime($login_info['date_modified'])) {
				$error['warning'] = $this->language->get('error_attempts');
			}

			// Check if customer has been approved.
			$customer_info = $this->model_account_customer->getCustomerByEmail($this->request->post['email']);

			if ($customer_info && !$customer_info['status']) {
				$error['warning'] = $this->language->get('error_approved');
			}

			if (!$error) {
				if (!$this->customer->login($this->request->post['email'], $this->request->post['password'])) {
					$error['warning'] = $this->language->get('error_login');

					$this->model_account_customer->addLoginAttempt($this->request->post['email']);
				} else {
					$this->model_account_customer->deleteLoginAttempts($this->request->post['email']);
				}
			}

			return !$error;
		}
	}
}
