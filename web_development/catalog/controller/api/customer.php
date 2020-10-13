<?php
class ControllerApiCustomer extends Controller {
	public function index() {
		$this->load->language('api/customer');

		// Delete past customer in case there is an error
		unset($this->session->data['customer']);

		$json = array();

		if (!isset($this->session->data['api_id'])) {
			$json['error']['warning'] = $this->language->get('error_permission');
		} else {
			// Add keys for missing post vars
			$keys = array(
				'customer_id',
				'customer_group_id',
				'firstname',
				'lastname',
				'email',
				'telephone',
			);

			foreach ($keys as $key) {
				if (!isset($this->request->post[$key])) {
					$this->request->post[$key] = '';
				}
			}

			// Customer
			if ($this->request->post['customer_id']) {
				$this->load->model('account/customer');

				$customer_info = $this->model_account_customer->getCustomer($this->request->post['customer_id']);

				if (!$customer_info || !$this->customer->login($customer_info['email'], '', true)) {
					$json['error']['warning'] = $this->language->get('error_customer');
				}
			}

			if ((utf8_strlen(trim($this->request->post['firstname'])) < 1) || (utf8_strlen(trim($this->request->post['firstname'])) > 32)) {
				$json['error']['firstname'] = $this->language->get('error_firstname');
			}

			if ((utf8_strlen(trim($this->request->post['lastname'])) < 1) || (utf8_strlen(trim($this->request->post['lastname'])) > 32)) {
				$json['error']['lastname'] = $this->language->get('error_lastname');
			}

			if ((utf8_strlen($this->request->post['email']) > 96) || (!filter_var($this->request->post['email'], FILTER_VALIDATE_EMAIL))) {
				$json['error']['email'] = $this->language->get('error_email');
			}

			if ((utf8_strlen($this->request->post['telephone']) < 3) || (utf8_strlen($this->request->post['telephone']) > 32)) {
				$json['error']['telephone'] = $this->language->get('error_telephone');
			}

			// Customer Group
			if (is_array($this->config->get('config_customer_group_display')) && in_array($this->request->post['customer_group_id'], $this->config->get('config_customer_group_display'))) {
				$customer_group_id = $this->request->post['customer_group_id'];
			} else {
				$customer_group_id = $this->config->get('config_customer_group_id');
			}

			// Custom field validation
			$this->load->model('account/custom_field');

			$custom_fields = $this->model_account_custom_field->getCustomFields($customer_group_id);

			foreach ($custom_fields as $custom_field) {
				if ($custom_field['location'] == 'account') { 
					if ($custom_field['required'] && empty($this->request->post['custom_field'][$custom_field['location']][$custom_field['custom_field_id']])) {
						$json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
					} elseif (($custom_field['type'] == 'text') && !empty($custom_field['validation']) && !filter_var($this->request->post['custom_field'][$custom_field['location']][$custom_field['custom_field_id']], FILTER_VALIDATE_REGEXP, array('options' => array('regexp' => $custom_field['validation'])))) {
						$json['error']['custom_field' . $custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
					}
				}
			}

			if (!$json) {
				$this->session->data['customer'] = array(
					'customer_id'       => $this->request->post['customer_id'],
					'customer_group_id' => $customer_group_id,
					'firstname'         => $this->request->post['firstname'],
					'lastname'          => $this->request->post['lastname'],
					'email'             => $this->request->post['email'],
					'telephone'         => $this->request->post['telephone'],
					'custom_field'      => isset($this->request->post['custom_field']) ? $this->request->post['custom_field'] : array()
				);

				$json['success'] = $this->language->get('text_success');
			}
		}
		
		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}
	public function  getCustomerDetail()
	{
		 //Must have function
        // !!!!!!!!!!!!!!!!!!!
		$json = array();
		$data  = array();
       if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
        }  
		$data=[
			'customer_id'=>$this->customer->getId(),
			'first_name'=>$this->customer->getFirstName(),
			'last_name'=>$this->customer->getLastName(),
			'name'=>$this->customer->getFirstName() . " " .$this->customer->getLastName(),
			'contact_no'=>$this->customer->getTelephone(),
			'email'=>$this->customer->getEmail()
		];
		$json['detail'] =$data;
		$json['response'] = array(
            'status' => 1,
            'msg'   => 'Get Customer detail successfully'
        );

        $this->response->setOutput(json_encode($json));

	}
	public function editInformation()
	{
		 //Must have function
        // !!!!!!!!!!!!!!!!!!!
		$json = array();
		$this->load->language('account/edit');
		$this->load->model('account/customer');
		
       if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
		}  
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateInfoForm($error)){
			$this->model_account_customer->editCustomer($this->customer->getId(), $this->request->post);

			$json['response'] = array(
                'status'    => 1,
                'msg'       => $this->language->get('text_success')
            );
		}
		else{
            $json['response'] = array(
                'msg'       => '',
                'status'    => 0
            );
            $json['error'] = $error;
        }

		$this->response->setOutput(json_encode($json));
	}
	public function  logout()
	{
		 //Must have function
        // !!!!!!!!!!!!!!!!!!!
		$json = array();
		
       if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
        }  
		$this->customer->logout();
		$json['response'] = array(
            'status' => 1,
            'msg'   => 'Log out successfully'
        );

        $this->response->setOutput(json_encode($json));

	}
	public function changePassword()
	{
		 //Must have function
        // !!!!!!!!!!!!!!!!!!!
		$json = array();
		$this->load->language('account/password');
		$this->load->model('account/customer');

		if(!$this->customer->isLogged()) {
            $json['response'] = array(
                'status' => -1,
                'msg' => 'Invalid token'
            );
            $this->response->setOutput(json_encode($json));
            return;
		}

		
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validatePasswordForm($error)) {

			$this->model_account_customer->editPassword($this->customer->getEmail(), $this->request->post['newPassword']);

			$json['response'] = array(
                'status'    => 1,
                'msg'       => $this->language->get('text_success')
            );

		}
		else{
            $json['response'] = array(
                'msg'       => '',
                'status'    => 0
            );
            $json['error'] = $error;
        }

		
		$this->response->setOutput(json_encode($json));

	}

	protected function validatePasswordForm(&$error) {
		if ((utf8_strlen(html_entity_decode($this->request->post['newPassword'], ENT_QUOTES, 'UTF-8')) < 4) || (utf8_strlen(html_entity_decode($this->request->post['newPassword'], ENT_QUOTES, 'UTF-8')) > 40)) {
			$error['newPassword'] = $this->language->get('error_password');
		}
		if(!$this->model_account_customer->validatePassword($this->customer->getEmail(),$this->request->post['oldPassword'])){
			$error['oldPassword'] = $this->language->get('error_oldPassword');

		}

		if ($this->request->post['confirm'] != $this->request->post['newPassword']) {
			$error['confirm'] = $this->language->get('error_confirm');
		}

		return !$error;
	}



	protected function validateInfoForm(&$error) {
		if ((utf8_strlen(trim($this->request->post['firstname'])) < 1) || (utf8_strlen(trim($this->request->post['firstname'])) > 32)) {
			$error['firstname'] = $this->language->get('error_firstname');
		}

		if ((utf8_strlen(trim($this->request->post['lastname'])) < 1) || (utf8_strlen(trim($this->request->post['lastname'])) > 32)) {
			$error['lastname'] = $this->language->get('error_lastname');
		}

		if ((utf8_strlen($this->request->post['email']) > 96) || !filter_var($this->request->post['email'], FILTER_VALIDATE_EMAIL)) {
			$error['email'] = $this->language->get('error_email');
		}

		if (($this->customer->getEmail() != $this->request->post['email']) && $this->model_account_customer->getTotalCustomersByEmail($this->request->post['email'])) {
			$error['email'] = $this->language->get('error_exists');
		}

		if ((utf8_strlen($this->request->post['telephone']) < 3) || (utf8_strlen($this->request->post['telephone']) > 32)) {
			$error['telephone'] = $this->language->get('error_telephone');
		}

		// Custom field validation
		$this->load->model('account/custom_field');

		$custom_fields = $this->model_account_custom_field->getCustomFields('account', $this->config->get('config_customer_group_id'));

		foreach ($custom_fields as $custom_field) {
			if ($custom_field['location'] == 'account') {
				if ($custom_field['required'] && empty($this->request->post['custom_field'][$custom_field['location']][$custom_field['custom_field_id']])) {
					$error['custom_field'][$custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
				} elseif (($custom_field['type'] == 'text') && !empty($custom_field['validation']) && !filter_var($this->request->post['custom_field'][$custom_field['location']][$custom_field['custom_field_id']], FILTER_VALIDATE_REGEXP, array('options' => array('regexp' => $custom_field['validation'])))) {
					$error['custom_field'][$custom_field['custom_field_id']] = sprintf($this->language->get('error_custom_field'), $custom_field['name']);
				}
			}
		}

		return !$error;
	}
}
