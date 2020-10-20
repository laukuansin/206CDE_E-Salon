<?php
	class ControllerApiRating extends Controller{

    public function getWorkerRating()
    {
        $json = array();
        $workerRating=array();
        $this->load->model('user/user');
        $this->load->model('customer/customer');

        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"
            );
            return $this->response->setOutput(json_encode($json));

        }
        $worker_id=(isset($this->request->post['worker_id'])) ? $this->request->post['worker_id'] : false; 

        if($worker_id)
        {
            $results=$this->model_user_user->getRatingByWorkerID($worker_id);
            $averageRating=$this->model_user_user->getAverageRatingOfWorker($worker_id);
            foreach($results as $result)
            {
                $customer=$this->model_customer_customer->getCustomer($result['customer_id']);
                $workerRating[]=array(
                    'customer_name'=>$customer['firstname']." ".$customer['lastname'],
                    'rating'=>(int)$result['customer_rating'],
                    'review'=>$result['customer_review']
                );
            }
            $json['rating_list']=$workerRating;
            $json['average_rating']=(float)$averageRating;
            $json['response'] = array(
                "status" => 1,
                "msg"	 => "Get worker rating success"
            );
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