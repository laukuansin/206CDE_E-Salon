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

        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"

            );
            return $this->response->setOutput(json_encode($json));
        }

        $postData = json_decode(file_get_contents('php://input'),true);

        if(!(isset($postData['token']) && isset($postData['appointment_id']) && isset($postData['services']) && isset($postData['description']))){
            $json['response'] = array(
                "status" => 0,
                "msg"    => "Missing Parameter"
            );
            return $this->response->setOutput(json_encode($json));
        }


        $this->load->model('customer/customer');
        $this->load->model('sale/sale');
        $this->load->model('appointment/appointment');
        
        $customerResult = $this->model_customer_customer->getCustomerIDByToken($postData['token']);

        if(empty($customerResult))
        {
            $json['response'] = array(
                "status" => 0,
                "msg"	 => "The customer id did not exist"
            );
        }
        else{
            $customerCredit = $this->model_customer_customer->getCustomerCredit($customerResult['customer_id']);

            // Should validate using server but time constraint
            $total = 0.0;
            foreach($postData['services'] as $service)
                $total += $service['qty'] * $service['service_price'];

            if($total > $customerCredit['total_credit']){
                $json['response'] = array(
                    "status" => 0,
                    "msg"    => "Customer does not have enough credit"
                );
                return $this->response->setOutput(json_encode($json));
            }


            $data = array(
                'appointment_id'=> $postData['appointment_id'],
                'worker_id'     => $this->user->getId(),
                'customer_id'   => $customerResult['customer_id']
            );

            $appointment_sale_id = $this->model_sale_sale->addSale($data);
            
  

            foreach($postData['services'] as $service)
            {
                $service_data = array(
                    'service_id'            => $service['service_id'],
                    'qty'                   => $service['qty'],
                    'appointment_sales_id'  => $appointment_sale_id
                );
                $this->model_sale_sale->addSaleItem($service_data);
            }

            $payment_detail=array(
                'credit'        => -$total,
                'description'   => $postData['description'],
                'customer_id'   => $customerResult['customer_id'],
                'reference'     => $this->getReference()
                
            );

            $this->model_customer_customer->payService($payment_detail);

            $json['response'] = array(
                "status" => 1,
                "msg"	 => "Payment success"
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