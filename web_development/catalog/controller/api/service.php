<?php

class ControllerApiService extends Controller{
	public function getAllServices(){
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

		$json = array();
		$this->load->model('service/service');
		$results = $this->model_service_service->getServices();
		foreach($results as $result){
			$json['services'][] = array(
				'service_id' => (int)$result['service_id']
				,'service_name' => $result['service_name']
				,'service_price' => (float)$result['service_price']
			);
		}
		 $json['response'] = [
	            'status' => 1,
	            'msg'   => 'Get services successfully.'
	        ];
		$this->response->setOutput(json_encode($json));
	}

	public function getCustomerServices(){
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
        if(!isset($this->request->get) || !isset($this->request->get['appointment_id'])){
            $json['response'] = array(
                'status' => 0,
                'msg' => 'Parameter missing'
            );
            $this->response->setOutput(json_encode($json));
            return;
        }


		$json = array();
		$this->load->model('service/service');
		$results = $this->model_service_service->getAppointmentServices($this->request->get['appointment_id']);
		foreach($results as $result){
			$json['services'][] = array(
				'service_id' => (int)$result['service_id']
				,'service_name' => $result['service_name']
				,'service_price' => (float)$result['service_price']
				,'quantity'		=> (int)$result['qty']				
			);
		}
		 $json['response'] = [
	            'status' => 1,
	            'msg'   => 'Get services successfully.'
	        ];
		$this->response->setOutput(json_encode($json));
	}
}

?>