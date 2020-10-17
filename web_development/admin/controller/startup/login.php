<?php
class ControllerStartupLogin extends Controller {
	public function index() {
		$route = isset($this->request->get['route']) ? $this->request->get['route'] : '';

		$ignore = array(
			'common/login',
			'common/forgotten',
			'common/reset',
		);

		$api = array(
			'api/login',
			'api/appointment',
			'api/payment'

		);


		// User
		$this->registry->set('user', new Cart\User($this->registry));

		if(isset($this->request->get['api_key'])){
			$this->user->loginByApiKey($this->request->get['api_key']);
		}
		else{

			if (!$this->user->isLogged() && !in_array($route, $ignore) && !in_array($route, $api)) {
				return new Action('common/login');
			}

			if (isset($this->request->get['route'])) {
				$ignore = array(
					'common/login',
					'common/logout',
					'common/forgotten',
					'common/reset',
					'error/not_found',
					'error/permission',
				);

				if (!in_array($route, $ignore) && !in_array($route, $api) && (!isset($this->request->get['user_token']) || !isset($this->session->data['user_token']) || ($this->request->get['user_token'] != $this->session->data['user_token']))) {
					return new Action('common/login');
				}
			} else {
				if (!isset($this->request->get['user_token']) || !isset($this->session->data['user_token']) || ($this->request->get['user_token'] != $this->session->data['user_token'])) {
					return new Action('common/login');
				}
			}
		}
	}
}
