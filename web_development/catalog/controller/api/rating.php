<?php
    class ControllerApiRating extends Controller{
        public function getWorkerDetail()
        {
             //Must have function
            // !!!!!!!!!!!!!!!!!!!
            $json = array();
            $this->load->model('user/user');
            $this->load->model('tool/image');


            if(!$this->customer->isLogged()) {
                $json['response'] = array(
                    'status' => -1,
                    'msg' => 'Invalid token'
                );
                $this->response->setOutput(json_encode($json));
                return;
            }
            $workerID = (isset($this->request->post['worker_id'])) ? $this->request->post['worker_id'] : false;
            if($workerID)
            {
                $result=$this->model_user_user->getUser($workerID);

                if (is_file(DIR_IMAGE . $result['image'])) {
                    $image = $this->model_tool_image->resize($result['image'], 250, 250);
                } else {
                    $image = $this->model_tool_image->resize('profile.png', 250, 250);
                }
                $worker=array(
                    'profile_image'=>$image,
                    'name'=>$result['firstname']." ".$result['lastname']
                );
                $json['worker']=$worker;
                $json['response'] = array(
                    'status' => 1,
                    'msg'   => 'Get worker detail successfully'
                );
            }
            else{
                $json['response'] = array(
                    'status' => -1,
                    'msg'   => 'Missing parameter'
                );
            }
            
    
            $this->response->setOutput(json_encode($json));
        }

        public function submitRating()
        {
             //Must have function
            // !!!!!!!!!!!!!!!!!!!
            $json = array();
            $this->load->model('user/user');

            if(!$this->customer->isLogged()) {
                $json['response'] = array(
                    'status' => -1,
                    'msg' => 'Invalid token'
                );
                $this->response->setOutput(json_encode($json));
                return;
            }
            $workerID = (isset($this->request->post['worker_id'])) ? $this->request->post['worker_id'] : false;
            $rating = (isset($this->request->post['rating'])) ? $this->request->post['rating'] : false;
            $feedback = (isset($this->request->post['feedback'])) ? $this->request->post['feedback'] : false;

            if($workerID&&$rating)
            {
                $data=array(
                    'customer_id'=>$this->customer->getId(),
                    'worker_id'=>$workerID,
                    'rating'=>$rating,
                    'feedback'=>$feedback
                );
                $this->model_user_user->submitRating($data);

                $json['response'] = array(
                    'status' => 1,
                    'msg'   => 'Submit rating success'
                );
            }
            else{
                $json['response'] = array(
                    'status' => -1,
                    'msg'   => 'Missing parameter'
                );
            }
            $this->response->setOutput(json_encode($json));
        }
    }

?>