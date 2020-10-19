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
        $this->load->model('sale/sale');
        $this->load->model('appointment/appointment');


        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"

            );
            return $this->response->setOutput(json_encode($json));
        }

        $customer_token=isset($this->request->post['token'])?$this->request->post['token']:false;
        $appointment_id=isset($this->request->post['appointment_id'])?$this->request->post['appointment_id']:false;
        $total=isset($this->request->post['total'])?$this->request->post['total']:false;
        $description=isset($this->request->post['description'])?$this->request->post['description']:false;

        if($customer_token&&$appointment_id)
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
                $data=array(
                    'appointment_id'=>$appointment_id,
                    'worker_id'=>$this->user->getId(),
                    'customer_id'=>$customer['customer_id']
                );
                $appointment_sale_id=$this->model_sale_sale->addSale($data);

                $appointment_services=$this->model_appointment_appointment->getServiceByAppointmentId($appointment_id);

                foreach($appointment_services as $service)
                {
                    $service_data=array(
                        'service_id'=>$service['service_id'],
                        'qty'=>$service['qty'],
                        'appointment_sales_id'=>$appointment_sale_id
                    );
                    $this->model_sale_sale->addSaleItem($service_data);
                }
                $payment_detail=array(
                    'credit'=>-$total,
                    'description'=>$description,
                    'customer_id'=>$customer['customer_id'],
                    'reference'=>$this->getReference()
                    
                );
                $this->model_customer_customer->payService($payment_detail);

                $json['response'] = array(
                    "status" => 1,
                    "msg"	 => "Payment success"
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
    private function getReference(){
        mt_srand((double)microtime()*10000);
        $charid = md5(uniqid(rand(), true));
        $c = unpack("C*",$charid);
        $c = implode("",$c);
        return substr($c,0,20);
    }
}
?>