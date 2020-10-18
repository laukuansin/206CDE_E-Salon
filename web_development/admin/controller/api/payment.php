<?php
	class ControllerApiPayment extends Controller{

    public function getPaymentDetail()
    {
        $json = array();
        $serviceDetail=array();

        $this->load->model('appointment/appointment');
        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"
            );
            return $this->response->setOutput(json_encode($json));

        } 


        if(isset($this->request->post['appointment_id']))
        {
            $customerResult = $this->model_appointment_appointment->getAppointmentById($this->request->post['appointment_id']);
            $serviceResult  = $this->model_appointment_appointment->getServiceByAppointmentId($this->request->post['appointment_id']);
            
            $customerDetail=array(
                'customer_name'=>$customerResult['customer_name'],
                'contact_no'=>$customerResult['telephone'],
                'date'=>$customerResult['appointment_date'],
                'location'=>$customerResult['appointment_address']
            );

            foreach($serviceResult as  $service)
            {
                $serviceDetail[]=array(
                    'service_name'=>$service['service_name'],
                    'quantity'=>(int)$service['qty'],
                    'service_price'=>(float)$service['service_price']
                );
            }

            $json['customer']=$customerDetail;
            $json['service']=$serviceDetail;
            $json['response'] = array(
                "status" => 1,
                "msg"	 => "Get Payment Detail Success"
            );
        }
        else{
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Missing parameter"
            );
        }
        $this->response->setOutput(json_encode($json));
    }

    public function scanCustomerQRCode()
    {
        $json = array();
        $this->load->model('customer/customer');

        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"

            );
            return $this->response->setOutput(json_encode($json));
        }

        $customer_token=isset($this->request->post['token'])?$this->request->post['token']:false;

        if($customer_token)
        {
            $customer=$this->model_customer_customer->getCustomerIDByToken($customer_token);

            if(empty($customer))
            {
                $json['response'] = array(
                    "status" => -1,
                    "msg"	 => "The customer id did not exist"
                );
            }
            else{
                $json['response'] = array(
                    "status" => 1,
                    "msg"	 => $customer['customer_id']
                );
            }
        }
        else{
            $json['response'] = array(
            "status" => -1,
            "msg"	 => "Missing Parameter"
        );
        }
        
        $this->response->setOutput(json_encode($json));
    }
}
?>