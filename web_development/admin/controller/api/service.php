<?php
	class ControllerApiService extends Controller{
		public function getAllServices(){
	        $json = array();
	        if(!$this->user->isLogged()){
	            $json['response'] = array(
	                "status" => -1,
	                "msg"	 => "Invalid token"
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
	}
?>