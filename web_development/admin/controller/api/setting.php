<?php

class ControllerApiSetting extends Controller{

    public function getSetting()
    {
        $json = array();

        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"
            );
            $this->response->setOutput(json_encode($json));
            return;
        } 
        $this->load->model('service/setting');

        $result=$this->model_service_setting->getSetting();
        
        $json['setting'] = json_decode($result['service_setting']);
        $json['response'] = array(
            'msg'       => 'Get Setting Success',
            'status'    => 1
        );

        $this->response->setOutput(json_encode($json));
    }

    public function editSetting()
    {
        $json = array();
		$this->load->language('service/setting');
        $this->load->model('service/setting');

        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"
            );
            $this->response->setOutput(json_encode($json));
            return;
        } 

        $postData = json_decode(file_get_contents('php://input'),true);
        if($this->request->server['REQUEST_METHOD'] == 'POST' && $this->validateForm($postData, $error)){
            $this->model_service_setting->updateSetting(json_encode($postData));
            $json['response'] = array(
                'status'    => 1,
                'msg'       => "Update Setting Success"
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

    public function validateForm($postData, &$error){
		if(!$this->user->hasPermission('modify', 'service/setting')){
			$error['permission'] = $this->language->get('error_permission');
		}

		if(empty($postData['cancellation_time'])){
			$error['cancellation_time'] = $this->language->get('error_empty_cancellation_time');
		} else if(!is_numeric($postData['cancellation_time'])){
			$error['cancellation_time'] = $this->language->get('error_cancellation_time');
		}

		if(empty($postData['travel_time'])){
			$error['travel_time'] = $this->language->get('error_empty_travel_time');
		} else if(!is_numeric($postData['travel_time'])){
			$error['travel_time'] = $this->language->get('error_travel_time');
		}

		if(empty($postData['appointment_interval'])){
			$error['appointment_interval'] = $this->language->get('error_empty_appointment_interval');
		} else if(!is_numeric($postData['appointment_interval'])){
			$error['appointment_interval'] = $this->language->get('error_appointment_interval');
		}


		return !$error;
	}
}
?>