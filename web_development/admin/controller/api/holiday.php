<?php

class ControllerApiHoliday extends Controller{
    public function getHoliday()
    {
        $json = array();
        $holidays=array();
        if(!$this->user->isLogged()){
            $json['response'] = array(
                "status" => -1,
                "msg"	 => "Invalid token"
            );
            $this->response->setOutput(json_encode($json));
            return;
        } 
        $this->load->model('setting/holiday');   
        $result=$this->model_setting_holiday->getHoliday();

        foreach($result as $holiday)
        {
            $holidays[]=array(
                "date"=>date("Y-n-j",strtotime($holiday['holiday_date']))
            );
        }
        $json['holiday']=$holidays;
        $json['response'] = array(
            'msg'       => 'Get Holiday Success',
            'status'    => 1
        );
        $this->response->setOutput(json_encode($json));
    }

    public function addHoliday()
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

        $this->load->model('setting/holiday');   
        
        if($this->request->post['date'])
        {
            $date=date("Y-n-j",strtotime($this->request->post['date']));
            $this->model_setting_holiday->addHoliday($date);
            $json['response'] = array(
                    'msg'       => 'Add Holiday Success',
                    'status'    => 1
                );
        }
        else{
            $json['response'] = array(
                'msg'       => 'Missing Parameter',
                'status'    => -1
            );
        }

       
        $this->response->setOutput(json_encode($json));
    }

    public function removeHoliday()
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
        $this->load->model('setting/holiday');   

        if(isset($this->request->post['date']))
        {
            $date=date("Y-n-j",strtotime($this->request->post['date']));
            $this->model_setting_holiday->removeHoliday($date);

            $json['response'] = array(
                    'msg'       => 'Remove Holiday Success',
                    'status'    => 1
                );
        }
        else{
            $json['response'] = array(
                'msg'       => 'Missing Parameter',
                'status'    => -1
            );
        }

        $this->response->setOutput(json_encode($json));
    }
}

?>